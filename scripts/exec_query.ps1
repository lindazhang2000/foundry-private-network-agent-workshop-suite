$ErrorActionPreference='Continue'
$sub='<subscription-id>'
$rg='networksecu'
$cosmos='aiservicesnbrqcosmosdb'
$storage='aiservicesnbrqstorage'
$search='aiservicesnbrqsearch'
$vnet='agent-vnet-test'
$peSubnet='pe-subnet'
$peName='cosmosendpoint'
$peConn='cosmosendpoint-conn'
$dnsZone='privatelink.documents.azure.com'
$dnsLink='agent-vnet-test-link-docs'

az account set --subscription $sub
$cosmosId = az cosmosdb show -g $rg -n $cosmos --subscription $sub --query id -o tsv
$storageId = az storage account show -g $rg -n $storage --subscription $sub --query id -o tsv
$searchId = az search service show -g $rg -n $search --subscription $sub --query id -o tsv
$vnetId = az network vnet show -g $rg -n $vnet --subscription $sub --query id -o tsv

Write-Output '--- principals from storage scope ---'
az role assignment list --scope $storageId --subscription $sub --query "[].{principalId:principalId,principalName:principalName,principalType:principalType,role:roleDefinitionName}" -o table

$principalIds = az role assignment list --scope $storageId --subscription $sub --query "[?principalType!='User'].principalId" -o tsv
Write-Output "Non-user principalIds:`n$principalIds"

Write-Output '--- check/create DNS zone ---'
az network private-dns zone list -g $rg --subscription $sub --query "[?name=='$dnsZone'].name" -o tsv
if ($LASTEXITCODE -eq 0 -and -not (az network private-dns zone list -g $rg --subscription $sub --query "[?name=='$dnsZone'] | [0].name" -o tsv)) {
  az network private-dns zone create -g $rg -n $dnsZone --subscription $sub -o json
}

Write-Output '--- check/create DNS link ---'
az network private-dns link vnet list -g $rg -z $dnsZone --subscription $sub --query "[].name" -o tsv
if (-not (az network private-dns link vnet list -g $rg -z $dnsZone --subscription $sub --query "[?name=='$dnsLink'] | [0].name" -o tsv)) {
  az network private-dns link vnet create -g $rg -z $dnsZone -n $dnsLink -v $vnetId -e false --subscription $sub -o json
}

Write-Output '--- check/create Cosmos private endpoint ---'
$peExists = az network private-endpoint list -g $rg --subscription $sub --query "[?name=='$peName'] | length(@)" -o tsv
Write-Output "peExists=$peExists"
if ($peExists -eq '0') {
  az network private-endpoint create -g $rg -n $peName --vnet-name $vnet --subnet $peSubnet --private-connection-resource-id $cosmosId --group-id Sql --connection-name $peConn --subscription $sub -o json
}

Write-Output '--- check/create DNS zone group on endpoint ---'
$zgExists = az network private-endpoint dns-zone-group list -g $rg --endpoint-name $peName --subscription $sub --query "[?name=='default'] | length(@)" -o tsv
Write-Output "zoneGroupExists=$zgExists"
if ($zgExists -eq '0') {
  az network private-endpoint dns-zone-group create -g $rg --endpoint-name $peName -n default --private-dns-zone $dnsZone --zone-name $dnsZone --subscription $sub -o json
}

Write-Output '--- role definition availability ---'
az role definition list --name 'Search Index Data Contributor' --query '[0].roleName' -o tsv
az role definition list --name 'Search Service Contributor' --query '[0].roleName' -o tsv
az role definition list --name 'Cosmos DB Operator' --query '[0].roleName' -o tsv
az role definition list --name 'Cosmos DB Built-in Data Contributor' --query '[0].roleName' -o tsv

Write-Output '--- assign Search/Cosmos RBAC + Cosmos SQL data role ---'
foreach ($pid in $principalIds -split "`n") {
  if (-not [string]::IsNullOrWhiteSpace($pid)) {
    Write-Output "processing principal: $pid"
    az role assignment create --assignee-object-id $pid --assignee-principal-type ServicePrincipal --role 'Search Index Data Contributor' --scope $searchId --subscription $sub --only-show-errors -o none
    az role assignment create --assignee-object-id $pid --assignee-principal-type ServicePrincipal --role 'Search Service Contributor' --scope $searchId --subscription $sub --only-show-errors -o none
    az role assignment create --assignee-object-id $pid --assignee-principal-type ServicePrincipal --role 'Cosmos DB Operator' --scope $cosmosId --subscription $sub --only-show-errors -o none

    $sqlDataContributorRoleId = "$cosmosId/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
    $existingSqlRole = az cosmosdb sql role assignment list -g $rg -a $cosmos --subscription $sub --query "[?principalId=='$pid' && roleDefinitionId=='$sqlDataContributorRoleId'] | length(@)" -o tsv
    if ($existingSqlRole -eq '0') {
      az cosmosdb sql role assignment create -g $rg -a $cosmos --subscription $sub --role-definition-id $sqlDataContributorRoleId --principal-id $pid --scope '/' -o none
      Write-Output "CREATED cosmos sql data contributor for $pid"
    } else {
      Write-Output "SKIPPED cosmos sql data contributor for $pid (already exists)"
    }
  }
}

Write-Output '--- final verification ---'
az network private-endpoint list -g $rg --subscription $sub --query "[].{name:name,groupIds:privateLinkServiceConnections[].groupIds}" -o table
az network private-dns zone list -g $rg --subscription $sub --query "[].name" -o table
az role assignment list --scope $searchId --subscription $sub --query "[].{principal:principalName,role:roleDefinitionName}" -o table
az role assignment list --scope $cosmosId --subscription $sub --query "[].{principal:principalName,role:roleDefinitionName}" -o table
az cosmosdb sql role assignment list -g $rg -a $cosmos --subscription $sub --query "[].{principalId:principalId,roleDefinitionId:roleDefinitionId,scope:scope}" -o table
