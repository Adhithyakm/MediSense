@ECHO off

set CEPS_ProdNumber=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
    for /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
        If "%%a" == "SKUNumber" ( Set "CEPS_ProdNumber=%%b" )
    )
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists

ECHO [%DATE%] [%TIME%] Product Number is "%CEPS_ProdNumber%"