$user = Get-ADUser $env:USERNAME -Properties *
$1 = $user.City
$2 = $user.Department
$3 = $user.SamAccountName 
$4 = $user.Name
$5 = $user.EmailAddress
#$6 = $env:CLIENTNAME
[System.IO.File]::WriteAllText("%out_folder%\$env:CLIENTNAME.txt","$1`r`n$2`r`n$3`r`n$4`r`n$5",[Text.Encoding]::UTF8)