@echo off

if exist "X:\Autounattend.xml" (GOTO ADD_FILES)
GOTO EOF

:ADD_FILES
for %%i in (C D E F G H I J K L N M O P Q R S T U V W Y Z) DO (if exist "%%i:\Windows\Panther" (set win_install=%%i))
xcopy /Y /S /I /E X:\scripts\C_ROOT\ %win_install%:\
GOTO EOF

:EOF