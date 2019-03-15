get-eventlog -LogName system -newest 5 | select -Property eventid, TimeWritten, Message | sort -Property timewritten | ConvertTo-Csv | Out-File [location]
//test
