pushd %~dp0
set logs=c:\system.sav\logs\CEPS\BTBHost
set logExportRegXML=%logs%\%~nx0.log

if exist BTBHost rmdir /S /Q BTBHost
md BTBHost

set LayoutModificationXML=C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml
set LayoutModificationJSON=C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.json
set TaskbarLayoutModificationXML=C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\TaskbarLayoutModification.xml

set srcEdgeTileFolder=C:\Users\Default\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\LocalState\PinnedTiles
set srcEdgeStableTileFolder=C:\Users\Default\AppData\Local\Packages\Microsoft.MicrosoftEdge.Stable_8wekyb3d8bbwe\LocalState\PinnedTiles
set dstEdgeTileFolder=Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\LocalState\PinnedTiles
set dstEdgeStableTileFolder=Packages\Microsoft.MicrosoftEdge.Stable_8wekyb3d8bbwe\LocalState\PinnedTiles

if exist %LayoutModificationXML% copy %LayoutModificationXML% "%~dp0\BTBHost\LayoutModification.xml" /y >> %logExportRegXML% 2>&1
if exist %LayoutModificationJSON% copy %LayoutModificationJSON% "%~dp0\BTBHost\LayoutModification.json" /y >> %logExportRegXML% 2>&1
if exist %TaskbarLayoutModificationXML% copy %TaskbarLayoutModificationXML% "%~dp0\BTBHost\TaskbarLayoutModification.xml" /y >> %logExportRegXML% 2>&1

if exist %srcEdgeTileFolder% xcopy /e/i/y/f %srcEdgeTileFolder% "%~dp0BTBHost\EdgeIcons\%dstEdgeTileFolder%" >> %logExportRegXML% 2>&1
if exist %srcEdgeStableTileFolder% xcopy /e/i/y/f %srcEdgeStableTileFolder% "%~dp0BTBHost\EdgeIcons\%dstEdgeStableTileFolder%" >> %logExportRegXML% 2>&1

if exist %srcEdgeTileFolder% xcopy /e/i/y/f %srcEdgeTileFolder% "%logs%\EdgeIcons\%dstEdgeTileFolder%" >> %logExportRegXML% 2>&1
if exist %srcEdgeStableTileFolder% xcopy /e/i/y/f %srcEdgeStableTileFolder% "%logs%\EdgeIcons\%dstEdgeStableTileFolder%" >> %logExportRegXML% 2>&1

setlocal enabledelayedexpansion
pushd RegSrc
for %%a in ( *.ini ) do (
	set count=0
	for /f "tokens=*" %%i in (%%a) do (
		reg export "%%i" %~dp0\BTBHost\%%a_!count!.reg >> %logExportRegXML% 2>&1
		call %~dp0\ReplaceString %~dp0\BTBHost\%%a_!count!.reg \SOFTWARE\ \SOFT\ >> %logExportRegXML% 2>&1
		set /a count=!count!+1
	)
)
popd
endlocal

popd
