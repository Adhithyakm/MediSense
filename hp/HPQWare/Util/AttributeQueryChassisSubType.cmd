@Echo off

set CEPS_ChassisSubType=CEPS_UtilityFail
set CEPS_ChassisSubType_Name=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
  For /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
    If "%%a" == "CTS_CONV" (
        Set CTS_CONV=%%b
    )
    If "%%a" == "CTS_DET" (
        Set CTS_DET=%%b
    )
    If "%%a" == "CTS_Ultra" (
        Set CTS_Ultra=%%b
    )
  )
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists &goto END

IF /I "%CTS_CONV%"=="1" Set "CEPS_ChassisSubType=1" &Set "CEPS_ChassisSubType_Name=Convertible"
IF /I "%CTS_DET%"=="1" Set "CEPS_ChassisSubType=2" &Set "CEPS_ChassisSubType_Name=Detachable"
IF /I "%CTS_Ultra%"=="1" Set "CEPS_ChassisSubType=3" &Set "CEPS_ChassisSubType_Name= Ultraslim"
IF /I "%CTS_CONV%" NEQ "1" IF /I "%CTS_DET%" NEQ "1" IF /I "%CTS_Ultra%" NEQ "1" Set "CEPS_ChassisSubType=0" &Set "CEPS_ChassisSubType_Name=NA"

:END
ECHO [%DATE%] [%TIME%] Chassis Sub Type is "%CEPS_ChassisSubType%" (%CEPS_ChassisSubType_Name%)
