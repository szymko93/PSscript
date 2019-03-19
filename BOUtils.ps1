function Show-Menu {
    param (
        [string]$Title = 'BOUtils'
    )
    cls
    Write-Host "================ $Title ================"
    Write-Host "1: Wcisnij '1' aby wyswietlic USLUGI."
    Write-Host "2: Wcisnij '2' aby wyswietlic PROCESY."
    Write-Host "3: Wcisnij '3' aby dodac uzytkownika do grupy FL_BO."
    Write-Host "Q: Wcisnij 'Q' aby wyjsc."
}
do {
    Show-Menu
    $input = Read-Host "DOKONAJ WYBORU..."
    switch ($input) {
        '1' {
            cls
            get-service -name *BO* -computername serwer-bo1, serwer-bo2 | Where-Object {$_.Status -eq "Running"}
        }'2' {
            cls
            Get-Process -ComputerName serwer-bo1, serwer-bo2 | Where-Object {($_.processName -match 'sia') -or ($_.processName -match 'tomcat8') -or ($_.processName -match 'CMS')}
        }'3' {
            cls
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
                    Write-Host "$usr nalezy do grupy $group"
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
        }
        'q' {
            return
        }
    }
    pause
}
until ($input -eq 'q')