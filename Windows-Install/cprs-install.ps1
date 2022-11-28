#
#   Powershell script to install VistA CPRS client on Windows Machine
#
#   Run with .\install.ps1 - This sets up a connection with default IP address 127.0.0.1 and default port 9001
#
#   To specify a port, run e.g. .\install.ps1 -ip 192.168.240.21 -p 5001
#
#
param ([String] $ip="127.0.0.1", [String] $port="9330",  [switch]$help = $false )
If ($help) {
    Write-Host ""
    Write-Host "This script runs an installer for the WorldVistA CPRS client"
    Write-Host "https://github.com/RamSailopal/Powershell-VistA-CPRS"
    Write-Host ""
    Write-Host "Additional flags:"
    Write-Host ""
    Write-Host -ForegroundColor "yellow" "-help" 
    Write-Host -ForegroundColor "green" "Print help"
    Write-Host ""
    Write-Host -ForegroundColor "yellow" "-ip 127.0.0.1" 
    Write-Host -ForegroundColor "green" "The ip address of the server running WorldVistA EHR, (default 127.0.0.1)"
    Write-Host ""
    Write-Host -ForegroundColor "yellow" "-port 9330"
    Write-Host -ForegroundColor "green" "The port of the server running WorldVistA EHR, (default 9430)"
    Write-Host ""
    exit
}
$ans1="D"
Set-Location '~\My Documents'
if (Get-ChildItem "C:\Program Files (x86)" | Where-Object { $_.Name -like "VistA" }) { 
    $ans=Read-Host -Prompt "VistA installation directory already exists. Would you like to delete it? (Y/N)"
    if ($ans.ToUpper() -eq "Y") {
        Remove-Item -Recurse -Path "C:\Program Files (x86)\VistA"
    }
}
if (Get-ChildItem "~/Desktop" | Where-Object { $_.Name -like "CPRS.lnk" }) { 
    $ans1 = Read-Host -Prompt "CPRS shortcut is already created on your desktop. Select Amend(A) or Delete(D)"
    if ($ans1.ToUpper() -eq "D") {
        Remove-Item -Path "~\Desktop\CPRS.lnk"
    }
}
if ($ip -notmatch "^([0-9]{1,3}\.){3}([0-9]{1,3})$") {
    Write-Host -ForegroundColor Red "IP address is in the wrong format"
    exit 
}
if ([int]$port -le 1024) {
    Write-Host -ForegroundColor Red "Port entered is in a reserved range"
    exit 
}
if ($ans1.ToUpper() -eq "D") {
    Write-Host "Downloading and Extracting CPRS installation file"
    Set-Location '~\My Documents'
    Invoke-WebRequest -URI https://altushost-swe.dl.sourceforge.net/project/worldvista-ehr/WorldVistA_EHR_3.0/CPRS-Files-WVEHR3.0Ver2-16_BasedOn1.0.30.16.zip -OutFile CPRS.zip
    Expand-Archive '~\My Documents\CPRS.zip' -DestinationPath 'C:\Program Files (x86)' -Force
}
$SourceFilePath = 'C:\Program Files (x86)\VistA\CPRS\CPRS-WVEHR3.0Ver2-16_BasedOn1.0.30.16.exe'
Get-Item '~/Desktop' | ForEach-Object { $ShortcutPath = $_.FullName }
$ShortcutPath = "$ShortcutPath\CPRS.lnk"
Write-Host "$ShortcutPath"
$WScriptObj = New-Object -ComObject ("WScript.Shell")
$shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $SourceFilePath
$shortcut.Arguments = "S=$ip P=$port CCOW=disable showrpcs"
$shortcut.Save()
$resp = Read-Host -Prompt "The CRPS client is now installed, would you like to run it now? (Y/N)"
if ($resp.ToUpper() = "Y") {
    ~\Desktop\CPRS.lnk
}  
