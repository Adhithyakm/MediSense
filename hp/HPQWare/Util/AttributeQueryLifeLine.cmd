@echo off

set CEPS_IsLifeLine=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
	for /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
		If "%%a" == "LifeL" (
        	Set LifeL=%%b
    	)
	)
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists

IF /I "%LifeL%"=="1" ( Set "CEPS_IsLifeLine=1" ) else Set "CEPS_IsLifeLine=0"

ECHO [%DATE%] [%TIME%] LifeLine exists: "%CEPS_IsLifeLine%"
