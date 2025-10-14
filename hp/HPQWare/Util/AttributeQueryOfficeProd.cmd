@Echo off

REM General
Set CEPS_PROD_DA="CEPS_UtilityFail"
set CEPS_AFO="CEPS_UtilityFail"
set CEPS_PROD_MSOFFSTA="CEPS_UtilityFail"

REM Office 365
set CEPS_PROD_MSOFF365_MA_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFF365_EM_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFF365_SEAS_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFF365_OPP_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFFHO365_MA_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFFHO365_EM_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFFHO365_LA_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFF365PERS="CEPS_UtilityFail"
set CEPS_PROD_MSOFF365_PI_EM_LB="CEPS_UtilityFail"

REM Office Home and Student
set CEPS_PROD_MSOFFHS19_MA_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFFHS19_EM_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFFHS19_IN_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFFHS19_IO_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFFHS19_CH_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFFHS19_PH_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFFHS19_AP_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFFHS19_ML_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFFHS19_TH_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFFHS19_VI_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFFHS19_LA_LB="CEPS_UtilityFail"

REM Office Home and Business
set CEPS_PROD_MSOFFHB19_LB="CEPS_UtilityFail"

REM Office Personal
set CEPS_PROD_MSOFFP19_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFFNA="CEPS_UtilityFail"
set CEPS_PROD_MSOFFNAEM="CEPS_UtilityFail"

REM Office Japan 2021
Set CEPS_PROD_OFF21_DIB="CEPS_UtilityFail"

REM Office Japan
set CEPS_PROD_MSOFFPRO19="CEPS_UtilityFail"
set CEPS_PROD_MSOFFPER19="CEPS_UtilityFail"
set CEPS_PROD_MSOFFHB19="CEPS_UtilityFail"
set CEPS_PROD_MSOFFMSNA="CEPS_UtilityFail"

REM Office PROPLUS
set CEPS_PROD_MSOFFPROPLUS="CEPS_UtilityFail"

REM not on Install Option Spec
set CEPS_PROD_MSOFFHB="CEPS_UtilityFail"
set CEPS_PROD_MSOFFHS="CEPS_UtilityFail"
set CEPS_PROD_MSOFFHS19_KR_LB="CEPS_UtilityFail"
set CEPS_PROD_MSOFFPER="CEPS_UtilityFail"
set CEPS_PROD_MSOFFPRE="CEPS_UtilityFail"
set CEPS_PROD_MSOFFPRO="CEPS_UtilityFail"


if exist "c:\system.sav\util\vars.ini" (
  For /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
    If /I "%%a" == "PROD_MSOFF365_EM_LB" (
        Set CEPS_PROD_MSOFF365_EM_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFF365_MA_LB" (
        Set CEPS_PROD_MSOFF365_MA_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFF365_OPP_LB" (
        Set CEPS_PROD_MSOFF365_OPP_LB=%%b
    )     
    If /I "%%a" == "PROD_MSOFF365_SEAS_LB" (
        Set CEPS_PROD_MSOFF365_SEAS_LB=%%b
    ) 
    If /I "%%a" == "PROD_MSOFF365PERS" (
        Set CEPS_PROD_MSOFF365PERS=%%b
    ) 
    If /I "%%a" == "PROD_MSOFFHB" (
        Set CEPS_PROD_MSOFFHB=%%b
    )
    If /I "%%a" == "PROD_MSOFFHB19" (
        Set CEPS_PROD_MSOFFHB19=%%b
    )
    If /I "%%a" == "PROD_MSOFFHB19_LB" (
        Set CEPS_PROD_MSOFFHB19_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFFHO365_EM_LB" (
        Set CEPS_PROD_MSOFFHO365_EM_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFFHO365_LA_LB" (
        Set CEPS_PROD_MSOFFHO365_LA_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFFHO365_MA_LB" (
        Set CEPS_PROD_MSOFFHO365_MA_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFFHS" (
        Set CEPS_PROD_MSOFFHS=%%b
    )
    If /I "%%a" == "PROD_MSOFFHS19_AP_LB" (
        Set CEPS_PROD_MSOFFHS19_AP_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFFHS19_CH_LB" (
        Set CEPS_PROD_MSOFFHS19_CH_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFFHS19_EM_LB" (
        Set CEPS_PROD_MSOFFHS19_EM_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFFHS19_IN_LB" (
        Set CEPS_PROD_MSOFFHS19_IN_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFFHS19_IO_LB" (
        Set CEPS_PROD_MSOFFHS19_IO_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFFHS19_KR_LB" (
        Set CEPS_PROD_MSOFFHS19_KR_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFFHS19_LA_LB" (
        Set CEPS_PROD_MSOFFHS19_LA_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFFHS19_MA_LB" (
        Set CEPS_PROD_MSOFFHS19_MA_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFFHS19_ML_LB" (
        Set CEPS_PROD_MSOFFHS19_ML_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFFHS19_PH_LB" (
        Set CEPS_PROD_MSOFFHS19_PH_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFFHS19_TH_LB" (
        Set CEPS_PROD_MSOFFHS19_TH_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFFHS19_VI_LB" (
        Set CEPS_PROD_MSOFFHS19_VI_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFFP19_LB" (
        Set CEPS_PROD_MSOFFP19_LB=%%b
    )
    If /I "%%a" == "PROD_MSOFFPER" (
        Set CEPS_PROD_MSOFFPER=%%b
    )
    If /I "%%a" == "PROD_MSOFFPER19" (
        Set CEPS_PROD_MSOFFPER19=%%b
    )
    If /I "%%a" == "PROD_MSOFFPRE" (
        Set CEPS_PROD_MSOFFPRE=%%b
    )
    If /I "%%a" == "PROD_MSOFFPRO" (
        Set CEPS_PROD_MSOFFPRO=%%b
    )
    If /I "%%a" == "PROD_MSOFFPRO19" (
        Set CEPS_PROD_MSOFFPRO19=%%b
    )
    If /I "%%a" == "PROD_MSOFFPROPLUS" (
        Set CEPS_PROD_MSOFFPROPLUS=%%b
    )
    If /I "%%a" == "PROD_MSOFFSTA" (
        Set CEPS_PROD_MSOFFSTA=%%b
    )
    If /I "%%a" == "AFO" (
        Set CEPS_AFO=%%b
    )
    If /I "%%a" == "PROD_MSOFFNA" (
        Set CEPS_PROD_MSOFFNA=%%b
    )
    If /I "%%a" == "PROD_MSOFFNAEM" (
        Set CEPS_PROD_MSOFFNAEM=%%b
    )
    If /I "%%a" == "PROD_MSOFF365_PI_EM_LB" (
        Set CEPS_PROD_MSOFF365_PI_EM_LB=%%b
    )	
	If /I "%%a" == "PROD_MSOFFMSNA" (
        Set CEPS_PROD_MSOFFMSNA=%%b
    )	
	If /I "%%a" == "PROD_DA" (
        Set CEPS_PROD_DA=%%b
    )	
	If /I "%%a" == "PROD_OFF21_DIB" (
        Set CEPS_PROD_OFF21_DIB=%%b
    )
  )
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists 

ECHO #########################################################################################
IF /I "%CEPS_PROD_MSOFF365_EM_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office 365 Personal EM (AFOLB) 
IF /I "%CEPS_PROD_MSOFF365_MA_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office 365 Personal (AFOLB) 
IF /I "%CEPS_PROD_MSOFF365_OPP_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft 365 Personal 2016 Subscr 1YR OPP AFOLB 
IF /I "%CEPS_PROD_MSOFF365_SEAS_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office 365 Personal Season Promo 
IF /I "%CEPS_PROD_MSOFF365PERS%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office 365 Personal 
IF /I "%CEPS_PROD_MSOFFHB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Home & Business 
IF /I "%CEPS_PROD_MSOFFHB19%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Home and Business 2019 (JP Only) 
IF /I "%CEPS_PROD_MSOFFHB19_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Home and Business 2019 (AFOLB) 
IF /I "%CEPS_PROD_MSOFFHO365_EM_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office 365 Home EM (AFOLB) 
IF /I "%CEPS_PROD_MSOFFHO365_LA_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office 365 Personal LATAM (AFOLB) 
IF /I "%CEPS_PROD_MSOFFHO365_MA_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office 365 Home (AFOLB) 
IF /I "%CEPS_PROD_MSOFFHS%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Home and Student 
IF /I "%CEPS_PROD_MSOFFHS19_AP_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Home and Student 2019 APAC (AFOLB) 
IF /I "%CEPS_PROD_MSOFFHS19_CH_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Home and Student 2019 China (AFOLB) 
IF /I "%CEPS_PROD_MSOFFHS19_EM_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Home and Student 2019 (EM) (AFOLB) 
IF /I "%CEPS_PROD_MSOFFHS19_IN_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Home and Student 2019 India (AFOLB) 
IF /I "%CEPS_PROD_MSOFFHS19_IO_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Home and Student 2019 Indonesia (AFOLB 
IF /I "%CEPS_PROD_MSOFFHS19_KR_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Home and Student 2019 Korea (AFOLB) 
IF /I "%CEPS_PROD_MSOFFHS19_LA_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Home and Student 2019 LATAM (AFOLB) 
IF /I "%CEPS_PROD_MSOFFHS19_MA_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Home and Student 2019 (AFOLB) 
IF /I "%CEPS_PROD_MSOFFHS19_ML_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Home and Student 2019 Malysia (AFOLB) 
IF /I "%CEPS_PROD_MSOFFHS19_PH_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Home and Student 2019 Philippines (AFOLB) 
IF /I "%CEPS_PROD_MSOFFHS19_TH_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Home and Student 2019 Thailand (AFOLB) 
IF /I "%CEPS_PROD_MSOFFHS19_VI_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Home and Student 2019 Vietnam (AFOLB) 
IF /I "%CEPS_PROD_MSOFFP19_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Professional 2019 (AFOLB) 
IF /I "%CEPS_PROD_MSOFFPER%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is MS Office Personal 
IF /I "%CEPS_PROD_MSOFFPER19%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is MS Office Personal 2019 (JP Only) 
IF /I "%CEPS_PROD_MSOFFPRE%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office Premium Family (JP Only) 
IF /I "%CEPS_PROD_MSOFFPRO%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is MS Office Professional Edition 
IF /I "%CEPS_PROD_MSOFFPRO19%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is MS Office Professional Edition 2019 (JP Only) 
IF /I "%CEPS_PROD_MSOFFPROPLUS%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft OFF PRO PLUS ( Install Microsoft Office pro plus NO License) 
IF /I "%CEPS_PROD_MSOFFSTA%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Microsoft Office 2010 Starter 
IF /I "%CEPS_AFO%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Activation for Office (AFO) 
IF /I "%CEPS_PROD_MSOFFNA%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Activation for Microsoft Office Professional 2021 National Academic (DA) 
IF /I "%CEPS_PROD_MSOFFNAEM%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Activation for Microsoft Office Professional 2021 National Academic (DA) (EM) 
IF /I "%CEPS_PROD_MSOFF365_PI_EM_LB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Activation for Microsoft Office 365 Personal Pilot EM (DA) 
IF /I "%CEPS_PROD_MSOFFMSNA%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Activation for Professional 2021 National Academic Japan  
IF /I "%CEPS_PROD_DA%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Digital Attach 
IF /I "%CEPS_PROD_OFF21_DIB%"=="1" ECHO [%DATE%] [%TIME%] Office Prod is Activation for MS office Japan 2021 DIB  
ECHO #########################################################################################
