@Echo off

set CEPS_McAfeeLength=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
  For /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
    If "%%a" == "IS_M30d" (
        Set IS_M30d=%%b
    )
    If "%%a" == "IS_M60d" (
        Set IS_M60d=%%b
    )
    If "%%a" == "IS_M6m" (
        Set IS_M6m=%%b
    )
    If "%%a" == "IS_M1y" (
        Set IS_M1y=%%b
    )
    If "%%a" == "IS_M2y" (
        Set IS_M2y=%%b
    )
    If "%%a" == "IS_M3y" (
        Set IS_M3y=%%b
    )              
  )
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists&goto END

IF /I "%IS_M30d%"=="1" Set "CEPS_McAfeeLength=0" &Set CEPS_McAfeeLengthDec=McAfee_30days
IF /I "%IS_M6m%"=="1" Set "CEPS_McAfeeLength=1" &Set CEPS_McAfeeLengthDec=McAfee_6months
IF /I "%IS_M1y%"=="1" Set "CEPS_McAfeeLength=2" &Set CEPS_McAfeeLengthDec=McAfee_1year
IF /I "%IS_M2y%"=="1" Set "CEPS_McAfeeLength=3" &Set CEPS_McAfeeLengthDec=McAfee_2year
IF /I "%IS_M3y%"=="1" Set "CEPS_McAfeeLength=4" &Set CEPS_McAfeeLengthDec=McAfee_3year
IF /I "%IS_M60d%"=="1" Set "CEPS_McAfeeLength=5" &Set CEPS_McAfeeLengthDec=McAfee_60days
IF /I "%IS_M30d%" NEQ "1" IF /I "%IS_M6m%" NEQ "1" IF /I "%IS_M1y%" NEQ "1" IF /I "%IS_M2y%" NEQ "1" IF /I "%IS_M3y%" NEQ "1" IF /I "%IS_M60d%" NEQ "1" Set "CEPS_McAfeeLength=7" &Set CEPS_McAfeeLengthDec=No_Macfee

:END
ECHO [%DATE%] [%TIME%] McAfee Length is "%CEPS_McAfeeLength%" (%CEPS_McAfeeLengthDec%)