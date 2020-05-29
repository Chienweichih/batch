::::::::::::::::::::::::::::::::::::::::::::
:: Elevate.cmd - Version 4
:: Automatically check & get admin rights
:: see "https://stackoverflow.com/a/12264592/1016343" for description
::::::::::::::::::::::::::::::::::::::::::::
 @echo off
 CLS
 ECHO.
 ECHO =============================
 ECHO Running Admin shell
 ECHO =============================

:init
 setlocal DisableDelayedExpansion
 set cmdInvoke=1
 set winSysFolder=System32
 set "batchPath=%~0"
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 setlocal EnableDelayedExpansion

:checkPrivileges
  NET FILE 1>NUL 2>NUL
  if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
  if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
  ECHO.
  ECHO **************************************
  ECHO Invoking UAC for Privilege Escalation
  ECHO **************************************

  ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  ECHO args = "ELEV " >> "%vbsGetPrivileges%"
  ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
  ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
  ECHO Next >> "%vbsGetPrivileges%"

  if '%cmdInvoke%'=='1' goto InvokeCmd 

  ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
  goto ExecElevation

:InvokeCmd
  ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
  ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
 "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
 exit /B

:gotPrivileges
 setlocal & cd /d %~dp0
 if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

 ::::::::::::::::::::::::::::
 ::START
 ::::::::::::::::::::::::::::
 REM Run shell as admin (example) - put here code as you like
 
 :::::::::::::
 ::1. DiskPart
 :::::::::::::
 C:
 cd %TEMP%
 SET DiskpartFile=diskpart.txt

 :: show list disk
 echo > %DiskpartFile% list disk
 diskpart /s %DiskpartFile%

 :: user input arguments
 set /p Disk=select disk : 

 :: set diskpart script
 echo > %DiskpartFile% select disk %Disk%
 echo >> %DiskpartFile% create partition primary align=1024
 echo >> %DiskpartFile% format fs=ntfs quick
 echo >> %DiskpartFile% assign letter="T"

 :: do partition
 diskpart /s %DiskpartFile%

 :::::::::::::
 ::2. Startup
 :::::::::::::
 C:
 cd "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
 SET FileB=b.bat
 echo > %FileB% cd "C:\Program Files\BurnInTest"
 echo >> %FileB% bit.exe -r

 :::::::::::::
 ::3. IP cfg
 :::::::::::::
 netsh interface ipv4 show config

 ECHO "interface Name:"
 set /p IF_Name=

 ECHO "Static IP Address:"
 set /p IP_Addr=

 ECHO "Setting Static IP Information"
 netsh interface ip set address name="%IF_Name%" source=static address=%IP_Addr% gwmetric=1

 :::::::::::::
 ::4. Recovery
 :::::::::::::
 bcdedit /set {default} recoveryenabled No
 bcdedit /set {default} bootstatuspolicy IgnoreAllFailures

 cmd /k
