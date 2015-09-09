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
ping 1.1.1.1 -n 1 -w 600 > nul
wizmo.exe quiet open
ping 1.1.1.1 -n 1 -w 600 > nul
echo.
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
ping 1.1.1.1 -n 1 -w 600 > nul
if "%operatingSystem%"=="xp" (
    @start "" /b "%ProgramFiles%\Internet Explorer\iexplore.exe" update.microsoft.com
) 
if "%operatingSystem%"=="ten" (
    start ms-settings:windowsupdate
) else ( 
    wuapp.exe
)
ping 1.1.1.1 -n 1 -w 600 > nul
echo.
set /p var=%BS%  Press Enter to Continue:   
cls
goto _virus

:: =================================================
:: Check Antivirus
:: =================================================
:_virus
echo.
echo   ------ Updates, AV, default programs installed ------
echo   AV - Installed AntiVirus:
rem Wait 600
control wscui.cpl
rem Wait 600
echo.
set /p var=%BS%  Press Enter to Continue:  
cls
control wscui.cpl
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
ping 1.1.1.1 -n 1 -w 600 > nul
@start "" /b "%ProgramFiles%\Internet Explorer\iexplore.exe" http://java.com/en/download/installed.jsp
ping 1.1.1.1 -n 1 -w 600 > nul
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
ping 1.1.1.1 -n 1 -w 600 > nul
@start "" /b "%ProgramFiles%\Internet Explorer\iexplore.exe" http://youtu.be/SDmbGrQqWog
ping 1.1.1.1 -n 1 -w 600 > nul
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
ping 1.1.1.1 -n 1 -w 600 > nul
if "%operatingSystem%"=="xp" (
    start oobe/msoobe /a
) else ( 
    start slmgr.vbs -xpr
)
ping 1.1.1.1 -n 1 -w 600 > nul
echo.
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
ping 1.1.1.1 -n 1 -w 600 > nul
mmc devmgmt.msc
ping 1.1.1.1 -n 1 -w 600 > nul
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
ping 1.1.1.1 -n 1 -w 600 > nul
FOR /F "delims=" %%i IN ('Qres.exe /S') DO set screenInfo=%%i
echo     %screenInfo%
ping 1.1.1.1 -n 1 -w 600 > nul
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
ping 1.1.1.1 -n 1 -w 100 > nul
sWavPlayer.exe marimba.wav
set input=
set /p input=%BS%  Did you hear it? (yes/no): 
if "%input%"=="yes" goto soundend
:soundstart
echo   Playing a test sound:
sWavPlayer.exe johncena.wav
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
ping 1.1.1.1 -n 1 -w 600 > nul
ncpa.cpl
ping 1.1.1.1 -n 1 -w 600 > nul
set /p var=%BS%  Press Enter to Continue:  
cls
goto _original

:: =================================================
:: Original Problem
:: =================================================
:_original
echo.
echo   ------ Data Backup/Recovery section is complete ------
:originalstart
set input=
set /p input=%BS%  Has the users original problem been solved or N/A? (yes/no): 
if "%input%"=="yes" goto originalend
goto originalstart

:originalend
echo.
echo %BS%  Thanks for checking!
echo.
set /p var=%BS%  Press Enter to Continue: 
cls
goto _restart

:: =================================================
:: Restart Computer
:: =================================================
:_restart
echo.
echo   The checkout is now complete.
echo.
set /p input=%BS%  Would you like to restart? (yes/no): 
if "%input%"=="yes" shutdown -r -t 4 -c "Your computer will restart momentarily"
exit

:_error
echo   No Valid OS Detected!
ping 1.1.1.1 -n 1 -w 5000 > nul
exit
