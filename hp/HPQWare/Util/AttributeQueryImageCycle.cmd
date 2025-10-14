@echo off

set CEPS_CycleInSystem=CEPS_UtilityFail
set CEPS_OOCycleOO=CEPS_UtilityFail

for /f "tokens=*" %%a in ('dir "c:\system.sav\flags\1c*.flg" /b /s') do set CEPS_CycleInSystem=%%~na
for /f "tokens=*" %%a in ('dir "c:\system.sav\flags\2c*.flg" /b /s') do set CEPS_CycleInSystem=%%~na
for /f "tokens=*" %%a in ('dir "c:\system.sav\flags\3c*.flg" /b /s') do set CEPS_CycleInSystem=%%~na
for /f "tokens=*" %%a in ('dir "c:\system.sav\flags\*c1.flg" /b /s') do set CEPS_CycleInSystem=%%~na
for /f "tokens=*" %%a in ('dir "c:\system.sav\flags\*c2.flg" /b /s') do set CEPS_CycleInSystem=%%~na
ECHO [%DATE%] [%TIME%] System Cycle is "%CEPS_CycleInSystem%"
if /i "%CEPS_CycleInSystem%"=="21C1" Set "CEPS_OOCycleOO=21c1"
if /i "%CEPS_CycleInSystem%"=="20C2" Set "CEPS_OOCycleOO=20c2sr"
if /i "%CEPS_CycleInSystem%"=="20C1" Set "CEPS_OOCycleOO=20c1sr"
if /i "%CEPS_CycleInSystem%"=="19C2" Set "CEPS_OOCycleOO=19c2sr"
if /i "%CEPS_CycleInSystem%"=="19C1" Set "CEPS_OOCycleOO=19c1sr"
if /i "%CEPS_CycleInSystem%"=="18C2" Set "CEPS_OOCycleOO=18c2sr"
if /i "%CEPS_CycleInSystem%"=="18C1" Set "CEPS_OOCycleOO=18c1sr"
if /i "%CEPS_CycleInSystem%"=="3C17" Set "CEPS_OOCycleOO=3c17sr"

ECHO [%DATE%] [%TIME%] Image Cycle flag is "%CEPS_OOCycleOO%"