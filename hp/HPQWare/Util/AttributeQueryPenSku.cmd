@echo off

set CEPS_IsPenSku=CEPS_UtilityFail
set CEPS_IsPenSkuBT=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
	for /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
		If "%%a" == "Pen" (
        	Set Pen=%%b
    	)
    	If "%%a" == "PEN_BT" (
        	Set PEN_BT=%%b
    	)
	)
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists

IF /I "%Pen%"=="1" ( Set "CEPS_IsPenSku=1" ) else Set "CEPS_IsPenSku=0"
IF /I "%PEN_BT%"=="1" ( Set "CEPS_IsPenSkuBT=1" ) else Set "CEPS_IsPenSkuBT=0"

ECHO [%DATE%] [%TIME%] Support PEN without BT is "%CEPS_IsPenSku%"
ECHO [%DATE%] [%TIME%] Support PEN with BT is "%CEPS_IsPenSkuBT%"