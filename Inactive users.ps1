$DaysInactive = 91  
$time = (Get-Date).Adddays(-($DaysInactive)) 

Get-ADUser -Filter {LastLogonTimeStamp -lt $time -and enabled -eq $true} -Properties LastLogonTimeStamp | 
Select-Object Name,SamAccountName,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp).ToString('dd-MM-yyyy_hh:mm')}} | 
Sort-Object Name | FT > old_users.txt
