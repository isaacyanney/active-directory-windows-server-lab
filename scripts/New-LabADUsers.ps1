<#
.SYNOPSIS
Creates or previews Active Directory lab users from a CSV file.

.DESCRIPTION
Uses ShouldProcess so -WhatIf can preview every change. The script requires the ActiveDirectory module and an authorised Windows Server lab. Passwords are supplied securely at runtime.

.EXAMPLE
.\scripts\New-LabADUsers.ps1 -CsvPath .\data\users.csv -InitialPassword (Read-Host -AsSecureString) -WhatIf
#>
[CmdletBinding(SupportsShouldProcess, ConfirmImpact="High")]
param(
    [Parameter(Mandatory)][string]$CsvPath,
    [Parameter(Mandatory)][SecureString]$InitialPassword,
    [Parameter()][string]$UpnSuffix = "corp.example"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Import-Module ActiveDirectory -ErrorAction Stop

$records = @(Import-Csv -Path $CsvPath)
if (-not $records.Count) { throw "No user records found." }

foreach ($record in $records) {
    if ($record.SamAccountName -notmatch "^[a-z0-9._-]+$") {
        Write-Warning "Skipped invalid account name: $($record.SamAccountName)"
        continue
    }

    $existing = Get-ADUser -Filter "SamAccountName -eq '$($record.SamAccountName)'" -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Warning "Skipped existing account: $($record.SamAccountName)"
        continue
    }

    if (-not (Get-ADOrganizationalUnit -Identity $record.OU -ErrorAction SilentlyContinue)) {
        Write-Warning "Skipped $($record.SamAccountName): OU not found."
        continue
    }

    $parameters = @{
        SamAccountName = $record.SamAccountName
        UserPrincipalName = "$($record.SamAccountName)@$UpnSuffix"
        GivenName = $record.GivenName
        Surname = $record.Surname
        Name = "$($record.GivenName) $($record.Surname)"
        DisplayName = "$($record.GivenName) $($record.Surname)"
        Department = $record.Department
        Title = $record.Title
        Path = $record.OU
        AccountPassword = $InitialPassword
        ChangePasswordAtLogon = $true
        Enabled = [System.Convert]::ToBoolean($record.Enabled)
    }

    if ($PSCmdlet.ShouldProcess($parameters.UserPrincipalName, "Create lab AD user")) {
        New-ADUser @parameters
        if ($record.ManagerSam) {
            $manager = Get-ADUser -Identity $record.ManagerSam -ErrorAction SilentlyContinue
            if ($manager) { Set-ADUser -Identity $record.SamAccountName -Manager $manager.DistinguishedName }
        }
        Write-Host "Created: $($parameters.UserPrincipalName)" -ForegroundColor Green
    }
}
