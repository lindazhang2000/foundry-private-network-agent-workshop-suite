# Internal Trainer Playbook: Private Network Foundry Agent Workshop

Audience: Internal trainers and field engineering leads  
Use case: Deliver consistent workshops across customer teams and regions
Series: Private Network Foundry Agent Workshop Suite  
Version: 2026-04-26  
Primary reference: foundry-private-network-agent-guide.md

## 0. How to Use This Version

Use this version as the facilitator operating guide for delivery quality and consistency.

Related versions:
- Full workshop: foundry-private-network-agent-hands-on-workshop.md
- 2-hour workshop: foundry-private-network-agent-hands-on-workshop-2h.md
- Executive demo: foundry-private-network-agent-workshop-executive-demo.md
- Engineer bootcamp: foundry-private-network-agent-workshop-engineer-bootcamp.md

## 1. Purpose

This playbook standardizes delivery quality for the private-network Foundry agent workshop. It provides a facilitator script, timing cues, intervention triggers, and escalation rules.

## 2. Delivery Modes

Choose one mode before session start:

| Mode | Duration | Recommended for |
|---|---:|---|
| Executive Demo | 60 to 75 min | Decision and architecture alignment |
| Condensed Hands-on | 2 hours | Mixed audiences with limited time |
| Engineer Bootcamp | 1 day | Deep technical enablement |

## 3. Trainer Preparation Checklist

Complete 24 hours before delivery:
- Confirm all participant subscriptions and permissions
- Validate regional quota assumptions
- Prepare one known-good reference environment
- Prepare one intentionally broken environment for demo troubleshooting
- Share participant worksheet and pre-read links

Complete 30 minutes before start:
- Verify internet and private connectivity path assumptions
- Open required markdown guides and command references
- Confirm timing owner and Q and A moderator

## 4. Facilitation Script with Cues

### Opening (0 to 10 min)

Trainer script:
- Today we will build a private-network AI Foundry agent stack and prove it with objective evidence.
- Success requires correct sequence, identity mapping, and capability host provisioning.

Cue to move on:
- Participants can describe difference between account capability host and project capability host.

### Architecture walkthrough (10 to 20 min)

Trainer script:
- Explain VNet segmentation, private endpoints, and private DNS zones.
- Explain why project connections use AAD auth.

Intervention trigger:
- If participants ask to skip DNS verification, insist on checkpoint completion.

### Lab execution blocks (20 to 100+ min, based on mode)

For each block:
1. State objective in one sentence.
2. Run 1 team as live pace car.
3. Stop for checkpoint evidence from all teams.

Escalation rule:
- If more than 30 percent of teams fail one checkpoint, pause timeline and run shared recovery.

### Troubleshooting block

Trainer script:
- Failures are expected. We care about time-to-recovery using the standard symptom map.

Required exercise:
- At least one team demonstrates recovery from a capability host provisioning failure.

### Closing

Trainer script:
- Review objective evidence artifacts.
- Capture next steps for automation and production readiness.

## 5. Checkpoint Governance

Use strict pass gates:

| Gate | Required evidence |
|---|---|
| Gate 1 | Correct subnet delegation and CIDR |
| Gate 2 | Backing services with public access disabled |
| Gate 3 | Account created with network injection and model deployment |
| Gate 4 | Private endpoints approved and DNS records present |
| Gate 5 | Three AAD project connections and required RBAC |
| Gate 6 | Account and project capability hosts are Succeeded |
| Gate 7 | Agent tool-enabled prompt succeeds |

## 6. Trainer Intervention Patterns

### Pattern A: Teams are blocked on RBAC
- Action: Verify assignee object id is the project managed identity, not user identity.
- Action: Re-run role checks by scope.
- Action: Enforce propagation wait before project capability host retry.

### Pattern B: Teams are blocked on endpoint connectivity
- Action: Confirm they are testing from private network path.
- Action: Check endpoint state and DNS zone records.

### Pattern C: Teams have inconsistent naming
- Action: Freeze progress and align variable names from worksheet.
- Action: Recreate connection payloads with corrected targets.

## 7. Communication Templates

Use these short prompts:

- Progress prompt: We are at Gate X. Please post your evidence output now.
- Recovery prompt: Stop new commands. We will do a shared fix in three steps.
- Time warning: Ten minutes left in this block. Focus only on pass criteria.

## 8. Post-Session Debrief Template

Collect:
- Completion rate by gate
- Most frequent failure mode
- Mean recovery time for capability host failures
- Actions needed for next delivery run

## 9. Recommended Artifact Set

Share these files with participants and co-trainers:
- foundry-private-network-agent-guide.md
- foundry-private-network-agent-hands-on-workshop.md
- foundry-private-network-agent-hands-on-workshop-2h.md
- foundry-private-network-agent-workshop-slide-outline.md
- foundry-private-network-agent-participant-worksheet.md
- foundry-private-network-agent-participant-worksheet-answer-key.md

## 10. Continuous Improvement Notes

After each workshop, update:
- Timing assumptions per module
- Troubleshooting symptom table based on new incidents
- Preflight checks for newly observed quota or policy constraints
