@echo off

set CEPS_FullProductName=CEPS_UtilityFail
set CEPS_FullProductNameRstone=CEPS_UtilityFail

FOR /F "tokens=3*" %%G IN ('REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\HP\System Properties" /v productname') DO SET "CEPS_FullProductName=%%G %%H"

if exist "c:\hp\bin\RStone.ini" (
    for /f "tokens=1,2 usebackq delims='='" %%a in (c:\hp\bin\RStone.ini) do (
        If "%%a" == "FullProductName" ( Set "CEPS_FullProductNameRstone=%%b" )
    )
) else ECHO [%DATE%] [%TIME%] RStone.ini does not exists &set "CEPS_FullProductNameRstone=NA"

ECHO [%DATE%] [%TIME%] Full Product Name from registry key is "%CEPS_FullProductName%"
ECHO [%DATE%] [%TIME%] Full Product Name from Rstone is "%CEPS_FullProductNameRstone%"
