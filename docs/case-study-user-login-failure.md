# Troubleshooting Case Study: Domain User Cannot Sign In

## Scenario

A newly provisioned user reports that they cannot sign in to a domain-joined Windows workstation. The fictional lab environment uses the `corp.example` domain, `DC01` as the domain controller and `CLIENT01` as the affected workstation.

This case study documents a repeatable diagnostic approach. It does not claim that the incident occurred in a production environment.

## Initial ticket

| Field | Value |
|---|---|
| User | Amina Mensah |
| Device | CLIENT01 |
| Impact | One user cannot access their assigned workstation |
| Error | “The user name or password is incorrect” |
| Recent change | New account created through the lab provisioning workflow |
| Priority | P3 in this fictional scenario |

## Investigation

### 1. Confirm scope and exact symptom

- Confirm the username and device name without requesting the password.
- Establish whether the user can sign in to another domain resource.
- Determine whether other users can sign in to CLIENT01.
- Record the exact error and timestamp.

### 2. Verify the client’s domain path

Run from CLIENT01:

```powershell
ipconfig /all
Resolve-DnsName dc01.corp.example
Test-NetConnection dc01.corp.example -Port 88
Test-NetConnection dc01.corp.example -Port 389
nltest /sc_verify:corp.example
```

Expected evidence:

- CLIENT01 uses the domain DNS server—not a public resolver.
- DC01 resolves to the documented lab address.
- Kerberos and LDAP paths are reachable.
- The workstation secure channel is valid.

### 3. Inspect the account safely

Run from an authorised administrative session:

```powershell
Get-ADUser -Identity amina.mensah -Properties Enabled,LockedOut,PasswordExpired,UserPrincipalName |
    Select-Object SamAccountName,Enabled,LockedOut,PasswordExpired,UserPrincipalName
```

Check that:

- the account exists and is enabled;
- the UPN and sign-in name match the approved record;
- the account is not locked;
- the temporary password has not expired unexpectedly;
- the user is signing in to the domain rather than a similarly named local account.

### 4. Review provisioning evidence

Compare the approved CSV record, the `-WhatIf` preview and the created account. Verify the target OU, UPN suffix and enabled state.

## Root cause used for this lab case

CLIENT01 was configured with a public DNS resolver. Internet access worked, but the client could not locate the domain controller reliably. The account itself was valid.

## Resolution

1. Changed CLIENT01’s DNS configuration to the authorised domain DNS server.
2. Flushed the DNS client cache and registered the client record.
3. Re-ran name-resolution and secure-channel checks.
4. Asked the user to sign in using `CORP\amina.mensah`.
5. Confirmed successful sign-in and recorded the outcome.

```powershell
Clear-DnsClientCache
ipconfig /registerdns
nltest /sc_verify:corp.example
```

## Ticket closure note

> User impact confirmed on CLIENT01. Account was enabled and not locked. Client used an external DNS resolver and could not reliably locate DC01. Restored the approved domain DNS configuration, cleared the resolver cache and verified the secure channel. User successfully signed in. No password was collected or recorded.

## Escalation boundary

Escalate if the secure channel remains broken, DNS records are missing on the server, replication is unhealthy, or remediation requires an unapproved domain-controller or network change.

## Skills demonstrated

DNS-aware domain troubleshooting, account-state validation, least-privilege administration, evidence-based incident notes and user-focused closure.
