@echo off

color f0
title Checkout Steps Automator

rem =================================================
rem Detect OS 
rem =================================================

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

:_vista7

rem Detect OS Bit Type

for /f "tokens=3" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PROCESSOR_ARCHITECTURE') do set bit=%%i

if "%bit%"=="x86" (
    set bit=32
) else ( 
    set bit=64
)

:_vista7only

rem Detect OS Bit Type

for /f "tokens=3" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PROCESSOR_ARCHITECTURE') do set bit=%%i

if "%bit%"=="x86" (
    set bit=32
) else ( 
    set bit=64
)

:_select
echo.
echo                Checkout Steps Automator
echo.
echo.
echo.
echo.
pause
cls
goto _steps

:_steps
rem =================================================
rem Start checkout steps
rem =================================================

rem Eject CD drive
echo.
echo Please check the optical drive for any PE CD's . . .
echo.
echo.
echo.
echo.
ping -n 3 127.0.0.1 > nul
%myfiles%\wizmo.exe quiet open
pause 
cls

rem Check Windows activation
echo.
echo.
echo Checking Activation Status . . .
echo.
echo.
echo.
echo.
ping -n 3 127.0.0.1 > nul
    if "%operatingSystem%"=="xp" (
    start oobe/msoobe /a
) else ( 
start slmgr.vbs -xpr
)
pause
cls

rem Launch Windows Updates
echo.
echo Check for Windows Updates . . .
echo.
echo.
echo.
echo.
echo                Launching Windows Update . . . 
ping -n 3 127.0.0.1 > nul
if "%operatingSystem%"=="xp" (
    @start "" /b "%ProgramFiles%\Internet Explorer\iexplore.exe" update.microsoft.com
) 
if "%operatingSystem%"=="ten" (
    start ms-settings:windowsupdate
) else ( 
    wuapp.exe
)
echo.
echo.
echo.
echo.
pause 
cls
goto _items
:_items
rem Display dialog
cls
echo.
echo Are all of the user's checked in items here? (Power adapter, bag, CD's)
echo.
echo.
echo.
set /p select=(yes or no):
echo.
echo.
echo.
if "%select%"=="yes" echo Thanks for checking! && goto _continue
if "%select%"=="YES" echo Thanks for checking! && goto _continue
if "%select%"=="no" echo Please gather all user's items. && goto _continue
if "%select%"=="NO" echo Please gather all user's items. && goto _continue
goto _items

:_continue  
echo.
echo.
pause
cls
rem Launch two IE windows with provided URLs
echo.
echo Test browsers for working Java and Flash . . .
ping -n 2 127.0.0.1 > nul
echo.
echo.
echo.
echo.
echo                Launching Internet Explorer . . .
echo.
ping -n 3 127.0.0.1 > nul
@start "" /b "%ProgramFiles%\Internet Explorer\iexplore.exe" http://youtu.be/SDmbGrQqWog
@start "" /b "%ProgramFiles%\Internet Explorer\iexplore.exe" http://java.com/en/download/installed.jsp
pause
cls

rem Display dialog
echo.
echo Checking Graphics and Sound . . . 
echo.
echo.
echo.
ping -n 3 127.0.0.1 > nul
echo The Current Screen Resolution is :
echo.
echo.
echo.
echo.
%myfiles%\Qres.exe /S | find "bits"
echo.
echo.
echo.
echo.
echo Doublecheck that this is the correct resolution for this display.
echo.
echo.
pause
cls
echo.
echo.
echo Playing a sample audio sound . . .
%myfiles%\sWavPlayer.exe %myfiles%\marimba.wav
echo.
echo.
echo Ensure that you were able to hear the sample sound.
echo.
pause
cls

rem Launch device manager
echo.
echo Check that all drivers are installed . . .
echo.
echo.
echo.
echo                Launching Device Manager . . .
ping -n 3 127.0.0.1 > nul
echo.
echo.
echo.
mmc devmgmt.msc
echo.
pause
cls

rem Check if MSE is installed or Defender Service is Running on Windows 8
echo.
echo Checking if Microsoft Security Essentials is installed . . .
echo.
echo.
echo.
ping -n 3 127.0.0.1 > nul
echo.
if "%operatingSystem%"=="eight" goto _mse8
    
if EXIST "%ProgramFiles%\Microsoft Security Client\" (
        echo   Microsoft Security Essentials is installed!
    )   else (
        echo Microsoft Security Essentials is NOT installed! Check to see if the computer has anti-virus software installed. 
    )
echo.
echo.
echo.
pause
cls

:_net
rem Lauch network connections
echo.
echo Ensure wireless/wired networking is operational.
echo.
echo.
echo.
echo.
echo                Launching Network Connections . . . 
ping -n 3 127.0.0.1 > nul
echo.
echo.
echo.
ncpa.cpl
pause
cls

:_backup
rem Display dialog
cls
echo.
echo Please check the Data Backup section on the form, is it complete?
echo.
echo.
echo.
echo.
set /p select=(yes or no):
echo.
echo.
echo.
echo.
if "%select%"=="yes" echo Thanks for checking! && goto _continue2
if "%select%"=="YES" echo Thanks for checking! && goto _continue2
if "%select%"=="no" echo Please go over and ensure each step is complete. && goto _continue2
if "%select%"=="NO" echo Please go over and ensure each step is complete. && goto _continue2
goto _backup

:_continue2 

rem Looking for and removing our tools if accidentally left on the user's desktop

if EXIST "%USERPROFILE%\Desktop\ComboFix.exe" (
    del /F "%USERPROFILE%\Desktop\ComboFix.exe"
    )

if EXIST "%USERPROFILE%\Desktop\HDTune.exe" (
    del /F "%USERPROFILE%\Desktop\HDTune.exe"
    )
    
if EXIST "%USERPROFILE%\Desktop\prime95.exe" (
    del /F "%USERPROFILE%\Desktop\prime95.exe"
    )
    
if EXIST "%USERPROFILE%\Desktop\prime95_64.exe" (
    del /F "%USERPROFILE%\Desktop\prime95_64.exe"
    )
    
if EXIST "%USERPROFILE%\Desktop\unstopcp.exe" (
    del /F "%USERPROFILE%\Desktop\unstopcp.exe"
    )

if EXIST "%USERPROFILE%\Desktop\autovirus.exe" (
    del /F "%USERPROFILE%\Desktop\autovirus.exe"
    )
    
if EXIST "%USERPROFILE%\Desktop\checkout.exe" (
    del /F "%USERPROFILE%\Desktop\checkout.exe"
    )
    
if EXIST "%USERPROFILE%\Desktop\defaultprograms.exe" (
    del /F "%USERPROFILE%\Desktop\defaultprograms.exe"
    )


echo.
echo.
echo.
pause
cls
rem Restart Computer
echo.
echo Please re-start the computer to ensure it boots up properly.
echo.
echo.
echo.
pause
cls

goto _done

:_done
rem =================================================
rem Done
rem =================================================

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
echo No Valid OS Detected!
pause
goto _end

:_mse8
wmic /locale:ms_409 service where (name="WinDefend") get state /value | findstr State=Running
    if %ErrorLevel% EQU 0 (
        echo "Windows Defender (MSE) is Running!"
) else (
    echo "Windows Defender (MSE) is NOT running!, check if another AV program is running."
)
pause
cls
goto _net   
