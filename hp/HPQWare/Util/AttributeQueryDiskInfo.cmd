@echo off

set CEPS_PrimaryDiskId=CEPS_UtilityFail
set CEPS_PrimaryDiskModel=CEPS_UtilityFail
set CEPS_PrimaryDiskType=CEPS_UtilityFail
set CEPS_PrimaryDiskTypeName=CEPS_UtilityFail
set CEPS_PrimaryDiskSizeInGB=CEPS_UtilityFail
set CEPS_PrimaryDiskBusType=CEPS_UtilityFail
set CEPS_PrimaryDiskBusTypeName=CEPS_UtilityFail
set CEPS_SecondaryDiskId=CEPS_UtilityFail
set CEPS_SecondaryDiskModel=CEPS_UtilityFail
set CEPS_SecondaryDiskType=CEPS_UtilityFail
set CEPS_SecondaryDiskTypeName=CEPS_UtilityFail
set CEPS_SecondaryDiskSizeInGB=CEPS_UtilityFail
set CEPS_SecondaryDiskBusType=CEPS_UtilityFail
set CEPS_SecondaryDiskBusTypeName=CEPS_UtilityFail

ECHO [%DATE%] [%TIME%] Disk Info

for /f "delims=" %%i in ('call %~dp0WMIQuery.exe "root\Microsoft\Windows\Storage" "SELECT * FROM MSFT_Disk WHERE BootFromDisk=true" "Number"') do (
    for /f "tokens=1,2 delims==" %%a in ("%%~i") do (
        if /i "%%~a" == "Number" (set "CEPS_PrimaryDiskId=%%~b") else (set "CEPS_PrimaryDiskId=")
    )
)
if not defined CEPS_PrimaryDiskId ECHO Could not found the primary boot disk. &GOTO:eof

for /f "delims=" %%i in ('call %~dp0WMIQuery.exe "root\Microsoft\Windows\Storage" "SELECT * FROM MSFT_PhysicalDisk WHERE DeviceId=%CEPS_PrimaryDiskId%" "Model"') do (
    for /f "tokens=1,2 delims==" %%a in ("%%~i") do (
       	if /i "%%~a" == "Model" (set "CEPS_PrimaryDiskModel=%%~b") else (set "CEPS_PrimaryDiskModel=")
    )
)

for /f "delims=" %%i in ('call %~dp0WMIQuery.exe "root\Microsoft\Windows\Storage" "SELECT * FROM MSFT_PhysicalDisk WHERE DeviceId=%CEPS_PrimaryDiskId%" "MediaType"') do (
    for /f "tokens=1,2 delims==" %%a in ("%%~i") do (
       	if /i "%%~a" == "MediaType" (set "CEPS_PrimaryDiskType=%%~b") else (set "CEPS_PrimaryDiskType=")
    )
)

for /f "delims=" %%i in ('call %~dp0WMIQuery.exe "root\Microsoft\Windows\Storage" "SELECT * FROM MSFT_PhysicalDisk WHERE DeviceId=%CEPS_PrimaryDiskId%" "BusType"') do (
    for /f "tokens=1,2 delims==" %%a in ("%%~i") do (
       	if /i "%%~a" == "BusType" (set "CEPS_PrimaryDiskBusType=%%~b") else (set "CEPS_PrimaryDiskBusType=")
    )
)

for /f "delims=" %%i in ('call %~dp0WMIQuery.exe "root\Microsoft\Windows\Storage" "SELECT * FROM MSFT_PhysicalDisk WHERE DeviceId=%CEPS_PrimaryDiskId%" "Size" ') do (
    for /f "tokens=1,2 delims==" %%a in ("%%~i") do (
       	if /i "%%~a" == "Size" (set "CEPS_PrimaryDiskSizeInGB=%%~b") else (set "CEPS_PrimaryDiskSizeInGB=")
    )
)

REM Truncate last three digits because it seems to be overflow
set CEPS_PrimaryDiskSizeInGB=%CEPS_PrimaryDiskSizeInGB:~0,-3%
REM Divide disk size by 1024*1024
set /a CEPS_PrimaryDiskSizeInGB = "CEPS_PrimaryDiskSizeInGB>>20"

REM mapping table for Bus Type
IF /I "%CEPS_PrimaryDiskBusType%"=="0" Set CEPS_PrimaryDiskBusTypeName=Unknown
IF /I "%CEPS_PrimaryDiskBusType%"=="1" Set CEPS_PrimaryDiskBusTypeName=SCSI
IF /I "%CEPS_PrimaryDiskBusType%"=="2" Set CEPS_PrimaryDiskBusTypeName=ATAPI
IF /I "%CEPS_PrimaryDiskBusType%"=="3" Set CEPS_PrimaryDiskBusTypeName=ATA
IF /I "%CEPS_PrimaryDiskBusType%"=="4" Set CEPS_PrimaryDiskBusTypeName=1394
IF /I "%CEPS_PrimaryDiskBusType%"=="5" Set CEPS_PrimaryDiskBusTypeName=SSA
IF /I "%CEPS_PrimaryDiskBusType%"=="6" Set CEPS_PrimaryDiskBusTypeName=Fibre Channel
IF /I "%CEPS_PrimaryDiskBusType%"=="7" Set CEPS_PrimaryDiskBusTypeName=USB
IF /I "%CEPS_PrimaryDiskBusType%"=="8" Set CEPS_PrimaryDiskBusTypeName=RAID
IF /I "%CEPS_PrimaryDiskBusType%"=="9" Set CEPS_PrimaryDiskBusTypeName=iSCSI
IF /I "%CEPS_PrimaryDiskBusType%"=="10" Set CEPS_PrimaryDiskBusTypeName=SAS
IF /I "%CEPS_PrimaryDiskBusType%"=="11" Set CEPS_PrimaryDiskBusTypeName=SATA
IF /I "%CEPS_PrimaryDiskBusType%"=="12" Set CEPS_PrimaryDiskBusTypeName=SD
IF /I "%CEPS_PrimaryDiskBusType%"=="13" Set CEPS_PrimaryDiskBusTypeName=MMC
IF /I "%CEPS_PrimaryDiskBusType%"=="14" Set CEPS_PrimaryDiskBusTypeName=Virtual
IF /I "%CEPS_PrimaryDiskBusType%"=="15" Set CEPS_PrimaryDiskBusTypeName=File Backed Virtual
IF /I "%CEPS_PrimaryDiskBusType%"=="16" Set CEPS_PrimaryDiskBusTypeName=Storage Spaces
IF /I "%CEPS_PrimaryDiskBusType%"=="17" Set CEPS_PrimaryDiskBusTypeName=NVMe
IF /I "%CEPS_PrimaryDiskBusType%"=="18" Set CEPS_PrimaryDiskBusTypeName=Microsoft Reserved

REM mapping table for Disk Type
IF /I "%CEPS_PrimaryDiskType%"=="0" Set CEPS_PrimaryDiskTypeName=Unspecified
IF /I "%CEPS_PrimaryDiskType%"=="3" Set CEPS_PrimaryDiskTypeName=HDD
IF /I "%CEPS_PrimaryDiskType%"=="4" Set CEPS_PrimaryDiskTypeName=SSD
IF /I "%CEPS_PrimaryDiskType%"=="5" Set CEPS_PrimaryDiskTypeName=SCM

ECHO [%DATE%] [%TIME%] Primary Disk ID is "%CEPS_PrimaryDiskId%"
ECHO [%DATE%] [%TIME%] Primary Disk Model is "%CEPS_PrimaryDiskModel%"
ECHO [%DATE%] [%TIME%] Primary Disk Type is "%CEPS_PrimaryDiskTypeName%" ("%CEPS_PrimaryDiskType%")
ECHO [%DATE%] [%TIME%] Primary Disk Size is "%CEPS_PrimaryDiskSizeInGB%GB"
ECHO [%DATE%] [%TIME%] Primary Disk Bus Type is "%CEPS_PrimaryDiskBusTypeName%" ("%CEPS_PrimaryDiskBusType%")


REM Query secondary disk info if there is any
for /f "delims=" %%i in ('call %~dp0WMIQuery.exe "root\Microsoft\Windows\Storage" "SELECT * FROM MSFT_Disk WHERE BootFromDisk=false" "Number"') do (
    for /f "tokens=1,2 delims==" %%a in ("%%~i") do (
        if /i "%%~a" == "Number" (set "CEPS_SecondaryDiskId=%%~b") else (set "CEPS_SecondaryDiskId=")
    )
)
if %CEPS_SecondaryDiskId% == CEPS_UtilityFail ECHO Could not found secondary disk. &GOTO:eof

for /f "delims=" %%i in ('call %~dp0WMIQuery.exe "root\Microsoft\Windows\Storage" "SELECT * FROM MSFT_PhysicalDisk WHERE DeviceId=%CEPS_SecondaryDiskId%" "Model"') do (
    for /f "tokens=1,2 delims==" %%a in ("%%~i") do (
       	if /i "%%~a" == "Model" (set "CEPS_SecondaryDiskModel=%%~b") else (set "CEPS_SecondaryDiskModel=")
    )
)

for /f "delims=" %%i in ('call %~dp0WMIQuery.exe "root\Microsoft\Windows\Storage" "SELECT * FROM MSFT_PhysicalDisk WHERE DeviceId=%CEPS_SecondaryDiskId%" "MediaType"') do (
    for /f "tokens=1,2 delims==" %%a in ("%%~i") do (
       	if /i "%%~a" == "MediaType" (set "CEPS_SecondaryDiskType=%%~b") else (set "CEPS_SecondaryDiskType=")
    )
)

for /f "delims=" %%i in ('call %~dp0WMIQuery.exe "root\Microsoft\Windows\Storage" "SELECT * FROM MSFT_PhysicalDisk WHERE DeviceId=%CEPS_SecondaryDiskId%" "BusType"') do (
    for /f "tokens=1,2 delims==" %%a in ("%%~i") do (
       	if /i "%%~a" == "BusType" (set "CEPS_SecondaryDiskBusType=%%~b") else (set "CEPS_SecondaryDiskBusType=")
    )
)

for /f "delims=" %%i in ('call %~dp0WMIQuery.exe "root\Microsoft\Windows\Storage" "SELECT * FROM MSFT_PhysicalDisk WHERE DeviceId=%CEPS_SecondaryDiskId%" "Size" ') do (
    for /f "tokens=1,2 delims==" %%a in ("%%~i") do (
       	if /i "%%~a" == "Size" (set "CEPS_SecondaryDiskSizeInGB=%%~b") else (set "CEPS_SecondaryDiskSizeInGB=")
    )
)

REM Truncate last three digits because it seems to be overflow
set CEPS_SecondaryDiskSizeInGB=%CEPS_SecondaryDiskSizeInGB:~0,-3%
REM Divide disk size by 1024*1024
set /a CEPS_SecondaryDiskSizeInGB = "CEPS_SecondaryDiskSizeInGB>>20"

REM mapping table for Bus Type
IF /I "%CEPS_SecondaryDiskBusType%"=="0" Set CEPS_SecondaryDiskBusTypeName=Unknown
IF /I "%CEPS_SecondaryDiskBusType%"=="1" Set CEPS_SecondaryDiskBusTypeName=SCSI
IF /I "%CEPS_SecondaryDiskBusType%"=="2" Set CEPS_SecondaryDiskBusTypeName=ATAPI
IF /I "%CEPS_SecondaryDiskBusType%"=="3" Set CEPS_SecondaryDiskBusTypeName=ATA
IF /I "%CEPS_SecondaryDiskBusType%"=="4" Set CEPS_SecondaryDiskBusTypeName=1394
IF /I "%CEPS_SecondaryDiskBusType%"=="5" Set CEPS_SecondaryDiskBusTypeName=SSA
IF /I "%CEPS_SecondaryDiskBusType%"=="6" Set CEPS_SecondaryDiskBusTypeName=Fibre Channel
IF /I "%CEPS_SecondaryDiskBusType%"=="7" Set CEPS_SecondaryDiskBusTypeName=USB
IF /I "%CEPS_SecondaryDiskBusType%"=="8" Set CEPS_SecondaryDiskBusTypeName=RAID
IF /I "%CEPS_SecondaryDiskBusType%"=="9" Set CEPS_SecondaryDiskBusTypeName=iSCSI
IF /I "%CEPS_SecondaryDiskBusType%"=="10" Set CEPS_SecondaryDiskBusTypeName=SAS
IF /I "%CEPS_SecondaryDiskBusType%"=="11" Set CEPS_SecondaryDiskBusTypeName=SATA
IF /I "%CEPS_SecondaryDiskBusType%"=="12" Set CEPS_SecondaryDiskBusTypeName=SD
IF /I "%CEPS_SecondaryDiskBusType%"=="13" Set CEPS_SecondaryDiskBusTypeName=MMC
IF /I "%CEPS_SecondaryDiskBusType%"=="14" Set CEPS_SecondaryDiskBusTypeName=Virtual
IF /I "%CEPS_SecondaryDiskBusType%"=="15" Set CEPS_SecondaryDiskBusTypeName=File Backed Virtual
IF /I "%CEPS_SecondaryDiskBusType%"=="16" Set CEPS_SecondaryDiskBusTypeName=Storage Spaces
IF /I "%CEPS_SecondaryDiskBusType%"=="17" Set CEPS_SecondaryDiskBusTypeName=NVMe
IF /I "%CEPS_SecondaryDiskBusType%"=="18" Set CEPS_SecondaryDiskBusTypeName=Microsoft Reserved

REM mapping table for Disk Type
IF /I "%CEPS_PSecondaryDiskType%"=="0" Set CEPS_SecondaryDiskTypeName=Unspecified
IF /I "%CEPS_PSecondaryDiskType%"=="3" Set CEPS_SecondaryDiskTypeName=HDD
IF /I "%CEPS_PSecondaryDiskType%"=="4" Set CEPS_SecondaryDiskTypeName=SSD
IF /I "%CEPS_PSecondaryDiskType%"=="5" Set CEPS_SecondaryDiskTypeName=SCM

ECHO [%DATE%] [%TIME%] Secondary Disk ID is "%CEPS_SecondaryDiskId%"
ECHO [%DATE%] [%TIME%] Secondary Disk Model is "%CEPS_SecondaryDiskModel%"
ECHO [%DATE%] [%TIME%] Secondary Disk Type is "%CEPS_SecondaryDiskTypeName%" ("%CEPS_SecondaryDiskType%")
ECHO [%DATE%] [%TIME%] Secondary Disk Size is "%CEPS_SecondaryDiskSizeInGB%GB"
ECHO [%DATE%] [%TIME%] Secondary Disk Bus Type is "%CEPS_SecondaryDiskBusTypeName%" ("%CEPS_SecondaryDiskBusType%")