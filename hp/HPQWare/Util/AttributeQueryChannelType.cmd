@Echo off

set CEPS_ChannelType=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
  For /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
    If "%%a" == "Chan" (
        Set Chan=%%b
    ) else Set "CEPS_ChannelType=0" &Set "CEPS_ChannelType_Name=Default"
  )
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists 

IF /I "%Chan%"=="CTO" Set "CEPS_ChannelType=1" &Set CEPS_ChannelType_Name=CTO_Channel
IF /I "%Chan%"=="Retail" Set "CEPS_ChannelType=2" &Set CEPS_ChannelType_Name=BTO_Channel
IF /I "%Chan%"=="Refurb" Set "CEPS_ChannelType=3" &Set CEPS_ChannelType_Name=Refurb_Channel(Not_on_RStone)

IF /I NOT "%Chan%"=="CTO" IF /I NOT "%Chan%"=="Retail" IF /I NOT "%Chan%"=="Refurb" Set "CEPS_ChannelType=0" &Set CEPS_ChannelType_Name=No_ChannelType

ECHO [%DATE%] [%TIME%] Channel Type is "%CEPS_ChannelType%" (%CEPS_ChannelType_Name%)