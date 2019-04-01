function Get-BOProcess {
    $serwer = Read-Host "Podaj serwer"
    "sia","tomcat8","CMS" | foreach-object {
    Get-Process -ComputerName $serwer -name $_ -PipelineVariable pv | 
    Measure-Object Workingset -sum -average | 
    Select-object @{Name="Name";Expression = {$pv.name}},
    Count,
    @{Name="SumMB";Expression = {[math]::round($_.Sum/1MB,2)}}
    }
    }