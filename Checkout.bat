@echo off

title Checkout Utility

:: define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A

:: =================================================
:: Detect OS 
:: =================================================
setLocal EnableDelayedExpansion
for /f "tokens=* USEBACKQ" %%f in (`ver`) do set versionOutput=%%f

if not "x!versionOutput:Version 10.0=!"=="x%versionOutput%" (
    set operatingSystem=ten
    goto _select
)

if not "x!versionOutput:Version 6.3=!"=="x%versionOutput%" (
    set operatingSystem=eight
    goto _select
)

if not "x!versionOutput:Version 6.2=!"=="x%versionOutput%" (
    set operatingSystem=eight
    goto _select
)

if not "x!versionOutput:Version 6.1=!"=="x%versionOutput%" (
    set operatingSystem=seven
    goto _select
)

if not "x!versionOutput:Version 6.0=!"=="x%versionOutput%" (
    set operatingSystem=vista
    goto _select
)

if not "x!versionOutput:Version 5.2=!"=="x%versionOutput%" (
    set operatingSystem=xp
    goto _select
)

if not "x!versionOutput:Version 5.1=!"=="x%versionOutput%" (
    set operatingSystem=xp
    goto _select
)
endlocal
goto _error

:: =================================================
:: Intro
:: =================================================
:_select
echo.
echo   The checkout utility will run through the checkout procedures
echo.
set /p var=%BS%  Press Enter to Continue:  
cls
goto _eject

:: =================================================
:: Eject CD Drive
:: =================================================
:_eject
echo.
echo   ------ CDs are removed ------
echo   Ejecting CD/DVD Drive:
echo.
%myfiles%\wizmo.exe quiet open
set /p var=%BS%  Press Enter to Continue:   
cls
goto _update

:: =================================================
:: Windows Updates
:: =================================================
:_update
echo.
echo   ------ Updates, AV, default programs installed ------
echo   Updates - Launching Windows Update:
echo.
if "%operatingSystem%"=="xp" (
    @start "" /b "%ProgramFiles%\Internet Explorer\iexplore.exe" update.microsoft.com
) 
if "%operatingSystem%"=="ten" (
    start ms-settings:windowsupdate
) else ( 
    wuapp.exe
)
set /p var=%BS%  Press Enter to Continue:   
cls
goto _virus

:: =================================================
:: Check MSSE and Defender
:: =================================================
:_virus
echo.
echo   ------ Updates, AV, default programs installed ------
echo   AV - Installed AntiVirus:
echo.
if "%operatingSystem%"=="eight" goto _mse8
    
if EXIST "%ProgramFiles%\Microsoft Security Client\" (
        echo   Microsoft Security Essentials is installed!
    )   else (
        echo   Microsoft Security Essentials is NOT installed!
    )
echo.
set /p var=%BS%  Press Enter to Continue:  
cls
goto _items

:: =================================================
:: Check for User's Items
:: =================================================
:_items
echo.
echo   ------ User's items collected (Power, CDs, etc.) ------
:itemsstart
set input=
set /p input=%BS%  Have you collected all of the users items? (yes/no): 
if "%input%"=="yes" goto itemsend
goto itemsstart

:itemsend
echo.
echo %BS%  Thanks for checking!
echo.
set /p var=%BS%  Press Enter to Continue: 
cls
goto _flash

:: =================================================
:: Check Flash
:: =================================================
:_flash
echo.
echo   ------ Browsers working: Search, Flash, Java ------
echo   Java - Launching java verification:
@start "" /b "%ProgramFiles%\Internet Explorer\iexplore.exe" http://java.com/en/download/installed.jsp
echo.
set /p var=%BS%  Press Enter to Continue:  
cls
goto _java

:: =================================================
:: Check Java
:: =================================================
:_java
echo.
echo   ------ Browsers working: Search, Flash, Java ------
echo   Flash - Launching a test video:
@start "" /b "%ProgramFiles%\Internet Explorer\iexplore.exe" http://youtu.be/SDmbGrQqWog
echo.
set /p var=%BS%  Press Enter to Continue:  
cls
goto _activate

:: =================================================
:: Windows Activation
:: =================================================
:_activate
echo.
echo   ------ OS and Office activated ------
echo   Checking OS status:
echo.
if "%operatingSystem%"=="xp" (
    start oobe/msoobe /a
) else ( 
    start slmgr.vbs -xpr
)
set /p var=%BS%  Press Enter to Continue:  
cls
goto _drivers

:: =================================================
:: Check Drivers
:: =================================================
:_drivers
echo.
echo   ------ Drivers Installed, Graphics and Sound Working ------
echo   Drivers - Launching Device Manager:
mmc devmgmt.msc
echo.
set /p var=%BS%  Press Enter to Continue:  
cls
goto _graphics

:: =================================================
:: Check Graphics
:: =================================================
:_graphics
echo.
echo   ------ Drivers Installed, Graphics and Sound Working ------
echo   Graphics - Getting Screen Resolution:
%myfiles%\Qres.exe /S | find "bits"
echo.
set /p var=%BS%  Press Enter to Continue:  
cls
goto _sound

:: =================================================
:: Check Sound
:: =================================================
:_sound
echo.
echo   ------ Drivers Installed, Graphics and Sound Working ------
echo   Sound - Playing a test sound:
%myfiles%\sWavPlayer.exe %myfiles%\marimba.wav
set input=
set /p input=%BS%  Did you hear it? (yes/no): 
if "%input%"=="yes" goto soundend
:soundstart
echo   Playing a test sound:
%myfiles%\sWavPlayer.exe %myfiles%\marimba.wav
set input=
set /p input=%BS%  Did you hear it? (yes/no): 
if "%input%"=="yes" goto soundend
goto soundstart

:soundend
echo.
set /p var=%BS%  Press Enter to Continue:  
cls
goto _backup

:: =================================================
:: Backup
:: =================================================
:_backup
echo.
echo   ------ Data Backup/Recovery section is complete ------
:backupstart
set input=
set /p input=%BS%  Has the users data been restored or N/A? (yes/no): 
if "%input%"=="yes" goto backupend
goto backupstart

:backupend
echo.
echo %BS%  Thanks for checking!
echo.
set /p var=%BS%  Press Enter to Continue: 
cls
goto _network

:: =================================================
:: Check Internet Connections
:: =================================================
:_network
echo.
echo   ------ Wireless and/or Wired network working ------"
echo   Launching Network Connections:
echo.
ncpa.cpl
set /p var=%BS%  Press Enter to Continue:  
cls
goto _restart

:: =================================================
:: Restart Computer
:: =================================================
:_restart
echo.
echo   Please re-start the computer to ensure it boots up properly.
echo.
set /p var=%BS%  Press Enter to Continue:  
cls

goto _done

:: =================================================
:: Done
:: =================================================
:_done
echo.
echo   The checkout is now complete.
echo.

set /p foo="Press ENTER to exit."

 shutdown -r -t 4 -c "Your computer will restart momentarily"

goto _end

:_end

rmdir /s /q "../checkout"
exit

:_error
echo   No Valid OS Detected!
set /p var=%BS%  Press Enter to Continue:  
goto _end

:_mse8
wmic /locale:ms_409 service where (name="WinDefend") get state /value | findstr State=Running
    if %ErrorLevel% EQU 0 (
        echo "  Windows Defender (MSE) is Running!"
) else (
        echo "  Windows Defender (MSE) is NOT running!"
)
set /p var=%BS%  Press Enter to Continue:  
cls
goto _net
