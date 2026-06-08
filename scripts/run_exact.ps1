$ErrorActionPreference = 'Stop'
$sub = $env:AZURE_SUBSCRIPTION_ID
if (-not $sub) { throw 'Set AZURE_SUBSCRIPTION_ID before running this script.' }
$rg = if ($env:AZURE_RESOURCE_GROUP) { $env:AZURE_RESOURCE_GROUP } else { 'networksecu' }
$cosmos = $env:COSMOS_ACCOUNT_NAME
if (-not $cosmos) { throw 'Set COSMOS_ACCOUNT_NAME before running this script.' }
$storage = $env:STORAGE_ACCOUNT_NAME
if (-not $storage) { throw 'Set STORAGE_ACCOUNT_NAME before running this script.' }
$search = $env:SEARCH_SERVICE_NAME
if (-not $search) { throw 'Set SEARCH_SERVICE_NAME before running this script.' }
$vnet = if ($env:VNET_NAME) { $env:VNET_NAME } else { 'agent-vnet' }
$peSubnet = if ($env:PE_SUBNET_NAME) { $env:PE_SUBNET_NAME } else { 'pe-subnet' }
$peName='cosmosendpoint'
$peConn='cosmosendpoint-conn'
$dnsZone='privatelink.documents.azure.com'
$dnsLink = "$vnet-link-docs"
$dnsZoneGroup='default'

az account set --subscription $sub | Out-Null

$cosmosId = az cosmosdb show -g $rg -n $cosmos --subscription $sub --query id -o tsv
$storageId = az storage account show -g $rg -n $storage --subscription $sub --query id -o tsv
$searchId = az search service show -g $rg -n $search --subscription $sub --query id -o tsv
$vnetId = az network vnet show -g $rg -n $vnet --subscription $sub --query id -o tsv

# Determine target principal IDs from storage roles (non-user identities)
$storageAssignments = az role assignment list --scope $storageId --subscription $sub -o json | ConvertFrom-Json
$targetPrincipalIds = @($storageAssignments | Where-Object { $_.principalType -ne 'User' } | Select-Object -ExpandProperty principalId -Unique)
if (-not $targetPrincipalIds -or $targetPrincipalIds.Count -eq 0) {
  # fallback: include all principals on storage scope
  $targetPrincipalIds = @($storageAssignments | Select-Object -ExpandProperty principalId -Unique)
}
Write-Output ("Target principalIds: " + ($targetPrincipalIds -join ', '))

function Ensure-RoleAssignment {
  param(
    [string]$Scope,
    [string]$PrincipalId,
    [string]$RoleName
  )
  $existing = az role assignment list --scope $Scope --assignee-object-id $PrincipalId --subscription $sub --query "[?roleDefinitionName=='$RoleName'] | length(@)" -o tsv
  if ($existing -eq '0') {
    az role assignment create --assignee-object-id $PrincipalId --assignee-principal-type ServicePrincipal --role $RoleName --scope $Scope --subscription $sub --only-show-errors -o none
    Write-Output "CREATED role '$RoleName' for principal $PrincipalId on $Scope"
  } else {
    Write-Output "SKIPPED role '$RoleName' for principal $PrincipalId on $Scope (already exists)"
  }
}

# Ensure Search + Cosmos roles
# Note: 'Cosmos DB Built-in Data Contributor' is a SQL data-plane role and must be
# assigned via `az cosmosdb sql role assignment create`, NOT via `az role assignment create`.
$sqlDataContributorRoleId = "$cosmosId/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
foreach ($pid in $targetPrincipalIds) {
  Ensure-RoleAssignment -Scope $searchId -PrincipalId $pid -RoleName 'Search Index Data Contributor'
  Ensure-RoleAssignment -Scope $searchId -PrincipalId $pid -RoleName 'Search Service Contributor'
  Ensure-RoleAssignment -Scope $cosmosId -PrincipalId $pid -RoleName 'Cosmos DB Operator'

  $existingSqlRole = az cosmosdb sql role assignment list -g $rg -a $cosmos --subscription $sub --query "[?principalId=='$pid' && roleDefinitionId=='$sqlDataContributorRoleId'] | length(@)" -o tsv
  if ($existingSqlRole -eq '0') {
    az cosmosdb sql role assignment create -g $rg -a $cosmos --subscription $sub --role-definition-id $sqlDataContributorRoleId --principal-id $pid --scope '/' -o none
    Write-Output "CREATED Cosmos SQL Built-in Data Contributor for principal $pid"
  } else {
    Write-Output "SKIPPED Cosmos SQL Built-in Data Contributor for principal $pid (already exists)"
  }
}

# Ensure private DNS zone for Cosmos
$zoneExists = az network private-dns zone list -g $rg --subscription $sub --query "[?name=='$dnsZone'] | length(@)" -o tsv
if ($zoneExists -eq '0') {
  az network private-dns zone create -g $rg -n $dnsZone --subscription $sub -o none
  Write-Output "CREATED private DNS zone $dnsZone"
} else {
  Write-Output "SKIPPED private DNS zone $dnsZone (already exists)"
}

# Ensure VNet link
$linkExists = az network private-dns link vnet list -g $rg -z $dnsZone --subscription $sub --query "[?name=='$dnsLink'] | length(@)" -o tsv
if ($linkExists -eq '0') {
  az network private-dns link vnet create -g $rg -z $dnsZone -n $dnsLink -v $vnetId -e false --subscription $sub -o none
  Write-Output "CREATED DNS VNet link $dnsLink"
} else {
  Write-Output "SKIPPED DNS VNet link $dnsLink (already exists)"
}

# Ensure Cosmos private endpoint
$peExists = az network private-endpoint list -g $rg --subscription $sub --query "[?name=='$peName'] | length(@)" -o tsv
if ($peExists -eq '0') {
  az network private-endpoint create -g $rg -n $peName --vnet-name $vnet --subnet $peSubnet --private-connection-resource-id $cosmosId --group-id Sql --connection-name $peConn --subscription $sub -o none
  Write-Output "CREATED private endpoint $peName"
} else {
  Write-Output "SKIPPED private endpoint $peName (already exists)"
}

# Ensure DNS zone group on endpoint
$zgExists = az network private-endpoint dns-zone-group list -g $rg --endpoint-name $peName --subscription $sub --query "[?name=='$dnsZoneGroup'] | length(@)" -o tsv
if ($zgExists -eq '0') {
  az network private-endpoint dns-zone-group create -g $rg --endpoint-name $peName -n $dnsZoneGroup --private-dns-zone $dnsZone --zone-name $dnsZone --subscription $sub -o none
  Write-Output "CREATED DNS zone group $dnsZoneGroup on $peName"
} else {
  Write-Output "SKIPPED DNS zone group $dnsZoneGroup on $peName (already exists)"
}

# Final verification
Write-Output '--- Verification: Private Endpoints ---'
az network private-endpoint list -g $rg --subscription $sub --query "[].{name:name,groupIds:privateLinkServiceConnections[].groupIds}" -o json

Write-Output '--- Verification: Private DNS Zones ---'
az network private-dns zone list -g $rg --subscription $sub --query "[].name" -o json

Write-Output '--- Verification: Cosmos Scope Roles ---'
az role assignment list --scope $cosmosId --subscription $sub --query "[].{principal:principalName,role:roleDefinitionName}" -o json

Write-Output '--- Verification: Search Scope Roles ---'
az role assignment list --scope $searchId --subscription $sub --query "[].{principal:principalName,role:roleDefinitionName}" -o json

Write-Output '--- Verification: Cosmos SQL Data-Plane Roles ---'
az cosmosdb sql role assignment list -g $rg -a $cosmos --subscription $sub --query "[].{principalId:principalId,roleDefinitionId:roleDefinitionId,scope:scope}" -o json
