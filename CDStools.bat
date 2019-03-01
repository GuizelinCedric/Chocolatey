@ECHO OFF
MODE CON:COLS=80 LINES=30
COLOR 02
TITLE "Configuration Poste"
REM ============================================================================================
REM [        TITRE:
REM [
REM [  DESCRIPTION:
REM [
REM [
REM [
REM [       AUTEUR:
REM [
REM [         DATE:
REM [
REM [      VERSION:
REM [
REM [  DEPENDENCES:
REM [
REM [        NOTES:
REM [
REM ============================================================================================
: checkPriv
    NET FILE 1>NUL 2>NUL
    IF '%errorlevel%'=='0' ( GOTO gotPriv ) ELSE ( GOTO getPriv )
:getPriv
    IF '%1'=='ELEV' ( SHIFT & GOTO gotPriv )
    SETLOCAL DisableDelayedExpansion
    SET "batchPath=%~0"
    SETLOCAL EnableDelayedExpansion
    ECHO SET UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
    ECHO UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
    "%temp%\OEgetPrivileges.vbs"
    EXIT /B
:gotPriv
    SETLOCAL & PUSHD.
    CLS & ECHO.
:main
:Ping
Rem ### Configuration du firewall pour activer la réponse au ping et la réponse aux requêtes NetBIOS
netsh advfirewall firewall add rule name="_ICMPv4" protocol=icmpv4:any,any dir=in action=allow
netsh advfirewall firewall add rule name="_NetBIOS UDP Port 137" dir=in action=allow protocol=UDP localport=137
netsh advfirewall firewall add rule name="_NetBIOS UDP Port 137" dir=out action=allow protocol=UDP localport=137
netsh advfirewall firewall add rule name="_NetBIOS UDP Port 138" dir=in action=allow protocol=UDP localport=138
netsh advfirewall firewall add rule name="_NetBIOS UDP Port 138" dir=out action=allow protocol=UDP localport=138
netsh advfirewall firewall add rule name="_NetBIOS TCP Port 139" dir=in action=allow protocol=TCP localport=139
netsh advfirewall firewall add rule name="_NetBIOS TCP Port 139" dir=out action=allow protocol=TCP localport=139
netsh advfirewall firewall add rule name="_NetBIOS TCP Port 445" dir=in action=allow protocol=TCP localport=445
netsh advfirewall firewall add rule name="_RPC" dir=in action=allow protocol=TCP localport=RPC
Rem ### Activation de l'administration à distance
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v AllowRemoteRPC /t reg_dword /d 1 /f
REM ### Désactivation de l'UAC pour les appels distants
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /t reg_dword /d 1 /f
:NoSleep
c:\windows\system32\powercfg.exe -change -standby-timeout-ac 0
c:\windows\system32\powercfg.exe -change -standby-timeout-dc 0
:Profil777
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\BranchCache"  /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Compress old files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Content Indexer Cleaner" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\D3D Shader Cache"  /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Memory Dump Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Microsoft_Event_Reporting_2.0_Temp_Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Offline Pages Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Old ChkDsk Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Previous Installations" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Remote Desktop Cache Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\RetailDemo Offline Content" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\ServicePack Cleanup" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Setup Log Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error minidump files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Setup Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Sync Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" /v StateFlags0777 /d 2 /t REG_DWORD /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Upgrade Discarded Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\User file versions" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\WebClient and WebPublisher Cache" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Defender" /v StateFlags0777 /d 2 /t REG_DWORD /f
REG ADD "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Files" /v StateFlags0777 /d 2 /t REG_DWORD /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Archive Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Queue Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Archive Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Queue Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows ESD installation files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Upgrade Log Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
:Profil1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files" /v "StateFlags0001" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files" /v "StateFlags0001" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" /v "StateFlags0001" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Setup Files" /v "StateFlags0001" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" /v "StateFlags0001" /t REG_DWORD /d 00000002 /f
SCHTASKS /Create /TN "Nettoyage Hebdo Profil" /TR cleanmgr.exe" /SAGERUN:1" /SC WEEKLY /D FRI /ST 12:00 /RU SYSTEM /F
SCHTASKS /Create /TN "Nettoyage 70J Profil" /TR cleanmgr.exe" /SAGERUN:777" /SC DAILY /MO 70 /ST 12:00 /RU SYSTEM /F
exit