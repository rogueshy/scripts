$input = Import-Csv -Encoding UTF8 -Delimiter ";" -Path .\phones.csv
Foreach ($line in $input) {
$name = '*'+$line.Name+'*'
$surname = '*'+$line.Surname+'*'
$mobile = $line.Mobile
$office = $line.Office
$add = $line.Add
$user = Get-ADUser -Filter {(GivenName -like $name) -and (Surname -like $surname)} -Properties mobile,telephoneNumber
if ($user -ne $null) {
    if (($mobile -eq $null) -and ($add -eq $null) -and ($office -eq $null)) { break }
    elseif (($mobile -ne $null) -and ($user.mobile -ne $null)) {
    Set-ADUser -Identity $user -Add @{mobile="$mobile"} }
    elseif (($mobile -ne $null) -and ($user.mobile -eq $null)) {
    Set-ADUser -Identity $user -Replace @{mobile="$mobile"} }
    elseif (($add -ne $null) -and ($user.OfficePhone -ne $null)) {
    Set-ADUser -Identity $user -Add @{telephoneNumber="$add"} }
    elseif (($add -ne $null) -and ($user.OfficePhone -eq $null)) {
    Set-ADUser -Identity $user -Replace @{telephoneNumber="$add"} }
    elseif (($add -eq $null) -and ($office -ne $null) -and ($user.OfficePhone -ne $null)) {
    Set-ADUser -Identity $user -Add @{telephoneNumber="$office"} }
    elseif (($add -eq $null) -and ($office -ne $null) -and ($user.OfficePhone -eq $null)) {
    Set-ADUser -Identity $user -Replace @{telephoneNumber="$office"} }
    else { break }
} 
else  { $fullname = $name + ' ' + $surname
Echo $fullname 'not found!' | Out-File -FilePath .\user_error.txt -Encoding utf8 -Append }
}