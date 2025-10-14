@Echo off

set CEPS_ChannelID=CEPS_UtilityFail
set CEPS_ChannelDec=CEPS_UtilityFail
set CEPS_RetailID=CEPS_UtilityFail
set CEPS_RetailDec=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
  For /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
    If "%%a" == "R_AMZ" (
        Set R_AMZ=%%b
    )
    If "%%a" == "R_BBPCol" (
        Set R_BBPCol=%%b
    )
    If "%%a" == "R_BBYBL" (
        Set R_BBYBL=%%b
    )
    If "%%a" == "BBUY" (
        Set BBUY=%%b
    )
    If "%%a" == "R_Cloud" (
        Set R_Cloud=%%b
    )
    If "%%a" == "R_CostCo" (
        Set R_CostCo=%%b
    )
    If "%%a" == "R_CTO" (
        Set R_CTO=%%b
    )
    If "%%a" == "R_DIX" (
        Set R_DIX=%%b
    )
    If "%%a" == "R_EDI" (
        Set R_EDI=%%b
    )
    If "%%a" == "R_EE" (
        Set R_EE=%%b
    )
    If "%%a" == "R_ELKJOP" (
        Set R_ELKJOP=%%b
    )
    If "%%a" == "R_ENTRDY" (
        Set R_ENTRDY=%%b
    )
    If "%%a" == "R_FAPPS" (
        Set R_FAPPS=%%b
    )
    If "%%a" == "R_FNAC" (
        Set R_FNAC=%%b
    )
    If "%%a" == "R_Optus" (
        Set R_Optus=%%b
    )
    If "%%a" == "R_PPR" (
        Set R_PPR=%%b
    )
    If "%%a" == "R_QVC" (
        Set R_QVC=%%b
    )
    If "%%a" == "R_SAM" (
        Set R_SAM=%%b
    )
    If "%%a" == "R_SE" (
        Set R_SE=%%b
    )
    If "%%a" == "R_sprint" (
        Set R_sprint=%%b
    )
    If "%%a" == "R_target" (
        Set R_target=%%b
    )
    If "%%a" == "R_TMO" (
        Set R_TMO=%%b
    )
    If "%%a" == "R_Veri" (
        Set R_Veri=%%b
    )
    If "%%a" == "R_VR" (
        Set R_VR=%%b
    )
    If "%%a" == "R_WM" (
        Set R_WM=%%b
    )
    If "%%a" == "R_ZHRPC" (
        Set R_ZHRPC=%%b
    )
    If "%%a" == "SL.PRE" (
        Set SL.PRE=%%b
    )
    If "%%a" == "R_STD" (
        Set R_STD=%%b
    )
    If "%%a" == "R_MIC" (
        Set R_MIC=%%b
    )
    If "%%a" == "R_CMCC" (
        Set R_CMCC=%%b
    )             
  )
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists

IF /I "%BBUY%"=="1" Set "CEPS_ChannelID=02" &Set "CEPS_ChannelDec=Retailer Best Buy"
IF /I "%R_WM%"=="1" Set "CEPS_ChannelID=03" &Set "CEPS_ChannelDec=Retailer Walmart"
IF /I "%R_AMZ%"=="1" Set "CEPS_ChannelID=0B" &Set "CEPS_ChannelDec=Retailer Amazon"
IF /I "%R_TMO%"=="1" Set "CEPS_ChannelID=0D" &Set "CEPS_ChannelDec=Retailer TMobile"
IF /I "%R_CostCo%"=="1" Set "CEPS_ChannelID=14" &Set "CEPS_ChannelDec=Retailer Costco"
IF /I "%R_SAM%"=="1" Set "CEPS_ChannelID=21" &Set "CEPS_ChannelDec=Retail Sams Club"
IF /I "%BBUY%"=="1" IF /I "%SL.PRE%"=="1" Set "CEPS_ChannelID=22" &Set "CEPS_ChannelDec=Retailer Best Buy and Premium Load"
IF /I "%R_FNAC%"=="1" Set "CEPS_ChannelID=23" &Set "CEPS_ChannelDec=Retailer Fnac"
IF /I "%R_BBYBL%"=="1" Set "CEPS_ChannelID=26" &Set "CEPS_ChannelDec=Retailer Best Buy Blue Label"
IF /I "%R_DIX%"=="1" Set "CEPS_ChannelID=27" &Set "CEPS_ChannelDec=Retailer Dixons"
IF /I "%R_ELKJOP%"=="1" Set "CEPS_ChannelID=28" &Set "CEPS_ChannelDec=Retailer ELKJOP"
IF /I "%R_Veri%"=="1" Set "CEPS_ChannelID=29" &Set "CEPS_ChannelDec=Retailer Verizon"
IF /I "%R_EDI%"=="1" Set "CEPS_ChannelID=30" &Set "CEPS_ChannelDec=Retailer Edianzu"
IF /I "%R_CMCC%"=="1" Set "CEPS_ChannelID=31" &Set "CEPS_ChannelDec=China Mobile Communications Corporation"
IF /I "%BBUY%" NEQ "1" IF /I "%R_WM%" NEQ "1" IF /I "%R_AMZ%" NEQ "1" IF /I "%R_TMO%" NEQ "1" IF /I "%R_CostCo%" NEQ "1" IF /I "%R_SAM%" NEQ "1" IF /I "%R_FNAC%" NEQ "1" IF /I "%R_MIC%" NEQ "1" IF /I "%R_BBYBL%" NEQ "1" IF /I "%R_DIX%" NEQ "1" IF /I "%R_ELKJOP%" NEQ "1" IF /I "%R_Veri%" NEQ "1" IF /I "%R_EDI%" NEQ "1" IF /I "%R_CMCC%" NEQ "1" Set "CEPS_ChannelID=00" &Set "CEPS_ChannelDec=NA"

REM Remove those install options not used in RStone.ini
REM IF /I "%R_BBPCol%"=="1" Set "CEPS_ChannelID=31" &Set CEPS_ChannelDec=Retail_Best_Buy_Pre_College
REM IF /I "%R_Cloud%"=="1" Set "CEPS_ChannelID=32" &Set CEPS_ChannelDec=Cloud_DT_on_AWS
REM IF /I "%R_CTO%"=="1" Set "CEPS_ChannelID=33" &Set CEPS_ChannelDec=Retail_WK_CTO
REM IF /I "%R_EE%"=="1" Set "CEPS_ChannelID=34" &Set CEPS_ChannelDec=Retail_EE
REM IF /I "%R_FAPPS%"=="1" Set "CEPS_ChannelID=36" &Set CEPS_ChannelDec=Retail_to_Enable_Remove_Application
REM IF /I "%R_Optus%"=="1" Set "CEPS_ChannelID=37" &Set CEPS_ChannelDec=Retail_Optus
REM IF /I "%R_PPR%"=="1" Set "CEPS_ChannelID=38" &Set CEPS_ChannelDec=Ebay_Test_For_US
REM IF /I "%R_QVC%"=="1" Set "CEPS_ChannelID=39" &Set CEPS_ChannelDec=Retail_QVC
REM IF /I "%R_SE%"=="1" Set "CEPS_ChannelID=40" &Set CEPS_ChannelDec=Retail_Special_Edition
REM IF /I "%R_sprint%"=="1" Set "CEPS_ChannelID=41" &Set CEPS_ChannelDec=Retail_Sprint
REM IF /I "%R_target%"=="1" Set "CEPS_ChannelID=42" &Set CEPS_ChannelDec=Retail_Target
REM IF /I "%R_VR%"=="1" Set "CEPS_ChannelID=43" &Set CEPS_ChannelDec=Retail_Virtual_Reality
REM IF /I "%R_ZHRPC%"=="1" Set "CEPS_ChannelID=44" &Set CEPS_ChannelDec=China_Rural_PC_Flag

IF /I "%R_STD%"=="1" Set "CEPS_RetailID=1" &Set "CEPS_RetailDec=Retail Standard"
IF /I "%R_MIC%"=="1" Set "CEPS_RetailID=2" &Set "CEPS_RetailDec=Retail Microsoft Signature"
IF /I "%R_ENTRDY%"=="1" Set "CEPS_RetailID=3" &Set "CEPS_RetailDec=Enterprise Ready Image"
IF /I "%R_STD%" NEQ "1" IF /I "%R_MIC%" NEQ "1" IF /I "%R_ENTRDY%" NEQ "1" Set "CEPS_RetailID=0" &Set "CEPS_RetailDec=NA"

ECHO [%DATE%] [%TIME%] Channel ID is "%CEPS_ChannelID%" (%CEPS_ChannelDec%)
ECHO [%DATE%] [%TIME%] Retail ID is "%CEPS_RetailID%" (%CEPS_RetailDec%)
