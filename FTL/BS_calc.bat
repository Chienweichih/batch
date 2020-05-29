@echo off

set /p Capacity=Capacity in Gbytes : 
set /p LUN=LUN :
set /p pl=Plane :
set /p TLC_pg=TLC Page:

set /a "LBACounts=2646+(244188*%Capacity%)"

set /a "data_k=%LBACounts%*4"
set /a "cls_k=%LBACounts%*4/1024"
set /a "dir_k=%LBACounts%*4/1024/1024"

set /a "TLC_BS_k=%LUN%*%pl%*%TLC_pg%*16"
set /a "SLC_BS_k=%TLC_BS_k%/3"

set /a "data_BS=(%data_k%+%TLC_BS_k%-1)/%TLC_BS_k%"
set /a "cls_BS=(%cls_k%+%SLC_BS_k%-1)/%SLC_BS_k%"
set /a "dir_BS=(%dir_k%+%SLC_BS_k%-1)/%SLC_BS_k%"

echo ==========================
echo Data need %data_BS% TLC BS
echo CLS need %cls_BS% SLC BS
echo DIR need %dir_BS% SLC BS

pause

