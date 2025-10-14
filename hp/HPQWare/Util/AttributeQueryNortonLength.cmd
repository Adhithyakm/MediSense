@Echo off

set CEPS_NortonLength=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
  For /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
    If /I "%%a" == "IS_N30d" (
        Set IS_N30d=%%b
    )
    If /I "%%a" == "IS_N60d" (
        Set IS_N60d=%%b
    )
    If /I "%%a" == "IS_N18m" (
        Set IS_N18m=%%b
    )
    If /I "%%a" == "IS_N1y" (
        Set IS_N1y=%%b
    )
    If /I "%%a" == "IS_N2Y" (
        Set IS_N2Y=%%b
    )
    If /I "%%a" == "IS_N3y" (
        Set IS_N3y=%%b
    )              
  )
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists&goto END

IF /I "%IS_N30d%"=="1" Set "CEPS_NortonLength=1" &Set CEPS_NortonLengthDec=Norton_30days
IF /I "%IS_N60d%"=="1" Set "CEPS_NortonLength=2" &Set CEPS_NortonLengthDec=Norton_60days
IF /I "%IS_N18m%"=="1" Set "CEPS_NortonLength=3" &Set CEPS_NortonLengthDec=Norton_18months
IF /I "%IS_N1y%"=="1" Set "CEPS_NortonLength=4" &Set CEPS_NortonLengthDec=Norton_1year
IF /I "%IS_N2Y%"=="1" Set "CEPS_NortonLength=5" &Set CEPS_NortonLengthDec=Norton_2year
IF /I "%IS_N3y%"=="1" Set "CEPS_NortonLength=6" &Set CEPS_NortonLengthDec=Norton_3year

IF /I "%IS_N30d%" NEQ "1" IF /I "%IS_N18m%" NEQ "1" IF /I "%IS_N1y%" NEQ "1" IF /I "%IS_N2y%" NEQ "1" IF /I "%IS_N3y%" NEQ "1" IF /I "%IS_N60d%" NEQ "1" Set "CEPS_NortonLength=0" &Set CEPS_NortonLengthDec=No_Norton

:END
ECHO [%DATE%] [%TIME%] Norton Length is "%CEPS_NortonLength%" (%CEPS_NortonLengthDec%)