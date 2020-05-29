@echo off
set /p Capacity=Capacity in Gbytes : 
set /a "LBACounts=2646+(244188*%Capacity%)"
call cmd /c exit /b %LBACounts%
set LBACountsHex=%=exitcode%
echo User-addressable logical block count : 0x%LBACountsHex%
pause
