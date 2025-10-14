@ECHO off

set CEPS_BuildCycle=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
    for /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
        If "%%a" == "BuildCycle" (Set "CEPS_BuildCycle=%%b")
    )
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists

ECHO [%DATE%] [%TIME%] Build Cycle is "%CEPS_BuildCycle%"