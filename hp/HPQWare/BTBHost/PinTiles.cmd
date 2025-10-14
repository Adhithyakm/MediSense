::BtBHost TilePin
if exist c:\system.sav\util\SetVariables.cmd Call c:\system.sav\util\SetVariables.cmd

if exist C:\hp\HPQware\Metro\All\All\Metro.reg %windir%\Regedit.exe /s C:\hp\HPQware\Metro\All\All\Metro.reg >>C:\system.sav\logs\CEPS\BTBHost\asgmetro.log 2>&1
echo errorlevel returned by regedit is "%errorlevel%">>C:\system.sav\logs\BTBHost\asgmetro.log
if NOT "%R_MIC%"=="1" (
	echo adding OEM tile promotion to registry >>C:\system.sav\logs\CEPS\BTBHost\asgmetro.log
	reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\SVDEn /v "PromoteOEMTiles" /t REG_DWORD /d 1 /f >>C:\system.sav\logs\CEPS\BTBHost\asgmetro.log 2>&1
)
reg export HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SVDEn c:\system.sav\logs\BTBHost\asgmetro.reg /y >>C:\system.sav\logs\CEPS\BTBHost\asgmetro.log 2>&1