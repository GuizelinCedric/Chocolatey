@ECHO OFF
MODE CON:COLS=80 LINES=30
COLOR 02
TITLE "Installation Chocolatey"
REM ============================================================================================
REM [        TITLE:
REM [
REM [  DESCRIPTION:
REM [
REM [
REM [
REM [       AUTHOR:
REM [
REM [         DATE:
REM [
REM [      VERSION:
REM [
REM [ DEPENDENCIES:
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
cls
reg add "HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" /v ExecutionPolicy /t REG_SZ /d Unrestricted /f 2>nul
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\PowerShell\1\ShellIDs\Microsoft.Powershell" /v ExecutionPolicy /t REG_SZ /d Unrestricted /f 2>nul
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
choco feature enable -n allowGlobalConfirmation

REM Read modified environment variables
RefreshEnv

REM Maintenance Choco
choco install choco-cleaner -y
choco install choco-upgrade-all-at --params "'/DAILY:yes /TIME:12:30 /ABORTTIME:13:30'" -y
choco install choco-optimize-at --params "'/WEEKLY:yes /DAY:MON /TIME:12:00'" -y