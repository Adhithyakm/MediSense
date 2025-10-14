@echo off

set CEPS_SBSO6U=CEPS_UtilityFail
set CEPS_SBSODT=CEPS_UtilityFail
set CEPS_SBSONB=CEPS_UtilityFail
set CEPS_CONDT=CEPS_UtilityFail
set CEPS_CONNB=CEPS_UtilityFail
set CEPS_CONDTPRE=CEPS_UtilityFail
set CEPS_CONNBPRE=CEPS_UtilityFail
set CEPS_CMITDT=CEPS_UtilityFail
set CEPS_CMITNB=CEPS_UtilityFail
set CEPS_BWS=CEPS_UtilityFail
set CEPS_MWS=CEPS_UtilityFail
set CEPS_RPOS=CEPS_UtilityFail

set CEPS_CON=CEPS_UtilityFail
set CEPS_CMIT=CEPS_UtilityFail

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

REM SBSO 6U segment
IF /I "%SEG.SBSO%"=="1" IF /I "%SL.MAI%"=="1" Set "CEPS_SBSO6U=1"&set "CEPS_CMIT=1"
IF /I "%SEG.SBSO%"=="1" IF /I "%SL.MAI%"=="1" Set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONDT=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CON=0

REM SBSO DT segment
IF /I "%SEG.SBSO%"=="1" IF /I "%CT.AIO%"=="1" Set "CEPS_SBSODT=1"&set "CEPS_CMIT=1"
IF /I "%SEG.SBSO%"=="1" IF /I "%CT.AIO%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSONB=0&set CEPS_CONDT=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CON=0
IF /I "%SEG.SBSO%"=="1" IF /I "%CT.MT%"=="1" Set "CEPS_SBSODT=1"&set "CEPS_CMIT=1"
IF /I "%SEG.SBSO%"=="1" IF /I "%CT.MT%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSONB=0&set CEPS_CONDT=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CON=0
IF /I "%SEG.SBSO%"=="1" IF /I "%CT.TC%"=="1" Set "CEPS_SBSODT=1"&set "CEPS_CMIT=1"
IF /I "%SEG.SBSO%"=="1" IF /I "%CT.TC%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSONB=0&set CEPS_CONDT=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CON=0

REM SBSO NB segment
IF /I "%SEG.SBSO%"=="1" IF /I "%CT.NB%"=="1" Set "CEPS_SBSONB=1"&set "CEPS_CMIT=1"
IF /I "%SEG.SBSO%"=="1" IF /I "%CT.NB%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_CONDT=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CON=0

REM Consumer DT segment
IF /I "%SEG.CON%"=="1" IF /I "%CT.AIO%"=="1" Set "CEPS_CONDT=1"&set "CEPS_CON=1"
IF /I "%SEG.CON%"=="1" IF /I "%CT.AIO%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CMIT=0
IF /I "%SEG.CON%"=="1" IF /I "%CT.MT%"=="1" Set "CEPS_CONDT=1"&set "CEPS_CON=1"
IF /I "%SEG.CON%"=="1" IF /I "%CT.MT%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CMIT=0
IF /I "%SEG.CON%"=="1" IF /I "%CT.TC%"=="1" Set "CEPS_CONDT=1"&set "CEPS_CON=1"
IF /I "%SEG.CON%"=="1" IF /I "%CT.TC%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CMIT=0

REM Consumer DT Premium segment
IF /I "%SEG.PRM%"=="1" IF /I "%CT.AIO%"=="1" Set "CEPS_CONDTPRE=1"&set "CEPS_CON=1"
IF /I "%SEG.PRM%"=="1" IF /I "%CT.AIO%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONNB=0&set CEPS_CONDT=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CMIT=0
IF /I "%SEG.PRM%"=="1" IF /I "%CT.MT%"=="1" Set "CEPS_CONDTPRE=1"&set "CEPS_CON=1"
IF /I "%SEG.PRM%"=="1" IF /I "%CT.MT%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONNB=0&set CEPS_CONDT=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CMIT=0
IF /I "%SEG.PRM%"=="1" IF /I "%CT.TC%"=="1" Set "CEPS_CONDTPRE=1"&set "CEPS_CON=1"
IF /I "%SEG.PRM%"=="1" IF /I "%CT.TC%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONNB=0&set CEPS_CONDT=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CMIT=0

REM Consumer NB segment
IF /I "%SEG.CON%"=="1" IF /I "%CT.NB%"=="1" Set "CEPS_CONNB=1"&set "CEPS_CON=1"
IF /I "%SEG.CON%"=="1" IF /I "%CT.NB%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONDT=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CMIT=0
IF /I "%SEG.CON%"=="1" IF /I "%CT.TAB%"=="1" Set "CEPS_CONNB=1"&set "CEPS_CON=1"
IF /I "%SEG.CON%"=="1" IF /I "%CT.TAB%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONDT=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CMIT=0

REM Consumer NB Premium segment
IF /I "%SEG.PRM%"=="1" IF /I "%CT.NB%"=="1" Set "CEPS_CONNBPRE=1"&set "CEPS_CON=1"
IF /I "%SEG.PRM%"=="1" IF /I "%CT.NB%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONNB=0&set CEPS_CONDT=0&set CEPS_CONDTPRE=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CMIT=0
IF /I "%SEG.PRM%"=="1" IF /I "%CT.TAB%"=="1" Set "CEPS_CONNBPRE=1"&set "CEPS_CON=1"
IF /I "%SEG.PRM%"=="1" IF /I "%CT.TAB%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONNB=0&set CEPS_CONDT=0&set CEPS_CONDTPRE=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CMIT=0

REM Commercial DT segment
IF /I "%SEG.ENT%"=="1" IF /I "%CT.AIO%"=="1" Set "CEPS_CMITDT=1"&set "CEPS_CMIT=1"
IF /I "%SEG.ENT%"=="1" IF /I "%CT.AIO%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONDT=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CON=0
IF /I "%SEG.ENT%"=="1" IF /I "%CT.MT%"=="1" Set "CEPS_CMITDT=1"&set "CEPS_CMIT=1"
IF /I "%SEG.ENT%"=="1" IF /I "%CT.MT%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONDT=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CON=0
IF /I "%SEG.ENT%"=="1" IF /I "%CT.TC%"=="1" Set "CEPS_CMITDT=1"&set "CEPS_CMIT=1"
IF /I "%SEG.ENT%"=="1" IF /I "%CT.TC%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONDT=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CON=0

REM Commercial NB segment
IF /I "%SEG.ENT%"=="1" IF /I "%CT.NB%"=="1" Set "CEPS_CMITNB=1"&set "CEPS_CMIT=1"
IF /I "%SEG.ENT%"=="1" IF /I "%CT.NB%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONDT=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CON=0
IF /I "%SEG.ENT%"=="1" IF /I "%CT.TAB%"=="1" Set "CEPS_CMITNB=1"&set "CEPS_CMIT=1"
IF /I "%SEG.ENT%"=="1" IF /I "%CT.TAB%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONDT=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CON=0
IF /I "%SEG.SBSO%"=="1" IF /I "%CT.TAB%"=="1" Set "CEPS_CMITNB=1"&set "CEPS_CMIT=1"
IF /I "%SEG.SBSO%"=="1" IF /I "%CT.TAB%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONDT=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_BWS=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CON=0

REM Workstation DT segment
IF /I "%SEG.WKS%"=="1" IF /I "%CT.MT%"=="1" Set "CEPS_BWS=1"&set "CEPS_CMIT=1"
IF /I "%SEG.WKS%"=="1" IF /I "%CT.MT%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONDT=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CON=0
IF /I "%SEG.WKS%"=="1" IF /I "%CT.AIO%"=="1" Set "CEPS_BWS=1"&set "CEPS_CMIT=1"
IF /I "%SEG.WKS%"=="1" IF /I "%CT.AIO%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONDT=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_MWS=0&set CEPS_RPOS=0&set CEPS_CON=0

REM Workstation Mobile segment
IF /I "%SEG.WKS%"=="1" IF /I "%CT.NB%"=="1" Set "CEPS_MWS=1"&set "CEPS_CMIT=1"
IF /I "%SEG.WKS%"=="1" IF /I "%CT.NB%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONDT=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_BWS=0&set CEPS_RPOS=0&set CEPS_CON=0

REM Retail point segment
IF /I "%SEG.RPS%"=="1" Set "CEPS_RPOS=1"&set "CEPS_CMIT=1"
IF /I "%SEG.RPS%"=="1" Set CEPS_SBSO6U=0&set CEPS_SBSODT=0&set CEPS_SBSONB=0&set CEPS_CONDT=0&set CEPS_CONNB=0&set CEPS_CONDTPRE=0&set CEPS_CONNBPRE=0&set CEPS_CMITDT=0&set CEPS_CMITNB=0&set CEPS_MWS=0&set CEPS_BWS=0&set CEPS_CON=0


IF /I "%CEPS_SBSO6U%"=="1" ECHO [%DATE%] [%TIME%] Platform segment is Desktop SBSO(6U)
IF /I "%CEPS_SBSODT%"=="1" ECHO [%DATE%] [%TIME%] Platform segment is Desktop SBSO
IF /I "%CEPS_SBSONB%"=="1" ECHO [%DATE%] [%TIME%] Platform segment is Notebook SBSO
IF /I "%CEPS_CMITDT%"=="1" ECHO [%DATE%] [%TIME%] Platform segment is Desktop Commercial
IF /I "%CEPS_CMITNB%"=="1" ECHO [%DATE%] [%TIME%] Platform segment is Notebook Commercial
IF /I "%CEPS_CONDT%"=="1" ECHO [%DATE%] [%TIME%] Platform segment is Desktop Consumer
IF /I "%CEPS_CONNB%"=="1" ECHO [%DATE%] [%TIME%] Platform segment is Notebook Consumer
IF /I "%CEPS_CONDTPRE%"=="1" ECHO [%DATE%] [%TIME%] Platform segment is Desktop Consumer Premium
IF /I "%CEPS_CONNBPRE%"=="1" ECHO [%DATE%] [%TIME%] Platform segment is Notebook Consumer Premium
IF /I "%CEPS_BWS%"=="1" ECHO [%DATE%] [%TIME%] Platform segment is Desktop Workstation
IF /I "%CEPS_MWS%"=="1" ECHO [%DATE%] [%TIME%] Platform segment is Mobile Workstation
IF /I "%CEPS_RPOS%"=="1" ECHO [%DATE%] [%TIME%] Platform segment is Retail point of sale Segment

IF /I "%CEPS_CON%"=="1" ECHO [%DATE%] [%TIME%] It is Consumer platform
IF /I "%CEPS_CMIT%"=="1" ECHO [%DATE%] [%TIME%] It is CMIT platform
