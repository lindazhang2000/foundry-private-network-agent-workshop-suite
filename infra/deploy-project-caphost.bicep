param accountName string
param projectName string
param caphostName string
param cosmosDBConnection string
param azureStorageConnection string
param aiSearchConnection string

resource account 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' existing = {
  name: accountName
}

resource project 'Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview' existing = {
  name: projectName
  parent: account
}

resource projectCapabilityHost 'Microsoft.CognitiveServices/accounts/projects/capabilityHosts@2025-04-01-preview' = {
  name: caphostName
  parent: project
  properties: {
    capabilityHostKind: 'Agents'
    vectorStoreConnections: [aiSearchConnection]
    storageConnections: [azureStorageConnection]
    threadStorageConnections: [cosmosDBConnection]
  }
}

output capHostName string = projectCapabilityHost.name
output provisioningState string = projectCapabilityHost.properties.provisioningState
