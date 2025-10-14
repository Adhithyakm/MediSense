set customLogSpec=c:\system.sav\logs\CEPS\BTBHost\customData2pp.log

echo==========%date% %time% BtBCustomData start==========>>%customLogSpec%
pushd %~dp0
echo Working dir is %CD%>>%customLogSpec%

if exist c:\system.sav\util\TDCsetVariables.cmd call c:\system.sav\util\TDCsetVariables.cmd
if exist c:\system.sav\util\setVariables.cmd call c:\system.sav\util\setVariables.cmd
c:\system.sav\util\WizInstaller.exe c:\system.sav\util\2postprocess\customdata\customData.ini>>c:\system.sav\logs\CEPS\BTBHost\WizInstaller.log

reg export "HKLM\SOFTWARE\HP\System Properties" c:\system.sav\logs\CEPS\BTBHost\Reg.SysProp.log /y >>%customLogSpec% 2>&1
reg export "HKLM\SOFTWARE\HP\CommonInfo" c:\system.sav\logs\CEPS\BTBHost\Reg.CommonInfo.log /y >>%customLogSpec% 2>&1

rd /s/q customdata
echo==========%date% %time% BtBCustomData end==========>>%customLogSpec%