@echo off
if not "%1" == "max" start /MAX cmd /c %0 max & exit/b

CHCP 65001

SET TodayYear=%date:~0,4%
SET TodayMonth=%date:~5,2%
SET TodayDay=%date:~8,2%

SET ServerPath=https://data.nhi.gov.tw/resource/mask/maskdata.csv
SET MaskPath=%TEMP%\%TodayYear%%TodayMonth%%TodayDay%_Mask.csv
SET Keyword="臺北"
SET Min=10000

curl %ServerPath% -o %MaskPath%

if exist %MaskPath% (
	for /f %%I in ('find %Keyword% %MaskPath%') do (
		for /f "usebackq tokens=1-7 delims=," %%a in ('%%I') do (
			:: if %%a == 5901023153 (
			if %%e GTR %Min% (
				echo [%%e]	%%a %%d %%b		%%c
			)
		)
	)
)

pause
