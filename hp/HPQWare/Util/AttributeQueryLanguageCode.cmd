@echo off

set CEPS_LanguageCode=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
    for /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
        if "%%a" == "languagecode" ( Set "CEPS_LanguageCode=%%b" )
        
    )
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists

ECHO [%DATE%] [%TIME%] Language Code is "%CEPS_LanguageCode%"