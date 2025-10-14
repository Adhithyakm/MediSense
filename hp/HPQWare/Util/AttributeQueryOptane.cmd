@echo off

Set CEPS_OptaneDevice=CEPS_UtilityFail

for /f "delims=" %%i in ('call %~dp0WMIQuery.exe "root\HP\InstrumentedBIOS" "SELECT * FROM HPBIOS_BIOSString WHERE name='Optane'" "value"') do (
    for /f "tokens=1,2 delims==" %%a in ("%%~i") do (
        if /i "%%~b" == "Yes" ( set "CEPS_OptaneDevice=True"&goto END)
    )
)
set "CEPS_OptaneDevice="

:END
ECHO [%DATE%] [%TIME%] Optane Device is "%CEPS_OptaneDevice%"