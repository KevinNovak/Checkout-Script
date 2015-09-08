@echo off

title Checkout Utility

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

:_select
echo.
echo   The checkout utility will run through the checkout procedures
echo.
pause
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
pause 
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
pause
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
echo.
pause 
cls
goto _items

:: =================================================
:: Check for User's Items
:: =================================================
:_items
cls
echo.
echo   ------ User's items collected (Power, CDs, etc.) ------
echo   Have you collected all of the users items?
set /p select=(yes or no):
echo.
if "%select%"=="yes" echo   Thanks for checking!
if "%select%"=="YES" echo   Thanks for checking!
if "%select%"=="no" echo   Please gather all user's items.
if "%select%"=="NO" echo   Please gather all user's items.
echo.
pause
cls
goto _java

:: =================================================
:: Check Java and Flash
:: =================================================
:_java
echo.
echo   ------ Browsers working: Search, Flash, Java ------
echo   Flash - Launching a test video:
@start "" /b "%ProgramFiles%\Internet Explorer\iexplore.exe" http://youtu.be/SDmbGrQqWog
echo.
pause
cls

echo.
echo   ------ Browsers working: Search, Flash, Java ------
echo   Java - Launching java verification:
@start "" /b "%ProgramFiles%\Internet Explorer\iexplore.exe" http://java.com/en/download/installed.jsp
echo.
pause
cls
goto _graphics

:: =================================================
:: Check Graphics and Sound
:: =================================================
:_graphics
echo.
echo   ------ Drivers Installed, Graphics and Sound Working ------
echo   Graphics - Getting Screen Resolution:
echo.
%myfiles%\Qres.exe /S | find "bits"
pause
cls

echo.
echo   ------ Drivers Installed, Graphics and Sound Working ------
echo   Sound - Playing a test sound:
%myfiles%\sWavPlayer.exe %myfiles%\marimba.wav
echo.
echo   Ensure that you were able to hear the sample sound.
echo.
pause
cls
goto _drivers

:: =================================================
:: Check Drivers
:: =================================================
:_drivers
echo.
echo   ------ Drivers Installed, Graphics and Sound Working ------
echo   Drivers - Launching Device Manager:
echo.
mmc devmgmt.msc
echo.
pause
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
pause
cls
goto _net

:: =================================================
:: Check Internet Connections
:: =================================================
:_net
echo.
echo   ------ Wireless and/or Wired network working ------"
echo   Launching Network Connections:"
echo.
ncpa.cpl
pause
cls
goto _backup

:: =================================================
:: Backup
:: =================================================
:_backup
cls
echo.
echo   Please check the Data Backup section on the form, is it complete?
echo.
set /p select=(yes or no):
echo.
if "%select%"=="yes" echo   Thanks for checking!
if "%select%"=="YES" echo   Thanks for checking!
if "%select%"=="no" echo   Please go over and ensure each step is complete.
if "%select%"=="NO" echo   Please go over and ensure each step is complete.
goto _backup 

:: =================================================
:: Restart Computer
:: =================================================
echo.
echo   Please re-start the computer to ensure it boots up properly.
echo.
pause
cls

goto _done

:: =================================================
:: Done
:: =================================================
:_done
echo.
echo  Finished!
echo.

set /p foo="Press ENTER to exit."

 shutdown -r -t 4 -c "Your computer will restart momentarily"

goto _end

:_end

rmdir /s /q "../checkout"
exit

:_error
echo   No Valid OS Detected!
pause
goto _end

:_mse8
wmic /locale:ms_409 service where (name="WinDefend") get state /value | findstr State=Running
    if %ErrorLevel% EQU 0 (
        echo "  Windows Defender (MSE) is Running!"
) else (
        echo "  Windows Defender (MSE) is NOT running!"
)
pause
cls
goto _net
