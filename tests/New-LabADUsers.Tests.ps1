BeforeAll {
    $scriptPath = Join-Path $PSScriptRoot '..\scripts\New-LabADUsers.ps1'
    $scriptText = Get-Content -Path $scriptPath -Raw
    $tokens = $null
    $parseErrors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile(
        $scriptPath,
        [ref]$tokens,
        [ref]$parseErrors
    )
}

Describe 'New-LabADUsers safety and quality checks' {
    It 'has valid PowerShell syntax' {
        $parseErrors.Count | Should -Be 0
    }

    It 'declares ShouldProcess support' {
        $scriptText | Should -Match 'SupportsShouldProcess'
    }

    It 'accepts the initial password as SecureString' {
        $scriptText | Should -Match '\[SecureString\]\$InitialPassword'
    }

    It 'supports safe preview through WhatIf' {
        $scriptText | Should -Match '\$PSCmdlet\.ShouldProcess'
    }

    It 'does not contain a plaintext password assignment' {
        $scriptText | Should -Not -Match '(?im)^\s*(password|initialpassword)\s*=\s*["''][^"'']+["'']'
    }

    It 'imports the ActiveDirectory module explicitly' {
        $scriptText | Should -Match 'Import-Module\s+ActiveDirectory'
    }

    It 'checks for an existing user before creation' {
        $scriptText | Should -Match 'Get-ADUser'
        $scriptText | Should -Match 'Skipped existing account'
    }

    It 'checks that the target OU exists' {
        $scriptText | Should -Match 'Get-ADOrganizationalUnit'
        $scriptText | Should -Match 'OU not found'
    }

    It 'creates users only inside a ShouldProcess block' {
        $shouldProcessNodes = $ast.FindAll(
            { param($node) $node -is [System.Management.Automation.Language.InvokeMemberExpressionAst] -and $node.Member.Value -eq 'ShouldProcess' },
            $true
        )
        $newUserNodes = $ast.FindAll(
            { param($node) $node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -eq 'New-ADUser' },
            $true
        )

        $shouldProcessNodes.Count | Should -BeGreaterThan 0
        $newUserNodes.Count | Should -Be 1
    }
}
