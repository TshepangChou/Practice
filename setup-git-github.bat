@echo OFF & CLS & echo.
NET FILE 1>NUL 2>NUL & IF ERRORLEVEL 1 (echo You must right-click and select &  echo "RUN AS ADMINISTRATOR"  to run this batch. Exiting... & echo. &  Timeout /t 10 & EXIT /B)
@REM ... proceed here with admin rights ...
@REM http://stackoverflow.com/questions/7044985/how-can-i-auto-elevate-my-batch-file-so-that-it-requests-from-uac-administrator
SETLOCAL

:: Custom Specific Registry Edits

@REM Enable scripting
reg add "HKLM\SOFTWARE\Microsoft\Windows Script Host\Settings" /v Enabled /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows Script Host\Settings" /v Enabled /t REG_DWORD /d 1 /f > NUL 2>&1

@REM Override Groupby in Downloads folder (https://lesferch.github.io/WinSetView/) (https://www.softwareok.com/?page=Windows/10/Explorer/7)
@REM https://www.tenforums.com/general-support/136903-disable-group-set-default-none-windows-10-1903-a-2.html
reg add "HKLM\SOFTWARE\Microsoft\Windows\Shell\Bags\AllFolders\Shell\{885A186E-A440-4ADA-812B-DB871B942259}" /v Mode /t REG_DWORD /d 4 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Shell\Bags\AllFolders\Shell\{885A186E-A440-4ADA-812B-DB871B942259}" /v GroupView /t REG_DWORD /d 0 /f > NUL 2>&1

@REM Install package manager
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

choco feature enable -n=useRememberedArgumentsForUpgrades

@REM Install package manager (GUI version)
@REM chocolateygui
@powershell -NoProfile -ExecutionPolicy Bypass -Command "choco install -y --force --allowGlobalConfirmation --allowEmptyChecksums --useRememberedArgumentsForUpgrades --acceptlicense --allowunofficial --ignore-checksums chocolateygui"

@REM Cmder (better conemu) https://github.com/cmderdev/cmder
@REM Cmder https://www.awmoore.com/2015/10/02/adding-cmder-to-the-windows-explorer-context-menu/
@powershell -NoProfile -ExecutionPolicy Bypass -Command "choco install -y --force --allowGlobalConfirmation --allowEmptyChecksums --useRememberedArgumentsForUpgrades --acceptlicense --allowunofficial --ignore-checksums Cmder --prerelease"

@REM Install text editor
@powershell -NoProfile -ExecutionPolicy Bypass -Command "choco install -y --force --allowGlobalConfirmation --allowEmptyChecksums --useRememberedArgumentsForUpgrades --acceptlicense --allowunofficial --ignore-checksums vscode --params '"/NoQuicklaunchIcon"' "

@REM Install git
@powershell -NoProfile -ExecutionPolicy Bypass -Command "choco install -y --force --allowGlobalConfirmation --allowEmptyChecksums --useRememberedArgumentsForUpgrades --acceptlicense --allowunofficial --ignore-checksums git --params '"/GitAndUnixToolsOnPath /NoAutoCrlf /NoGuiHereIntegration"' "

@REM always have Linux line endings in text files
git config --global core.autocrlf input
@REM support more than 260 characters on Windows
@REM See https://stackoverflow.com/a/22575737/873282 for details
git config --global core.longpaths true

call refreshenv
cmd

choco feature enable -n=useRememberedArgumentsForUpgrades