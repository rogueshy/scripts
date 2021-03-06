<# © RogueShy <rogueshy@derpymail.org> , 2016

 Script for correcting Zebra's broken permissions for ZXP Series 3.
 Must be running as Administrator. #>

# for phantom
$phantomSDDL = "G:SYD:(A;CIIO;RC;;;CO)(A;OIIO;RPWPSDRCWDWO;;;CO)(A;OIIO;RPWPSDRCWDWO;;;BA)(A;;LCSWSDRCWDWO;;;BA)"
$PhantomZebras = Get-Printer -Name Zebra*
foreach ($phantom in $PhantomZebras) {
    Set-Printer $phantom.Name -PermissionSDDL $phantomSDDL
}

# for regular
$members = Get-ADGroupMember ZebraUsers
foreach ($member in $members) {
    $user = Get-ADUser $member -Properties Description
    $session_id = ((quser | ? { $_ -match $user.SamAccountName }) -split ' +')[3]
        if ($session_id) {
                $printerName = $user.Description + " (перенаправлено " + $session_id + ")"
                $printer = Get-Printer -Name $printerName -ErrorAction SilentlyContinue
                $SID = $user.SID.Value
                $SDDL = "G:SYD:(A;CIIO;RC;;;CO)(A;OIIO;RPWPSDRCWDWO;;;CO)(A;OIIO;RPWPSDRCWDWO;;;"+$SID+")(A;;LCSWSDRCWDWO;;;"+$SID+")(A;;LCSWSDRCWDWO;;;BA)(A;OIIO;RPWPSDRCWDWO;;;BA)(A;;SWRC;;;AC)(A;CIIO;RC;;;AC)(A;OIIO;RPWPSDRCWDWO;;;AC)(A;;LCSWSDRCWDWO;;;PO)(A;OIIO;RPWPSDRCWDWO;;;PO)(A;;LCSWSDRCWDWO;;;SY)(A;OIIO;RPWPSDRCWDWO;;;SY)"
                Set-Printer $printer.Name -PermissionSDDL $SDDL -ErrorAction SilentlyContinue
            }
        else {
            #get something here
            }
    }