# Windows Server & Active Directory Administration Lab

[![PowerShell syntax validation](https://github.com/isaacyanney/active-directory-windows-server-lab/actions/workflows/powershell-syntax.yml/badge.svg)](https://github.com/isaacyanney/active-directory-windows-server-lab/actions/workflows/powershell-syntax.yml)

A reproducible lab design for core junior-system-administration work: directory structure, DNS-aware domain topology, Group Policy, role-based access, safe user provisioning and evidence-based troubleshooting.

## Evidence boundary

The domain, addresses and users are synthetic. The PowerShell provisioning script is functional but must be run only in an authorised Windows Server lab with the ActiveDirectory module available. No live-domain deployment is claimed here.

## Skills demonstrated

- AD DS logical design and organisational units
- DNS and domain-client dependencies
- Separate daily and privileged identities
- Group-based access and least privilege
- GPO pilot, validation and rollback planning
- PowerShell provisioning with `-WhatIf` and `ShouldProcess`
- Account, group-access and GPO troubleshooting
- Automated PowerShell syntax validation

## Contents

```text
├── data/users.csv
├── scripts/New-LabADUsers.ps1
├── docs/topology.md
├── docs/gpo-baseline.md
├── docs/troubleshooting.md
└── .github/workflows/powershell-syntax.yml
```

## Preview user provisioning

```powershell
$initialPassword = Read-Host "Temporary lab password" -AsSecureString
.\scripts\New-LabADUsers.ps1 `
  -CsvPath .\data\users.csv `
  -InitialPassword $initialPassword `
  -WhatIf
```

Remove `-WhatIf` only after the OU paths, naming standard, approvals and test environment are verified. Passwords are never stored in the repository.

## Intended lab sequence

1. Build an isolated virtual network.
2. Install Windows Server and configure static addressing.
3. Promote `DC01` and configure domain DNS.
4. Create the documented OU and group model.
5. Join a Windows client.
6. Preview and run user provisioning.
7. Link GPOs to a test OU and validate with a standard user.
8. Capture evidence and rollback results.

## Completion evidence to add later

- virtual-machine inventory and versions
- domain-join validation
- `gpresult` output from the test client
- user-provisioning transcript
- DNS and secure-channel tests
- documented rollback test

## Author

**Isaac Lovelace Yanney** — IT Support & Technical Operations  
[GitHub](https://github.com/isaacyanney) · [LinkedIn](https://www.linkedin.com/in/isaac-lovelace-yanney/)
