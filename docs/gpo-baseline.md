# Group Policy Baseline

| GPO | Scope | Purpose | Validation |
|---|---|---|---|
| Workstation security baseline | Workstations | Firewall, Defender and screen-lock controls | gpresult and policy state |
| Windows Update policy | Workstations | Maintenance windows and restart behaviour | Update policy report |
| Drive mapping | Role-based user groups | Department share mapping | Standard-user sign-in |
| Local admin control | Workstations | Restrict unauthorised local administrators | Group membership report |
| Audit policy | Servers and workstations | Log account and policy changes | Event Viewer / audit report |

## Change procedure

1. Back up the GPO.
2. Document owner, purpose and intended scope.
3. Link to a test OU.
4. Test with normal and edge-case users.
5. Review gpresult, event logs and application behaviour.
6. Obtain approval before wider linking.
7. Maintain a tested rollback path.

Do not edit Default Domain Policy for settings that belong in a dedicated, clearly named GPO.
