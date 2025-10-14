@echo off

set CEPS_IsWin10S=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
	for /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
		If /I "%%a" == "S_Mode" (
        	Set S_Mode=%%b
    	)
	)
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists

IF /I "%S_Mode%"=="1" ( Set "CEPS_IsWin10S=1" ) else Set "CEPS_IsWin10S=0"

ECHO [%DATE%] [%TIME%] Windows 10S flag is "%CEPS_IsWin10S%"