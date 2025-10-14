@Echo off

set CEPS_ChassisType=CEPS_UtilityFail
set CEPS_ChassisType_Name=CEPS_UtilityFail
set CEPS_PlatformType=CEPS_UtilityFail
set CEPS_PlatformType_Name=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
  For /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
    If "%%a" == "CT.AIO" (
        Set CT.AIO=%%b
    )
    If "%%a" == "CT.MT" (
        Set CT.MT=%%b
    )
    If "%%a" == "CT.NB" (
        Set CT.NB=%%b
    )
    If "%%a" == "CT.TC" (
        Set CT.TC=%%b
    )
    If "%%a" == "CT.TAB" (
        Set CT.TAB=%%b
    )              
  )
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists 

IF /I "%CT.AIO%"=="1" Set "CEPS_ChassisType=1" &Set "CEPS_ChassisType_Name=AIO_Chassis_Type"&Set "CEPS_PlatformType=1" &Set "CEPS_PlatformType_Name=Desktop"
IF /I "%CT.MT%"=="1" Set "CEPS_ChassisType=2" &Set "CEPS_ChassisType_Name=Desktop_SFF_MT_uT_ChassisType"&Set "CEPS_PlatformType=1" &Set "CEPS_PlatformType_Name=Desktop"
IF /I "%CT.NB%"=="1" Set "CEPS_ChassisType=3" &Set "CEPS_ChassisType_Name=ChassisType_Notebook"&Set "CEPS_PlatformType=2" &Set "CEPS_PlatformType_Name=Notebook"
IF /I "%CT.TC%"=="1" Set "CEPS_ChassisType=4" &Set "CEPS_ChassisType_Name=ChassisType_ThinClient"&Set "CEPS_PlatformType=1" &Set "CEPS_PlatformType_Name=Desktop"
IF /I "%CT.TAB%"=="1" Set "CEPS_ChassisType=5" &Set "CEPS_ChassisType_Name=ChassisType_Tablet"&Set "CEPS_PlatformType=2" &Set "CEPS_PlatformType_Name=Notebook"

ECHO [%DATE%] [%TIME%] Chassis Type is "%CEPS_ChassisType%" (%CEPS_ChassisType_Name%)
ECHO [%DATE%] [%TIME%] Platform Type is "%CEPS_PlatformType%" (%CEPS_PlatformType_Name%)
