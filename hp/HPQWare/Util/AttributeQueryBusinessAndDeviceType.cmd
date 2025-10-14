@Echo off

set CEPS_BusinessAndDeviceType=CEPS_UtilityFail
set CEPS_BusinessAndDeviceTypeName=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
    For /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
        If "%%a" == "SEG.CON" (
            Set SEG.CON=%%b
        )
        If "%%a" == "SEG.SBSO" (
            Set SEG.SBSO=%%b
        )
        If "%%a" == "SEG.PRM" (
            Set SEG.PRM=%%b
        )
        If "%%a" == "SEG.ENT" (
            Set SEG.ENT=%%b
        )
        If "%%a" == "SEG.WKS" (
            Set SEG.WKS=%%b
        )
        If "%%a" == "SEG.RPS" (
            Set SEG.RPS=%%b
        )
        If "%%a" == "CT.AIO" (
            Set CT.AIO=%%b
        )
        If "%%a" == "CT.MT" (
            Set CT.MT=%%b
        )
        If "%%a" == "CT.TC" (
            Set CT.TC=%%b
        ) 
        If "%%a" == "CT.NB" (
            Set CT.NB=%%b
        )
        If "%%a" == "CT.TAB" (
            Set CT.TAB=%%b
        )
        If "%%a" == "SL.MAI" (
            Set SL.MAI=%%b
        )
    )
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists

REM Consumer NB
IF /I "%SEG.CON%"=="1" IF /I "%CT.NB%"=="1" Set "CEPS_BusinessAndDeviceType=1"&set "CEPS_BusinessAndDeviceTypeName=Consumer NB"
IF /I "%SEG.CON%"=="1" IF /I "%CT.TAB%"=="1" Set "CEPS_BusinessAndDeviceType=1"&set "CEPS_BusinessAndDeviceTypeName=Consumer NB"
IF /I "%SEG.PRM%"=="1" IF /I "%CT.NB%"=="1" Set "CEPS_BusinessAndDeviceType=1"&set "CEPS_BusinessAndDeviceTypeName=Consumer NB"
IF /I "%SEG.PRM%"=="1" IF /I "%CT.TAB%"=="1" Set "CEPS_BusinessAndDeviceType=1"&set "CEPS_BusinessAndDeviceTypeName=Consumer NB"

REM Consumer DT
IF /I "%SEG.CON%"=="1" IF /I "%CT.AIO%"=="1" Set "CEPS_BusinessAndDeviceType=2"&set "CEPS_BusinessAndDeviceTypeName=Consumer DT"
IF /I "%SEG.CON%"=="1" IF /I "%CT.MT%"=="1" Set "CEPS_BusinessAndDeviceType=2"&set "CEPS_BusinessAndDeviceTypeName=Consumer DT"
IF /I "%SEG.CON%"=="1" IF /I "%CT.TC%"=="1" Set "CEPS_BusinessAndDeviceType=2"&set "CEPS_BusinessAndDeviceTypeName=Consumer DT"
IF /I "%SEG.PRM%"=="1" IF /I "%CT.AIO%"=="1" Set "CEPS_BusinessAndDeviceType=2"&set "CEPS_BusinessAndDeviceTypeName=Consumer DT"
IF /I "%SEG.PRM%"=="1" IF /I "%CT.MT%"=="1" Set "CEPS_BusinessAndDeviceType=2"&set "CEPS_BusinessAndDeviceTypeName=Consumer DT"
IF /I "%SEG.PRM%"=="1" IF /I "%CT.TC%"=="1" Set "CEPS_BusinessAndDeviceType=2"&set "CEPS_BusinessAndDeviceTypeName=Consumer DT"

REM Commercial NB
IF /I "%SEG.SBSO%"=="1" IF /I "%CT.NB%"=="1" Set "CEPS_BusinessAndDeviceType=3"&set "CEPS_BusinessAndDeviceTypeName=Commercial NB"
IF /I "%SEG.SBSO%"=="1" IF /I "%CT.TAB%"=="1" Set "CEPS_BusinessAndDeviceType=3"&set "CEPS_BusinessAndDeviceTypeName=Commercial NB"
IF /I "%SEG.ENT%"=="1" IF /I "%CT.NB%"=="1" Set "CEPS_BusinessAndDeviceType=3"&set "CEPS_BusinessAndDeviceTypeName=Commercial NB"
IF /I "%SEG.ENT%"=="1" IF /I "%CT.TAB%"=="1" Set "CEPS_BusinessAndDeviceType=3"&set "CEPS_BusinessAndDeviceTypeName=Commercial NB"
IF /I "%SEG.WKS%"=="1" IF /I "%CT.NB%"=="1" Set "CEPS_BusinessAndDeviceType=3"&set "CEPS_BusinessAndDeviceTypeName=Commercial NB"
IF /I "%SEG.RPS%"=="1" IF /I "%CT.NB%"=="1" Set "CEPS_BusinessAndDeviceType=3"&set "CEPS_BusinessAndDeviceTypeName=Commercial NB"
IF /I "%SEG.RPS%"=="1" IF /I "%CT.TAB%"=="1" Set "CEPS_BusinessAndDeviceType=3"&set "CEPS_BusinessAndDeviceTypeName=Commercial NB"

REM Commercial DT
IF /I "%SEG.SBSO%"=="1" IF /I "%CT.AIO%"=="1" Set "CEPS_BusinessAndDeviceType=4"&set "CEPS_BusinessAndDeviceTypeName=Commercial DT"
IF /I "%SEG.SBSO%"=="1" IF /I "%CT.MT%"=="1" Set "CEPS_BusinessAndDeviceType=4"&set "CEPS_BusinessAndDeviceTypeName=Commercial DT"
IF /I "%SEG.SBSO%"=="1" IF /I "%CT.TC%"=="1" Set "CEPS_BusinessAndDeviceType=4"&set "CEPS_BusinessAndDeviceTypeName=Commercial DT"
IF /I "%SEG.ENT%"=="1" IF /I "%CT.AIO%"=="1" Set "CEPS_BusinessAndDeviceType=4"&set "CEPS_BusinessAndDeviceTypeName=Commercial DT"
IF /I "%SEG.ENT%"=="1" IF /I "%CT.MT%"=="1" Set "CEPS_BusinessAndDeviceType=4"&set "CEPS_BusinessAndDeviceTypeName=Commercial DT"
IF /I "%SEG.ENT%"=="1" IF /I "%CT.TC%"=="1" Set "CEPS_BusinessAndDeviceType=4"&set "CEPS_BusinessAndDeviceTypeName=Commercial DT"
IF /I "%SEG.WKS%"=="1" IF /I "%CT.MT%"=="1" Set "CEPS_BusinessAndDeviceType=4"&set "CEPS_BusinessAndDeviceTypeName=Commercial DT"
IF /I "%SEG.WKS%"=="1" IF /I "%CT.AIO%"=="1" Set "CEPS_BusinessAndDeviceType=4"&set "CEPS_BusinessAndDeviceTypeName=Commercial DT"
IF /I "%SEG.RPS%"=="1" IF /I "%CT.AIO%"=="1" Set "CEPS_BusinessAndDeviceType=4"&set "CEPS_BusinessAndDeviceTypeName=Commercial DT"
IF /I "%SEG.RPS%"=="1" IF /I "%CT.MT%"=="1" Set "CEPS_BusinessAndDeviceType=4"&set "CEPS_BusinessAndDeviceTypeName=Commercial DT"
IF /I "%SEG.RPS%"=="1" IF /I "%CT.TC%"=="1" Set "CEPS_BusinessAndDeviceType=4"&set "CEPS_BusinessAndDeviceTypeName=Commercial DT"

IF /I "%CEPS_BusinessAndDeviceType%" NEQ "1" IF /I "%CEPS_BusinessAndDeviceType%" NEQ "2" IF /I "%CEPS_BusinessAndDeviceType%" NEQ "3" IF /I "%CEPS_BusinessAndDeviceType%" NEQ "4" Set "CEPS_BusinessAndDeviceType=0" &Set CEPS_BusinessAndDeviceTypeName=No_Match

ECHO [%DATE%] [%TIME%] Business and Device Type is "%CEPS_BusinessAndDeviceType%" (%CEPS_BusinessAndDeviceTypeName%)