@ECHO OFF
MODE CON:COLS=80 LINES=30
COLOR 02
TITLE "Installation AddIns Poste"
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
choco feature enable -n allowGlobalConfirmation
choco install jre8 -y
choco install flashplayeractivex -y
choco install flashplayerplugin -y
choco install flashplayerppapi -y
choco install adobeair -y
choco install silverlight -y
choco install dotnet3.5 dotnet4.0 dotnet4.5 dotnet4.5.1 dotnet4.5.2 dotnet4.6 dotnet4.6.1 dotnet4.6.2 -y
choco install sysinternals -y
choco install powershell -y
choco install vcredist-all -y
