@echo off

set CEPS_CorporateDevice=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
	for /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
		If "%%a" == "R_ENTRDY" (
        	Set R_ENTRDY=%%b
    	)
	)
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists

IF /I "%R_ENTRDY%"=="1" ( Set "CEPS_CorporateDevice=1" ) else Set "CEPS_CorporateDevice=0"

ECHO [%DATE%] [%TIME%] Entreprise Ready Image or Corporate Ready image: "%CEPS_CorporateDevice%"
