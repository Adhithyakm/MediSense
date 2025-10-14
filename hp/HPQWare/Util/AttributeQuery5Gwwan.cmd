@echo off

set CEPS_5G_WWAN=CEPS_UtilityFail
set CEPS_5G_WWAN_China=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
    for /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
        if "%%a" == "languagecode" ( Set "languagecode=%%b" )
        if "%%a" == "WWAN" ( Set "WWAN=%%b" )
        
    )
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists

IF /I "%WWAN%"=="1" (Set "CEPS_5G_WWAN=1") else (Set "CEPS_5G_WWAN=0")
IF /I "%CEPS_5G_WWAN%"=="1" IF /I "%languagecode%"=="AB2" (Set "CEPS_5G_WWAN_China=1")
IF /I "%CEPS_5G_WWAN%"=="1" IF /I "%languagecode%"=="B1L" (Set "CEPS_5G_WWAN_China=1")

ECHO [%DATE%] [%TIME%] It is 5G WWAN SKU "%CEPS_5G_WWAN%"
ECHO [%DATE%] [%TIME%] It is 5G WWAN SKU + China region(%languagecode%) "%CEPS_5G_WWAN_China%"