@echo off
REM Set you log name and path here.
Set Logpath=C:\system.sav\Logs\xxxxxxxxx_driver_install.log
if not exist C:\system.sav\Logs md C:\system.sav\Logs
REM  Detect OS version
set os_ver=
for /f "tokens=1,2 delims== " %%i in ('wmic os get version /value') do (if /i %%~i == version set "os_ver=%%~j")
if not defined os_ver echo [%date%][%time%][%~dpnx0] Could not get OS version >> %Logpath% & goto fail
ECHO [%date%][%time%][%~dpnx0] Detected OS version : [%os_ver%] >> %Logpath%

REM ================== Check if OS is 21H2 (10.0.22000) ==================
ECHO [%date%][%time%][%~dpnx0] Check if OS version has met requirement >> %Logpath%
IF /I [%os_ver%] GEQ [10.0.22000] echo [%date%][%time%][%~dpnx0] OS version match. >> %Logpath% & goto Install_DRV

echo [%date%][%time%][%~dpnx0] OS version missmatch. >> %Logpath%
goto unsupport_OS

:Install_DRV
CALL "installdrv.cmd"
goto END 

:fail
goto END

:unsupport_OS
mshta.exe vbscript:Execute("msgbox ""The driver is not supported on this OS version (%os_ver%)."",48,""Warning"":close")
:END

