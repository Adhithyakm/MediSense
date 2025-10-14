@Echo off

set CEPS_BrandName=CEPS_UtilityFail
set CEPS_BrandName_Alias=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
  For /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
    If "%%a" == "SEG.CON" (
        Set SEG.CON=%%b
    )
    If "%%a" == "SL.PRE" (
        Set SL.PRE=%%b
    )
    If "%%a" == "SEG.SBSO" (
        Set SEG.SBSO=%%b
    )
    If "%%a" == "SL.MAI" (
        Set SL.MAI=%%b
    )
    If "%%a" == "SL.AIO" (
        Set SL.AIO=%%b
    )
    If "%%a" == "SL.BUD" (
        Set SL.BUD=%%b
    )
    If "%%a" == "SEG.PRM" (
        Set SEG.PRM=%%b
    )     
    If "%%a" == "SL.GAM" (
        Set SL.GAM=%%b
    ) 
    If "%%a" == "CT.NB" (
        Set CT.NB=%%b
    ) 
    If "%%a" == "CT.TAB" (
        Set CT.TAB=%%b
    )
    If "%%a" == "SEG.ENT" (
        Set SEG.ENT=%%b
    )
    If "%%a" == "SEG.WKS" (
        Set SEG.WKS=%%b
    )            
  )
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists 

IF /I "%SEG.CON%"=="1" IF /I "%SL.PRE%"=="1" Set "CEPS_BrandName=ENVY" &Set "CEPS_BrandName_Alias=ENVY"
IF /I "%SEG.CON%"=="1" IF /I "%SL.AIO%"=="1" Set "CEPS_BrandName=EnvyAIO" &Set "CEPS_BrandName_Alias=EnvyAIO"
IF /I "%SEG.CON%"=="1" IF /I "%SL.MAI%"=="1" Set "CEPS_BrandName=Pavilion" &Set "CEPS_BrandName_Alias=Pavilion"
IF /I "%SEG.CON%"=="1" IF /I "%SL.BUD%"=="1" Set "CEPS_BrandName=OPP" &Set "CEPS_BrandName_Alias=HPC"
IF /I "%SEG.PRM%"=="1" IF /I "%SL.PRE%"=="1" Set "CEPS_BrandName=Premium" &Set "CEPS_BrandName_Alias=Premium"
IF /I "%SEG.PRM%"=="1" IF /I "%SL.GAM%"=="1" Set "CEPS_BrandName=OMEN" &Set "CEPS_BrandName_Alias=OMEN"
IF /I "%SEG.CON%"=="1" IF /I "%SL.GAM%"=="1" Set "CEPS_BrandName=PavilionGaming" &Set "CEPS_BrandName_Alias=VICTUS"
IF /I "%SEG.ENT%"=="1" IF /I "%SL.PRE%"=="1" Set "CEPS_BrandName=EnterprisePremium" &Set "CEPS_BrandName_Alias=Commercial Premium"
IF /I "%SEG.WKS%"=="1" IF /I "%SL.MAI%"=="1" Set "CEPS_BrandName=WorkStation" &Set "CEPS_BrandName_Alias=Commercial Workstation"
IF /I "%SEG.SBSO%"=="1" IF /I "%SL.MAI%"=="1" Set "CEPS_BrandName=SBSO" &Set "CEPS_BrandName_Alias=HPB"

ECHO [%DATE%] [%TIME%] Brand Name is "%CEPS_BrandName%"
ECHO [%DATE%] [%TIME%] Brand Alias Name is "%CEPS_BrandName_Alias%"