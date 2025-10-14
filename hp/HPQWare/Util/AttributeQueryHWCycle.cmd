@Echo off

set CEPS_HardwareCycle="CEPS_UtilityFail"
set CEPS_IsAdlerI22C1="CEPS_UtilityFail"
set CEPS_IsWatsonI22C1="CEPS_UtilityFail"
set CEPS_IsWatsonA22C1="CEPS_UtilityFail"
set CEPS_IsCARMK22C1="CEPS_UtilityFail"

for /f "delims=" %%i in ('call %~dp0WMIQuery.exe "root\HP\InstrumentedBIOS" "SELECT * FROM HP_BIOSSetting WHERE name=\"HW Platform Cycle\"" "value"') do (
    for /f "tokens=1,2 delims==" %%a in ("%%~i") do (
        if /i "%%~a" == "value" (set "CEPS_HardwareCycle=%%~b") else (set "CEPS_HardwareCycle=NOT_DEFINED")
    )
)

REM Check if it is 22C1 AdlerI or WatsonI
if exist "c:\system.sav\util\vars.ini" (
  For /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
    If "%%a" == "C_ALDI" (
        Set C_ALDI=%%b
    )
    If "%%a" == "C_WATI" (
        Set C_WATI=%%b
    )
    If "%%a" == "C_WATS" (
        Set C_WATS=%%b
    )	
    If "%%a" == "C_CARMK" (
        Set C_CARMK=%%b
    )
    If "%%a" == "BO_KILL_MCR" (
        Set BO_KILL_MCR=%%b
    )                 
  )
  Set "CEPS_IsAdlerI22C1=0"
  Set "CEPS_IsWatsonI22C1=0"
  Set "CEPS_IsWatsonA22C1=0"
  Set "CEPS_IsCARMK22C1=0"
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists

REM Query system board ID for 22C1 CarmK
for /f "delims=" %%i in ('call %~dp0WMIQuery.exe "root\CIMV2" "SELECT * FROM Win32_BaseBoard" "Product"') do (
    for /f "tokens=1,2 delims==" %%a in ("%%~i") do (
         if /i "%%~a" == "Product" (set "SystemID=%%~b") else (set "SystemID=")
    )
)

IF /I "%C_ALDI%"=="1" IF /I "%BO_KILL_MCR%"=="1" (Set "CEPS_IsAdlerI22C1=1")
IF /I "%C_WATI%"=="1" IF /I "%BO_KILL_MCR%"=="1" (Set "CEPS_IsWatsonI22C1=1")
IF /I "%C_WATS%"=="1" IF /I "%BO_KILL_MCR%"=="1" (Set "CEPS_IsWatsonA22C1=1")
IF /I "%C_CARMK%"=="1" IF /I "%SystemID%"=="8923" (Set "CEPS_IsCARMK22C1=1")
IF /I "%C_CARMK%"=="1" IF /I "%SystemID%"=="8926" (Set "CEPS_IsCARMK22C1=1")

ECHO [%DATE%][%TIME%] Hardware cycle is %CEPS_HardwareCycle%
ECHO [%DATE%][%TIME%] If it is 22C1 AdlerI: %CEPS_IsAdlerI22C1%
ECHO [%DATE%][%TIME%] If it is 22C1 WatsonI: %CEPS_IsWatsonI22C1%
ECHO [%DATE%][%TIME%] If it is 22C1 WatsonA: %CEPS_IsWatsonA22C1%
ECHO [%DATE%][%TIME%] If it is 22C1 CarmK: %CEPS_IsCARMK22C1%