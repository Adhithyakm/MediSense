@echo off

set CEPS_RegionCode=CEPS_UtilityFail

FOR /F "tokens=3*" %%G IN ('REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\HP\CommonInfo" /v regioncode') DO SET "CEPS_RegionCode=%%G"

ECHO [%DATE%] [%TIME%] Region Code is "%CEPS_RegionCode%"
