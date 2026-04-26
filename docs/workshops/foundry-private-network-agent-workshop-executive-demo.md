# Executive Demo Version: Private Network Azure AI Foundry Agent

Audience: Business and technical decision makers  
Duration: 60 to 75 minutes  
Goal: Show business value, risk controls, and operational readiness of private-network agent architecture
Series: Private Network Foundry Agent Workshop Suite  
Version: 2026-04-26  
Primary reference: foundry-private-network-agent-guide.md

## 0. How to Use This Version

Use this version to align sponsors and decision makers on business impact, controls, and readiness criteria.

Related versions:
- Full workshop: foundry-private-network-agent-hands-on-workshop.md
- 2-hour workshop: foundry-private-network-agent-hands-on-workshop-2h.md
- Engineer bootcamp: foundry-private-network-agent-workshop-engineer-bootcamp.md
- Trainer playbook: foundry-private-network-agent-workshop-internal-trainer-playbook.md

## 1. Executive Narrative

This demo shows how to build an enterprise AI agent platform that:
- Keeps traffic on private network paths
- Uses managed identity and role-based access instead of shared secrets
- Supports search, storage, and conversation history services with controlled access
- Produces clear deployment evidence for governance and audit discussions

## 2. Business Outcomes to Emphasize

- Data boundary control with private endpoints and private DNS
- Security posture improvement through AAD-based service connections
- Lower operational risk by using deterministic deployment order and verification gates
- Faster compliance conversations because architecture and role assignments are traceable

## 3. Demo Flow and Timing

| Segment | Time | Focus |
|---|---:|---|
| Context and objective | 10 min | Why private network agent architecture matters |
| Architecture walkthrough | 10 min | What components are deployed and why |
| Live evidence review | 20 min | Capability host status, private endpoints, connections, RBAC |
| Agent test scenario | 10 min | Tool-enabled prompt in Foundry |
| Risk and readiness summary | 10 min | Controls, gaps, next-step decisions |

## 4. Required Demo Evidence

Prepare and show these outputs live:
- Account capability host is Succeeded
- Project capability host is Succeeded
- Three project connections exist and use AAD
- Four private endpoints are Approved
- Model deployment exists
- One successful agent test prompt with tool usage

## 5. Suggested Talking Points by Artifact

### Capability host success
- Message: Platform control plane and project runtime are fully wired.

### AAD project connections
- Message: Identity-first integration reduces secret sprawl and credential rotation burden.

### Private endpoint approval
- Message: Data-plane path remains private and policy-enforceable.

### Agent tool test success
- Message: Controls are not only configured; the end-user flow works.

## 6. Risk Discussion Framework

Use this simple map:

| Risk area | Typical concern | Control in this architecture |
|---|---|---|
| Data exfiltration | Public service exposure | Public network access disabled + private endpoints |
| Credential misuse | Shared keys and unmanaged secrets | Managed identity and AAD auth connections |
| Change fragility | Incorrect deployment sequence | Ordered workshop runbook with checkpoints |
| Troubleshooting delays | Hard-to-locate root causes | Standard symptom-to-fix table and verification checklist |

## 7. Executive Questions to Anticipate

1. How does this differ from a public Foundry setup?
2. What security controls are mandatory versus optional?
3. What is the minimum team capability needed to operate this in production?
4. How do we scale to multiple projects and environments?
5. What is the rollback and cleanup model?

## 8. Decisions to Capture at End of Demo

- Preferred landing region and quota owner
- Target pilot use case and data classification
- Team ownership for networking, identity, and AI app operations
- Production readiness criteria and timeline

## 9. Hand-off Artifacts

Point executives and architects to:
- Full build guide: foundry-private-network-agent-guide.md
- Full workshop: foundry-private-network-agent-hands-on-workshop.md
- Condensed workshop: foundry-private-network-agent-hands-on-workshop-2h.md

## 10. Optional Follow-up Session

Recommend a 90-minute technical deep dive that covers:
- CI/CD automation of the deployment order
- Policy enforcement and drift checks
- Operational runbooks for capability host and RBAC break/fix
