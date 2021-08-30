@echo off

if not exist "X:\Autounattend.xml" (GOTO EOF)

:START
cls
mode con:cols=60 lines=10

echo ============================================================
echo               Pre-Windows Install Questions
echo ============================================================
echo.

echo The computer name must be less than 15 characters
set /p PCNAME= Set a computer name:
set PCNAME=%PCNAME:~0,15%

:EDIT
X:\scripts\sed.exe -i "s/<ComputerName><\/ComputerName>/<ComputerName>%PCNAME%<\/ComputerName>/" X:\Autounattend.xml

:EOF