@echo off

set CEPS_DPKType=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
	for /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
		If "%%a" == "DPK_Entry" (
        	Set DPK_Entry=%%b
    	)
    	If "%%a" == "DPK_GIFT" (
        	Set DPK_GIFT=%%b
    	)
    	If "%%a" == "DPK_High-End" (
        	Set DPK_HighEnd=%%b
    	)
    	If "%%a" == "DPK_KP" (
        	Set DPK_KP=%%b
    	)
    	If "%%a" == "DPK_ONED" (
        	Set DPK_ONED=%%b
    	)
    	If "%%a" == "DPK_PSEA" (
        	Set DPK_PSEA=%%b
    	)
    	If "%%a" == "DPK_SEA" (
        	Set DPK_PSEA=%%b
    	)
    	If "%%a" == "DPK_Step-up" (
        	Set DPK_Stepup=%%b
    	)
    	If "%%a" == "DPK_STI" (
        	Set DPK_STI=%%b
    	)
    	If "%%a" == "DPK_STR" (
        	Set DPK_STR=%%b
    	)
    	If "%%a" == "DPK_Value" (
        	Set DPK_Value=%%b
    	)
    	If "%%a" == "DPK_GIFT_BTS16" (
        	Set DPK_GIFT_BTS16=%%b
    	)
        If "%%a" == "DPK_ACha" (
            Set DPK_ACha=%%b
        )
        If "%%a" == "DPK_ADV" (
            Set DPK_ADV=%%b
        )
        If "%%a" == "DPK_AFPPP" (
            Set DPK_AFPPP=%%b
        )
        If "%%a" == "DPK_APAC" (
            Set DPK_APAC=%%b
        )
        If "%%a" == "DPK_CARE" (
            Set DPK_CARE=%%b
        )
        If "%%a" == "DPK_CBB16" (
            Set DPK_CBB16=%%b
        )
        If "%%a" == "DPK_COL" (
            Set DPK_COL=%%b
        )
        If "%%a" == "DPK_GIGA" (
            Set DPK_GIGA=%%b
        )
        If "%%a" == "DPK_IDPPP" (
            Set DPK_IDPPP=%%b
        )
        If "%%a" == "DPK_India" (
            Set DPK_India=%%b
        )
        If "%%a" == "DPK_IPPP" (
            Set DPK_IPPP=%%b
        )
        If "%%a" == "DPK_LTSB16" (
            Set DPK_LTSB16=%%b
        )
        If "%%a" == "DPK_LTSC18" (
            Set DPK_LTSC18=%%b
        )
        If "%%a" == "DPK_MSNA_STD" (
            Set DPK_MSNA_STD=%%b
        )
        If "%%a" == "DPK_SEASON" (
            Set DPK_SEASON=%%b
        )
        If "%%a" == "DPK_SLG" (
            Set DPK_SLG=%%b
        )
        If "%%a" == "DPK_VALUE2" (
            Set DPK_VALUE2=%%b
        )
        If "%%a" == "DPK_W10" (
            Set DPK_W10=%%b
        )
        If "%%a" == "DPK_WK6" (
            Set DPK_WK6=%%b
        )
        If "%%a" == "DPK_WK7" (
            Set DPK_WK7=%%b
        )
        If "%%a" == "DPK_WKS" (
            Set DPK_WKS=%%b
        )
        If "%%a" == "DPK_WKS2" (
            Set DPK_WKS2=%%b
        )
	)
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists

IF /I "%DPK_Entry%"=="1" Set "CEPS_DPKType=1" &Set CEPS_DPKTypeDec=ENTRY_SKU_Type
IF /I "%DPK_GIFT%"=="1" Set "CEPS_DPKType=2" &Set CEPS_DPKTypeDec=Gift_Card_for_Windows_10
IF /I "%DPK_HighEnd%"=="1" Set "CEPS_DPKType=3" &Set CEPS_DPKTypeDec=High_End_Type
IF /I "%DPK_KP%"=="1" Set "CEPS_DPKType=4" &Set CEPS_DPKTypeDec=IO_For_Korea_AFO_Special_deal
IF /I "%DPK_ONED%"=="1" Set "CEPS_DPKType=5" &Set CEPS_DPKTypeDec=one_drive
IF /I "%DPK_PSEA%"=="1" Set "CEPS_DPKType=6" &Set CEPS_DPKTypeDec=SEA_program_for_Windows_Pro
IF /I "%DPK_SEA%"=="1" Set "CEPS_DPKType=7" &Set CEPS_DPKTypeDec=SEAT_countries_special_deal
IF /I "%DPK_Stepup%"=="1" Set "CEPS_DPKType=8" &Set CEPS_DPKTypeDec=STEP_UP_SKU_Type
IF /I "%DPK_STI%"=="1" Set "CEPS_DPKType=9" &Set CEPS_DPKTypeDec=STICK_PC
IF /I "%DPK_STR%"=="1" Set "CEPS_DPKType=10" &Set CEPS_DPKTypeDec=windows_10_MSNA_Strategic
IF /I "%DPK_Value%"=="1" Set "CEPS_DPKType=11" &Set CEPS_DPKTypeDec=VALUE_SKU_type
IF /I "%DPK_GIFT_BTS16%"=="1" Set "CEPS_DPKType=12" &Set CEPS_DPKTypeDec=Gift_Card_for_Back_to_School_2016_for_Windows_10
IF /I "%DPK_ACha%"=="1" Set "CEPS_DPKType=13" &Set CEPS_DPKTypeDec=All_Chassis_NB_DT_AIO_TAB
IF /I "%DPK_ADV%"=="1" Set "CEPS_DPKType=14" &Set CEPS_DPKTypeDec=Advance_SKU
IF /I "%DPK_AFPPP%"=="1" Set "CEPS_DPKType=15" &Set CEPS_DPKTypeDec=Africa_Partner_Program_Premium
IF /I "%DPK_APAC%"=="1" Set "CEPS_DPKType=16" &Set CEPS_DPKTypeDec=APAC_Partner_Program_Premium
IF /I "%DPK_CARE%"=="1" Set "CEPS_DPKType=17" &Set CEPS_DPKTypeDec=Care_Covid_19_DPK
IF /I "%DPK_CBB16%"=="1" Set "CEPS_DPKType=18" &Set CEPS_DPKTypeDec=Windows_10_IoT_Enterprise_CBB
IF /I "%DPK_COL%"=="1" Set "CEPS_DPKType=19" &Set CEPS_DPKTypeDec=Collaboration_for_TEAM_IOT
IF /I "%DPK_GIGA%"=="1" Set "CEPS_DPKType=20" &Set CEPS_DPKTypeDec=WIN_10_PRO_NATL_ACAD
IF /I "%DPK_IDPPP%"=="1" Set "CEPS_DPKType=21" &Set CEPS_DPKTypeDec=Indonesia_Partner_Program_Premium
IF /I "%DPK_India%"=="1" Set "CEPS_DPKType=22" &Set CEPS_DPKTypeDec=DPK_for_India_only
IF /I "%DPK_IPPP%"=="1" Set "CEPS_DPKType=23" &Set CEPS_DPKTypeDec=India_Partner_Program_Premium
IF /I "%DPK_LTSB16%"=="1" Set "CEPS_DPKType=24" &Set CEPS_DPKTypeDec=Windows_10_LTSB_2016_SKU
IF /I "%DPK_LTSC18%"=="1" Set "CEPS_DPKType=25" &Set CEPS_DPKTypeDec=Windows_10_LTSC_2018_SKU
IF /I "%DPK_MSNA_STD%"=="1" Set "CEPS_DPKType=26" &Set CEPS_DPKTypeDec=DPK_MSNA_StF_Standard
IF /I "%DPK_SEASON%"=="1" Set "CEPS_DPKType=27" &Set CEPS_DPKTypeDec=SEASON_PROMO
IF /I "%DPK_SLG%"=="1" Set "CEPS_DPKType=28" &Set CEPS_DPKTypeDec=DPK_select_GEO
IF /I "%DPK_VALUE2%"=="1" Set "CEPS_DPKType=29" &Set CEPS_DPKTypeDec=VALUE_2_Sku_type
IF /I "%DPK_W10%"=="1" Set "CEPS_DPKType=30" &Set CEPS_DPKTypeDec=Digital_Product_Key_for_Windows_10
IF /I "%DPK_WK6%"=="1" Set "CEPS_DPKType=31" &Set CEPS_DPKTypeDec=Workstation_6_core
IF /I "%DPK_WK7%"=="1" Set "CEPS_DPKType=32" &Set CEPS_DPKTypeDec=Workstation_plus_6_core
IF /I "%DPK_WKS%"=="1" Set "CEPS_DPKType=33" &Set CEPS_DPKTypeDec=Workstation_tier_1
IF /I "%DPK_WKS2%"=="1" Set "CEPS_DPKType=34" &Set CEPS_DPKTypeDec=Workstation_tier_2

ECHO [%DATE%] [%TIME%] Digital Product Key type is %CEPS_DPKTypeDec%(%CEPS_DPKType%)