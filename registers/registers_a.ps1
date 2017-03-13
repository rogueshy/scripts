#модель материнки
$System = GWMI Win32_OperatingSystem
$CPU = GWMI Win32_Processor
$Ram = $System.TotalVisibleMemorySize / 1000000
$Ram = "{0:N0}" -f $Ram
# Блок для определения ID TeamViewer'а  (только для 9-ой версии), с обработкой его отсутствия
If ($System.OSArchitecture -like "*64*") {
    $TV = Get-ItemProperty HKLM:\Software\Wow6432Node\TeamViewer\Version9\ ClientID -ErrorAction SilentlyContinue }
    Else {
        $TV = Get-ItemProperty HKLM:\Software\TeamViewer\Version9 ClientID -ErrorAction SilentlyContinue }

If ($TV.ClientID -notmatch "[0-9]") { $TV_ID = "000000000" }
    else { $TV_ID = $TV.ClientID }

#Блок для определения IP-адреса
$ip = (ipconfig | Select-String IPv4) -split ":" | Select-String -notmatch ". ." -ErrorAction SilentlyContinue


#Ноутбук или нет, и модель материнки
$HW = GWMI Win32_ComputerSystem
$PC_Type = $HW.PCSystemType
If ($PC_Type -eq 2) { 
    #$Manuf = $HW.Manufacturer
    $Model = $HW.Model
    $out_hw = "N, $Model"
    }
Else { 
    $MB = GWMI Win32_Baseboard
    #$MB_Manuf = $MB.Manufacturer
    $MB_Model = $MB.Product
    $out_hw = "D, $MB_Model" }

#Для всего остального
$CPName = $CPU.Name
$OS = $System.Caption
$OS = $OS + " " + $System.OSArchitecture

#Вывод
$env:COMPUTERNAME, $CPName, $Ram, $OS, $TV_ID, $ip, $out_hw, $env:username | Out-File -FilePath "%folder_path\$env:COMPUTERNAME.txt" -Encoding UTF8