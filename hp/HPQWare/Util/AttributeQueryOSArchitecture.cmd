@echo off

set CEPS_OSArch=CEPS_UtilityFail

if exist "%~dp0QueryWMI.vbs" (
	for /F "usebackq tokens=*" %%r in (`CSCRIPT "%~dp0QueryWMI.vbs"`) do (set "CEPS_OSArch=%%r")
) else ECHO [%DATE%] [%TIME%] QueryWMI.vbs does not exists

ECHO [%DATE%] [%TIME%] CPU and OS Architecture is "%CEPS_OSArch%"