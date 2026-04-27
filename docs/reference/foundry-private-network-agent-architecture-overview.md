# Architecture Overview: Private Network Azure AI Foundry Agent

This document provides a concise architecture view of the private-network Foundry agent pattern used in this workshop suite.

## 1. Architecture at a Glance

Choose the view below based on audience depth.

### 1.1 Keynote View (6-Box Story)

```mermaid
%%{init: {"themeVariables": {"fontSize": "22px"}}}%%
flowchart LR
  U[User App]
  A[Foundry Agent]
  P[Private Network Boundary]
  M[Model Inference]
  D[Enterprise Data Services]
  G[Governance and RBAC]

  U -->|Ask| A
  A -->|Invoke| M
  A -->|Route through| P
  P -->|Private access| D
  G -->|Enforce access| A
  G -->|Enforce access| D

  classDef user fill:#FFE9A8,stroke:#B38A00,color:#2E2500,stroke-width:1px,font-size:22px;
  classDef runtime fill:#DDF6EA,stroke:#2E8B57,color:#0D3D28,stroke-width:1px,font-size:22px;
  classDef network fill:#EDE1FF,stroke:#6D3FB3,color:#2F1854,stroke-width:1px,font-size:22px;
  classDef foundry fill:#DCEBFF,stroke:#2F6FBD,color:#0E2D57,stroke-width:1px,font-size:22px;
  classDef data fill:#FFE3DC,stroke:#B14B2B,color:#4A1B0E,stroke-width:1px,font-size:22px;
  classDef guard fill:#EFEFEF,stroke:#666666,color:#222222,stroke-width:1px,font-size:22px;

  class U user;
  class A runtime;
  class P network;
  class M foundry;
  class D data;
  class G guard;
```

### 1.2 Executive View (Slide-Friendly)

```mermaid
%%{init: {"themeVariables": {"fontSize": "20px"}}}%%
flowchart LR
  USER[Business App or User]
  AGENT[Foundry Agent Runtime]

  subgraph PRIVATE[Private Network Boundary]
    direction LR
    VNET[VNet with delegated subnet]
    PEP[Private Endpoints]
    DNS[Private DNS]
  end

  subgraph FOUNDRY[Foundry Platform]
    direction TB
    AIS[AI Services Account]
    PROJ[Foundry Project and AAD Connections]
  end

  subgraph DATA[Enterprise Data Services]
    direction TB
    SRCH[AI Search]
    STOR[Storage]
    CDB[Cosmos DB]
  end

  USER -->|Ask| AGENT
  AGENT -->|Model and orchestration| AIS
  AIS --> PROJ

  AGENT -->|Private traffic only| PEP
  PEP --> SRCH
  PEP --> STOR
  PEP --> CDB
  DNS -.-> PEP
  VNET --> PEP

  classDef user fill:#FFE9A8,stroke:#B38A00,color:#2E2500,stroke-width:1px,font-size:20px;
  classDef runtime fill:#DDF6EA,stroke:#2E8B57,color:#0D3D28,stroke-width:1px,font-size:20px;
  classDef foundry fill:#DCEBFF,stroke:#2F6FBD,color:#0E2D57,stroke-width:1px,font-size:20px;
  classDef network fill:#EDE1FF,stroke:#6D3FB3,color:#2F1854,stroke-width:1px,font-size:20px;
  classDef data fill:#FFE3DC,stroke:#B14B2B,color:#4A1B0E,stroke-width:1px,font-size:20px;

  class USER user;
  class AGENT runtime;
  class AIS,PROJ foundry;
  class PRIVATE,VNET,PEP,DNS network;
  class DATA,SRCH,STOR,CDB data;
```

### 1.3 Technical View (Implementation Detail)

```mermaid
%%{init: {"themeVariables": {"fontSize": "22px"}}}%%
flowchart LR
  U[Workshop User or Operator]

  subgraph CTRL[Foundry Control and Project Plane]
    direction TB
    AI[AI Services Account\nAIServices S0]
    MODEL[Model Deployment]
    PROJ[Foundry Project]
    CONN[Project Connections\nAAD]
  end

  subgraph VNET[Customer VNet 192.168.0.0/16]
    direction TB

    subgraph AGENT[agent-subnet 192.168.0.0/24\ndelegated to Microsoft.App/environments]
      direction TB
      ACH[Account Capability Host]
      PCH[Project Capability Host]
    end

    subgraph PE[pe-subnet 192.168.1.0/24]
      direction TB
      PEAI[PE: AI Services]
      PESE[PE: AI Search]
      PEST[PE: Storage Blob]
      PECO[PE: Cosmos DB SQL]
    end

    DNS[Private DNS Zones\nlinked to VNet]
  end

  subgraph DATA[Backing Data Services]
    direction TB
    SEARCH[Azure AI Search]
    STORE[Azure Storage Blob]
    COSMOS[Azure Cosmos DB NoSQL]
  end

  subgraph LEGEND[Color Legend]
    direction TB
    LG1[User Entry]:::user
    LG2[Foundry Control and Project]:::foundry
    LG3[Runtime Hosts]:::runtime
    LG4[Network and DNS]:::network
    LG5[Data Services]:::data
  end

  U -->|Prompt| PROJ
  AI -->|Hosts| MODEL
  AI -->|Creates| ACH
  PROJ -->|Creates| PCH
  PROJ -->|Defines| CONN

  PCH -->|Uses AAD connections| CONN
  CONN -->|Vector and retrieval| SEARCH
  CONN -->|Blob and files| STORE
  CONN -->|Threads and entities| COSMOS

  ACH -->|Private path| PEAI
  PCH -->|Private path| PEAI
  PCH -->|Private path| PESE
  PCH -->|Private path| PEST
  PCH -->|Private path| PECO

  DNS -.->|privatelink resolution| PEAI
  DNS -.->|privatelink resolution| PESE
  DNS -.->|privatelink resolution| PEST
  DNS -.->|privatelink resolution| PECO

  PEAI --> AI
  PESE --> SEARCH
  PEST --> STORE
  PECO --> COSMOS

  classDef user fill:#FFE9A8,stroke:#B38A00,color:#2E2500,stroke-width:1px,font-size:22px;
  classDef foundry fill:#DCEBFF,stroke:#2F6FBD,color:#0E2D57,stroke-width:1px,font-size:22px;
  classDef runtime fill:#DDF6EA,stroke:#2E8B57,color:#0D3D28,stroke-width:1px,font-size:22px;
  classDef network fill:#EDE1FF,stroke:#6D3FB3,color:#2F1854,stroke-width:1px,font-size:22px;
  classDef data fill:#FFE3DC,stroke:#B14B2B,color:#4A1B0E,stroke-width:1px,font-size:22px;
  classDef dns fill:#EFEFEF,stroke:#666666,color:#222222,stroke-width:1px,font-size:22px;

  class U user;
  class AI,MODEL,PROJ,CONN foundry;
  class ACH,PCH runtime;
  class PEAI,PESE,PEST,PECO network;
  class DNS dns;
  class SEARCH,STORE,COSMOS data;

  style VNET fill:#F9FAFC,stroke:#8EA3BF,stroke-width:1px;
  style AGENT fill:#ECFFF5,stroke:#5AAE84,stroke-width:1px;
  style PE fill:#F5EEFF,stroke:#8A67C7,stroke-width:1px;
  style CTRL fill:#EFF6FF,stroke:#7EA7D8,stroke-width:1px;
  style DATA fill:#FFF3F0,stroke:#DA8B74,stroke-width:1px;
  style LEGEND fill:#FFFFFF,stroke:#B0B0B0,stroke-width:1px;
```

## 2. Core Components

| Layer | Component | Purpose |
|---|---|---|
| Control plane | AI Services account | Hosts model deployments and account capability host configuration |
| Project plane | Foundry project | Owns project managed identity and project-level connections |
| Runtime | Account capability host | Enables network-injected runtime in delegated subnet |
| Runtime | Project capability host | Binds Search, Storage, and Cosmos connections for agent tools |
| Data services | AI Search, Storage, Cosmos DB | Retrieval, blob storage, and thread/entity persistence |
| Network | Private endpoints + private DNS | Keeps data plane traffic private and name resolution internal |

## 3. Request and Data Flow

1. User invokes agent from approved private access path.
2. Foundry project routes to deployed model in AI Services account.
3. Agent runtime uses project capability host for tool access.
4. Tool calls resolve service FQDNs through private DNS zones.
5. Calls reach private endpoints in pe-subnet.
6. Backing services enforce AAD and RBAC with project managed identity.
7. Results return to runtime and then to user.

## 4. Security and Governance Controls

- Public network access disabled on AI Services, Search, Storage, and Cosmos DB.
- AAD-based project connections instead of key-based auth.
- Least-privilege RBAC on storage, search, and cosmos scopes.
- Private endpoint approval and DNS linkage as deployment gates.
- Capability host provisioning state used as operational health signal.

## 5. Critical Dependencies

- `agent-subnet` must be delegated to `Microsoft.App/environments`.
- Required RBAC must exist before project capability host creation.
- Private DNS zones must be linked to the VNet and contain A records.
- Project capability host must show `Succeeded` with all three connection arrays populated.

## 6. Verification Checklist

- Account capability host: `Succeeded`
- Project capability host: `Succeeded`
- Project connections: `CosmosDB`, `AzureStorageAccount`, `CognitiveSearch` using `AAD`
- Private endpoints: `Approved` for AI Services, Search, Storage, Cosmos DB
- DNS records resolve to private range used by pe-subnet
