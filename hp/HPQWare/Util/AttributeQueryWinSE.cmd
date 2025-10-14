@Echo off

set CEPS_WinSE=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
  For /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
    If /I "%%a" == "Vos.B" (
        Set Vos.B=%%b
    )
    If /I "%%a" == "S_Mode" (
        Set S_Mode=%%b
    )          
  )
  Set "CEPS_WinSE=0"
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists

IF /I "%Vos.B%"=="1" IF /I "%S_Mode%"=="1" Set "CEPS_WinSE=1"

ECHO [%DATE%] [%TIME%] Windows 11SE flag is "%CEPS_WinSE%"
