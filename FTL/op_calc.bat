@echo off

:: user input arguments
set /p capacity_GB=Capacity (GB) : 
set /p extendedLbn=EXTENDED_LBN_NUM (65536 or 1024) : 
set /p LUN=phyLUNNum (channelNum x bankNum x lunNumPerTarget) : 
set /p plane=blkNumPerLUNForOneDBS (2) : 
set /p page=pageNumPerBlk : 
set /p SLCBS=SLC BS Num : 
set /p TLCBS=TLC BS Num : 
set /a "Frame=4"

:: reference from sbl code (blkNumInfo.opPercentage)
set /a "TLCFrame=%LUN%*%TLCBS%*%plane%*%page%*%Frame%"
set /a "SLCFrame=%LUN%*%SLCBS%*%plane%*(%page%/3)*%Frame%"
set /a "supportLbn=%TLCFrame%+%SLCFrame%"
set /a "totalLbn=2646+(244188*%capacity_GB%)+%extendedLbn%"
set /a "op=(%supportLbn%-%totalLbn%)/((%totalLbn%+99)/100)"

echo ===================================================
echo op : %op%%%

pause
