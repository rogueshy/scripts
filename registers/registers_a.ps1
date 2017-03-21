# output path & filename:
$out_file = "folder"+$env:computername+".txt"

# motherboard stuff
$System = GWMI Win32_OperatingSystem
$CPU = GWMI Win32_Processor
$Ram = $System.TotalVisibleMemorySize*1024/1GB
$Ram = "{0:N0}" -f $Ram
<# Checking if TeamViewer v9 is present and getting it's ID
    If it's not - write a single 0 instead of ID
    changed from 000000000 for correct JSON parsing  #>
If ($System.OSArchitecture -like "*64*") {
    $TV = Get-ItemProperty HKLM:\Software\Wow6432Node\TeamViewer\Version9\ ClientID -ErrorAction SilentlyContinue }
    Else {
        $TV = Get-ItemProperty HKLM:\Software\TeamViewer\Version9 ClientID -ErrorAction SilentlyContinue }

If ($TV.ClientID -notmatch "[0-9]") { $TV_ID = "0" }
    else { $TV_ID = $TV.ClientID }

# Network info: IP and MAC.
$network = GWMI Win32_NetworkAdapterConfiguration -filter 'IPEnabled=True'| Where {$_.MACAddress} | select -Last 1 IPAddress,MACAddress
$ip = $network.IPAddress | Select-String -NotMatch ":"
$ip = $ip -split " "
$mac = $network.MACAddress

# Check SystemType.
# If it's 1 or 3 than it's Desktop computer, if it's 2 than it's laptop, and on all other cases consider this as a server machine
$HW = GWMI Win32_ComputerSystem
$PC_Type = $HW.PCSystemType
If ($PC_Type -eq 2) { 
    $Manuf = ($HW.Manufacturer) -split " " | Select-Object -First 1
    $Model = $HW.Model
    $type = "N"
    $out_hw = "$Manuf $Model"
    }
Elseif (($PC_Type -eq 1) -or ($PC_Type -eq 3)) { 
    $MB = GWMI Win32_Baseboard
    $MB_Manuf = ($MB.Manufacturer) -split " " | Select-Object -First 1
    $MB_Model = $MB.Product
    $type = "D"
    $out_hw = "$MB_Manuf $MB_Model" }
Else {
    $Manuf = ($HW.Manufacturer) -split " " | Select-Object -First 1
    $Model = $HW.Product
    $type = "S"
    $out_hw = "$Manuf $Model"
    }

#CPU & OS
$CPName = $CPU.Name
$OS = $System.Caption
$OS = $OS + " " + $System.OSArchitecture
#isDomain
If ($HW.PartOfDomain -eq $True ) {
    $Dom = "True"
    }
Else { $Dom = "False" }

# there's an extra space in system variable $username for some reason, off with it
$user = $env:username -split " " | Select -First 1

#output format
$out = '{"Domain":"'+$Dom+'","CPU":"'+$CPName+'","RAM":'+$Ram+',"OS":"'+$OS+'","TV":'+$TV_ID+',"IP":"'+$ip+'","MAC":"'+$mac+'","Type":"'+$type+'","HW":"'+$out_hw+'","User":"'+$user+'"}'

# Writing all we've got into a file without new line
[System.IO.File]::WriteAllText("$out_file","$out",[text.encoding]::UTF8)