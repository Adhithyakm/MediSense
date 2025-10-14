setlocal enabledelayedexpansion
pushd %~dp0
if exist c:\system.sav\util\SetVariables.cmd Call c:\system.sav\util\SetVariables.cmd
if exist c:\system.sav\util\TDCSetVariables.cmd Call c:\system.sav\util\TDCSetVariables.cmd

set log=\system.sav\logs\CEPS\BTBHost
if not exist %log% md %log%
set logSpec=%log%\customData2pp.log

echo ============%0 Start %Date% %Time% =======================>>%logSpec%

FOR /F "tokens=3" %%A IN ('REG QUERY "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v BaseBoardProduct') DO SET SystemBoardProductId=%%A
set release=231

:: Default to nonexclusive
set devseller=NONX

if "%BBUY%"=="1" set devseller=BBUY
if "%R_COSTCO%"=="1" set devseller=COST
if "%R_WM%"=="1" set devseller=WLMT
if "%R_SAM%"=="1" set devseller=SAMS

if /I "%ChannelId%"=="02" set devseller=BBUY
if /I "%ChannelId%"=="22" set devseller=BBUY
if /I "%ChannelId%"=="03" set devseller=WLMT
if /I "%ChannelId%"=="14" set devseller=COST
if /I "%ChannelId%"=="21" set devseller=SAMS

:: Legacy, not sure who consumes pcseller
set pcseller=-1
if /I "%WallpaperID%"=="16" set pcseller=004
if /I "%ChannelId%"=="2" set pcseller=004
if /I "%ChannelId%"=="10" set pcseller=004
if /I "%BBUY%"=="1" set pcseller=004

echo ====================%date% %time%  Setup Half-Cover=================>>%logSpec%
set HalfCover=0
For /f "tokens=1,2 usebackq delims='='" %%a in (C:\HP\Bin\RStone.INI) do (
	If "%%a" == "Half-cover" Set HalfCover=%%b	
)
echo ====================%date% %time%  Finish Setup Half-Cover:%HalfCover%=================>>%logSpec%

echo ====================%date% %time%  Write BuildID begin =================>>%logSpec%
set dpsPath=""
for /f "tokens=*" %%a in ('dir c:\system.sav\*_DPS /b /s') do set dpsPath=%%a
if exist %dpsPath% (
	echo Try to parse %dpsPath% ... >> %logSpec%
	for /f "tokens=1,2 eol=: delims==" %%a in ( %dpsPath% ) do if "%%a"=="; BuildID" set BuildIDFromDPS=%%b
)
for /l %%a in (1,1,100) do if "!BuildIDFromDPS:~-1!"==" " set BuildIDFromDPS=!BuildIDFromDPS:~0,-1!

if not exist %dpsPath% (
	echo Cannot find c:\system.sav\*_DPS >> %logSpec%
) else if not exist c:\system.sav\flags\BtBDisableJSKey.flg (
	if defined BuildIDFromDPS (
		echo Write BuildIDFromDPS="!BuildIDFromDPS!" to registry >> %logSpec%
		reg add "HKLM\Software\HP\System Properties" /v "BuildID" /t REG_SZ /d !BuildIDFromDPS! /f >> %logSpec% 2>&1
	) else (
		echo Cannot find BuildIDFromDPS in %dpsPath%>> %logSpec%
	)
) else (
	echo BtBDisableJSKey.flg found, ignore to write BuildIDFromDPS="!BuildIDFromDPS!" to registry>> %logSpec%
)
echo ====================%date% %time%  Write BuildID finish =================>>%logSpec%

set  >>%logSpec%
echo ============BTBHost2pp %Date% %Time% =======================>>%logSpec%

call c:\HP\HPQware\BTBHost\QueryWMI.vbs 
call c:\HP\HPQware\BTBHost\CheckAudioBrand.bat >>%logSpec%
call c:\HP\HPQware\BTBHost\SetCustomVars.bat 

echo AudioBrand=%AudioBrand% >>%logSpec%
set MSSI=0
if exist c:\system.sav\flags\BtBR_MIC.flg set MSSI=1
echo MSSI=%MSSI% >>%logSpec%

C:\hp\hpqware\BTBHost\SetEnv.exe /E OnlineServices=%OnlineServices% /P platform=%Platform%,platformcode=%PlatformCode%,release=%Release%,productnumber=%ProductNumber%,modelnumber=%ModelNumber%,serialnumber=%SerialNumber%,OSBit=%OSHAL%,pcseller=%pcseller%,productname=%productname%,buildtype=%buildType%,UUID=%SystemGUID%,systemfamily=%SystemFamily%,,systemboardproductid=%SystemBoardProductId%,brand=%brand%,subbrand=%subbrand%,hardwaretype=%hardwaretype%,segment=%segment%,WinOSMajor=%WinOSMajor%,WinOSMinor=%WinOSMinor%,WinOSSPMajor=%WinOSSPMajor%,WinOSSPMinor=%WinOSSPMinor%,WinOSProductType=%WinOSProductType%,WinOSBuild=%WinOSBuild%,devseller=%devseller%,Half-Cover=%HalfCover%,MSSI=%MSSI% /U

C:\hp\hpqware\BTBHost\SetEnv.exe /R @path=CommonInfo,Country=%ISO_COUNTRY%,Language=%ISO_UILG%,Channel=%Channel%,PlatformCode=%PlatformCode%,ProductName=%productname%,ProductNumber=%ProductNumber%,Release=%Release%,CPUBrandName=%CPUBrandName%,CPUFullName=%CPUFullName%,Segment=%segment%,SerialNumber=%SerialNumber%,SystemBoardProductId=%SystemBoardProductId%,UUID=%SystemGUID%,BuildID=!BuildIDFromDPS!,TouchPanel=%TouchPanel%,ScreenWidth=%ScreenW%,ScreenHeight=%ScreenH%,WinOSBuild=%WinOSBuild%,WinOSMajor=%WinOSMajor%,WinOSMinor=%WinOSMinor%,WinOSProductType=%WinOSProductType%,GPUBrandName=%GPUBrandName%,GPUFullName=%GPUFullName%,AudioBrand=%AudioBrand%
popd

echo ====================%date% %time%  Begin  BTBHost2pp Getlocale =================>>%logSpec%
C:\HP\HPQWare\BTBHost\Getlocale.exe
call C:\HP\HPQware\setlocale.bat
type C:\HP\HPQware\setlocale.bat >>%logSpec%
echo ====================%date% %time%  Begin  BTBHost2pp Getlocale =================>>%logSpec%

set HandleIETask=0
if "%Vos.CL%"=="1" set HandleIETask=1
echo Vos.CL=%Vos.CL% >>%logSpec%
if "%S_Mode%"=="1" set HandleIETask=1
echo S_Mode=%S_Mode% >>%logSpec%
if "%CloudOS%"=="1" set HandleIETask=1
echo CloudOS=%CloudOS% >>%logSpec%
if exist c:\system.sav\flags\W10RS2Cloud.FLG set HandleIETask=1
if exist c:\system.sav\flags\W10RS2Cloud.FLG echo c:\system.sav\flags\W10RS2Cloud.FLG exist >>%logSpec%

echo HandleIETask=%HandleIETask% >>%logSpec%
if not "%HandleIETask%"=="1" goto END

echo ====================%date% %time%  Begin  BTBHost2pp IE Search for CloudOS =================>>%logSpec%

if exist C:\hp\HPQware\browser\All\All\IESearch.reg (
	echo %date% %time% .\browser\All\All\IESearch.reg >>%logSpec%
	regedit -s C:\hp\HPQware\browser\All\All\IESearch.reg >>%logSpec%
)
if exist C:\hp\HPQware\browser\%ISO_UILGCTRY%\All\IESearch.reg (
	echo %date% %time% .\browser\%ISO_UILGCTRY%\All\IESearch.reg >>%logSpec%
	regedit -s C:\hp\HPQware\browser\%ISO_UILGCTRY%\All\IESearch.reg >>%logSpec%
)
if exist C:\hp\HPQware\browser\All\%ISO_COUNTRY3%\IESearch.reg (
	echo %date% %time% .\browser\All\%ISO_COUNTRY3%\IESearch.reg >>%logSpec%
	regedit -s C:\hp\HPQware\browser\All\%ISO_COUNTRY3%\IESearch.reg >>%logSpec%
)
if exist C:\hp\HPQware\browser\%ISO_UILGCTRY%\%ISO_COUNTRY3%\IESearch.reg (
	echo %date% %time% .\browser\%ISO_UILGCTRY%\%ISO_COUNTRY3%\IESearch.reg >>%logSpec%
	regedit -s C:\hp\HPQware\browser\%ISO_UILGCTRY%\%ISO_COUNTRY3%\IESearch.reg >>%logSpec%
)
if exist C:\hp\HPQware\browser\All\All\IESearch_Amazon.reg (
	echo %date% %time% .\browser\All\All\IESearch_Amazon.reg >>%logSpec%
	regedit -s C:\hp\HPQware\browser\All\All\IESearch_Amazon.reg >>%logSpec%
)

echo ====================%date% %time%  Finish BTBHost2pp IE Search for CloudOS =================>>%logSpec%

echo ====================%date% %time%  Copy IE Fav for CloudOS begin =================>>%logSpec%
if exist "c:\hp\hpqware\Favs\All\All" (
	echo Copy IE Favorite from c:\hp\hpqware\Favs\All\All for Windows ARM/CloudOS >>%logSpec%
	xcopy /e/i/y/f "c:\hp\hpqware\Favs\All\All" "C:\Users\Default\Favorites\" >>%logSpec% 2>&1
)

if exist "c:\hp\hpqware\Favs\All\%ISO_COUNTRY3%" (
	echo Copy IE Favorite from c:\hp\hpqware\Favs\All\%ISO_COUNTRY3% for Windows ARM/CloudOS >>%logSpec%
	xcopy /e/i/y/f "c:\hp\hpqware\Favs\All\%ISO_COUNTRY3%" "C:\Users\Default\Favorites" >>%logSpec% 2>&1
) else (
	echo No default country IE favorite for copying >>%logSpec%
)
echo ====================%date% %time%  Copy IE Fav for CloudOS end =================>>%logSpec%

echo ====================%date% %time%  BTBHost2pp IE Favorite Bar for CloudOS =================>>%logSpec%
if exist c:\system.sav\flags\BtBR_MIC.flg goto NOIEFAV
if exist c:\system.sav\logs\DisableIEFav.flg goto NOIEFAV	
If exist c:\system.sav\flags\mssign.flg goto NOIEFAV

echo "Enable IE Bar" >>%logSpec%
reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\MINIE" /v LinksBandEnabled /t REG_DWORD /d 1 /f >> %logSpec% 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Feeds" /v SyncStatus /t REG_DWORD /d 1 /f >> %logSpec% 2>&1
reg load HKLM\DefaultUser c:\users\default\ntuser.dat >> %logSpec% 2>&1
reg add "HKLM\DefaultUser\SOFTWARE\Microsoft\Internet Explorer\MINIE" /v LinksBandEnabled /t REG_DWORD /d 1 /f >> %logSpec% 2>&1
reg add "HKLM\DefaultUser\SOFTWARE\Microsoft\Feeds" /v SyncStatus /t REG_DWORD /d 1 /f >> %logSpec% 2>&1
reg unload HKLM\DefaultUser

:NOIEFAV
if exist c:\system.sav\flags\BtBR_MIC.flg (
	echo "Disable IE Bar" >>%logSpec%
	reg load HKU\DEFAULTTEMP c:\users\default\ntuser.dat
	reg unload HKU\DEFAULTTEMP
)

If exist "c:\system.sav\flags\mssign.flg" (
	echo "Disable IE Bar" >>%logSpec%
	reg load HKU\DEFAULTTEMP c:\users\default\ntuser.dat
	regedit /s "c:\hp\hpqware\btbhost\Signature\IE_Settings.reg"
	reg unload HKU\DEFAULTTEMP
)

echo ====================%date% %time%  Finish BTBHost2pp IE Favorite Bar for ARM/CloudOS =================>>%logSpec%

:END
echo ============%0 End %Date% %Time% =======================>>%logSpec%
endlocal