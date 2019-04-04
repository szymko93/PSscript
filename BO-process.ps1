Clear-Host
Function Get-BOProcess {
    Param(
        [Parameter(Mandatory)]
        [validateSet("sia","tomcat")]
        [string[]]$Name,
        [Parameter(Mandatory)]
        [validateSet("serwer-bo1","serwer-bo2")]
        [string[]]$Computername
        )

    Invoke-Command -ScriptBlock {
    $using:Name | foreach-object {
    Get-Process -name $_ -PipelineVariable pv | 
    Measure-Object Workingset -sum | 
    Select-object @{Name="Name";Expression = {$pv.name}},
    @{Name="SumMB";Expression = {[math]::round($_.Sum/1MB,2)}} | Format-Table
    }
    } -ComputerName $computername
    }
