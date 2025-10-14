@ECHO off

set CEPS_RStoneBrandName=CEPS_UtilityFail

if exist "c:\hp\bin\RStone.ini" (
    for /f "tokens=1,2 usebackq delims='='" %%a in (c:\hp\bin\RStone.ini) do (
        If "%%a" == "BrandName" ( Set "CEPS_RStoneBrandName=%%b" )
    )
) else ECHO [%DATE%] [%TIME%] RStone.ini does not exists &set "CEPS_RStoneBrandName=NA"

ECHO [%DATE%] [%TIME%] Brand Name is "%CEPS_RStoneBrandName%"