# Engineer Bootcamp Version: Private Network Azure AI Foundry Agent

Audience: Platform engineers, cloud engineers, AI engineers  
Duration: 1 full day (6.5 to 7.5 hours with breaks)  
Goal: Build, validate, break, and recover a private-network Foundry agent environment
Series: Private Network Foundry Agent Workshop Suite  
Version: 2026-04-26  
Primary reference: foundry-private-network-agent-guide.md

## 0. How to Use This Version

Use this version for deep technical enablement with lab evidence and break/fix exercises.

Related versions:
- Full workshop: foundry-private-network-agent-hands-on-workshop.md
- 2-hour workshop: foundry-private-network-agent-hands-on-workshop-2h.md
- Executive demo: foundry-private-network-agent-workshop-executive-demo.md
- Trainer playbook: foundry-private-network-agent-workshop-internal-trainer-playbook.md

## 1. Bootcamp Outcomes

By the end of this bootcamp, participants can:
- Deploy all required resources in correct dependency order
- Configure project connections with AAD authentication
- Assign and verify required RBAC for project managed identity
- Provision and validate both capability host layers
- Diagnose and repair common failure modes quickly

## 2. Day Plan

| Module | Time | Mode |
|---|---:|---|
| Module 0: Preflight and setup | 45 min | Lab |
| Module 1: Networking and private path | 60 min | Lab |
| Module 2: Core services and Foundry account | 75 min | Lab |
| Module 3: Project, connections, RBAC | 90 min | Lab |
| Module 4: Capability host deep dive | 60 min | Lab + review |
| Module 5: Break/fix exercises | 75 min | Scenario lab |
| Module 6: Validation, hardening, cleanup | 45 min | Lab |

## 3. Preflight Checklist

Complete before Module 1:
- Azure provider registration completed
- Quota validated in selected region
- Naming suffix selected per team
- Subscription scope confirmed
- Baseline tools installed (Azure CLI and PowerShell)

## 4. Module Details

### Module 0: Preflight and setup

Tasks:
1. Set workshop variables.
2. Create resource group.
3. Verify account context and permissions.

Evidence:
- Resource group and location output captured.

### Module 1: Networking and private path

Tasks:
1. Create VNet and two subnets.
2. Delegate agent subnet to Microsoft.App environments.
3. Validate address space and delegation.

Evidence:
- Subnet delegation details.
- Non-overlapping CIDR proof.

### Module 2: Core services and Foundry account

Tasks:
1. Deploy Search, Storage, Cosmos DB with public access disabled.
2. Create AI Services account with network injection (REST).
3. Deploy one model.

Evidence:
- Service-level network hardening settings.
- Account and model deployment status.

### Module 3: Project, connections, RBAC

Tasks:
1. Create project with system-assigned identity.
2. Create Cosmos, Storage, and Search project connections using AAD auth.
3. Assign required RBAC roles to project managed identity.
4. Wait for role propagation.

Evidence:
- Three AAD project connections listed.
- Role assignment output by scope.

### Module 4: Capability host deep dive

Tasks:
1. Create project capability host with three connection arrays.
2. Poll async status and inspect transitions.
3. Verify account and project capability hosts.

Evidence:
- Final Succeeded status for both capability hosts.
- Mapping arrays visible in project capability host response.

### Module 5: Break/fix exercises

Exercise A: Missing project capability host
- Injected fault: Skip project capability host creation and test agent flow.
- Expected result: Invalid endpoint or connection failed.
- Fix: Create project capability host and retest.

Exercise B: Incomplete RBAC
- Injected fault: Remove one required role and attempt project capability host creation.
- Expected result: Capability host provisioning failure.
- Fix: Reassign role, wait propagation, recreate project capability host.

Exercise C: Embedding permission issue
- Injected fault: Missing Cognitive Services OpenAI User role.
- Expected result: Search embedding permission denied.
- Fix: Grant role to project managed identity and account managed identity.

Evidence:
- Before and after outputs for each fix.

### Module 6: Validation, hardening, cleanup

Tasks:
1. Run consolidated verification checklist.
2. Discuss production hardening priorities.
3. Execute cleanup sequence.

Evidence:
- Final pass/fail worksheet complete.

## 5. Scoring Rubric

| Category | Weight | Pass criteria |
|---|---:|---|
| Build correctness | 35% | All required resources deployed in correct state |
| Security posture | 25% | Private access + AAD connections + RBAC complete |
| Troubleshooting skill | 25% | Break/fix scenarios resolved with evidence |
| Operational readiness | 15% | Validation artifacts and cleanup execution |

## 6. Production Readiness Discussion

At session end, each team proposes:
- CI/CD approach for ordering and idempotency
- Alerting strategy for capability host failures
- RBAC governance model across environments
- Cost and cleanup controls

## 7. Reference Files

Use these in the workspace:
- foundry-private-network-agent-guide.md
- foundry-private-network-agent-hands-on-workshop.md
- foundry-private-network-agent-participant-worksheet.md
- foundry-private-network-agent-participant-worksheet-answer-key.md
