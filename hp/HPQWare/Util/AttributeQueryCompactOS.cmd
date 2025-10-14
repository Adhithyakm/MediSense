@echo off

set CEPS_IsCompactOS=CEPS_UtilityFail

if exist c:\system.sav\Flags\RM_COMPACTOS.flg (
	set "CEPS_IsCompactOS=1"
) else (
	set "CEPS_IsCompactOS=0"
	ECHO [%DATE%] [%TIME%] RM_COMPACTOS.flg does not exists
)

ECHO [%DATE%] [%TIME%] Compact OS flag is "%CEPS_IsCompactOS%"