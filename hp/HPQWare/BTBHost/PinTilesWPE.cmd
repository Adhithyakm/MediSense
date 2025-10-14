::Import tile reg info in WinPE
:: dj 2013-07

if exist %UPDriveLetter%\system.sav\util\SetVariables.cmd Call %UPDriveLetter%\system.sav\util\SetVariables.cmd
pushd %~dp0

set asgMetroLogSpec=%UPDriveLetter%\system.sav\logs\CEPS\BTBHost\asgmetro.log
echo Run PinTilesWPE >>%asgMetroLogSpec%

reg load HKLM\SOFT %UPDriveLetter%\windows\system32\config\SOFTWARE>> %asgMetroLogSpec% 2>&1

echo reg import "%~dp0metroWinPE.reg" >>%asgMetroLogSpec%
reg import "%~dp0metroWinPE.reg">> %asgMetroLogSpec% 2>&1
if NOT "%R_MIC%"=="1" (
	echo adding OEM tile promotion to registry >>%asgMetroLogSpec%
	reg add HKLM\SOFT\Microsoft\Windows\CurrentVersion\Explorer\SVDEn /v "PromoteOEMTiles" /t REG_DWORD /d 1 /f >> %asgMetroLogSpec% 2>&1
)
echo unload HKLM\SOFT >>%asgMetroLogSpec%
reg unload HKLM\SOFT>> %asgMetroLogSpec% 2>&1

popd