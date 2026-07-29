# Authorised Lab Evidence-Capture Guide

Use this guide after building the environment in a personally owned or otherwise authorised Windows Server lab. Do not capture employer systems, real user data, credentials, licence keys, tokens or private network details.

## Evidence checklist

| Evidence | What it proves | Sanitisation required |
|---|---|---|
| VM inventory | Documented server/client versions and roles | Remove host identifiers if necessary |
| AD Users and Computers | OU and group structure exists | Use synthetic identities only |
| `-WhatIf` transcript | Provisioning changes were reviewed first | Remove local paths containing personal names |
| Provisioning transcript | Script executed as designed | Exclude passwords and secrets |
| `Get-ADUser` output | Synthetic account attributes match the plan | Show only lab accounts |
| CLIENT01 domain status | Workstation joined the intended domain | Use fictional domain/addressing |
| `Resolve-DnsName` output | Client resolves DC01 through domain DNS | Keep only lab addresses |
| `nltest /sc_verify` | Secure channel is healthy | No extra production information |
| `gpresult /r` | Intended user/computer policies apply | Remove identifying host/user data |
| Rollback record | A tested change can be reversed | Describe result and timestamp |

## Suggested folder structure

```text
evidence/
├── 01-vm-inventory.md
├── 02-ou-and-group-structure.png
├── 03-provisioning-whatif.txt
├── 04-provisioning-result.txt
├── 05-domain-join.png
├── 06-dns-and-secure-channel.txt
├── 07-gpo-result.txt
└── 08-rollback-test.md
```

The `evidence/` folder should be added only when its contents are genuine and reviewed.

## Screenshot standard

- Capture only the relevant application window.
- Keep the system clock visible when it helps establish sequence.
- Use a consistent 16:9 or wide landscape crop.
- Add a short caption explaining the action, expected result and observed result.
- Never manufacture or digitally alter command output.
- If a result fails, keep it and document the remediation; troubleshooting evidence is valuable.

## Evidence record template

```markdown
# Evidence item: <short title>

- Date:
- Lab owner:
- Environment:
- Change or test:
- Expected result:
- Observed result:
- Pass/fail:
- Follow-up:
- Sanitisation performed:
```

## Completion rule

A checklist item is complete only when the corresponding command or interface was used in an authorised lab and the resulting evidence was reviewed for sensitive information.
