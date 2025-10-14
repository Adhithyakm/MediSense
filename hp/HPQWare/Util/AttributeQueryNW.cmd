@echo off

set CEPS_IsNW=CEPS_UtilityFail
set CEPS_MainOSVersion=22000
set CEPS_SubOSVersion=1
set CEPS_IsUseMainVersion=1

for /F "TOKENS=1,2* DELIMS= " %%i in ('Reg query "HKLM\software\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild') do (
	if /I [%%i]==[CurrentBuild] ( set "CEPS_OSBuildVersion=%%k" )
)
ECHO [%DATE%] [%TIME%] OS Build Version is "%CEPS_OSBuildVersion%"

IF /I "%CEPS_IsUseMainVersion%"=="1" goto MAIN
IF /I "%CEPS_IsUseMainVersion%"=="0" goto MAINANDSUB

:MAIN
if %CEPS_OSBuildVersion% geq %CEPS_MainOSVersion% ( Set "CEPS_IsNW=1" ) else ( Set "CEPS_IsNW=0" )
goto END

:MAINANDSUB
for /f "tokens=1,2 delims=." %%a in ("%CEPS_OSBuildVersion%") do (set deviceMainVersion=%%~a&set deviceSubVersion=%%~b)
ECHO [%DATE%] [%TIME%] OS Build Main Version is "%deviceMainVersion%"

if %deviceMainVersion% geq %CEPS_MainOSVersion% set "CEPS_IsNW=1"
goto END

if %deviceMainVersion% lss %CEPS_MainOSVersion% (
	if %deviceSubVersion% geq %CEPS_SubOSVersion% ( Set "CEPS_IsNW=1" ) else ( Set "CEPS_IsNW=0" )
	)
ECHO [%DATE%] [%TIME%] OS Build Sub Version is "%deviceSubVersion%"

:END
IF /I "%CEPS_IsNW%"=="1" ECHO [%DATE%] [%TIME%] It is New Windows ("%CEPS_IsNW%")
IF /I "%CEPS_IsNW%"=="0" ECHO [%DATE%] [%TIME%] It is Windows10 ("%CEPS_IsNW%")
