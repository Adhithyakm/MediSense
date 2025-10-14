@echo off

set CEPS_IsHealthCareSku=CEPS_UtilityFail
set CEPS_IsEducationSku=CEPS_UtilityFail
set CEPS_IsMMDImage=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
	for /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
		If "%%a" == "V_Health" (
        	Set V_Health=%%b
    	)
    	If "%%a" == "SCH_EDU" (
        	Set SCH_EDU=%%b
    	)
    	If "%%a" == "V_MMD" (
        	Set V_MMD=%%b
    	)
	)
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists

IF /I "%V_Health%"=="1" ( Set "CEPS_IsHealthCareSku=1" ) else Set "CEPS_IsHealthCareSku=0"
IF /I "%SCH_EDU%"=="1" ( Set "CEPS_IsEducationSku=1" ) else Set "CEPS_IsEducationSku=0"
IF /I "%V_MMD%"=="1" ( Set "CEPS_IsMMDImage=1" ) else Set "CEPS_IsMMDImage=0"

ECHO [%DATE%] [%TIME%] Health Care Sku is "%CEPS_IsHealthCareSku%"
ECHO [%DATE%] [%TIME%] Education Sku is "%CEPS_IsEducationSku%"
ECHO [%DATE%] [%TIME%] MMD Image is "%CEPS_IsMMDImage%"