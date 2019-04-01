Clear-Host
Function Get-BOProcess {
    Param([string[]]$Name,[string]$Computername = $env:computername)

    Invoke-Command -ScriptBlock {
    $using:Name | foreach-object {
    Get-Process -name $_ -PipelineVariable pv | 
    Measure-Object Workingset -sum | 
    Select-object @{Name="Name";Expression = {$pv.name}},
    @{Name="SumMB";Expression = {[math]::round($_.Sum/1MB,2)}} | Format-Table
    }
    } -ComputerName $computername
    }