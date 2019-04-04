function Stop_BOService {
    param (
        [Parameter(Mandatory)]
        [validateSet("sia","tomcat")]
        [string[]]$Name,
        [Parameter(Mandatory)]
        [validateSet("serwer-bo1","serwer-bo2")]
        [string[]]$Computername
        )

    Invoke-Command -ScriptBlock {
    $using:Name | foreach-object{
        Stop-Service -Name $_ -PipelineVariable pv
    }
    }   
    -ComputerName $computername
}   