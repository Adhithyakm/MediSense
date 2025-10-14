@echo off

set CEPS_OSBuildVersion=CEPS_UtilityFail

for /F "TOKENS=1,2* DELIMS= " %%i in ('Reg query "HKLM\software\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild') do (
	if /I [%%i]==[CurrentBuild] ( set "CEPS_OSBuildVersion=%%k" )
)

ECHO [%DATE%] [%TIME%] OS Build Version is "%CEPS_OSBuildVersion%"