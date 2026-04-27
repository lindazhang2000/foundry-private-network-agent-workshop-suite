# Screenshot Library

This folder stores workshop evidence screenshots captured from a real subscription deployment.

## Folder Map

- `readme/`: hero screenshots referenced by top-level README
- `reference/`: detailed technical evidence for the full implementation guide
- `hands-on/`: checkpoint screenshots for the full workshop
- `hands-on-2h/`: condensed checkpoint screenshots for the 2-hour workshop
- `executive-demo/`: business-facing evidence visuals for executive demo
- `trainer-playbook/`: troubleshooting and facilitation visuals for trainer guidance
- `slide-outline/`: architecture and flow visuals used in slides
- `worksheet-answer-key/`: expected-outcome screenshots for answer-key validation

## Suggested Naming Convention

Use ordered, stable names so links stay deterministic:

- `01-architecture-overview.png`
- `02-private-endpoints-approved.png`
- `03-private-dns-records.png`
- `04-project-connections-aad.png`
- `05-project-caphost-succeeded.png`
- `06-agent-tool-validation.png`

## Redaction Checklist

Before committing screenshots, hide or blur:

- Subscription IDs
- Tenant IDs
- User emails and names
- Private IPs and hostnames that expose internal topology
- Access tokens or secret-like values
