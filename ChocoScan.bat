@ECHO OFF
MODE CON:COLS=80 LINES=30
COLOR 02
TITLE "Nettoyage Malware poste"
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

choco install emsisoft-emergency-kit --ignore-checksum -y


:: eek (EmsisoftEmergencyKit﻿, provides a tool "a2cmd" full text mode)
c:\EEK\bin32\a2cmd.exe /quick /rk /m /t /pup /a /am /n /q=c:\EEK\Quarantine\ /l=C:\EEK\Reports\%ComputerName%- Eek.log
:: /quick : Scans all active programs and Spyware Traces
:: You can also specify to scan the entire disk C:\ or D:\ or a directory)
:: /rk : Scan for active Rootkits
:: /m : Scan Memory for active Malware
:: /t : Scan for Spyware Traces
:: /pup : Alert Potentially Unwanted Programs
:: /a : Scan in compressed archives
:: /am : Scan in mail archives
:: /n : Scan in NTFS Alternate Data Streams
:: /q : Put found Malware into Quarantine (path)
:: /l : Save a logfile in UNICODE format (path)
:: (In addition, the update of EEK "/u" must be performed independently. I think this idea is not very good)
exit