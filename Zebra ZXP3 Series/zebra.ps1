<# © RogueShy <rogueshy@derpymail.org> , 2016

 Script for correcting Zebra's broken permissions for ZXP Series 3.
 Must be running as Administrator. #>

# ChangeDir to one where's your subinacl.exe is located:
cd C:\Printers\user_scripts\

# Variables definition:
# username = obviously, username (SamAccountName in AD)
$username = "username"
# SID = user's SID, we need this to put into SDDL string (see below)
$SID = Get-ADUser $username | Select SID
$SID = $SID.SID.Value
# ACL_SDDL = full sddl string, here's an example of the string which enables printing only for that user and Administrators local group
$ACL_SDDL = '/sddl="O:SYG:SYD:(A;CIIO;RC;;;CO)(A;OIIO;RPWPSDRCWDWO;;;CO)(A;OIIO;RPWPSDRCWDWO;;;BA)(A;;LCSWSDRCWDWO;;;BA)(A;;LCSWSDRCWDWO;;;'+ $SID +')(A;OIIO;RPWPSDRCWDWO;;;'+ $SID +')(A;OIIO;RPWPSDRCWDWO;;;PU)(A;;LCSWSDRCWDWO;;;PU)"'
# session_id = getting user's current port number
$session_id = ((quser | ? { $_ -match $username }) -split ' +')[3]
# Printer_Name = your printer name, I highly recommend using same naming pattern
$Printer_Name = 'Badges HR Moscow (redirected ' + $session_id + ')'
# now we're all done, let's set the correct ACL
.\subinacl.exe /printer $Printer_Name $ACL_SDDL

<# here's an addition in case your driver wouldn't work correctly on client's machine
broken driver sometimes could create some Phantom Printers with a name "Zebra ZXP Series 3 USB Card Printer (copy 1)"
to use this block, simply uncomment the executable lines below #>

# there's a correct ACL for that, which disables all printing to it and hides that printer completely from all users:
# $ACL_Phantom = '/sddl="O:SYG:SYD:(A;CIIO;RC;;;CO)(A;OIIO;RPWPSDRCWDWO;;;CO)(A;OIIO;RPWPSDRCWDWO;;;BA)(A;;LCSWSDRCWDWO;;;BA)"'
# And some examples for their names:
# $Phantom_Printer = 'Zebra ZXP Series 3 USB Card Printer (redirected ' + $session_id + ')'
# $Phantom_Printer1 = 'Zebra ZXP Series 3 USB Card Printer (copy 1) (redirected ' + $session_id + ')'
# Same as above, setting up correct ACLs
# .\subinacl.exe /printer $Phantom_Printer $ACL_Phantom
# .\subinacl.exe /printer $Phantom_Printer1 $ACL_Phantom
