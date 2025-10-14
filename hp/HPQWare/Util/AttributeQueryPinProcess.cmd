@Echo off

set CEPS_PinProcess="CEPS_UtilityFail"
set Is_Consumer_pin_process=

for /f "delims=" %%i in ('call %~dp0WMIQuery.exe "root\HP\InstrumentedBIOS" "SELECT * FROM HP_BIOSSetting WHERE name=\"PIN Process cycle\"" "value"') do (
    for /f "tokens=1,2 delims==" %%a in ("%%~i") do (
        set "Is_Consumer_pin_process=1" 
    )
)

if /i "%Is_Consumer_pin_process%" == "1" (set "CEPS_PinProcess=0") else (set "CEPS_PinProcess=1")
if /i "%CEPS_PinProcess%" == "0" (ECHO It is consumer pin process:%CEPS_PinProcess%) else (ECHO It is commercial pin process:%CEPS_PinProcess%)