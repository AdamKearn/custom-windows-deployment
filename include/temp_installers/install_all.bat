C:\temp_installers\chrome.exe /silent /install
C:\temp_installers\firefox.exe -ms -ma
del C:\Users\%username%\Desktop\* /f /q
del C:\Users\Public\Desktop\* /f /q
TIMEOUT /t 60 /NOBREAK
shutdown.exe /r