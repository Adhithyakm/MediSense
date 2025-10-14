@echo off


set /a MyVerDotNet_x64=%CEPS_VerDotNet_x64:.=%
set /a MyVerDotNet_x86=%CEPS_VerDotNet_x86:.=%
set /a MyVerDotNet_arm64=%CEPS_VerDotNet_arm64:.=%
set /a MyVerDotNet_arm=%CEPS_VerDotNet_arm:.=%
set /a MyVerVCLibs_x64=%CEPS_VerVCLibs_x64:.=%
set /a MyVerVCLibs_x86=%CEPS_VerVCLibs_x86:.=%
set /a MyVerVCLibs_arm64=%CEPS_VerVCLibs_arm64:.=%
set /a MyVerVCLibs_arm=%CEPS_VerVCLibs_arm:.=%
set /a MyVerRuntime_x64=%CEPS_VerRuntime_x64:.=%
set /a MyVerRuntime_x86=%CEPS_VerRuntime_x86:.=%
set /a MyVerRuntime_arm64=%CEPS_VerRuntime_arm64:.=%
set /a MyVerRuntime_arm=%CEPS_VerRuntime_arm:.=%

echo === Microsoft.NET.Native.Framework ===
FOR /F "delims=" %%i IN ('DIR /A /B /W /O:N "C:\Program Files\WindowsApps\Microsoft.NET.Native.Framework*_x64*"') DO SET LibDotNet_x64=%%i
set LibVerStrWithDot=%LibDotNet_x64:~35,11%
set /a CuLibVerNum_x64=%LibVerStrWithDot:.=%
echo CuLibVerNum_x64=%CuLibVerNum_x64%
echo MyVerDotNet_x64=%MyVerDotNet_x64%
if %CuLibVerNum_x64% gtr %MyVerDotNet_x64% set CEPS_ParamDotNet_x64=
echo CEPS_ParamDotNet_x64=%CEPS_ParamDotNet_x64%
echo.
FOR /F "delims=" %%i IN ('DIR /A /B /W /O:N "C:\Program Files\WindowsApps\Microsoft.NET.Native.Framework*_x86*"') DO SET LibDotNet_x86=%%i
set LibVerStrWithDot=%LibDotNet_x86:~35,11%
set /a CuLibVerNum_x86=%LibVerStrWithDot:.=%
echo CuLibVerNum_x86=%CuLibVerNum_x86%
echo MyVerDotNet_x86=%MyVerDotNet_x86%
if %CuLibVerNum_x86% gtr %MyVerDotNet_x86% set CEPS_ParamDotNet_x86=
echo CEPS_ParamDotNet_x86=%CEPS_ParamDotNet_x86%
echo.
FOR /F "delims=" %%i IN ('DIR /A /B /W /O:N "C:\Program Files\WindowsApps\Microsoft.NET.Native.Framework*_arm64*"') DO SET LibDotNet_arm64=%%i
set LibVerStrWithDot=%LibDotNet_arm64:~35,11%
set /a CuLibVerNum_arm64=%LibVerStrWithDot:.=%
echo CuLibVerNum_arm64=%CuLibVerNum_arm64%
echo MyVerDotNet_arm64=%MyVerDotNet_arm64%
if %CuLibVerNum_arm64% gtr %MyVerDotNet_arm64% set CEPS_ParamDotNet_arm64=
echo CEPS_ParamDotNet_arm64=%CEPS_ParamDotNet_arm64%
echo.
FOR /F "delims=" %%i IN ('DIR /A /B /W /O:N "C:\Program Files\WindowsApps\Microsoft.NET.Native.Framework*_arm*"') DO SET LibDotNet_arm=%%i
set LibVerStrWithDot=%LibDotNet_arm:~35,11%
set /a CuLibVerNum_arm=%LibVerStrWithDot:.=%
echo CuLibVerNum_arm=%CuLibVerNum_arm%
echo MyVerDotNet_arm=%MyVerDotNet_arm%
if %CuLibVerNum_arm% gtr %MyVerDotNet_arm% set CEPS_ParamDotNet_arm=
echo CEPS_ParamDotNet_arm=%CEPS_ParamDotNet_arm%
echo.


echo === Microsoft.VCLibs ===
FOR /F "delims=" %%i IN ('DIR /A /B /W /O:N "C:\Program Files\WindowsApps\Microsoft.VCLibs*_x64*"') DO SET LibVCLibs_x64=%%i
set LibVerStrWithDot=%LibVCLibs_x64:~24,12%
set /a CuLibVerNum_x64=%LibVerStrWithDot:.=%
echo CuLibVerNum_x64=%CuLibVerNum_x64%
echo MyVerVCLibs_x64=%MyVerVCLibs_x64%
if %CuLibVerNum_x64% gtr %MyVerVCLibs_x64% set CEPS_ParamVCLibs_x64=
echo CEPS_ParamVCLibs_x64=%CEPS_ParamVCLibs_x64%
echo.
FOR /F "delims=" %%i IN ('DIR /A /B /W /O:N "C:\Program Files\WindowsApps\Microsoft.VCLibs*_x86*"') DO SET LibVCLibs_x86=%%i
set LibVerStrWithDot=%LibVCLibs_x86:~24,12%
set /a CuLibVerNum_x86=%LibVerStrWithDot:.=%
echo CuLibVerNum_x86=%CuLibVerNum_x86%
echo MyVerVCLibs_x86=%MyVerVCLibs_x86%
if %CuLibVerNum_x86% gtr %MyVerVCLibs_x86% set CEPS_ParamVCLibs_x86=
echo CEPS_ParamVCLibs_x86=%CEPS_ParamVCLibs_x86%
echo.
FOR /F "delims=" %%i IN ('DIR /A /B /W /O:N "C:\Program Files\WindowsApps\Microsoft.VCLibs*_arm64*"') DO SET LibVCLibs_arm64=%%i
set LibVerStrWithDot=%LibVCLibs_arm64:~24,12%
set /a CuLibVerNum_arm64=%LibVerStrWithDot:.=%
echo CuLibVerNum_arm64=%CuLibVerNum_arm64%
echo MyVerVCLibs_arm64=%MyVerVCLibs_arm64%
if %CuLibVerNum_arm64% gtr %MyVerVCLibs_arm64% set CEPS_ParamVCLibs_arm64=
echo CEPS_ParamVCLibs_arm64=%CEPS_ParamVCLibs_arm64%
echo.
FOR /F "delims=" %%i IN ('DIR /A /B /W /O:N "C:\Program Files\WindowsApps\Microsoft.VCLibs*_arm*"') DO SET LibVCLibs_arm=%%i
set LibVerStrWithDot=%LibVCLibs_arm:~24,12%
set /a CuLibVerNum_arm=%LibVerStrWithDot:.=%
echo CuLibVerNum_arm=%CuLibVerNum_arm%
echo MyVerVCLibs_arm=%MyVerVCLibs_arm%
if %CuLibVerNum_arm% gtr %MyVerVCLibs_arm% set CEPS_ParamVCLibs_arm=
echo CEPS_ParamVCLibs_arm=%CEPS_ParamVCLibs_arm%
echo.


echo === Microsoft.NET.Native.Runtime ===
FOR /F "delims=" %%i IN ('DIR /A /B /W /O:N "C:\Program Files\WindowsApps\Microsoft.NET.Native.Runtime*_x64*"') DO SET LibRuntime_x64=%%i
set LibVerStrWithDot=%LibRuntime_x64:~33,11%
set /a CurLibVerNum_x64=%LibVerStrWithDot:.=%
echo CurLibVerNum_x64=%CurLibVerNum_x64%
echo MyVerRuntime_x64=%MyVerRuntime_x64%
if %CurLibVerNum_x64% gtr %MyVerRuntime_x64% set CEPS_ParamRuntime_x64=
echo CEPS_ParamRuntime_x64=%CEPS_ParamRuntime_x64%
echo.
FOR /F "delims=" %%i IN ('DIR /A /B /W /O:N "C:\Program Files\WindowsApps\Microsoft.NET.Native.Runtime*_x86*"') DO SET LibRuntime_x86=%%i
set LibVerStrWithDot=%LibRuntime_x86:~33,11%
set /a CurLibVerNum_x86=%LibVerStrWithDot:.=%
echo CurLibVerNum_x86=%CurLibVerNum_x86%
echo MyVerRuntime_x86=%MyVerRuntime_x86%
if %CurLibVerNum_x86% gtr %MyVerRuntime_x86% set CEPS_ParamRuntime_x86=
echo CEPS_ParamRuntime_x86=%CEPS_ParamRuntime_x86%
echo.
FOR /F "delims=" %%i IN ('DIR /A /B /W /O:N "C:\Program Files\WindowsApps\Microsoft.NET.Native.Runtime*_arm64*"') DO SET LibRuntime_arm64=%%i
set LibVerStrWithDot=%LibRuntime_arm64:~33,11%
set /a CurLibVerNum_arm64=%LibVerStrWithDot:.=%
echo CurLibVerNum_arm64=%CurLibVerNum_arm64%
echo MyVerRuntime_arm64=%MyVerRuntime_arm64%
if %CurLibVerNum_arm64% gtr %MyVerRuntime_arm64% set CEPS_ParamRuntime_arm64=
echo CEPS_ParamRuntime_arm64=%CEPS_ParamRuntime_arm64%
echo.
FOR /F "delims=" %%i IN ('DIR /A /B /W /O:N "C:\Program Files\WindowsApps\Microsoft.NET.Native.Runtime*_arm*"') DO SET LibRuntime_arm=%%i
set LibVerStrWithDot=%LibRuntime_arm:~33,11%
set /a CurLibVerNum_arm=%LibVerStrWithDot:.=%
echo CurLibVerNum_arm=%CurLibVerNum_arm%
echo MyVerRuntime_arm=%MyVerRuntime_arm%
if %CurLibVerNum_arm% gtr %MyVerRuntime_arm% set CEPS_ParamRuntime_arm=
echo CEPS_ParamRuntime_arm=%CEPS_ParamRuntime_arm%
echo.-




