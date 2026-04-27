# Participant Worksheet: Private Network Foundry Agent Workshop

Use this worksheet during the lab. Record evidence at each checkpoint.

Participant name: ____________________  
Team: ____________________  
Date: ____________________

## 1. Environment Setup

Subscription id: ____________________  
Resource group: ____________________  
Location: ____________________  
Suffix: ____________________

Derived names:
- ACCT_NAME: ____________________
- PROJECT_NAME: ____________________
- SEARCH_NAME: ____________________
- STORAGE_NAME: ____________________
- COSMOS_NAME: ____________________

## 2. Checkpoint A - Network Foundation

Record outputs:
- VNet name: ____________________
- Agent subnet CIDR: ____________________
- PE subnet CIDR: ____________________
- Agent subnet delegation value: ____________________

Pass or fail: ____________________

## 3. Checkpoint B - Backing Resources

Complete table:

| Resource | Name | Provisioning state | Public network access setting |
|---|---|---|---|
| Search |  |  |  |
| Storage |  |  |  |
| Cosmos DB |  |  |  |

Pass or fail: ____________________

## 4. Checkpoint C - Foundry Account and Model

Account name: ____________________  
Account provisioning state: ____________________  
Account public network access: ____________________  
Model deployment name: ____________________

Pass or fail: ____________________

## 5. Checkpoint D - Private Endpoints and DNS

Private endpoint states:

| Endpoint | State |
|---|---|
| foundry-pe |  |
| search-pe |  |
| storage-pe |  |
| cosmos-pe |  |

DNS zones and record count:

| DNS zone | A record count |
|---|---|
| privatelink.cognitiveservices.azure.com |  |
| privatelink.openai.azure.com |  |
| privatelink.services.ai.azure.com |  |
| privatelink.search.windows.net |  |
| privatelink.blob.core.windows.net |  |
| privatelink.documents.azure.com |  |

Pass or fail: ____________________

## 6. Checkpoint E - Project, Connections, RBAC

Project name: ____________________  
Project managed identity object id: ____________________

Connections:

| Connection name | Category | Auth type | Target |
|---|---|---|---|
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |

RBAC evidence:

| Scope | Required role | Present (Y/N) |
|---|---|---|
| Storage account | Storage Blob Data Owner |  |
| Cosmos DB | Cosmos DB Operator |  |
| Cosmos DB | SQL Built-in Data Contributor |  |
| Search | Search Index Data Contributor |  |
| Search | Search Service Contributor |  |

Pass or fail: ____________________

## 7. Checkpoint F - Capability Hosts

Account capability host state: ____________________  
Project capability host state: ____________________

Project capability host mapped connections:
- vectorStoreConnections: ____________________
- storageConnections: ____________________
- threadStorageConnections: ____________________

Pass or fail: ____________________

## 8. Agent Validation

Portal access method (VM/VPN/ExpressRoute): ____________________  
Agent name: ____________________  
Model used: ____________________  
Tool added: ____________________

Prompt tested: ____________________  
Tool call result summary: ____________________

Pass or fail: ____________________

## 9. Troubleshooting Notes

Record one issue encountered and how it was fixed:

Issue: ________________________________________________  
Root cause: ____________________________________________  
Fix applied: ____________________________________________

## 10. Final Sign-off

- Account capability host is Succeeded: Yes / No
- Project capability host is Succeeded: Yes / No
- Three AAD project connections are present: Yes / No
- Four private endpoints are Approved: Yes / No
- At least one model deployment exists: Yes / No
- Agent test completed: Yes / No

Facilitator initials: ____________________

## 11. Screenshot Capture Log (Optional)

If your team captured evidence images, store them in `assets/screenshots/hands-on/` and record file names here:

- Architecture screenshot: ____________________
- Private endpoints screenshot: ____________________
- Project capability host screenshot: ____________________
- Agent validation screenshot: ____________________
