# Active Directory Troubleshooting Runbook

## Sign-in failure

1. Record the exact message and affected device.
2. Confirm network connectivity and domain DNS.
3. Check system time and secure-channel state.
4. Confirm whether the account is enabled, locked or expired.
5. Review recent password, group or GPO changes.
6. Test with a known-good user or device to isolate the fault.

## Group access failure

- confirm effective group membership
- distinguish security from distribution groups
- check token refresh or sign-out requirements
- review nested groups
- inspect share and NTFS permissions separately
- use whoami /groups and documented ACL evidence

## GPO not applying

Check OU placement, link status, security filtering, WMI filters, replication and client event logs before forcing repeated updates. Capture gpresult and Resultant Set of Policy reports.

## Escalation evidence

Include hostname, user, time, IP/DNS state, domain controller used, relevant event IDs, gpresult output, actions attempted and business impact.
