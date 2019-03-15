invoke-command -computer [computername] -scriptblock {Get-EventLog -logname system -newest 5 |select -Property username, timegenerated}
//test