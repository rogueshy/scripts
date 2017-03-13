$user = Get-ADUser $env:USERNAME -Properties *
$1 = $user.City
$2 = $user.Department
$3 = $user.SamAccountName 
$4 = $user.Name
$5 = $user.EmailAddress
#$6 = $env:CLIENTNAME

$1, $2, $3, $4, $5 | Out-File -FilePath "%out_folder%\$env:CLIENTNAME.txt" -Encoding UTF8