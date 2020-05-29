@echo off
setlocal enableDelayedExpansion

cd %TEMP%
SET DiskpartFile=diskpart.txt

:: show list disk
echo > %DiskpartFile% list disk
echo
diskpart /s %DiskpartFile%

:: user input arguments
set /p Disk=select disk : 
set /p Size=input size (GB) : 
set /a "Size=%Size%*1024"
set /p Part=input partition number : 
set /p StartChar=input start letter (D, E, F ...) : 
set /a "partSize=%Size%/%Part%"

:: set StartChar and StartChar
for /L %%a in (65,1,90) do (
  cmd /c exit %%a
  if "!=exitcodeAscii!" EQU "%StartChar%" set StartChar=%%a
)
set /a "EndChar=%StartChar%+%Part%-1"

:: set diskpart script
echo > %DiskpartFile% select disk %Disk%
echo >> %DiskpartFile% clean
echo >> %DiskpartFile% convert gpt

for /L %%a in (%StartChar%,1,%EndChar%) do (
  cmd /c exit %%a
  if %%a EQU %EndChar% echo >> %DiskpartFile% create partition primary align=1024
  if %%a NEQ %EndChar% echo >> %DiskpartFile% create partition primary align=1024 size=%partSize%
  echo >> %DiskpartFile% format fs=ntfs quick
  echo >> %DiskpartFile% assign letter="!=exitcodeAscii!"
)

:: confirm
set /p YorN=ARE YOU SURE? Disk %Disk%, Size %Size%, Part %Part% Do the partition? (y/N):
if "%YorN%" NEQ "y" goto :eof

:: do partition
diskpart /s %DiskpartFile%

pause

