@ECHO OFF
MODE CON:COLS=80 LINES=30
COLOR 02
TITLE "Installation Applications Poste"
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
:Choco
reg add "HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" /v ExecutionPolicy /t REG_SZ /d Unrestricted /f 2>nul
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\PowerShell\1\ShellIDs\Microsoft.Powershell" /v ExecutionPolicy /t REG_SZ /d Unrestricted /f 2>nul
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
REM Read modified environment variables
RefreshEnv

REM Essential fonts ;-)
choco install -y dejavufonts
choco install -y FiraCode
choco install -y hackfont
choco install -y inconsolata
choco install -y RobotoFonts

REM Some tools...
choco install -y 7zip.install
choco install -y dexpot
choco install -y dumeter
choco install -y f.lux
rem choco install -y foxitreader
rem choco install -y googledrive
rem choco install -y dropbox
choco install -y imageresizerapp
choco install -y notepadplusplus.install
rem choco install -y pdfcreator
choco install -y jpegtran
choco install -y paint.net
choco install -y adobereader
choco install -y pdf-ifilter-64
choco install -y pdfsam.install
choco install -y skype
choco install -y sysinternals
rem choco install -y sumatra
choco install -y smplayer
choco install -y treesizefree
choco install -y zoomit

REM More web browsers...
choco install -y GoogleChrome
choco install -y firefox -packageParameters "l=fr-FR" -x86
choco install -y filezilla

REM Development stuff...
rem choco -y install vb5runtime
choco install -y vcredist-all
choco install -y dotnet4.0 dotnet4.5 dotnet4.5.1 dotnet4.5.2 dotnet4.6 dotnet4.6.1 dotnet4.6.2
choco install -y powershell

REM Addon stuff...
choco install flashplayeractivex flashplayerplugin flashplayerppapi -y
rem choco install adobeshockwaveplayer -y
choco install -y adobeair
choco install -y jre8
choco install -y silverlight
choco install -y citrix-receiver

REM Fun with Visual Studio 2017... other versions are available too
REM choco install -y VisualStudio2017Professional
REM choco install -y visualstudio2017-workload-netweb
REM choco install -y visualstudio2017-workload-netcoretools
REM choco install -y vscode

REM Install WebPI packages
REM choco install -y IISExpress10 -source webpi
REM choco install -y WindowsAzurePowershellGet -source webpi
REM choco install -y WindowsInstaller45 -source webpi


REM Multimedia
choco install -y AIMP
choco install -y cdburnerxp
choco install -y vlc

REM Remote
choco install -y putty.install
choco install -y rdcman
choco install -y mremoteng
choco install -y vnc-viewer
choco install -y vnc-viewer-chrome
Rem choco install vmware-horizon-client -y
Rem choco install vmware-horizon-client --version 4.2.0 -y

REM Maintenance Choco
choco install vnc-viewer-chrome -y
choco install choco-cleaner -y
choco install choco-upgrade-all-at --params "'/DAILY:yes /TIME:12:30 /ABORTTIME:13:30'" -y
choco install choco-optimize-at --params "'/WEEKLY:yes /DAY:MON /TIME:12:00'" -y
Rem choco install choco-upgrade-all-at-startup -y
Rem choco install choco-upgrade-all-at --params "'/Time:16:00'"
rem SCHTASKS /delete /tn "updateAll" /f
rem SCHTASKS /create /tn "updateAll" /tr "cmd.exe /c \"choco upgrade all -y\"" /sc ONCE /ST 00:00 /sd 01/01/1910 /RL HIGHEST
rem SCHTASKS /run /tn "updateAll"
exit