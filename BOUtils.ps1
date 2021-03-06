﻿function Show-Menu {
    param (
        [string]$Title = 'BOUtils'
    )
    cls
    Write-Host "================ $Title ================"
    Write-Host "1: Wcisnij '1' aby wyswietlic USLUGI."
    Write-Host "2: Wcisnij '2' aby wyswietlic PROCESY."
    Write-Host "3: Wcisnij '3' aby dodac uzytkownika do grupy FL_BO."
    Write-Host "4: Wcisnij '4' aby wyswietlic rozmiar baz danych BOXIAUDIT i BOXIREPO."
    Write-Host "5: Wcisnij '5' aby wyswietlic logowania uzytkownika."
    Write-Host "Q: Wcisnij 'Q' aby wyjsc."
}
do {
    Show-Menu
    $input = Read-Host "DOKONAJ WYBORU..."
    switch ($input) {
        '1' {
            clear
            get-service -name *BO* -computername serwer-bo1, serwer-bo2 | Where-Object {$_.Status -eq "Running"} | format-table
        }'2' {
            clear
            Get-Process -ComputerName serwer-bo1, serwer-bo2 | Where-Object {($_.processName -match 'sia') -or ($_.processName -match 'tomcat8') -or ($_.processName -match 'CMS')} | format-table
        }'3' {
            clear
            $user = Read-Host "Podaj uzytkownika"
                
            $SamAccountName = 'doesNotExist'
            try {
                $usr = Get-ADUser $user -Properties DisplayName | select -expand displayname -ErrorAction Stop
            }
            catch {
                Write-Warning -Message "NIE MA TAKIEGO UZYTKOWNIKA W ACTIVE DIRECTORY"
                break
            } 
            $users = $user
            $group = '#FL_BO'
            $members = Get-ADGroupMember -Identity $group -Recursive | Select-Object -ExpandProperty SAMAccountName
            ForEach ($user in $users) {
                Write-Host "================================="
                If ($members -contains $user) {
                    Write-Host "$usr nalezy juz do grupy $group"
                } 
                Else {
                    Write-Host "$usr NIE nalezy do grupy $group"
                    $zmienna = Read-Host "Czy chcesz go teraz dodac? tak/nie"
                    switch ($zmienna) {
                        'tak' {
                            foreach ($Groups in $Group) {
                                Add-ADPrincipalGroupMembership -identity $User -MemberOf $Groups -WhatIf
                            }
                            Write-Host "Uzytkownik został dodany do grupy!"
                        }
                        'nie' {
                            Write-Host "Powodzenia dalej!"
                        } 
                    }
                }
            }   
        }'4'{
            $dbName1 = 'BOXIREPO4'
            $dbName2 = 'BOXIAUDIT4'
            Get-DbaDbSpace -SqlServer sbop-test01 -database $dbName1, $dbName2 | select-Object Database, UsedSpace, FreeSpace, FileSize | format-table
            
        }'5'{
            $SqlServer = Read-Host "Enter SQL Server Instance name:"
            $SqlQuery = "SELECT TOP (50) [User_Name],[Object_Name] FROM dbo.ADS_EVENT" 
            $SqlDatabase = Read-Host "Enter SQL Database name:"
            Invoke-Sqlcmd -ServerInstance $SqlServer -Database $SqlDatabase -Query $SqlQuery | format-table
        }'q' 
        {
            return
        }
    }
    pause
}
until ($input -eq 'q')