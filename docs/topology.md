# Lab Topology

## Systems

| System | Role | Example address | Notes |
|---|---|---|---|
| DC01 | AD DS and DNS | 192.0.2.10 | Static address in isolated lab |
| CLIENT01 | Domain client | DHCP reservation | Standard-user testing |
| ADMIN01 | Administration | 192.0.2.20 | RSAT; separate admin identity |

The documentation range 192.0.2.0/24 is used deliberately. Replace it with the isolated network assigned to the actual virtual lab.

## Directory structure

- corp.example
  - Users: Finance, Operations, People and IT
  - Workstations
  - Servers
  - Groups
  - Service Accounts

## Administrative model

- Daily user and privileged admin accounts are separate.
- Group membership grants access; direct ACL entries are exceptions.
- Service accounts cannot perform interactive logon.
- Domain Admin membership is temporary and reviewed.
- DNS points domain members to the domain DNS service.
