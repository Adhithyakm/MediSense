@echo off

set CEPS_eServiceDisable=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
    for /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
        If "%%a" == "Noe-Ser" (
        	Set NoeSer=%%b
    	)
    )
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists

IF /I "%NoeSer%"=="1" ( Set "CEPS_eServiceDisable=1" ) else Set "CEPS_eServiceDisable=0"

ECHO [%DATE%] [%TIME%] eService disable is "%CEPS_eServiceDisable%"