@echo off

if not exist "X:\Autounattend.xml" (GOTO EOF)
for %%i in (C D E F G H I J K L N M O P Q R S T U V W Y Z) DO (if exist "%%i:\Windows\system32\config\system" (set old_win_install=%%i))

:SHOW_OLD_DETAILS
reg load "HKLM\_SYSTEM" "%old_win_install%:\Windows\system32\config\system"

set OLD_PCNAME=FALLBACK
for /f "tokens=2* skip=2" %%a in ('reg query "HKLM\_SYSTEM\ControlSet001\Control\ComputerName\ComputerName" /V "ComputerName"') do set OLD_PCNAME=%%b
for /f "tokens=12" %%a in ('ipconfig /all ^|FIND /I "Physical Address"') do set MAC_ADDR=%%a
for /f "tokens=2 delims==" %%a in ('wmic bios get serialnumber /format:value') do set SERIAL=%%a

reg unload "HKLM\_SYSTEM"

:START
cls
mode con:cols=60 lines=13

echo ============================================================
echo               Pre-Windows Install Questions
echo ============================================================
echo.

echo MAC: %MAC_ADDR%
echo S/N: %SERIAL%
echo.

IF "%OLD_PCNAME:~0,7%"=="DESKTOP" (GOTO ASK_PCNAME)
IF "%OLD_PCNAME:~0,6%"=="LAPTOP"  (GOTO ASK_PCNAME)
IF "%OLD_PCNAME%"=="FALLBACK"     (GOTO ASK_PCNAME)

echo Previous Computer Name: %OLD_PCNAME% && echo.

:ASK_PCNAME
echo ============================================================
echo.

echo The computer name must be less than 15 characters
set /p PCNAME= Set a computer name:
set PCNAME=%PCNAME:~0,15%

:EDIT
X:\scripts\sed.exe -i "s/<ComputerName><\/ComputerName>/<ComputerName>%PCNAME%<\/ComputerName>/" X:\Autounattend.xml

:EOF