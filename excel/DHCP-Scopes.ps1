<#
.SYNOPSIS
    Export all DHCP scopes where `.0` may be assigned to a host, which can break detection tools like CrowdStrike.

.OUTPUT
    CSV file: DHCP_Scopes_DotZero_Risk.csv on desktop of current user
#>

function Get-CIDR {
    param ([string]$SubnetMask)

    $maskBytes = $SubnetMask.Split(".") | ForEach-Object {
        [Convert]::ToString($_, 2).PadLeft(8, '0')
    }

    return ($maskBytes -join '').ToCharArray() |
        Where-Object { $_ -eq '1' } |
        Measure-Object |
        Select-Object -ExpandProperty Count
}

# Build output with dot-zero risk flag
$scopes = Get-DhcpServerv4Scope | ForEach-Object {
    $cidr = Get-CIDR -SubnetMask $_.SubnetMask
    $dotZeroRisk = $cidr -ne 24

    [PSCustomObject]@{
        ScopeID        = $_.ScopeId
        SubnetMask     = $_.SubnetMask
        CIDR           = "/$cidr"
        ScopeName      = $_.Name
        DotZeroUsable  = $dotZeroRisk
    }
}

# Export only risky scopes
$scopes | Where-Object { $_.DotZeroUsable } |
Export-Csv -Path "$env:USERPROFILE\Desktop\DHCP_Scopes_DotZero_Risk.csv" -NoTypeInformation -Encoding UTF8

Write-Host "Export complete: DHCP_Scopes_DotZero_Risk.csv on desktop." -ForegroundColor Green
