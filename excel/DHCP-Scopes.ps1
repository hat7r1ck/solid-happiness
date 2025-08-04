function Get-CIDR {
    param ([string]$SubnetMask)

    $maskBytes = $SubnetMask.Split(".") | ForEach-Object { [Convert]::ToString($_, 2).PadLeft(8, '0') }
    return ($maskBytes -join '').ToCharArray() | Where-Object { $_ -eq '1' } | Measure-Object | Select-Object -ExpandProperty Count
}

$output = Get-DhcpServerv4Scope | ForEach-Object {
    $cidr = Get-CIDR -SubnetMask $_.SubnetMask
    [PSCustomObject]@{
        ScopeID        = $_.ScopeId
        SubnetMask     = $_.SubnetMask
        CIDR           = "/$cidr"
        ScopeName      = $_.Name
        IsLargerThan24 = $cidr -lt 24
    }
} | Where-Object { $_.IsLargerThan24 }

# Export to CSV
$output | Export-Csv -Path "$env:USERPROFILE\Desktop\DHCP_Scopes_LargerThan24.csv" -NoTypeInformation
