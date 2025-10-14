
copy /y c:\system.sav\util\Rstone_PININST.ini c:\hp\bin\RStonePost.ini
echo. >> c:\system.sav\logs\CEPS\BTBHost\wizinstaller.log
echo %date% %time% BtBHost postUser begin>> c:\system.sav\logs\CEPS\BTBHost\wizinstaller.log
call c:\hp\hpqware\BtBHost\PostWizInstaller.bat
echo %date% %time% BtBHost postUser finish>> c:\system.sav\logs\CEPS\BTBHost\wizinstaller.log
