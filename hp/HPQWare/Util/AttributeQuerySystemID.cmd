@echo off

set CEPS_SystemID=CEPS_UtilityFail

for /f "delims=" %%i in ('call %~dp0WMIQuery.exe "root\CIMV2" "SELECT * FROM Win32_BaseBoard" "Product"') do (
    for /f "tokens=1,2 delims==" %%a in ("%%~i") do (
         if /i "%%~a" == "Product" (set "CEPS_SystemID=%%~b") else (set "CEPS_SystemID=")
    )
)

ECHO [%DATE%] [%TIME%] System ID is "%CEPS_SystemID%"