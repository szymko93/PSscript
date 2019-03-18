function Show-Menu
{
     param (
           [string]$Title = 'BOUtils'
     )
     cls
     Write-Host "================ $Title ================"
     
     Write-Host "1: Wcisnij '1' aby wyswietlic USLUGI."
     Write-Host "2: Wcisnij '2' aby wyswietlic PROCESY."
     
     Write-Host "Q: Wcisnij 'Q' aby wyjsc."
}
do
{
     Show-Menu
     $input = Read-Host "DOKONAJ WYBORU..."
     switch ($input)
     {
           '1' {
                cls
                get-service -name *BO* -computername serwer-bo1, serwer-bo2 | Where-Object {$_.Status -eq "Running"}
           } '2' {
                cls
                Get-Process -ComputerName serwer-bo1, serwer-bo2 | Where-Object {$_.processName -match 'sia'}
                #Get-Process -ComputerName serwer-bo1, serwer-bo2 | Where-Object {$_.processName -match 'sia'}
                #Get-Process -ComputerName serwer-bo1, serwer-bo2 | Where-Object {$_.processName -match 'tomcat8'}
                #Get-Process -ComputerName serwer-bo1, serwer-bo2 | Where-Object {$_.processName -match 'CMS'}
           } 
           'q' {
                return
           }
     }
     pause
}
until ($input -eq 'q')


