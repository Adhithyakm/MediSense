@ECHO OFF
setlocal enabledelayedexpansion


REM ====================================================
REM   Initial Variable
REM ====================================================
SET ERR.NUM=0
SET ERR.MSG=NO ERROR DURING %~n0 PROCESSING
SET WPDrvLetter=NONE
SET WorkDir=%~dp0\BTBHost
SET WorkDrvLetter=%~d0


REM ====================================================
REM   Find WP Drive Letter
REM ====================================================
ECHO [%time%][%~nx0] Find WP Drive Letter
SET CheckFile=\Windows\System32\ReAgentc.exe
FOR %%a IN ( c d e f g h i j k l m n o p q r s t u v w x y z ) DO (
  vol %%a: 2>NUL 1>NUL && IF EXIST "%%a:%CheckFile%" SET WPDrvLetter=%%a:
)
ECHO [%time%][%~nx0] WP Drive Letter = %WPDrvLetter%


REM ====================================================
REM   Prepare required path, ex: log and flag path
REM ====================================================
SET FILE.PATH=%WPDrvLetter%\system.sav\flags\
IF NOT EXIST %FILE.PATH% (MKDIR %FILE.PATH%)

SET FILE.PATH=%WPDrvLetter%\system.sav\logs\CEPS\BTBHost\
IF NOT EXIST %FILE.PATH% (MKDIR %FILE.PATH%)


SET LOGPATH=%WPDrvLetter%\system.sav\logs\CEPS\BTBHost\BTBHostD_PBR.log
IF EXIST %LOGPATH% (DEL /Q %LOGPATH%)

REM ====================================================
REM   Main
REM ====================================================

:: Copy LayoutModification.xml
SET FILE.SRC=%WorkDir%\LayoutModification.xml
SET FILE.DEST=%WPDrvLetter%\Users\Default\AppData\Local\Microsoft\Windows\Shell\
IF EXIST "%FILE.SRC%" (
  MKDIR "%FILE.DEST%" 
  ECHO [%time%][%~nx0] COPY /Y %FILE.SRC% %FILE.Dest% >> %LOGPATH%
  COPY /Y %FILE.SRC% %FILE.Dest% >> %LOGPATH% 2>&1
) ELSE (
  ECHO [%time%][%~nx0] Can't Find %FILE.SRC% >> %LOGPATH%	
)

:: Copy LayoutModification.json
SET FILE.SRC=%WorkDir%\LayoutModification.json
SET FILE.DEST=%WPDrvLetter%\Users\Default\AppData\Local\Microsoft\Windows\Shell\
IF EXIST "%FILE.SRC%" (
  MKDIR "%FILE.DEST%" 
  ECHO [%time%][%~nx0] COPY /Y %FILE.SRC% %FILE.Dest% >> %LOGPATH%
  COPY /Y %FILE.SRC% %FILE.Dest% >> %LOGPATH% 2>&1
) ELSE (
  ECHO [%time%][%~nx0] Can't Find %FILE.SRC% >> %LOGPATH%	
)

:: Copy TaskbarLayoutModification.xml
SET FILE.SRC=%WorkDir%\TaskbarLayoutModification.xml
SET FILE.DEST=%WPDrvLetter%\Users\Default\AppData\Local\Microsoft\Windows\Shell\
IF EXIST "%FILE.SRC%" (
  MKDIR "%FILE.DEST%" 
  ECHO [%time%][%~nx0] COPY /Y %FILE.SRC% %FILE.Dest% >> %LOGPATH%
  COPY /Y %FILE.SRC% %FILE.Dest% >> %LOGPATH% 2>&1
) ELSE (
  ECHO [%time%][%~nx0] Can't Find %FILE.SRC% >> %LOGPATH%	
)

:: Copy Edge tile icons
SET FOLDER.SRC=%WorkDir%\EdgeIcons\Packages
SET FOLDER.DEST=%WorkDir%\Users\Default\AppData\Local\Packages
IF EXIST "%FOLDER.SRC%" (
  MKDIR "%FOLDER.DEST%" 
  ECHO [%time%][%~nx0] XCOPY /E/I/Y/F %FOLDER.SRC% %FOLDER.Dest% >> %LOGPATH%
  XCOPY /E/I/Y/F "%FOLDER.SRC%" "%FOLDER.Dest%" >> %LOGPATH% 2>&1
) ELSE (
  ECHO [%time%][%~nx0] Can't Find %FOLDER.SRC% >> %LOGPATH%
)
 
:: Load Registry in WinPE
ECHO [%time%][%~nx0] LOAD HKLM\SOFT %WPDrvLetter%\windows\system32\config\SOFTWARE >> %LOGPATH%
REG LOAD HKLM\SOFT %WPDrvLetter%\windows\system32\config\SOFTWARE>> %LOGPATH% 2>&1

:: Import registry files
FOR %%a IN ( %WorkDir%\*.reg ) DO (
  SET REG.SRC=%%a
  IF EXIST "!REG.SRC!" (
    ECHO [%time%][%~nx0] REG IMPORT "!REG.SRC!" >> %LOGPATH%
    REG IMPORT "!REG.SRC!" >> %LOGPATH% 2>&1
  ) ELSE (
    ECHO [%time%][%~nx0] Can't Find !REG.SRC! >> %LOGPATH%	
  )
)

FOR %%a IN ( %WPDrvLetter%\HP\HPQWare\BTBHost\PBR\PostUser\*.reg ) DO (
  SET REG.SRC=%%a
  IF EXIST "!REG.SRC!" (
    IF "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
      ECHO [%time%][%~nx0] ReplaceRegString64.exe "!REG.SRC!" >> %LOGPATH%
      %WPDrvLetter%\HP\HPQWare\BTBHost\PBR\ReplaceRegString64.exe "!REG.SRC!" >> %LOGPATH% 2>&1
    ) ELSE (
      ECHO [%time%][%~nx0] ReplaceRegString32.exe "!REG.SRC!" >> %LOGPATH%
      %WPDrvLetter%\HP\HPQWare\BTBHost\PBR\ReplaceRegString32.exe "!REG.SRC!" >> %LOGPATH% 2>&1	
    )
    ECHO [%time%][%~nx0] REG IMPORT "!REG.SRC!" >> %LOGPATH%
    REG IMPORT "!REG.SRC!" >> %LOGPATH% 2>&1
  ) ELSE (
    ECHO [%time%][%~nx0] Can't Find !REG.SRC! >> %LOGPATH%	
  )
)

:: Add LayoutXMLPath registry for RS1 taskbar pinning
SET TaskbarLayoutModificationXML=\Users\Default\AppData\Local\Microsoft\Windows\Shell\TaskbarLayoutModification.xml
IF EXIST %WPDrvLetter%%TaskbarLayoutModificationXML% (
	ECHO [%time%][%~nx0] REG ADD "HKLM\SOFT\Microsoft\Windows\CurrentVersion\Explorer" /v "LayoutXMLPath" /t REG_SZ /d c:%TaskbarLayoutModificationXML% /f  >> %LOGPATH%
	REG ADD "HKLM\SOFT\Microsoft\Windows\CurrentVersion\Explorer" /v "LayoutXMLPath" /t REG_SZ /d c:%TaskbarLayoutModificationXML% /f >> %LOGPATH% 2>&1
) ELSE (
	ECHO [%time%][%~nx0] %WPDrvLetter%%TaskbarLayoutModificationXML% Not exist! >> %LOGPATH%
)

:: Unload Registry in WinPE
ECHO [%time%][%~nx0] UNLOAD HKLM\SOFT >> %LOGPATH%
REG UNLOAD HKLM\SOFT >> %LOGPATH% 2>&1

GOTO END

:ENDPROCESS
REM ====================================================
REM   ENDPROCESS  -   CALL HERE TO EXIT - IF WE HAVE AN ERROR THEN LOG IT
REM ====================================================
IF %ERR.NUM% NEQ 0 (
	ECHO.
	ECHO ******************************************************************************  >> %LOGPATH%
	ECHO * ERROR: %ERR.NUM%                                                              >> %LOGPATH%
	ECHO *      : %ERR.MSG%                                                              >> %LOGPATH%
	ECHO ******************************************************************************  >> %LOGPATH%
	ECHO.
)

:END
ECHO [%~nx0] %date% %time% >> %LOGPATH%
ECHO ********** FINISH %~nx0 ********** >> %LOGPATH%
ECHO RETURN CODE - %ERR.NUM% >> %LOGPATH%

REM EXIT THE SCRIPT AND RETURN THE ERROR LEVEL
EXIT /b %ERR.NUM%
