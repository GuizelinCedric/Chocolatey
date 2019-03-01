' Include By GlobalscriptGUI 2.5.0.5 - Renaud DEGOSSE 2010 - http://globalscript.free.fr
INCLUDEINI = "# INI INCLUDE START #" & vbcrlf &_
"[GLOBALSCRIPT]" & vbcrlf &_
"Version=2.5.0.5" & vbcrlf &_
"Type=INI" & vbcrlf &_
"[CONFIGURATION]" & vbcrlf &_
"NameID=CDS-Rouen" & vbcrlf &_
"Description=CDS Rouen" & vbcrlf &_
"Procedures=LecteursImprimantes" & vbcrlf &_
"DisconnectAllDrives=0" & vbcrlf &_
"DisconnectAllPrinters=0" & vbcrlf &_
"Eventlog=0" & vbcrlf &_
"KeepAndRestoreDefaultPrinter=1" & vbcrlf &_
"Logging=1" & vbcrlf &_
"LogPath=%USERPROFILE%\GlobalScript.log" & vbcrlf &_
"RemoveDesktopShortcuts=0" & vbcrlf &_
"RemoveProgramShortcuts=0" & vbcrlf &_
"RemoveQuickLaunchShortcuts=0" & vbcrlf &_
"Debug=1" & vbcrlf &_
"[LecteursImprimantes]" & vbcrlf &_
"Description=LecteursImprimantes" & vbcrlf &_
"Conditions=Rouen" & vbcrlf &_
"Sequences=Lecteurs,Imprimantes" & vbcrlf &_
"inHerit=1" & vbcrlf &_
"[Rouen]" & vbcrlf &_
"Type=36" & vbcrlf &_
"Negation=0" & vbcrlf &_
"RangesIP=192.168.76.1-192.168.76.254" & vbcrlf &_
"[Lecteurs]" & vbcrlf &_
"Type=100" & vbcrlf &_
"Actions=Clients,InformatiqueInterne,ISIClients" & vbcrlf &_
"[Clients]" & vbcrlf &_
"Type=1004" & vbcrlf &_
"Connect=1" & vbcrlf &_
"Letter=T" & vbcrlf &_
"UncPath=\\ro9-srvfic1\Clients" & vbcrlf &_
"Force=0" & vbcrlf &_
"Persistent=1" & vbcrlf &_
"Username=" & vbcrlf &_
"[InformatiqueInterne]" & vbcrlf &_
"Type=1004" & vbcrlf &_
"Connect=1" & vbcrlf &_
"Letter=W" & vbcrlf &_
"UncPath=\\ro9-srvfic1\Informatique Interne" & vbcrlf &_
"Force=0" & vbcrlf &_
"Persistent=1" & vbcrlf &_
"Username=" & vbcrlf &_
"[ISIClients]" & vbcrlf &_
"Type=1004" & vbcrlf &_
"Connect=1" & vbcrlf &_
"Letter=X" & vbcrlf &_
"UncPath=\\srv-isi-api\Partage\Clients" & vbcrlf &_
"Force=0" & vbcrlf &_
"Persistent=1" & vbcrlf &_
"Username=" & vbcrlf &_
"[Imprimantes]" & vbcrlf &_
"Type=100" & vbcrlf &_
"Actions=LexmarkX644eHotline" & vbcrlf &_
"[LexmarkX644eHotline]" & vbcrlf &_
"Type=1006" & vbcrlf &_
"UNCPath=\\ro9-srvfic1\Lexmark X644e Hotline" & vbcrlf &_
"DefaultPrinter=0" & vbcrlf &_
"Remove=0" & vbcrlf &_
"Username=" & vbcrlf &_
"Password=" & vbcrlf &_
"# INI INCLUDE END #"

'============================================================================
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'       GlobalScript v 2.5.0.5
'       Renaud DEGOSSE - 2010 - globalscript@free.fr
'       http://globalscript.free.fr
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'============================================================================
on error resume next
Const VERSION = "2.5.0.5"
Const DEBUGLOG = False
'============================================================================
'''' PERSONNALISATIONS PRE EXECUTION GLOBALSCRIPT '''''''''''''''''''''''''''

'-->

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'============================================================================

'============================================================================
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim ObjGS
Set ObjGS = New GlobalScript2
ObjGS.GlobalScript_Execute()
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'============================================================================

'============================================================================
'''' PERSONNALISATIONS POST EXECUTION GLOBALSCRIPT ''''''''''''''''''''''''''

'-->

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'============================================================================

'============================================================================
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'    CLASSE GlobalScript2 : regroupe toutes les fonctions utilisées         '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'============================================================================
class GlobalScript2
'============================================================================
' Attributs : Objects et variables globales                                 '
'============================================================================
Private objNetwork
Private objShell
Private objShellApp
Private objFSO
Private ConfigINIContents
Private FileLog
Private ObjGSCT
Private ObjADSysInfo
Private privCurrentComputerName
Private privCurrentClientName
Private privCurrentUserMemberOf
Private privCurrentComputerIPs
Private privCurrentDay
Private privCurrentTime
Private privCurrentDirectory
Private privCurrentUserName
Private privCurrentUserDomain
Private privCurrentUserDnsDomain
Private privCurrentConfigINIPath
Private privCurrentDesktopPath
Private privCurrentQuickLaunchPath
Private privCurrentProgramsPath
Private privCurrentComputerIsDomainMember
Private privCurrentUserIsDomainMember
Private privCurrentUserPrintersConnections
Private privCurrentUserDrivesConnections
Private privCurrentDefaultPrinter
Private Config_NameID
Private Config_Description
Private Config_DisconnectAllDrives
Private Config_DisconnectAllPrinters
Private Config_Eventlog
Private Config_KeepAndRestoreDefaultPrinter
Private Config_Logging
Private Config_LogPath
Private Config_RemoveDesktopShortcuts
Private Config_RemoveProgramShortcuts
Private Config_RemoveQuickLaunchShortcuts
Private Config_DebugLog
Private Config_Procedures
Private EventLogMsg
Private CacheLog
Private CacheErrLog
Private CptError
'============================================================================
' Constructeur de GlobalScript2
'============================================================================
Private Sub Class_Initialize
        on error resume next
        CacheLog = Empty
        CptError = 0
        Config_Logging = True
        Config_DebugLog = DEBUGLOG
        WriteLog "GlobalScript2.Class_Initialize:START Version:" & VERSION
        Set objNetwork = WScript.CreateObject("Wscript.Network")
        Set objShell = WScript.CreateObject("WScript.Shell")
        Set objShellApp = WScript.CreateObject("Shell.Application")
        Set objFSO = Wscript.CreateObject("Scripting.FileSystemObject")
        Set ObjADSysInfo = Wscript.CreateObject("ADSystemInfo")
        If Err Then
                WriteLog "Class_Initialize:Set Obj: " & Err.description & Hex(err.number)
                Err.Clear
        End If
        Set ObjGSCT = Wscript.CreateObject("GlobalScript.GlobalScriptComTool")
        If Err Then
                WriteLog "Class_Initialize:GlobalScriptComTool: " & Err.description & Hex(err.number)
                ObjGSCT = Empty
                InstallGlobalscriptCOMforUser()
        End If
        WriteDebugLog "Class_Initialize:END"
End Sub

'============================================================================
' Destructeur
'============================================================================
Private Sub Class_Terminate
        on error resume next
        WriteDebugLog "Class_Terminate:START"
        FinalizeEventLog()
        Set objNetwork = Nothing
        Set objShell = Nothing
        Set ObjGSCT = Nothing
        WriteLog "Globalscript2.Class_Terminate:END"
        FileLog.close()
        Set objFSO = Nothing
End Sub

'============================================================================
'============================================================================
' GlobalScript2_Execute : Procédure Principale d'execution
'============================================================================
'============================================================================
Public Sub GlobalScript_Execute()
        on error resume next:err.clear
        WriteDebugLog "GlobalScript_Execute:START"
        SetScriptParameters()
        ApplyStartParameters()
        TestAndExecuteScript()
        ApplyEndParameters()
        WriteDebugLog "GlobalScript_Execute:END"
End Sub
'============================================================================
'LOGGING
'============================================================================
Private Sub WriteStrLog(str)
    on error resume next
    if Config_Logging Then
            StrWrite = Now & vbTab & str
            if isEmpty(FileLog) then
                CacheLog = CacheLog & StrWrite & vbCrLf
                'if Config_EventLog Then EventLogMsg = EventLogMsg & Now & vbTab & Str
            Else
                if isEmpty(CacheLog) Then
                        FileLog.WriteLine StrWrite
                        'if Config_EventLog Then EventLogMsg = EventLogMsg & Now & vbTab & Str
                Else
                        FileLog.Write CacheLog
                        CacheLog = Empty
                        FileLog.WriteLine StrWrite
                        'if Config_EventLog Then EventLogMsg = EventLogMsg & Now & vbTab & Str
                End If
            End If
    End If
End Sub

Private Sub WriteErrLog(str)
    CacheErrLog = CacheErrLog & str & vbCrLf
    CptError = CptError + 1
    WriteStrLog "ERROR:" & vbTab & str
End Sub

Private Sub WriteDebugLog(str)
    if Config_DebugLog Then WriteStrLog "DEBUG:" & vbTab & str
End Sub

Private Sub WriteLog(str)
    WriteStrLog vbTab & str
End Sub

Private Sub WriteEventLog(Msg)
        on error resume next
        ObjShell.LogEvent 0,Msg
End Sub

Private Sub WriteErrEventLog(Msg)
        on error resume next
        ObjShell.LogEvent 1,Msg
End Sub

Private Sub FinalizeEventLog()
       on error resume next
       If Config_EventLog Then
                If CptError > 0 Then
                        WriteErrEventLog "Execution de :" & Wscript.ScriptFullName & vbcrlf& " LOG:" & Config_LogPath & vbCrlf & vbcrlf & CacheErrLog
                Else
                        WriteEventLog "Execution de :" & Wscript.ScriptFullName & " LOG:" & Config_LogPath
                End If
        End If
End Sub
'============================================================================
'============================================================================
' PRIMITIVES
'============================================================================
'============================================================================
Private Sub InstallGlobalscriptCOMforUser()
   on error resume next:err.clear
   FullPathGSCFU = CurrentDirectory & "SetupGlobalScriptCOMforUser.msi"
   if objFSO.FileExists(FullPathGSCFU) Then
        objFSO.CopyFile FullPathGSCFU , ExpandLocalVar("%TEMP%\SetupGlobalScriptCOMforUser.msi") , True
        If err then
                writeErrLog "InstallGlobalscriptCOMforUser " & Hex(err.number) & " -> " & err.description
                err.clear
        else
                writeDebugLog "InstallGlobalscriptCOMforUser: COPY MSI OK"
        End If
        objShell.run "MSIEXEC.EXE /i """ & ExpandLocalVar("%TEMP%\SetupGlobalScriptCOMforUser.msi") & """ /quiet" , 0 , True
        If err then
                writeErrLog "InstallGlobalscriptCOMforUser " & Hex(err.number) & " -> " & err.description
                err.clear
        else
                WriteLog "InstallGlobalscriptCOMforUser: INSTALL OK"
        End If
        Set ObjGSCT = Wscript.CreateObject("GlobalScript.GlobalScriptComTool")
        If err then
                writeErrLog "InstallGlobalscriptCOMforUser " & Hex(err.number) & " -> " & err.description
        else
                writeDebugLog "InstallGlobalscriptCOMforUser: SET OBJECT OK"
        End If
   Else
        writeDebugLog "InstallGlobalscriptCOMforUser: SetupGlobalScriptCOMforUser.msi NOT PRESENT"
   End If
End Sub

Private Function GetFile(ByVal FileName)
  On Error Resume Next:err.clear
  if objFSO.FileExists(FileName) Then
        GetFile = objFSO.OpenTextFile(FileName,1,True).ReadAll
  Else
        GetFile = ""
  End If
  If err then
        writeErrLog "GetFile " & Hex(err.number) & " -> " & err.description & " " & FileName
  else
        writeDebugLog "GetFile: " & FileName
  End If
End Function

Function WriteFile(ByVal FileName, ByVal Contents)
  Dim OutStream: Set OutStream = objFSO.OpenTextFile(FileName, 2, True)
  OutStream.Write Contents
  OutStream.Close
End Function

Function WriteFileASCII(ByVal FileName, ByVal Contents)
  on error resume next:err.clear
  WriteFile FileName, Contents
  If err then
        writeErrLog "WriteFileASCII " & Hex(err.number) & " -> " & err.description
        WriteFileASCII = False
  else
        writeDebugLog "WriteFileASCII: " & FileName
        WriteFileASCII = True
  End If
End Function

Function WriteFileUnicode(ByVal FileName, ByVal Contents)
  on error resume next:err.clear
  Dim OutStream: Set OutStream = objFSO.OpenTextFile(FileName, 2, True, -1)
  OutStream.Write Contents
  OutStream.Close
  If err then
        writeErrLog "WriteFileUnicode " & Hex(err.number) & " -> " & err.description
        WriteFileUnicode = False
  else
        writeDebugLog "WriteFileUnicode: " & FileName
        WriteFileUnicode = True
  End If
End Function

Private Function SeparateField(ByVal sFrom, ByVal sStart, ByVal sEnd)
  Dim PosB: PosB = InStr(1, sFrom, sStart, 1)
  If PosB > 0 Then
    PosB = PosB + Len(sStart)
    Dim PosE: PosE = InStr(PosB, sFrom, sEnd, 1)
    If PosE = 0 Then PosE = InStr(PosB, sFrom, vbCrLf, 1)
    If PosE = 0 Then PosE = Len(sFrom) + 1
    SeparateField = Mid(sFrom, PosB, PosE - PosB)
  End If
End Function

private Function INIBool(Str) ' as boolean
        select case lcase(Str)
                case "1"
                        INIBool = True
                case "y"
                        INIBool = True
                case "o"
                        INIBool = True
                case "true"
                        INIBool = True
                case "0"
                        INIBool = False
                case "false"
                        INIBool = False
                case "n"
                        INIBool = False
                case else
                        INIBool = False
       End Select
End Function

Private Function IsMemberOf(Group) 'as boolean
        on error resume next:err.clear
       If CurrentUserMemberOf.Exists(UCASE(Group)) Then
             if Err Then
                     IsMemberOf = False
                     WriteErrLog "IsMemberOf:" & Group & " -> FALSE " & Hex(err.number) & " " & err.description
             Else
                     IsMemberOf = True
                     WriteLog "IsMemberOf:" & Group & " -> TRUE"
             End If
       Else
             IsMemberOf = False
             WriteLog "IsMemberOf:" & Group & " -> FALSE"
       End If
End Function

Private Function GetINIString(FileName,Section, KeyName, Default)
  on error resume next:err.clear
  Dim INIContentsRead, PosSection, PosEndSection, sContents, Value, Found
  INIContentsRead = GetFile(ExpandLocalVar(FileName))
  PosSection = InStr(1, INIContentsRead, "[" & Section & "]", vbTextCompare)
  If PosSection>0 Then
    PosEndSection = InStr(PosSection, INIContentsRead, vbCrLf & "[")
    If PosEndSection = 0 Then PosEndSection = Len(INIContents)+1
    sContents = Mid(INIContentsRead, PosSection, PosEndSection - PosSection)
    If InStr(1, sContents, vbCrLf & KeyName & "=", vbTextCompare)>0 Then
        Found = True
        Value = SeparateField(sContents, vbCrLf & KeyName & "=", vbCrLf)
    End If
  End If
  If isempty(Found) Then Value = Default
  GetINIString = Value
  If Err Then
        WriteErrLog "GetINIString:" & Hex(err.number) & " " & err.description & " FileName:" & FileName & " Section:" & section & " KeyName:" & KeyName & " Value:" & GetINIString
  End If
End Function

Private Sub WriteINIString(Section, KeyName, Value, FileName)
  'on error resume next:err.clear
  Dim INIContentsWrite, PosSection, PosEndSection
  INIContentsWrite = GetFile(FileName)
  PosSection = InStr(1, INIContentsWrite, "[" & Section & "]", vbTextCompare)
  If PosSection>0 Then
    PosEndSection = InStr(PosSection, INIContentsWrite, vbCrLf & "[")
    If PosEndSection = 0 Then PosEndSection = Len(INIContentsWrite)+1
    Dim OldsContents, NewsContents, Line
    Dim sKeyName, Found
    OldsContents = Mid(INIContentsWrite, PosSection, PosEndSection - PosSection)
    OldsContents = split(OldsContents, vbCrLf)
    sKeyName = LCase(KeyName & "=")
    For Each Line In OldsContents
      If LCase(Left(Line, Len(sKeyName))) = sKeyName Then
        Line = KeyName & "=" & Value
        Found = True
      End If
      NewsContents = NewsContents & Line & vbCrLf
    Next
    If isempty(Found) Then
       NewsContents = NewsContents & KeyName & "=" & Value
    Else
       NewsContents = Left(NewsContents, Len(NewsContents) - 2)
    End If
       INIContentsWrite = Left(INIContentsWrite, PosSection-1) & _
      NewsContents & Mid(INIContentsWrite, PosEndSection)
  else
    If Right(INIContentsWrite, 2) <> vbCrLf And Len(INIContentsWrite)>0 Then
      INIContentsWrite = INIContentsWrite & vbCrLf
    End If
    INIContentsWrite = INIContentsWrite & "[" & Section & "]" & vbCrLf & _
      KeyName & "=" & Value
  end if
  WriteFile FileName, INIContentsWrite
  If err then
        writeErrLog "WriteINIString: " & iniFile & Hex(err.number) & " -> " & err.description
  End If
End Sub

Private Function IPAddressToNumber(StrIP) 'as Long
        on error resume next:err.clear
        Dim intResult, arrDec
        arrDec = Split(Cstr(StrIP),".")
        if isArray(arrDec) Then
                For i = UBound(arrDec) To LBound(arrDec) Step -1
                    intResult = intResult + ((CLng(arrDec(i)) Mod 256) * 256 ^ (3 - i))
                Next
                IPAddressToNumber = intResult
        Else
                WriteErrLog "IPAddressToNumber Not An Array:" & StrIP
        End If
        if Err Then
                WriteErrLog "IPAddressToNumber " & Hex(err.number) &  " " & err.description
        Else
                WriteDebugLog "IPAddressToNumber " & StrIP & " -> " & intResult
        End If
End Function

Private Function NumberToIPAddress(Num) 'str x.x.x.x
        IPSTr = "" & (num - (num Mod 16777216)) / 16777216 & "." & ((num - (num Mod 65536)) Mod 16777216) / 65536 & "." & ((num Mod 65536) - (num Mod 256)) / 256 & "." & num Mod 256
        WriteDebugLog "NumberToIPAddress " & Num & " -> " & IPStr
        NumberToIPAddress = IPStr
End Function

Private Function RegExpTest(patrn, strng)
  Dim regEx, retVal
  Set regEx = New RegExp
  regEx.Pattern = patrn
  regEx.IgnoreCase = True
  retVal = regEx.Test(strng)
  If retVal Then
    RegExpTest = True
  Else
    RegExpTest = False
  End If
End Function

Private Function IsIPv4(strIP)
        IsIPv4 = RegExpTest("^(25[0-5]|2[0-4]\d|[0-1]?\d?\d)(\.(25[0-5]|2[0-4]\d|[0-1]?\d?\d)){3}$",strIP)
End Function

Private Function ExpandLocalVar(Str)
            ExpandLocalVar = objShell.ExpandEnvironmentStrings(Str)
End Function

Private Function PrinterIsConnected(UNCPath)
       on error resume next:err.clear
       If CurrentUserPrintersConnections.Exists(UCASE(UNCPath)) Then
             if Err Then
                     PrinterIsConnected = False
                     WriteErrLog "PrinterIsConnected:" & UNCPath & " -> FALSE " & Hex(err.number) & " " & err.description
             Else
                     PrinterIsConnected = True
                     WriteDebugLog "PrinterIsConnected:" & UNCPath & " -> TRUE"
             End If
       Else
            PrinterIsConnected = False
            WriteDebugLog "PrinterIsConnected:" & UNCPath & " -> FALSE"
       End If
End Function
'============================================================================
'============================================================================
' Propriétés
'============================================================================
'============================================================================
Private Function CurrentComputerIsDomainMember()
        on error resume next:err.clear
        if isEmpty(privCurrentComputerIsDomainMember) Then
                'WriteDebugLog "CurrentComputerIsDomainMember START"
                Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
                Set colComputers = objWMIService.ExecQuery("Select DomainRole from Win32_ComputerSystem","WQL",48)
                For Each objComputer in colComputers
                    Select Case objComputer.DomainRole
                        Case 0
                            strComputerRole = "Standalone Workstation"
                            privCurrentComputerIsDomainMember = False
                        Case 1
                            strComputerRole = "Member Workstation"
                            privCurrentComputerIsDomainMember = True
                        Case 2
                            strComputerRole = "Standalone Server"
                            privCurrentComputerIsDomainMember = False
                        Case 3
                            strComputerRole = "Member Server"
                            privCurrentComputerIsDomainMember = True
                        Case 4
                            strComputerRole = "Backup Domain Controller"
                            privCurrentComputerIsDomainMember = True
                        Case 5
                            strComputerRole = "Primary Domain Controller"
                            privCurrentComputerIsDomainMember = True
                        case Else
                            strComputerRole = "Not Specified"
                            privCurrentComputerIsDomainMember = False
                    End Select
                Next
                WriteDebugLog "CurrentComputerIsDomainMember: Role: " & strComputerRole & " is Domain Member?: " & privCurrentComputerIsDomainMember
        End If
        CurrentComputerIsDomainMember = privCurrentComputerIsDomainMember
End Function

Private Function CurrentUserIsDomainMember()
        on error resume next:err.clear
        if isEmpty(privCurrentUserIsDomainMember) Then
                privCurrentUserIsDomainMember = False
                Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
                Set colUsers = objWMIService.ExecQuery("Select LocalAccount from Win32_UserAccount WHERE Name = '" & CurrentUserName & "' AND Domain = '" & CurrentUserDomain & "'","WQL",48)
                If Not Err Then
                        For Each objUser in colUsers
                             if Not objUser.LocalAccount Then
                                     privCurrentUserIsDomainMember = True
                                     Exit For
                             End If
                        Next
                        WriteDebugLog "CurrentUserIsDomainMember: " & privCurrentUserIsDomainMember
                Else
                        WriteErrLog "CurrentUserIsDomainMember: " & Hex(err.number) & " " & err.Description
                End If
        End If
        CurrentUserIsDomainMember = privCurrentUserIsDomainMember
End Function

Private Property Get CurrentUserDomain()
        on error resume next:err.clear
        if isEmpty(privCurrentUserDomain) Then
                If CurrentComputerIsDomainMember Then
                      privCurrentUserDomain = ObjNetwork.UserDomain
                Else
                      privCurrentUserDomain = CurrentComputerName
                End If
                WriteDebugLog "CurrentUserDomain = " & privCurrentUserDomain
        End If
        CurrentUserDomain = privCurrentUserDomain
        if Err Then
              WriteErrLog "CurrentUserDomain: " & Hex(err.number) & " " & err.Description
        End If
End Property

Private Property Get CurrentUserDnsDomain()
        on error resume next:err.clear
        if isEmpty(privCurrentUserDnsDomain) Then
                WriteDebugLog "CurrentUserDnsDomain START"
                Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
                Set colDomains = objWMIService.ExecQuery("Select DnsForestName from Win32_NTDomain Where DomainName = '" & CurrentUserDomain & "'","WQL",48)
                For Each objDomain in colDomains
                        If Err Then Exit For
                        privCurrentUserDnsDomain = objDomain.DnsForestName
                        WriteDebugLog "CurrentUserDnsDomain = " & privCurrentUserDnsDomain
                Next
        End If
        CurrentUserDnsDomain = privCurrentUserDnsDomain
        if Err Then
              If Cstr(Hex(err.number)) = "80041010" Then
                   privCurrentUserDnsDomain = ExpandLocalVar("%USERDNSDOMAIN%")
                   WriteDebugLog "CurrentUserDnsDomain(Win2K) = " & privCurrentUserDnsDomain
              Else
                   WriteErrLog "CurrentUserDnsDomain: " & Hex(err.number) & " " & err.Description
              End If
        End If
End Property

Private Property Get CurrentUserName()
        on error resume next:err.clear
        if isEmpty(privCurrentUserName) Then
                privCurrentUserName = ObjNetwork.UserName
                WriteDebugLog "CurrentUserName = " & privCurrentUserName
        End If
        CurrentUserName = privCurrentUserName
        if Err Then
              WriteErrLog "CurrentUserName: " & Hex(err.number) & " " & err.Description
        End If
End Property

Private Property Get CurrentADSite() 'as string
        on error resume next:err.clear
        if isEmpty(privCurrentADSite) Then
                if CurrentComputerIsDomainMember Then
                        privCurrentADSite = ObjADSysInfo.SiteName
                Else
                        privCurrentADSite = "STANDALONE"
                End If
                if err Then
                      WriteErrLog "CurrentADSite = " & privCurrentADSIte & " " & Hex(err.number) & " " & err.description
                      CurrentADSite = "ERROR"
                Else
                      WriteDebugLog "CurrentADSite = " & privCurrentADSIte
                End If
        End If
        CurrentADSite = privCurrentADSite
End Property

Private Property Get CurrentComputername() 'as string
        on error resume next:err.clear
        if isEmpty(privCurrentComputername) Then
                privCurrentComputername = objNetwork.Computername
                WriteDebugLog "CurrentComputername = " & privCurrentComputername
        End If
        CurrentComputername = privCurrentComputername
        if Err Then
              WriteErrLog "CurrentComputername: " & Hex(err.number) & " " & err.Description
        End If
End Property

Private Property Get CurrentClientName() 'as string
        on error resume next:err.clear
        if isEmpty(privCurrentClientName) then
                'citrix
                tmpClientName = ExpandLocalVar("%CLIENTNAME%")
                if tmpCLientName = "" Then
                      privClientName = "NOT_SPECIFIED"
                Else
                      privClientName = tmpClientName
                End If
                WriteDebugLog "CurrentClientName = " & privCurrentClientName
        End If
        CurrentClientName = privClientName
        if Err Then
              WriteErrLog "CurrentClientName: " & Hex(err.number) & " " & err.Description
        End If
End Property

Private Property Get CurrentUserMemberOf() 'as dictionnary
        on error resume next:err.clear
        if isEmpty(privCurrentUserMemberOf) then
                WriteDebugLog "CurrentUserMemberOf START"

                Set privCurrentUserMemberOf = CreateObject("Scripting.Dictionary")
                privCurrentUserMemberOf.CompareMode = vbTextCompare
       	        privCurrentUserMemberOf.add CurrentUserDomain & "\" & CurrentUserName , ""
                privCurrentUserMemberOf.add CurrentUserName , ""

        	if CurrentComputerIsDomainMember Then
        	       If CurrentUserIsDomainMember Then
        	               If isNull(CurrentUserDnsDomain) Then
	                               WriteDebugLog "CurrentUserMemberOf DETECT: NT4 Domain"
	                               GetMemberOf_NT4()
	                               GetMemberOf_Local()
	                       Else
	                               WriteDebugLog "CurrentUserMemberOf DETECT: Active Directory Domain"
	                               GetMemberOf_AD()
	                               GetMemberOf_Local()
	                       End If
        	       Else
                               WriteDebugLog "CurrentUserMemberOf DETECT: Local User on Domain Computer"
                               GetMemberOf_Local()
        	       End If
                Else
                       WriteDebugLog "CurrentUserMemberOf DETECT: Local User on Workgroup Computer"
                       GetMemberOf_Local()
                End If

                If err then
                        writeErrLog "CurrentUserMemberOf:" & Hex(err.number) & " -> " & err.description
                else
                        writeDebugLog "CurrentUserMemberOf: OK: " & Join(privCurrentUserMemberOf.Keys,",")
                End If
                WriteDebugLog "CurrentUserMemberOf END"
        End If
        Set CurrentUserMemberOf = privCurrentUserMemberOf
End Property

Private Sub GetMemberOf_AD()
        on error resume next:err.clear
        Dim strDomain
        WriteDebugLog "GetMemberOf_AD START"
        Set objCon = CreateObject("ADODB.Connection")
        Set objCom = CreateObject("ADODB.Command")
        Set objRec = CreateObject("ADODB.Recordset")
        objCon.ConnectionTimeout = 10
        objCom.CommandTimeOut = 10
        objCon.Open "Provider=ADsDSOObject;"
        objCom.ActiveConnection = objCon
        Set objRootDSE = GetObject("LDAP://rootDSE")
        strDomain = objRootDSE.Get("defaultNamingContext")
        WriteDebugLog "GetMemberOf_AD DefaultNamingContext:" & strDomain

        Ch_LDAP = "LDAP://" & CurrentUserDnsDomain & "/" & ObjADSysInfo.Username
        Set objItem = GetObject(Ch_LDAP)
        If err Then
                WriteErrLog "GetMemberOf_AD Ch_LDAP=" & ch_LDAP & " " & Hex(err.number) & " " & err.description
        Else
                WriteDebugLog "GetMemberOf_AD Ch_LDAP=" & ch_LDAP
                PrimaryGroupID = objItem.Get("primaryGroupID")
                WriteDebugLog "GetMemberOf_AD PrimaryGroupID=" & PrimaryGroupID
                objCom.CommandText = "<LDAP://" & CurrentUserDnsDomain & "/" & strDomain &">;(objectCategory=group);Name,primaryGroupToken;subtree"
                Set objRec = objCom.Execute
                if Not Err Then
                        Do While Not objRec.EOF
                                If objRec.Fields("primaryGroupToken") = PrimaryGroupID Then
                                        PrimaryGroupName = objRec.Fields("Name")
                                        if err Then
                                                WriteErrLog "GetMemberOf_AD PrimaryGroupName " & Hex(err.number) & " " & Err.description
                                                Exit Do
                                        End If
                                        privCurrentUserMemberOf.add CurrentUserDomain & "\" & PrimaryGroupName , ""
                                        privCurrentUserMemberOf.add PrimaryGroupName , ""
                                        WriteDebugLog "GetMemberOf_AD PrimaryGroupName=" & CurrentUserDomain & "\" & PrimaryGroupName
                                        Exit Do
                                End If
                                objRec.MoveNext
                        Loop
                Else
                        WriteErrLog "GetMemberOf_AD PrimaryGroupName: " & Hex(err.number) & " " & err.description
                End If

                Err.clear
                colmemberOf = objItem.GetEx("memberOf")
                if Err.Number <> &h8000500D Then
                        For Each Item in colmemberOf
                                tmpGroup = GetObject("LDAP://" & CurrentUserDnsDomain & "/" & Item).get("Name")
                                If Err Then
                                        WriteErrLog "GetMemberOf_AD GetObject:LDAP://" & CurrentUserDnsDomain & "/" & Item & " " & Hex(err.number) & " " & err.description
                                        Err.clear
                                Else
                                        privCurrentUserMemberOf.add CurrentUserDomain & "\" & tmpGroup , ""
                                        privCurrentUserMemberOf.add tmpGroup , ""
                                End If
                        Next
                Else
                        WriteDebugLog "GetMemberOf_AD MemberOf Not Set"
                End If
        End If

        objRec.close
        objCon.Close
        Set objCon = Nothing
        Set objCom = Nothing
        Set objRec = Nothing
        WriteDebugLog "GetMemberOf_AD END"
End Sub

Private Sub GetMemberOf_Local()
        on error resume next:err.clear
        WriteDebugLog "GetMemberOf_Local START"
        Set objWMIService = GetObject("winmgmts:\\.\root\CimV2")
        Set colItems = objWMIService.ExecQuery("Select Domain, Name from Win32_Group Where LocalAccount = True","WQL",48)
        For Each objItem in colItems
                Set colItems2 = objWMIService.ExecQuery("Select * from Win32_GroupUser Where PartComponent = ""Win32_UserAccount.Domain='" & CurrentUserDomain & "',Name='" & CurrentUsername & "'"" AND GroupComponent = ""Win32_Group.Domain='" & ObjItem.Domain & "',Name='" & ObjItem.Name & "'""","WQL",48)
                For Each objItem2 in colItems2
                        privCurrentUserMemberOf.add objItem.Domain & "\" & objItem.name , ""
                        privCurrentUserMemberOf.add objItem.name , ""
                Next
        Next
        if Err Then
              If Cstr(Hex(err.number)) = "80041017" Then
                   GetMemberOf_Local_Win2K()
                   WriteDebugLog "GetMemberOf_Local END"
              Else
                   WriteErrLog "GetMemberOf_Local " & Hex(err.number) & " " & err.Description
              End If
        Else
              WriteDebugLog "GetMemberOf_Local END"
        End If
End Sub

Private Sub GetMemberOf_Local_Win2K()
        on error resume next:err.clear
        WriteDebugLog "GetMemberOf_Local_Win2K START"
        Dim oUser:Set oUser = GetObject("WinNT://" & CurrentComputername & "/" & CurrentUserName)
        For Each oGroup In oUser.Groups
                privCurrentUserMemberOf.add UCASE(CurrentComputername & "\" & oGroup.Name) , ""
                privCurrentUserMemberOf.add UCASE(oGroup.Name) , ""
                if err then Exit For
        Next
        Set oUser = Nothing
        If Err Then
                WriteErrLog "GetMemberOf_Local_Win2K " & Hex(err.number) & " " & err.Description
        Else
                WriteDebugLog "GetMemberOf_Local_Win2K END"
        End If
End Sub

Private Sub GetMemberOf_NT4()
        on error resume next:err.clear
        WriteDebugLog "GetMemberOf_NT4 START"
        Dim oUser:Set oUser = GetObject("WinNT://" & CurrentUserDomain & "/" & CurrentUserName)
        For Each oGroup In oUser.Groups
                privCurrentUserMemberOf.add UCASE(CurrentUserDomain & "\" & oGroup.Name) , ""
                privCurrentUserMemberOf.add UCASE(oGroup.Name) , ""
                if err then Exit For
        Next
        Set oUser = Nothing
        If Err Then
                WriteErrLog "GetMemberOf_NT4 " & Hex(err.number) & " " & err.Description
        Else
                WriteDebugLog "GetMemberOf_NT4 END"
        End If
End Sub

Private Property Get CurrentComputerIPs()  'as Dictionary
        on error resume next:err.clear
        if isEmpty(privCurrentComputerIPs) Then
                Set privCurrentComputerIPs = CreateObject("Scripting.Dictionary")
                Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
                Set colAdapters = objWMIService.ExecQuery("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled = True","WQL",48)
                For Each objAdapter in colAdapters
                        If isArray(ObjAdapter.IPAddress) Then
                               For each IP in ObjAdapter.IPAddress
                                       If IsIPv4(IP) Then
                                                privCurrentComputerIPs.add  IP , IPAddressToNumber(IP)
                                       End If
                               Next
                        Else
                                        WriteErrLog "CurrentComputerIPs: Not An Array"
                        End if
                Next
                If err then
                        writeErrLog "CurrentComputerIPs: " & Hex(err.number) & " -> " & err.description
                else
                        writeDebugLog "CurrentComputerIPs = " & Join(privCurrentComputerIPs.Keys,",")
                End If
        End If
        Set CurrentComputerIPs = privCurrentComputerIPs
End Property

Private Property Get CurrentDay() 'as String
        if isEmpty(privCurrentDay) Then
                select Case WeekDay(Now)
                        case vbSunday
                                privCurrentDay = "Sunday"
                        case vbMonday
                                privCurrentDay = "Monday"
                        case vbTuesday
                                privCurrentDay = "Tuesday"
                        case vbWednesday
                                privCurrentDay = "Wednesday"
                        case vbThursday
                                privCurrentDay = "Thursday"
                        case vbFriday
                                privCurrentDay = "Friday"
                        case vbSaturday
                                privCurrentDay = "Saturday"
                        case Else
                                privCurrentDay = "ERROR"
                End Select
                WriteDebugLog "CurrentDay = " & privCurrentDay
        End If
        CurrentDay = privCurrentDay
        if Err Then
              WriteErrLog "CurrentDay: " & Hex(err.number) & " " & err.Description
        End If
End Property

Private Property Get CurrentTime() 'as String
         if isEmpty(privCurrentTime) Then
                privCurrentTime = Left(Time,5)
                WriteDebugLog "CurrentTime = " & privCurrentTime
        End If
        CurrentTime = privCurrentTime
        if Err Then
              WriteErrLog "CurrentTime: " & Hex(err.number) & " " & err.Description
        End If
End Property

Private Property Get CurrentDirectory() 'as String
        if isEmpty(privCurrentDirectory) Then
                'privCurrentDirectory = replace(wscript.ScriptFullName,Wscript.ScriptName,"")
                privCurrentDirectory = Left(wscript.ScriptFullName,Len(wscript.ScriptFullName) - Len(Wscript.ScriptName))
                WriteDebugLog "CurrentDirectory = " & privCurrentDirectory
        End If
        CurrentDirectory = privCurrentDirectory
        if Err Then
              WriteErrLog "CurrentDirectory: " & Hex(err.number) & " " & err.Description
        End If
End Property

Private Property Get CurrentConfigINIPath() 'as String
        on error resume next:err.clear
        if isEmpty(privCurrentConfigINIPath) Then
'                if Wscript.Aguments.count
                privCurrentConfigINIPath = replace(wscript.ScriptFullName,".vbs",".ini")
                WriteDebugLog "CurrentConfigINIPath = " & privCurrentConfigINIPath
        End If
        CurrentConfigINIPath = privCurrentConfigINIPath
        if Err Then
              WriteErrLog "CurrentConfigINIPath: " & Hex(err.number) & " " & err.Description
        End If
End Property

Private Property Get CurrentDesktopPath() 'as String
        on error resume next:err.clear
        if isEmpty(privCurrentDesktopPath) Then
                privCurrentDesktopPath = objShellApp.Namespace(&H10&).Self.Path
                WriteDebugLog "CurrentDesktopPath = " & privCurrentDesktopPath
        End If
        CurrentDesktopPath = privCurrentDesktopPath
        if Err Then
              WriteErrLog "CurrentDesktopPath: " & Hex(err.number) & " " & err.Description
        End If
End Property

Private Property Get CurrentQuickLaunchPath() 'as String
        on error resume next:err.clear
        if isEmpty(privCurrentQuickLaunchPath) Then
                privCurrentQuickLaunchPath = objShellApp.Namespace(&H1a&).Self.Path & "\Microsoft\Internet Explorer\Quick Launch"
                WriteDebugLog "CurrentQuickLaunchPath = " & privCurrentQuickLaunchPath
        End If
        CurrentQuickLaunchPath = privCurrentQuickLaunchPath
        if Err Then
              WriteErrLog "CurrentQuickLaunchPath: " & Hex(err.number) & " " & err.Description
        End If
End Property

Private Property Get CurrentProgramsPath() 'as String
        on error resume next:err.clear
        if isEmpty(privCurrentProgramsPath) Then
                privCurrentProgramsPath = objShellApp.Namespace(&H2&).Self.Path
                WriteDebugLog "CurrentProgramsPath = " & privCurrentProgramsPath
        End If
        CurrentProgramsPath = privCurrentProgramsPath
        if Err Then
              WriteErrLog "CurrentProgramsPath: " & Hex(err.number) & " " & err.Description
        End If
End Property

Private Property Get CurrentUserPrintersConnections()
        on error resume next:err.clear
        if isEmpty(privCurrentUserPrintersConnections) Then
                Set privCurrentUserPrintersConnections = CreateObject("Scripting.Dictionary")
                Set oPrinters = ObjNetwork.EnumPrinterConnections
                For i = 0 to oPrinters.Count - 1 Step 2
                        If Left(oPrinters.Item(i+1),2) = "\\" Then
                        privCurrentUserPrintersConnections.add UCASE(oPrinters.Item(i+1)) , UCASE(oPrinters.Item(i))
                        WriteDebugLog "CurrentUserPrintersConnections Dictionary ADD:" & oPrinters.Item(i+1) & " -> " & oPrinters.Item(i)
                        Else
                        WriteDebugLog "CurrentUserPrintersConnections Dictionary IGNORE:" & oPrinters.Item(i+1) & " -> " & oPrinters.Item(i)
                        End If
                Next
        End If
        Set CurrentUserPrintersConnections = privCurrentUserPrintersConnections
        if Err Then
              WriteErrLog "CurrentUserPrintersConnections: " & Hex(err.number) & " " & err.Description
        End If
End Property

Private Property Get CurrentUserDrivesConnections()
        on error resume next:err.clear
        if isEmpty(privCurrentUserDrivesConnections) Then
                Set privCurrentUserDrivesConnections = CreateObject("Scripting.Dictionary")
                Set oDrives = ObjNetwork.EnumNetworkDrives
                For i = 0 to oDrives.Count - 1 Step 2
                        privCurrentUserDrivesConnections.add UCASE(oDrives.Item(i)) , UCASE(oDrives.Item(i+1))
                        WriteDebugLog "CurrentUserDrivesConnections Dictionary ADD:" & oDrives.Item(i) & " -> " & oDrives.Item(i+1)
                Next
        End If
        Set CurrentUserDrivesConnections = privCurrentUserDrivesConnections
        if Err Then
              WriteErrLog "CurrentUserDrivesConnections: " & Hex(err.number) & " " & err.Description
        End If
End Property
'============================================================================
'============================================================================
' ACTIONS
'============================================================================
'============================================================================
Private Sub Action_Copy(Src, Dest, Overwrite , Move)
        on error resume next:err.clear
        If objFSO.FolderExists(ExpandLocalVar(Src)) Then
              if Move Then
                        objFSO.MoveFolder ExpandLocalVar(Src) , ExpandLocalVar(Dest)
                        if Err Then
                              WriteErrLog "Action_Copy:MoveFolder " & Hex(err.number) & " " & err.description & " Src:" & Src & " Dest:" & Dest
                        Else
                              WriteLog "Action_Copy:MoveFolder Src:" & Src & " Dest:" & Dest
                        End If
              Else
                        objFSO.CopyFolder ExpandLocalVar(Src) , ExpandLocalVar(Dest) , Overwrite
                        if Err Then
                              WriteErrLog "Action_Copy:CopyFolder " & Hex(err.number) & " " & err.description & " Src:" & Src & " Dest:" & Dest
                        Else
                              WriteLog "Action_Copy:CopyFolder Src:" & Src & " Dest:" & Dest
                        End If
              End If
        ElseIf objFSO.FileExists(ExpandLocalVar(Src)) Then
              If Move Then
                        if objFSO.FileExists(ExpandLocalVar(Dest)) And Overwrite Then
                                objFSO.DeleteFile ExpandLocalVar(Dest), true
                                err.clear
                        End If
                        objFSO.MoveFile ExpandLocalVar(Src) , ExpandLocalVar(Dest)
                        if Err Then
                              WriteErrLog "Action_Copy:MoveFile " & Hex(err.number) & " " & err.description & " Src:" & Src & " Dest:" & Dest
                        Else
                              WriteLog "Action_Copy:MoveFile Src:" & Src & " Dest:" & Dest
                        End If
              Else
                        objFSO.CopyFile ExpandLocalVar(Src) , ExpandLocalVar(Dest) , Overwrite
                        if Err Then
                              WriteErrLog "Action_Copy:CopyFile " & Hex(err.number) & " " & err.description & " Src:" & Src & " Dest:" & Dest
                        Else
                              WriteLog "Action_Copy:CopyFile Src:" & Src & " Dest:" & Dest
                        End If
              End If
        Else
                if Move Then
                       WriteErrLog "Action_Copy:Move " & Src & " INEXIST"
                Else
                       WriteErrLog "Action_Copy:Copy " & Src & " INEXIST"
                End If
        End If
End Sub

Private Sub Action_Delete(Path)
        on error resume next:err.clear
        If objFSO.FolderExists(ExpandLocalVar(Path)) Then
                objFSO.DeleteFolder Path
                if Err Then
                        WriteErrLog "Action_Delete:Folder " & Hex(err.number) & " " & err.description & " Path:" & Path
                Else
                        WriteLog "Action_Delete:Folder Path:" & Path
                End If
        ElseIf objFSO.FileExists(ExpandLocalVar(Path)) Then
                objFSO.DeleteFile Path, True
                if Err Then
                        WriteErrLog "Action_Delete:Files " & Hex(err.number) & " " & err.description & " Path:" & Path
                Else
                        WriteLog "Action_Delete:Files Path:" & Path
                End If
        Else
               WriteLog "Action_Delete: " & Path & " INEXIST"
        End If
End Sub

Private Sub Action_MakeDir(Dir)
        on error resume next:err.clear
        If Not objFSO.FolderExists(ExpandLocalVar(Dir)) Then
                Set objFolder = objFSO.CreateFolder(ExpandLocalVar(Dir))
                if Err Then
                        WriteErrLog "Action_MakeDir: " & Hex(err.number) & " " & err.description & " Dir:" & Dir
                Else
                        WriteLog "Action_MakeDir: Dir:" & Dir
                End If
        Else
                WriteLog "Action_MakeDir: " & Dir & " EXIST"
        End If
End Sub

Private Sub Action_ConnectNetworkDrive(Connect,Letter,UNCPath,Force,persistent,username,password)
        on error resume next:err.clear
        If Connect Then
        	if Force Then objNetwork.RemoveNetworkDrive Letter & ":" , true , true
                err.clear
        	if username = "" Then
	               objNetwork.MapNetworkDrive Letter & ":", ExpandLocalVar(UNCPath) , persistent
        	Else
	               objNetwork.MapNetworkDrive Letter & ":", ExpandLocalVar(UNCPath) , persistent, username, password
        	End If
       	Else
       	        objNetwork.RemoveNetworkDrive Letter & ":" , true , true
       	End If
	If err then
               WriteErrLog "Action_ConnectNetworkDrive: ConnectMode:" & Connect & " " & Hex(err.number) & " " & err.description  & " Letter:" & Letter & " UNCPath:" & UNCPath
        else
               WriteLog "Action_ConnectNetworkDrive: ConnectMode:" & Connect & " " & Letter & ": = " & UNCPath
        End If
End Sub

Private Sub Action_ConnectNetworkPrinter(UNCPath,Default,Remove,DomUsername,Password)
        on error resume next:err.clear
        UNCPath = ExpandLocalVar(UNCPath)
        If Remove Then
                If PrinterIsConnected(UNCPath) Then
                        ObjNetwork.RemovePrinterConnection UNCPath
                        If err then
                                if err.number = -2147022646 Then
                                        WriteLog "Action_ConnectNetworkPrinter:RemovePrinterConnection " & UNCPath & " NOT EXIST"
                                Else
                                        WriteErrLog "Action_ConnectNetworkPrinter:RemovePrinterConnection " & UNCPath & " " & Hex(err.number) & " " & err.description
                                End If
                        Else
                                WriteLog "Action_ConnectNetworkPrinter:RemovePrinterConnection " & UNCPath & " OK"
                        End If
                Else
                        WriteLog "Action_ConnectNetworkPrinter:RemovePrinterConnection " & UNCPath & " NOT CONNECTED"
                End If
        Else
                If DomUsername <> "" Then
                        IPC = Left(UNCPath,InStr(3,UNCPath,"\",vbTextCompare)) & "IPC$"
                        objNetwork.MapNetworkDrive "", IPC , False, DomUsername, Password
                        If err then
                                WriteErrLog "Action_ConnectNetworkPrinter:ConnectIPC$ " & Hex(err.number) & " " & err.description  & " IPC$Path:" & IPC
                                err.clear
                        else
                                WriteLog "Action_ConnectNetworkPrinter:ConnectIPC$ IPC$Path:" & IPC & " OK"
                        End If
                End If
                ObjNetwork.AddWindowsPrinterConnection UNCPath
                If err then
                        WriteErrLog "Action_ConnectNetworkPrinter:AddPrinter " & Hex(err.number) & " " & err.description  & " UNCPath:" & UNCPath
                else
                        WriteLog "Action_ConnectNetworkPrinter:AddPrinter " & UNCPath & " OK"
                End If
                If Default Then
                        ObjNetwork.SetDefaultPrinter UNCPath
                        If err then
                                WriteErrLog "Action_ConnectNetworkPrinter:SetDefaultPrinter " & Hex(err.number) & " " & err.description  &  " UNCPath:" & UNCPath
                        else
                                WriteLog "Action_ConnectNetworkPrinter:SetDefaultPrinter " & UNCPath & " OK"
                        End If
                End If
        End If
End Sub

Private Sub Action_CreateVirtualDrive(Letter,Path,Remove)
        on error resume next:err.clear
        If Remove Then
              ObjShell.run "SUBST.EXE " & Letter & ": " & " /D" , 0 , True
        Else
              ObjShell.run "SUBST.EXE " & Letter & ": " & " /D" , 0 , True
              ErrCode = ObjShell.run("SUBST.EXE " & Letter & ": " & """" & Path & """" , 0 , True)
        End If
        if err Or ErrCode > 0 Then
               WriteErrLog "Action_CreateVirtualDrive " & ErrCode & " " & " Letter:" & Letter & ": = Path:" & Path
        else
               WriteLog "Action_CreateVirtualDrive Letter:" & Letter & ": = " & "Path:" & Path
        End If
End Sub

Private Sub Action_RegistryKey(Key,Value,DataValue,RegType,Cmd)
        on error resume next:err.clear
        Select Case Cmd
                Case "ADDKEY"
                        objShell.regWrite Key & "\"  , "" , "REG_SZ"
                Case "ADDVAL"
                        objShell.regWrite Key & "\" & Value , DataValue , RegType
                Case "DELKEY"
                        objShell.regDelete Key & "\"
                Case "DELVAL"
                        objShell.regDelete Key & "\" & Value
                Case Else
                        WriteErrLog "Action_RegistryKey Key:" & Key & " Value:" & Value& " RegType:" & RegType
        End Select
        if err Then
                WriteErrLog "Action_RegistryKey Cmd:" & Cmd & " "  & Hex(err.number) & " " & err.description  & " Key:" & Key & " Value:" & Value& " RegType:" & RegType
        Else
                WriteLog "Action_RegistryKey Cmd:" & Cmd & " Key:" & Key & " Value:" & Value& " RegType:" & RegType
        End If
End Sub

Private Sub Action_SendMail(From, Too,Subject,Body,Attachments,SmtpSrv,SmtpPort)
        on error resume next:err.clear
        With CreateObject("CDO.Message")
                .From = ExpandLocalVar(From)
                .To= ExpandLocalVar(Too)
                .Subject=ExpandLocalVar(Subject)
                .TextBody=ExpandLocalVar(Body)
                AttachmentsArr = split(Attachments,",")
                for each fic in AttachmentsArr
                        if ObjFso.FileExists(ExpandLocalVar(fic)) Then
                                .AddAttachment(ExpandLocalVar(fic))
                        End If
                next
                if SmtpSrv <> "" then
                        .Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
                        .Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = ExpandLocalVar(SmtpSrv)
                        .Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = ExpandLocalVar(SmtpPort)
                        .Configuration.Fields.Update
                End If
                .Send
        End With
        if err Then
                WriteErrLog "Action_SendMail " & Hex(err.number) & " " & err.description & " From:" & From & " To:" & Too & " Subject:" & Subject
        Else
                WriteLog "Action_SendMail From:" & From & " To:" & Too & " Subject:" & Subject
        End If
End Sub

Private Sub Action_WriteInINIFile(FilePath,Section,Variable,Value)
       on error resume next:err.clear
       WriteINIString Section, Variable, Value, FilePath
       if err Then
                WriteErrLog "Action_WriteInINIFile " & Hex(err.number) & " " & err.description  & " FilePath:" & FilePath & " Section:" & Section & " Variable:" & Variable & " Value:" & Value
       Else
                WriteLog "Action_WriteInINIFile FilePath:" & FilePath & " Section:" & Section & " Variable:" & Variable & " Value:" & Value
       End If
End Sub

Private Sub Action_CreateEnvironmentVariable(Variable,Value,TypeVariable)
       on error resume next:err.clear
       Set EnvUser = objShell.environment(UCASE(TypeVariable))
       EnvUser(Variable) = Value
       if err Then
                WriteErrLog "Action_CreateEnvironmentVariable " & Hex(err.number) & " " & err.description  & " Variable:" & Variable & " Value:" & Value
       Else
                WriteLog "Action_CreateEnvironmentVariable Variable:" & Variable & " Value:" & Value
       End If
End Sub

Private Sub Action_Sleep(nbreMs)
       on error resume next:err.clear
       Wscript.sleep nbreMs
       if err Then
                WriteErrLog "Action_Sleep " & Hex(err.number) & " " & err.description  & " nbreMs:" & nbreMs
       Else
                WriteLog "Action_Sleep: nbreMs:" & nbreMs
       End If
End Sub

Private Sub Action_CreateShortCut( NamePath , TargetPath , Arguments , Description ,_
                                 Hotkey , IconLocation , WindowStyle , WorkingDirectory,_
                                 OnDesktop, OnProgram, ProgramSubFolder, OnQuickLaunch, OnOtherpath, OtherPath, Remove )
	on error resume next:err.clear
	if OnProgram Then
	       If Remove Then
	               ObjFSO.DeleteFile CurrentProgramsPath & "\" & ProgramSubFolder & "\" & NamePath & ".lnk"
	       Else
	               'objFSO.CreateFolder(ExpandLocalVar(CurrentProgramsPath & "\" & ProgramSubFolder))
	               CreateSubFolders ExpandLocalVar(CurrentProgramsPath) , ExpandLocalVar(ProgramSubFolder)
	               err.clear
	               CreateShortCut CurrentProgramsPath & "\" & ProgramSubFolder & "\" & NamePath & ".lnk" , TargetPath , Arguments , Description , Hotkey , IconLocation , WindowStyle , WorkingDirectory
	       End If
	End If
	
	if OnDesktop Then
	       If Remove Then
	               ObjFSO.DeleteFile ExpandLocalVar(CurrentDesktopPath & "\" & NamePath & ".lnk")
	       Else
	               CreateShortCut CurrentDesktopPath & "\" & NamePath & ".lnk" , TargetPath , Arguments , Description , Hotkey , IconLocation , WindowStyle , WorkingDirectory
	       End If
	End If
	
	If OnQuickLaunch Then
	       If Remove Then
	               ObjFSO.DeleteFile CurrentQuickLaunchPath & "\" & NamePath & ".lnk"
	       Else
	               CreateShortCut CurrentQuickLaunchPath & "\" & NamePath & ".lnk" , TargetPath , Arguments , Description , Hotkey , IconLocation , WindowStyle , WorkingDirectory
	       End If
	End If
	
	if err Then
                WriteErrLog "Action_CreateShortCut " & Hex(err.number) & " " & err.description & " NamePath:" & NamePath & " TargetPath:" & TargetPath & " Description:" & Description
        End If
End Sub

Private Sub CreateSubFolders(RootFolder,SubFolders)
        on error resume next
        ArrFolders = Split(SubFolders,"\")
        For each Folder in ArrFolders
            RootFolder = RootFolder & "\" & Folder
            objFSO.CreateFolder(RootFolder)
        Next
End Sub

Private Sub CreateShortCut( NamePath , TargetPath , Arguments , Description , Hotkey , IconLocation , WindowStyle , WorkingDirectory)
        on error resume next:err.clear
        Set objShortCut = objShell.CreateShortcut(NamePath)
	objShortCut.TargetPath = TargetPath
	If Description <> "" Then objShortCut.Description = Description
	If Hotkey <> "" Then objShortCut.HotKey = Hotkey
	If IconLocation <> "" Then objShortCut.IconLocation = IconLocation
	If Arguments <> "" Then objShortCut.Arguments = Arguments
	If WindowStyle <> "" Then objShortCut.WindowStyle = WindowStyle
	If WorkingDirectory <> "" Then objShortCut.WorkingDirectory = WorkingDirectory
	objShortCut.Save
	if err Then
                WriteErrLog "CreateShortCut " & Hex(err.number) & " " & err.description & " NamePath:" & NamePath & " TargetPath:" & TargetPath & " Description:" & Description
        Else
                WriteLog "CreateShortCut  NamePath:" & NamePath & " TargetPath:" & TargetPath & " Description:" & Description
        End If
End Sub

Private Sub Action_ShowPopup(Msg,Title,Icon,Duration)
        on error resume next:err.clear
        Dim nType
        Select case UCASE(Icon)
                case "NOTHING"
                        nType = 0
                case "STOP"
                        nType = 16
                case "QUESTION"
                        nType = 32
                case "EXCLAMATION"
                        nType = 48
                case "INFORMATION"
                        nType = 64
                case Else
                        nType = 0
        End Select
        ObjShell.Popup Replace(Msg,"|",vbCrLf) , Duration , Title , nType
        if err Then
                WriteErrLog "Action_ShowPopup " & Hex(err.number) & " " & err.description & " Msg:" & Msg & " Title:" & Title & " Duration:" & Duration
        Else
                WriteLog "Action_ShowPopup  Msg:" & Msg & " Title:" & Title & " Duration:" & Duration
        End If
End Sub

Private Sub Action_ExecuteProcess(Path,Args,WorkDir,Hide,Wait,Username,Password)
        on error resume next:err.clear
        Dim ReturnCode
        if Username = "" Then
                If WorkDir <> "" Then objShell.CurrentDirectory = WorkDir
                err.clear
                If Hide Then
                    ReturnCode = ObjShell.run( """" & Path & """ " & Args , 0 , Wait)
                Else
                    ReturnCode = ObjShell.run( """" & Path & """ " & Args , 1 , Wait)
                End If
        Else
                if isEmpty(ObjGSCT) Then
                     WriteErrLog "Action_ExecuteProcess GlobalScript.GlobalScriptComTool NOT INSTALLED -> Path:" & Path & " Args:" & Args & " WorkDir:" & WorkDir & " Username:" & Username & " " & Hex(err.number) & " " & Err.description
                     Exit Sub
                Else

                     ReturnCode = ObjGSCT.runas( Path , Args,  Workdir, Split(Username,"\")(0), Split(Username,"\")(1) , Password , Hide , Wait )
                End If
        End If
        If err Then
                WriteErrLog "Action_ExecuteProcess " & Hex(err.number) & " " & err.description & " Path:" & Path & " Args:" & Args & " WorkDir:" & WorkDir & " Username:" & Username
        Else
                WriteLog "Action_ExecuteProcess  ReturnCode:" & ReturnCode & " Path:" & Path & " Args:" & Args & " WorkDir:" & WorkDir & " Username:" & Username
        End If
End Sub

Private Sub Action_LaunchIncludeScript( EngineAndLang , ScriptEngineArgs , Arguments , Hide , Wait , WorkingDirectory , Username , Password , Separator , ScriptText)
       on error resume next
       Dim EngineEXE ,tmpScript, extens
       If Username <> "" Then
            If Not objFSO.FolderExists(ExpandLocalVar("%SYSTEMDRIVE%\TEMP")) Then Set objFolder = objFSO.CreateFolder(ExpandLocalVar("%SYSTEMDRIVE%\TEMP"))
            If Err Then
                WriteErrLog "Action_LaunchIncludeScript: Impossible de creer le dossier temporaire " & ExpandLocalVar("%SYSTEMDRIVE%\TEMP")
            End If
            tmpScript = ExpandLocalVar("%SYSTEMDRIVE%\TEMP\") & objFSO.GetTempName
       Else
            tmpScript = ExpandLocalVar("%TEMP%") & "\" & objFSO.GetTempName
       End If
       Select case EngineAndLang
                case "WSCVBS":
                        Script = tmpScript & ".vbs"
                        Path = "Wscript.exe"
                        Args = """" & Script & """ " & ScriptEngineArgs & " " & Arguments
                case "WSCJS":
                        Script = tmpScript & ".js"
                        Path = "Wscript.exe"
                        Args = """" & Script & """ " & ScriptEngineArgs & " " & Arguments
                case "WSCWSH":
                        Script = tmpScript & ".wsf"
                        Path = "Wscript.exe"
                        Args = """" & Script & """ " & ScriptEngineArgs & " " & Arguments
                case "CSCVBS":
                        Script = tmpScript & ".vbs"
                        Path = "Cscript.exe"
                        Args = """" & Script & """ " & ScriptEngineArgs & " " & Arguments
                Case "CSCJS":
                        Script = tmpScript & ".js"
                        Path = "Cscript.exe"
                        Args = """" & Script & """ " & ScriptEngineArgs & " " & Arguments
                Case "CSCWSH":
                        Script = tmpScript & ".wsf"
                        Path = "Cscript.exe"
                        Args = """" & Script & """ " & ScriptEngineArgs & " " & Arguments
                Case "CMD":
                        Script = tmpScript & ".cmd"
                        Path = Script
                        Args = Arguments
                Case "PS":
                        Script = tmpScript & ".ps1"
                        Path = "PowerShell.exe"
                        Args = ScriptEngineArgs & " -File """ & Script & """ " & Arguments
                Case Else
       End Select

       Dim FileWriteOK
       Select case EngineAndLang
                case "CMD":
                       FileWriteOK = WriteFileASCII(Script,Replace(ScriptText , Separator, vbCrLf))
                case Else
                       FileWriteOK = WriteFileUnicode(Script,Replace(ScriptText , Separator, vbCrLf))
       End Select
       

       If FileWriteOK Then
                Action_ExecuteProcess Path,Args,WorkDir,Hide,Wait,Username,Password
                If Wait Then
                        objFSO.DeleteFile Script, True
                End If
       Else
                WriteErrLog "Action_LaunchIncludeScript Script:" & Script & " WRITEFILE ERROR"
       End If
       If err Then
                WriteErrLog "Action_LaunchIncludeScript " & Hex(err.number) & " " & err.description & " Path:" & Path & " Args:" & Args
       Else
                WriteLog "Action_LaunchIncludeScript OK Path:" & Path & " Args:" & Args
       End If
End Sub
'============================================================================
'============================================================================
' CONDITIONS
'============================================================================
'============================================================================
Private Function Test_ConditionTrue(ConditionNameID) 'as boolean
              on error resume next:err.clear
              Test_ConditionTrue = True
              WriteLog "Test_ConditionTrue:" & ConditionNameID & " -> TRUE"
End Function

Private Function Test_ConditionComputername(ConditionNameID) 'as boolean
              on error resume next:err.clear
              Test_ConditionComputername = False
              if INIBool(GetConfigINIString(ConditionNameID, "LocalComputer", "1")) Then
                        ComputerName =  CurrentComputername
              Else
                        ComputerName =  CurrentClientName
              End If
              WriteDebugLog "Test_ConditionComputername:" & ConditionNameID & " ComputerName = " & ComputerName

              strRegEx = GetConfigINIString(ConditionNameID, "RegEx", "")
              if strRegEx <> "" Then
                          Set regEx = New RegExp
                          regEx.Pattern = strRegEx
                          regEx.IgnoreCase = True
                          regEx.Global = True
                          Set Matches = regEx.Execute(Computername)
                          if Matches.count > 0 Then
                                Test_ConditionComputername = True
                                WriteDebugLog "Test_ConditionComputername:" & ConditionNameID & " RegEx:" & strRegEx & " MATCH"
                          Else
                                Test_ConditionComputername = False
                                WriteDebugLog "Test_ConditionComputername:" & ConditionNameID & " RegEx:" & strRegEx & " NOT MATCH"
                          End If
              End If
              'ERR

              strComputers = GetConfigINIString(ConditionNameID, "Computers", "")
              if strComputers <> "" Then
                        ArrayComputers = Split(strComputers,",")
                        For each Computer in ArrayComputers
                                if lcase(Computer) = lcase(Computername) then
                                        Test_ConditionComputername = True
                                        WriteDebugLog "Test_ConditionComputername:" & ConditionNameID & " Computer:" & Computer
                                        Exit For
                                End If
                        Next
              End If
              if err Then
                        WriteErrLog "Test_ConditionComputername:" & ConditionNameID & " " & Hex(err.number) & " " & err.description & " ComputerName:" & ComputerName
                        Test_ConditionComputername = False
              Else
                        if INIBool(GetConfigINIString(ConditionNameID, "Negation", "0")) then Test_ConditionComputername = Not Test_ConditionComputername
                        if Test_ConditionComputerName Then
                                WriteLog "Test_ConditionComputername:" & ConditionNameID & " -> TRUE"
                        Else
                                WriteLog "Test_ConditionComputername:" & ConditionNameID & " -> FALSE"
                        End If
              End If
End Function

Private Function Test_ConditionDays(ConditionNameID) 'as boolean
             on error resume next:err.clear
             Test_ConditionDays = False
             DayInfo = GetConfigINIString(ConditionNameID, CurrentDay, "NO")
             Select case DayInfo
                case "NO"
                        Test_ConditionDays = False
                case "FULL"
                        Test_ConditionDays = True
                case else
                        ArrTime = Split(DayInfo,"-")
                        if DateDiff("s",ArrTime(0),CurrentTime) > 0 And DateDiff("s",CurrentTime,ArrTime(1)) > 0 Then
                                Test_ConditionDays = True
                        Else
                                Test_ConditionDays = False
                        End If
             End Select
             if err Then
                        WriteErrLog "Test_ConditionDays:" & ConditionNameID & " " & Hex(err.number) & " " & err.description
                        Test_ConditionDays = False
              Else
                        if INIBool(GetConfigINIString(ConditionNameID, "Negation", "0")) then Test_ConditionDays = Not Test_ConditionDays
                        if Test_ConditionDays Then
                                WriteLog "Test_ConditionDays:" & ConditionNameID & " -> TRUE"
                        Else
                                WriteLog "Test_ConditionDays:" & ConditionNameID & " -> FALSE"
                        End If
              End If
End Function

Private Function Test_ConditionEnvironment(ConditionNameID) 'as boolean
              on error resume next:err.clear
              Test_ConditionEnvironment = False
              if ExpandLocalVar("%" & GetConfigINIStringNoExpandVar(ConditionNameID, "Variable", "ERR1") & "%") = GetConfigINIString(ConditionNameID, "Value", "ERR2") Then Test_ConditionEnvironment = True
              if err Then
                        WriteErrLog "Test_ConditionEnvironment:" & ConditionNameID & " " & Hex(err.number) & " " & err.description
                        Test_ConditionEnvironment = False
              Else
                        if INIBool(GetConfigINIString(ConditionNameID, "Negation", "0")) then Test_ConditionEnvironment = Not Test_ConditionEnvironment
                        if Test_ConditionEnvironment Then
                                WriteLog "Test_ConditionEnvironment:" & ConditionNameID & " -> TRUE"
                        Else
                                WriteLog "Test_ConditionEnvironment:" & ConditionNameID & " -> FALSE"
                        End If
              End If
End Function

Private Function Test_ConditionADSite(ConditionNameID) 'as boolean
              on error resume next:err.clear
              Test_ConditionADSite = False
              If lcase(GetConfigINIString(ConditionNameID, "Site", "")) = lcase(CurrentADSIte) Then  Test_ConditionADSite = True
              if err Then
                        WriteErrLog "Test_ConditionADSite:" & ConditionNameID & " " & Hex(err.number) & " " & err.description
                        Test_ConditionADSite = False
              Else
                        if INIBool(GetConfigINIString(ConditionNameID, "Negation", "0")) then Test_ConditionADSite = Not Test_ConditionADSite
                        if Test_ConditionADSite Then
                                WriteLog "Test_ConditionADSite:" & ConditionNameID & " -> TRUE"
                        Else
                                WriteLog "Test_ConditionADSite:" & ConditionNameID & " -> FALSE"
                        End If
              End If
End Function

Private Function Test_ConditionMemberOf(ConditionNameID) 'as boolean
              on error resume next:err.clear
              Test_ConditionMemberOf = IsMemberOf(GetConfigINIString(ConditionNameID, "Group", ""))
              if err Then
                        WriteErrLog "Test_ConditionMemberOf:" & ConditionNameID & " " & Hex(err.number) & " " & err.description
                        Test_ConditionMemberOf = False
              Else
                        if INIBool(GetConfigINIString(ConditionNameID, "Negation", "0")) then Test_ConditionMemberOf = Not Test_ConditionMemberOf
                        if Test_ConditionMemberOf Then
                                WriteLog "Test_ConditionMemberOf:" & ConditionNameID & " -> TRUE"
                        Else
                                WriteLog "Test_ConditionMemberOf:" & ConditionNameID & " -> FALSE"
                        End If
              End If
End Function

Private Function Test_ConditionNetwork(ConditionNameID) 'as boolean
              on error resume next:err.clear
              Test_ConditionNetwork = False
              tmpRangesIP = Split(GetConfigINIString(ConditionNameID, "RangesIP", ""),",")
              if isArray(tmpRangesIP) Then
                    For each range in tmpRangesIP
                        If Test_ConditionNetwork Then Exit For
                        RangeIP = Split(range, "-")
                        if isArray(RangeIP) Then
                                IPNumberStart = IPAddressToNumber(RangeIP(0))
                                IPNumberEnd = IPAddressToNumber(RangeIP(1))
                                For each LocalIP in CurrentComputerIPs.Keys
                                       IPNumberLocalIP = CurrentComputerIPs.Item(LocalIP)
                                       WriteDebugLog "Test_ConditionNetwork.IPNumberLocalIP = " & IPNumberLocalIP & " IPNumberStart = " & IPNumberStart & " IPNumberEnd = " & IPNumberEnd
                                       if IPNumberStart <= IPNumberLocalIP AND IPNumberEnd >= IPNumberLocalIP Then
                                              if Err Then WriteErrLog "ERROR"
                                              Test_ConditionNetwork = True
                                              Exit For
                                       End If
                                Next
                        End If
                    Next
              End If
              if err Then
                        WriteErrLog "Test_ConditionNetwork:" & ConditionNameID & " " & Hex(err.number) & " " & err.description
                        Test_ConditionNetwork = False
              Else
                        if INIBool(GetConfigINIString(ConditionNameID, "Negation", "0")) then Test_ConditionNetwork = Not Test_ConditionNetwork
                        if Test_ConditionNetwork Then
                                WriteLog "Test_ConditionNetwork:" & ConditionNameID & " -> TRUE"
                        Else
                                WriteLog "Test_ConditionNetwork:" & ConditionNameID & " -> FALSE"
                        End If
              End If
End Function

Private Function Test_ConditionRegistry(ConditionNameID) 'as boolean
              on error resume next:err.clear
              Test_ConditionRegistry = False
              Read = CStr(ObjShell.RegRead(GetConfigINIString(ConditionNameID, "Key", "ERR2")))
              WriteDebugLog  "Test_ConditionRegistry: ReadKey=" & Read
              if UCASE(GetConfigINIString(ConditionNameID, "Value", "ERR1")) = UCASE(Read) Then
                        Test_ConditionRegistry = True
              Else
                        Test_ConditionRegistry = False
              End If
              if err Then
                        WriteErrLog "Test_ConditionRegistry:" & ConditionNameID & " " & Hex(err.number) & " " & err.description
                        Test_ConditionRegistry = False
              Else
                        if INIBool(GetConfigINIString(ConditionNameID, "Negation", "0")) then Test_ConditionRegistry = Not Test_ConditionRegistry
                        if Test_ConditionRegistry Then
                                WriteLog "Test_ConditionRegistry:" & ConditionNameID & " -> TRUE"
                        Else
                                WriteLog "Test_ConditionRegistry:" & ConditionNameID & " -> FALSE"
                        End If
              End If
End Function

Private Function Test_ConditionQueryWMI(ConditionNameID)
                on error resume next:err.clear
                Test_ConditionQueryWMI = False
                Set objWMIService = GetObject("winmgmts:\\.\" & GetConfigINIString(ConditionNameID, "NameSpace", "root\CimV2"))
                Set colAdapters = objWMIService.ExecQuery(GetConfigINIStringNoExpandVar(ConditionNameID, "QueryWMI", "ERROR"),"WQL",48)
                For Each objAdapter in colAdapters
                      Test_ConditionQueryWMI = True
                      Exit For
                Next
                If err Then
                        WriteErrLog "Test_ConditionQueryWMI:" & ConditionNameID & " " & Hex(err.number) & " " & err.description
                        Test_ConditionQueryWMI = False
                Else
                        if INIBool(GetConfigINIString(ConditionNameID, "Negation", "0")) then Test_ConditionQueryWMI = Not Test_ConditionQueryWMI
                        if Test_ConditionQueryWMI Then
                                WriteLog "Test_ConditionQueryWMI:" & ConditionNameID & " -> TRUE"
                        Else
                                WriteLog "Test_ConditionQueryWMI:" & ConditionNameID & " -> FALSE"
                        End If
                End If
End Function

Private Function Test_SequenceTrue(SequenceNameID) 'as Boolean
              on error resume next:err.clear
              Test_SequenceTrue = True
              WriteLog "Test_SequenceTrue:" & SequenceNameID & " -> TRUE"
End Function

Private Function Test_SequenceMemberOf(SequenceNameID) 'as boolean
              on error resume next:err.clear
              Test_SequenceMemberOf = IsMemberOf(GetConfigINIString(SequenceNameID, "Group", ""))
              if err Then
                        WriteErrLog "Test_SequenceMemberOf:" & ConditionNameID & " " & Hex(err.number) & " " & err.description
                        Test_SequenceMemberOf = False
              Else
                        WriteLog "Test_SequenceMemberOf:" & ConditionNameID & " -> TRUE"
              End If
End Function
'============================================================================
' EXECUTION
'============================================================================
Private Sub SetScriptINIContent(iniFile)
       on error resume next:err.clear
       If INCLUDEINI <> "" Then
            ConfigINIContents = INCLUDEINI
            iniFile = "INCLUDEINI"
       Else
            if objFSO.FileExists(iniFile) Then
                ConfigINIContents = GetFile(iniFile)
            Else
                writeErrLog "SetScriptINIContent: NOT FOUND: " & iniFile
                Wscript.Quit(0)
            End If
       End If

       If err then
               writeErrLog "SetScriptINIContent: ERROR: " & iniFile  & " : " & Hex(err.number) & " " & err.description
       else
               writeLog "SetScriptINIContent: OK: " & iniFile
       End If
End Sub

Private Function GetConfigINIString(Section, KeyName, Default)
  Dim PosSection, PosEndSection, sContents, Value, Found
  PosSection = InStr(1, ConfigINIContents, "[" & Section & "]", vbTextCompare)
  If PosSection>0 Then
    PosEndSection = InStr(PosSection, ConfigINIContents, vbCrLf & "[")
    If PosEndSection = 0 Then PosEndSection = Len(ConfigINIContents)+1
    sContents = Mid(ConfigINIContents, PosSection, PosEndSection - PosSection)
    If InStr(1, sContents, vbCrLf & KeyName & "=", vbTextCompare)>0 Then
        Found = True
        Value = SeparateField(sContents, vbCrLf & KeyName & "=", vbCrLf)
    End If
  End If
  If isempty(Found) Then Value = ExpandLocalVar(Default)
  GetConfigINIString = ExpandLocalVar(Value)
  writeDebugLog "GetConfigINIString: Section:" & section & " KeyName:" & KeyName & " Value:" & Left(GetConfigINIString, 100)
End Function

Private Function GetConfigINIStringPwd(Section, KeyName, Default)
  Dim PosSection, PosEndSection, sContents, Value, Found
  PosSection = InStr(1, ConfigINIContents, "[" & Section & "]", vbTextCompare)
  If PosSection>0 Then
    PosEndSection = InStr(PosSection, ConfigINIContents, vbCrLf & "[")
    If PosEndSection = 0 Then PosEndSection = Len(ConfigINIContents)+1
    sContents = Mid(ConfigINIContents, PosSection, PosEndSection - PosSection)
    If InStr(1, sContents, vbCrLf & KeyName & "=", vbTextCompare)>0 Then
        Found = True
        Value = SeparateField(sContents, vbCrLf & KeyName & "=", vbCrLf)
    End If
  End If
  If isempty(Found) Then Value = ExpandLocalVar(Default)
  GetConfigINIStringPwd = ExpandLocalVar(Value)
  writeDebugLog "GetConfigINIString: Section:" & section & " KeyName:" & KeyName & " Value:*********"
End Function

Private Function GetConfigINIStringNoExpandVar(Section, KeyName, Default)
  Dim PosSection, PosEndSection, sContents, Value, Found
  PosSection = InStr(1, ConfigINIContents, "[" & Section & "]", vbTextCompare)
  If PosSection>0 Then
    PosEndSection = InStr(PosSection, ConfigINIContents, vbCrLf & "[")
    If PosEndSection = 0 Then PosEndSection = Len(ConfigINIContents)+1
    sContents = Mid(ConfigINIContents, PosSection, PosEndSection - PosSection)
    If InStr(1, sContents, vbCrLf & KeyName & "=", vbTextCompare)>0 Then
        Found = True
        Value = SeparateField(sContents, vbCrLf & KeyName & "=", vbCrLf)
    End If
  End If
  If isempty(Found) Then Value = Default
  GetConfigINIStringNoExpandVar = Value
  writeDebugLog "GetConfigINIStringNoExpandVar: Section:" & section & " KeyName:" & KeyName & " Value:" & GetConfigINIStringNoExpandVar
End Function
''''''''''''''''''''''
Private Sub SetScriptParameters()
        on error resume next
        err.clear
        SetScriptINIContent CurrentConfigINIPath
        Config_DebugLog = INIBool(GetConfigINIString("CONFIGURATION", "Debug", "1"))
        Config_NameID = GetConfigINIString("CONFIGURATION", "NameID", "ERROR")
        Config_Description = GetConfigINIString("CONFIGURATION", "Description", "ERROR")
        Config_DisconnectAllDrives = INIBool(GetConfigINIString("CONFIGURATION", "DisconnectAllDrives", "0"))
        Config_DisconnectAllPrinters = INIBool(GetConfigINIString("CONFIGURATION", "DisconnectAllPrinters", "0"))
        Config_Eventlog = INIBool(GetConfigINIString("CONFIGURATION", "Eventlog", "0"))
        Config_KeepAndRestoreDefaultPrinter = INIBool(GetConfigINIString("CONFIGURATION", "KeepAndRestoreDefaultPrinter", "0"))
        Config_Logging = INIBool(GetConfigINIString("CONFIGURATION", "Logging", "1"))
        Config_LogPath = GetConfigINIString("CONFIGURATION", "LogPath", "%USERPROFILE%\Globalscript.log")
        Config_RemoveDesktopShortcuts = INIBool(GetConfigINIString("CONFIGURATION", "RemoveDesktopShortcuts", "0"))
        Config_RemoveProgramShortcuts = INIBool(GetConfigINIString("CONFIGURATION", "RemoveProgramShortcuts", "0"))
        Config_RemoveQuickLaunchShortcuts = INIBool(GetConfigINIString("CONFIGURATION", "RemoveQuickLaunchShortcuts", "0"))
        Config_Procedures = split(GetConfigINIString("CONFIGURATION", "Procedures", "ERROR"),",")
        If Config_Logging Then Set FileLog = ObjFSO.OpenTextFile(ExpandLocalVar(Config_LogPath),2,True)
        if err Then
                WriteErrLog "SetScriptParameters " & Hex(err.number) & " " & err.description
        Else
                WriteLog "SetScriptParameters:" & Config_NameID & " " & Config_Description & " OK"
        End If
End Sub

Private Sub ApplyStartParameters()
        on error resume next:err.clear
        If Config_KeepAndRestoreDefaultPrinter Then KeepDefaultPrinter()
        If Config_DisconnectAllDrives Then DisconnectAllDrives()
        If Config_DisconnectAllPrinters Then DisconnectAllPrinters()
        If Config_RemoveDesktopShortcuts Then RemoveDesktopShortcuts()
        If Config_RemoveProgramShortcuts Then RemoveProgramShortcuts()
        If Config_RemoveQuickLaunchShortcuts Then RemoveQuickLaunchShortcuts()
        if err Then
                WriteErrLog "ApplyStartParameters " & Hex(err.number) & " " & err.description
        Else
                WriteLog "ApplyStartParameters  OK"
        End If
End Sub

Private Sub ApplyEndParameters()
        on error resume next:err.clear

        If Config_KeepAndRestoreDefaultPrinter Then RestoreDefaultPrinter()

        if err Then
                WriteErrLog "ApplyEndParameters " & Hex(err.number) & " " & err.description
        Else
                WriteLog "ApplyEndParameters  OK"
        End If
End Sub
Private Sub TestAndExecuteScript()
        on error resume next:err.clear
        If IsArray(Config_Procedures) Then
                For each ProcedurenameID in Config_Procedures
                        TestProcedure ProcedureNameID
                Next
        Else
                WriteErrLog "TestAndExecuteScript: Config_Procedures is not an Array"
        End If
        if err Then
                WriteErrLog "TestAndExecuteScript " & Hex(err.number) & " " & err.description
        Else
                WriteLog "TestAndExecuteScript  OK"
        End If
End Sub

Private Sub TestProcedure(ProcedureNameID)
        on error resume next:err.clear
        if UserIsInThesesConditions(split(GetConfigINIString(ProcedureNameID, "Conditions", "ERROR"),",")) Then
              WriteLog "TestProcedure:" & ProcedureNameID & " ALL CONDITIONS ARE TRUE"
              TestUserInThesesSequencesAndExecuteActions split(GetConfigINIString(ProcedureNameID, "Sequences", "ERROR"),",")
        Else
              WriteLog "TestProcedure:" & ProcedureNameID & " LAST CONDITION IS FALSE"
        End If
        if err Then
                WriteErrLog "TestProcedure " & Hex(err.number) & " " & err.description
        End If
End Sub

Private Function UserIsInThesesConditions(ArrayStrConditionNameID)
        on error resume next:err.clear
        UserIsInThesesConditions = True
        if isArray(ArrayStrConditionNameID) then
                For each ConditionNameID in ArrayStrConditionNameID
                        if Not TestInCondition(ConditionNameID) Then
                               UserIsInThesesConditions = False
                               Exit For
                        End If
                Next
        Else
                UserIsInThesesConditions = False
                WriteErrLog "UserIsInThesesConditions: Not An Array"
        End If
        if err Then
                WriteErrLog "UserIsInThesesConditions " & Hex(err.number) & " " & err.description
        End If
End Function
Private Function TestInCondition(ConditionNameID) 'as boolean
        on error resume next
        err.clear
        Select case GetConfigINIString(ConditionNameID, "Type", "0")
                case "30"       '    ConditionADSite = 30
                      TestInCondition = Test_ConditionADSite(ConditionNameID)
                case "32"       '    ConditionComputername = 32
                      TestInCondition = Test_ConditionComputerName(ConditionNameID)
                case "33"       '    ConditionDays = 33
                      TestInCondition = Test_ConditionDays(ConditionNameID)
                case "34"       '    ConditionEnvironment = 34
                      TestInCondition = Test_ConditionEnvironment(ConditionNameID)
                case "35"       '    ConditionMemberOf = 35
                      TestInCondition = Test_ConditionMemberOf(ConditionNameID)
                case "36"       '    ConditionNetwork = 36
                      TestInCondition = Test_ConditionNetwork(ConditionNameID)
                case "37"       '    ConditionRegistry = 37
                      TestInCondition = Test_ConditionRegistry(ConditionNameID)
                case "38"       '    ConditionTrue = 38
                      TestInCondition = Test_ConditionTrue(ConditionNameID)
                case "39"       '    ConditionTrue = 38
                      TestInCondition = Test_ConditionQueryWMI(ConditionNameID)
                case Else
                      TestInCondition = False
                      WriteErrLog "TestInCondition:" & ConditionNameID & " ConditionType ERROR"
        End Select
        if err Then
                WriteErrLog "TestInCondition:" & ConditionNameID & " "  & Hex(err.number) & " " & err.description
        End If
End Function

Private Function TestUserInThesesSequencesAndExecuteActions(ArrayStrSequenceNameID)  'as boolean
        on error resume next
        err.clear
        if isArray(ArrayStrSequenceNameID) then
                For each SequenceNameID in ArrayStrSequenceNameID
                      if TestInSequence(SequenceNameID) Then
                            ExecuteActionsSequence split(GetConfigINIString(SequenceNameID, "Actions", ""),",")
                      End If
                Next
        Else
               WriteErrLog "TestUserInThesesSequencesAndExecuteActions: Not An Array"
        End If
        if err Then
                WriteErrLog "TestUserInThesesSequencesAndExecuteActions " & Hex(err.number) & " " & err.description
        End If
End Function

Private Function TestInSequence(SequenceNameID)  'as boolean
        on error resume next
        err.clear
        Select case GetConfigINIString(SequenceNameID, "Type", "0")
                case "100"      '    SequenceTrue = 100
                        TestInSequence = Test_SequenceTrue(SequenceNameID)
                case "101"      '    SequenceMemberOf = 101
                        TestInSequence = Test_SequenceMemberOf(SequenceNameID)
                case else
                        TestInSequence = False
                        WriteErrLog "TestInSequence " & SequenceNameID & " SequenceType ERROR"
        End Select
        if err Then
                WriteErrLog "TestInSequence " & Hex(err.number) & " " & err.description
        End If
End Function

Private Sub ExecuteActionsSequence(ArrayStrActionNameID)
        on error resume next:err.clear
        if isArray(ArrayStrActionNameID) then
                For each ActionNameID in ArrayStrActionNameID
                       ExecuteAction ActionNameID
                Next
        Else
                WriteErrLog "ExecuteActionsSequence Not An Array"
        End If
        if err Then
                WriteErrLog "ExecuteActionsSequence " & Hex(err.number) & " " & err.description
        End If
End Sub

Private Sub ExecuteAction(ActionNameID)
        on error resume next:err.clear
        Select case GetConfigINIString(ActionNameID, "Type", "0")
                case "1000":     '    ActionCopy = 1000
                        select case UCASE(GetConfigINIString(ActionNameID, "Cmd", ""))
                                case "MOV":
                                        Action_Copy GetConfigINIString(ActionNameID, "Source", "ERROR"),_
                                                GetConfigINIString(ActionNameID, "Destination", "ERROR"),_
                                                INIBool(GetConfigINIString(ActionNameID, "Overwrite", "0")),_
                                                True
                                case "COP":
                                        Action_Copy GetConfigINIString(ActionNameID, "Source", "ERROR"),_
                                                GetConfigINIString(ActionNameID, "Destination", "ERROR"),_
                                                INIBool(GetConfigINIString(ActionNameID, "Overwrite", "0")),_
                                                False
                                case "DEL":
                                        Action_Delete GetConfigINIString(ActionNameID, "Source", "ERROR")
                                case "MKD":
                                        Action_MakeDir GetConfigINIString(ActionNameID, "Source", "ERROR")
                                case else
                        End Select
                case "1001":     '    ActionEnvironment = 1001
                        Action_CreateEnvironmentVariable GetConfigINIString(ActionNameID, "Variable", "ERROR"),_
                                GetConfigINIString(ActionNameID, "Value", "ERROR"),_
                                GetConfigINIString(ActionNameID, "TypeVariable", "ERROR")
                case "1002":     '    ActionINI = 1002
                        Action_WriteInINIFile GetConfigINIString(ActionNameID, "INIPath", "ERROR"),_
                        GetConfigINIString(ActionNameID, "Section", "ERROR"),_
                        GetConfigINIString(ActionNameID, "Variable", "ERROR"),_
                        GetConfigINIString(ActionNameID, "Value", "ERROR")
                case "1003":     '    ActionMail = 1003
                        Action_SendMail GetConfigINIString(ActionNameID, "From", "ERROR"),_
                        GetConfigINIString(ActionNameID, "To", "ERROR"),_
                        GetConfigINIString(ActionNameID, "Subject", "ERROR"),_
                        GetConfigINIString(ActionNameID, "Body", "ERROR"),_
                        GetConfigINIString(ActionNameID, "Attachments", "ERROR"),_
                        GetConfigINIString(ActionNameID, "SmtpServer", "ERROR"),_
                        GetConfigINIString(ActionNameID, "PortServer", "ERROR")
                case "1004":     '    ActionNetDrive = 1004
                        Action_ConnectNetworkDrive INIBool(GetConfigINIString(ActionNameID, "Connect", "1")),_
                        GetConfigINIString(ActionNameID, "Letter", "ERROR"),_
                        GetConfigINIString(ActionNameID, "UNCPath", "ERROR"),_
                        INIBool(GetConfigINIString(ActionNameID, "Force", "0")),_
                        INIBool(GetConfigINIString(ActionNameID, "Persistent", "0")),_
                        GetConfigINIString(ActionNameID, "Username", ""),_
                        GetConfigINIString(ActionNameID, "Password", "")
                case "1005":     '    ActionPopup = 1005
                        Action_ShowPopup GetConfigINIString(ActionNameID, "Text", "ERROR"),_
                        GetConfigINIString(ActionNameID, "Title", "ERROR"),_
                        GetConfigINIString(ActionNameID, "PopupType", "ERROR"),_
                        GetConfigINIString(ActionNameID, "SecToWait", "10")
                case "1006":     '    ActionPrinter = 1006
                        Action_ConnectNetworkPrinter GetConfigINIString(ActionNameID, "UNCPath", "ERROR"),_
                        INIBool(GetConfigINIString(ActionNameID, "DefaultPrinter", "ERROR")),_
                        INIBool(GetConfigINIString(ActionNameID, "Remove", "ERROR")),_
                        GetConfigINIString(ActionNameID, "Username", ""),_
                        GetConfigINIString(ActionNameID, "Password", "")
                case "1007":     '    ActionProcess = 1007
                        Action_ExecuteProcess GetConfigINIString(ActionNameID, "Path", "ERROR"),_
                        GetConfigINIString(ActionNameID, "Arguments", "ERROR"),_
                        GetConfigINIString(ActionNameID, "WorkingDirectory", "ERROR"),_
                        INIBool(GetConfigINIString(ActionNameID, "Hide", "0")),_
                        INIBool(GetConfigINIString(ActionNameID, "Wait", "1")),_
                        GetConfigINIString(ActionNameID, "Username", Empty),_
                        GetConfigINIStringPwd(ActionNameID, "Password", Empty)
                case "1008":     '    ActionRegistry = 1008
                        Action_RegistryKey GetConfigINIString(ActionNameID, "Key", "ERROR"),_
                        GetConfigINIString(ActionNameID, "Value", "(default)"),_
                        GetConfigINIString(ActionNameID, "DataValue", ""),_
                        GetConfigINIString(ActionNameID, "RegType", "ERROR"),_
                        GetConfigINIString(ActionNameID, "Cmd", "")
                case "1009":     '    ActionShortcut = 1009
                        Action_CreateShortCut GetConfigINIString(ActionNameID, "ShortcutName", "ERROR"),_
                        GetConfigINIString(ActionNameID, "TargetPath", "ERROR"),_
                        GetConfigINIString(ActionNameID, "Arguments", ""),_
                        GetConfigINIString(ActionNameID, "Description", ""),_
                        GetConfigINIString(ActionNameID, "Hotkey", ""),_
                        GetConfigINIString(ActionNameID, "IconLocation", ""),_
                        GetConfigINIString(ActionNameID, "WindowStyle", vbNormal),_
                        GetConfigINIString(ActionNameID, "WorkingDirectory", ""),_
                        INIBool(GetConfigINIString(ActionNameID, "OnDesktop", "0")),_
                        INIBool(GetConfigINIString(ActionNameID, "OnProgram", "0")),_
                        GetConfigINIString(ActionNameID, "ProgramSubFolder", ""),_
                        INIBool(GetConfigINIString(ActionNameID, "OnQuickLaunch", "0")),_
                        INIBool(GetConfigINIString(ActionNameID, "OnOtherPath", "0")),_
                        GetConfigINIString(ActionNameID, "OtherPath", ""),_
                        INIBool(GetConfigINIString(ActionNameID, "Remove", "0"))
                case "1010":     '    ActionSleep = 1010
                        Action_Sleep GetConfigINIString(ActionNameID, "Sleep", "1")
                case "1011":     '    ActionSubst = 1011
                        Action_CreateVirtualDrive GetConfigINIString(ActionNameID, "Letter", "ERROR"),_
                        GetConfigINIString(ActionNameID, "Path", "ERROR"),_
                        INIBool(GetConfigINIString(ActionNameID, "Remove", "0"))
                case "1012":      '   ActionScript = 1012
                        Action_LaunchIncludeScript GetConfigINIString(ActionNameID, "EngineAndLang", "ERROR"),_
                        GetConfigINIString(ActionNameID, "ScriptEngineArgs", ""),_
                        GetConfigINIString(ActionNameID, "Arguments", ""),_
                        INIBool(GetConfigINIString(ActionNameID, "Hide", "0")),_
                        INIBool(GetConfigINIString(ActionNameID, "Wait", "0")),_
                        GetConfigINIString(ActionNameID, "WorkingDirectory", ""),_
                        GetConfigINIString(ActionNameID, "Username", ""),_
                        GetConfigINIStringPwd(ActionNameID, "Password", ""),_
                        GetConfigINIString(ActionNameID, "Separator", ""),_
                        GetConfigINIString(ActionNameID, "ScriptText", "")
                case Else
                        'err
                        WriteErrLog "ExecuteAction:" & ActionNameID & " ActionType ERROR"
        End Select
        if err Then
                WriteErrLog "ExecuteAction :" & ActionNameID & " " & Hex(err.number) & " " & err.description
        End If
End Sub

Private Sub DisconnectAllDrives()
        on error resume next:err.clear
        WriteDebugLog "DisconnectAllDrives:START"
        Set Col = CurrentUserDrivesConnections
        Arr = Col.Keys
        if Not isEmpty(Col) Then
                For i = 0 To Col.count - 1
                    Letter = Arr(i)
                    objNetwork.RemoveNetworkDrive Letter , true , true
                    if Err Then
                          WriteErrLog "DisconnectAllDrives: Letter:" & Letter & " " & Hex(err.number) & " " & err.description
                          'err.clear
                    Else
                          WriteLog "DisconnectAllDrives: Letter:" & Letter & " Ok"
                    End If
                Next
        Else
               WriteDebugLog "DisconnectAllDrives: Empty"
        End If
        'Patch Disconnected Drives
        objShell.regDelete "HKEY_CURRENT_USER\Network\"
        objShell.regWrite "HKEY_CURRENT_USER\Network\"  , "" , "REG_SZ"
        If Err Then
                WriteErrLog "DisconnectAllDrives:" & Hex(err.number) & " " & err.description
        End If
        WriteDebugLog "DisconnectAllDrives:END"
End Sub

Private Sub DisconnectAllPrinters()
       on error resume next:err.clear
       WriteDebugLog "DisconnectAllPrinters:START"
       Set Col = CurrentUserPrintersConnections
       Arr = Col.Keys
       if Not isEmpty(Col) Then
               For i = 0 To Col.count - 1
                    Printer = Arr(i)
                    ObjNetwork.RemovePrinterConnection Printer
                    if Err Then
                          WriteErrLog "DisconnectAllPrinters: Printer:" & Printer & " " & Hex(err.number) & " " & err.description
                          'err.clear
                    Else
                          WriteLog "DisconnectAllPrinters: Printer:" & Printer & " Ok"
                    End If
               Next
       Else
               WriteDebugLog "DisconnectAllPrinters: Empty"
       End If
       If Err Then
                WriteErrLog "DisconnectAllPrinters:" & Hex(err.number) & " " & err.description
       End If
       WriteDebugLog "DisconnectAllPrinters:END"
End Sub

Private Sub KeepDefaultPrinter()
        on error resume next:err.clear
        Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
        Set colPrinters = objWMIService.ExecQuery("Select * From Win32_Printer Where Default = TRUE","WQL",48)
        For Each objPrinter in colPrinters
                privCurrentDefaultPrinter = objPrinter.DeviceID
        Next
        If Err Then
                WriteErrLog "KeepDefaultPrinter: " & Hex(err.number) & " " & err.description
        Else
                WriteLog "KeepDefaultPrinter: " & privCurrentDefaultPrinter
        End If
End Sub

Private Sub RestoreDefaultPrinter()
        on error resume next:err.clear
        If Not isEmpty(privCurrentDefaultPrinter) Then
		If RegExpTest("^\\\\[\w\.-_\\\$]*$",privCurrentDefaultPrinter) Then
			ObjNetwork.AddWindowsPrinterConnection privCurrentDefaultPrinter
			If Err Then
        	        	WriteErrLog "RestoreDefaultPrinter: ConnectDefaultPrinter: " & privCurrentDefaultPrinter & " " & Hex(err.number) & " " & err.description
				Err.clear
                	Else
                      		WriteLog "RestoreDefaultPrinter: ConnectDefaultPrinter: " & privCurrentDefaultPrinter
	        	End If
		End If
		ObjNetwork.SetDefaultPrinter privCurrentDefaultPrinter
		If Err Then
        	        WriteErrLog "RestoreDefaultPrinter: SetDefaultPrinter: " & privCurrentDefaultPrinter & " " & Hex(err.number) & " " & err.description
                Else
                      	WriteLog "RestoreDefaultPrinter: SetDefaultPrinter: " & privCurrentDefaultPrinter
	        End If
        Else
                WriteLog "RestoreDefaultPrinter: No Default Printer to restore"
        End If
End Sub

Private Sub RemoveDesktopShortcuts()
        on error resume next:err.clear
        Path = CurrentDesktopPath & "\*.lnk"
        objFSO.DeleteFile Path, True
        if Err ANd Err.Number <> 53 Then
                WriteErrLog "RemoveDesktopShortcuts: " & Hex(err.number) & " " & err.description & " Path:" & Path
        Else
                WriteLog "RemoveDesktopShortcuts:" & Path
        End If
End Sub

Private Sub RemoveProgramShortcuts()
        on error resume next:err.clear
        Path = CurrentProgramsPath & "\*.lnk"
        objFSO.DeleteFile Path, True
        if Err ANd Err.Number <> 53 Then
                WriteErrLog "RemoveProgramShortcuts: " & Hex(err.number) & " " & err.description & " Path:" & Path
        Else
                WriteLog "RemoveProgramShortcuts:" & Path
        End If
End Sub

Private Sub RemoveQuickLaunchShortcuts()
        on error resume next:err.clear
        Path = CurrentQuickLaunchPath & "\*.lnk"
        objFSO.DeleteFile Path, True
        if Err ANd Err.Number <> 53 Then
                WriteErrLog "RemoveQuickLaunchShortcuts: " & Hex(err.number) & " " & err.description & " Path:" & Path
        Else
                WriteLog "RemoveQuickLaunchShortcuts:" & Path
        End If
End Sub

End Class