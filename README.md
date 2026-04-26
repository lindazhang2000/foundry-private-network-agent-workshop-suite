# Microsoft Foundry Private Network Agent Workshop Suite

This repository contains a complete workshop suite for building and validating a private-network Azure AI Foundry agent environment end to end.

## What Is Included

- Full implementation guide
- Multi-format workshop tracks (full, 2-hour, executive, bootcamp, trainer)
- Participant worksheet and answer key
- Deployment payload templates and infrastructure sample
- Utility scripts used during troubleshooting and verification

## Repository Structure

```text
foundry-private-network-agent-workshop-suite/
  docs/
    reference/
      foundry-private-network-agent-guide.md
    workshops/
      foundry-private-network-agent-hands-on-workshop.md
      foundry-private-network-agent-hands-on-workshop-2h.md
      foundry-private-network-agent-workshop-executive-demo.md
      foundry-private-network-agent-workshop-engineer-bootcamp.md
      foundry-private-network-agent-workshop-internal-trainer-playbook.md
      foundry-private-network-agent-workshop-slide-outline.md
      foundry-private-network-agent-participant-worksheet.md
      foundry-private-network-agent-participant-worksheet-answer-key.md
  assets/
    templates/
      caphost.json
      caphost2.json
      caphost3.json
      cosmos-conn.json
      storage-conn.json
      search-conn.json
      cosmos-role-proj.json
      cosmosdb-template.json
  infra/
    deploy-project-caphost.bicep
  scripts/
    exec_query.ps1
    run_exact.ps1
```

## Suggested Start Points

- First read: `docs/reference/foundry-private-network-agent-guide.md`
- Full hands-on delivery: `docs/workshops/foundry-private-network-agent-hands-on-workshop.md`
- Fast 2-hour run: `docs/workshops/foundry-private-network-agent-hands-on-workshop-2h.md`
- Executive briefing: `docs/workshops/foundry-private-network-agent-workshop-executive-demo.md`
- Internal trainer operations: `docs/workshops/foundry-private-network-agent-workshop-internal-trainer-playbook.md`

## Local Usage

1. Open this folder in VS Code.
2. Review prerequisites in the reference guide.
3. Pick the workshop track based on audience and time.
4. Use templates from `assets/templates/` when creating REST payloads.

## Notes

- The workshop content assumes Azure CLI access and required Azure permissions.
- Keep sensitive values out of committed files.
