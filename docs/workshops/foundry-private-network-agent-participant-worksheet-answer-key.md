# Answer Key: Participant Worksheet

Use this guide for facilitator validation during checkpoints.

## 1. Environment Setup

Expected:
- Naming is consistent across all resources.
- Storage and Search names satisfy Azure naming constraints.
- Subscription and resource group are in intended tenant and region.

## 2. Checkpoint A - Network Foundation

Expected:
- VNet address range: `192.168.0.0/16` (or approved equivalent if intentionally changed)
- Agent subnet: `/24` minimum size
- Agent subnet delegation: `Microsoft.App/environments`
- Private endpoint subnet exists and does not overlap

Fail conditions:
- Missing delegation
- Smaller subnet than required policy
- Overlapping CIDR blocks

## 3. Checkpoint B - Backing Resources

Expected configuration:
- Search: public access disabled
- Storage: public network access disabled, shared key disabled, blob public access disabled
- Cosmos DB: public network access disabled

Fail conditions:
- Any service left public
- Provisioning not complete before next step

## 4. Checkpoint C - Foundry Account and Model

Expected:
- Account kind is AIServices
- Public network access disabled
- Network injection configured to delegated agent subnet
- At least one model deployment exists

Fail conditions:
- Account created without network injection
- No model deployment

## 5. Checkpoint D - Private Endpoints and DNS

Expected:
- Four private endpoints present and status Approved:
  - foundry-pe
  - search-pe
  - storage-pe
  - cosmos-pe
- DNS zones created and linked to VNet:
  - privatelink.cognitiveservices.azure.com
  - privatelink.openai.azure.com
  - privatelink.services.ai.azure.com
  - privatelink.search.windows.net
  - privatelink.blob.core.windows.net
  - privatelink.documents.azure.com
- A records resolve to private subnet IPs (commonly `192.168.1.x` in this lab)

Fail conditions:
- Missing zone links
- Missing A records
- Endpoint stuck in pending or rejected

## 6. Checkpoint E - Project, Connections, RBAC

Expected project connections:
- Category `CosmosDB`, authType `AAD`
- Category `AzureStorageAccount`, authType `AAD`
- Category `CognitiveSearch`, authType `AAD`

Required RBAC before project capability host:
- Storage Blob Data Owner on storage account scope
- Cosmos DB Operator on cosmos account scope
- Cosmos SQL Built-in Data Contributor (data-plane role assignment)
- Search Index Data Contributor on search scope
- Search Service Contributor on search scope

Fail conditions:
- Missing any required role
- Connections created with non-AAD auth

## 7. Checkpoint F - Capability Hosts

Expected:
- Account capability host provisioning state is `Succeeded`
- Project capability host provisioning state is `Succeeded`
- Project capability host has all three mapping arrays populated:
  - vectorStoreConnections
  - storageConnections
  - threadStorageConnections

Fail conditions:
- Project capability host in failed state
- Any required connection array missing

## 8. Agent Validation

Expected:
- Portal accessed through private path (VM/VPN/ExpressRoute)
- Agent created on deployed model
- Azure AI Search tool added from project connection
- Playground run completes without connection endpoint failures

Fail conditions:
- Access attempted from public path only
- Tool call failure with endpoint or authorization errors

## 9. Common Troubleshooting Mapping

| Symptom | Likely cause | Corrective action |
|---|---|---|
| Invalid endpoint or connection failed | Missing project capability host | Create or recreate project capability host |
| Capability host provisioning failed | Missing RBAC or insufficient propagation time | Reassign roles, wait, retry project capability host |
| Search embedding permission denied | Missing Cognitive Services OpenAI User role | Grant role to project managed identity and account managed identity |
| Cannot reach service endpoint | Not on private network path | Use approved private connectivity path |

## 10. Final Pass Criteria

Mark workshop as passed when all are true:
- Account capability host: Succeeded
- Project capability host: Succeeded
- Three AAD project connections present
- Four private endpoints approved
- At least one model deployment present
- Agent playground test succeeds with tool flow
