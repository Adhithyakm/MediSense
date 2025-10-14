@ECHO off

set CEPS_Hugo=CEPS_UtilityFail

REM get information from VARS for HUGO
if exist "c:\system.sav\util\vars.ini" (
    For /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
        If "%%a" == "SEG.CON" (
            Set SEG.CON=%%b
        )
        If "%%a" == "SL.BUD" (
            Set SL.BUD=%%b
        )
        If "%%a" == "PCBR.HP" (
            Set PCBR.HP=%%b
        )
    )
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists

IF /I "%SEG.CON%"=="1" (
    IF /I "%SL.BUD%"=="1" (
        IF /I "%PCBR.HP%"=="1" Set "CEPS_Hugo=1"
        ) else Set "CEPS_Hugo=0"
    )

ECHO [%DATE%] [%TIME%] HUGO is "%CEPS_Hugo%"