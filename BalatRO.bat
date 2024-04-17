:: Traducere în română pentru Balatro
::
:: Script de instalare pentru pachetul de limbă RO pentru Balatro
:: Toate sursele actualizate sunt disponibile aici: https://github.com/olenicandrei/balatro-romanian-translations/
::


@echo off
setlocal enabledelayedexpansion

set "colorReset=[0m"
set "resourcesFolder=Resurse_Localizare_Balatro"

echo ==========================================
echo ==  Traducere în română pentru Balatro  ==
echo ==  Instalarea pachetului de limbă RO   ==
echo ==========================================

:: Definire folder
set "RESOURCES=%~dp0BalatRO"
mkdir "%RESOURCES%" 2>nul
mkdir "%RESOURCES%\resources\textures\1x" 2>nul
mkdir "%RESOURCES%\resources\textures\2x" 2>nul
mkdir "%RESOURCES%\resources\fonts" 2>nul
mkdir "%RESOURCES%\localization" 2>nul

:: Definirea URL-ului de bază al repository-ului
set "REPO_URL=https://raw.githubusercontent.com/olenicandrei/balatro-romanian-translations/main/loc_files"

:: Se descarcă fișierele specifice în structura corectă
echo Se descarcă resursele actualizate...
set "files=boosters.png Tarots.png Vouchers.png icons.png Jokers.png ShopSignAnimation.png"
for %%f in (%files%) do (
    powershell -command "Invoke-WebRequest -Uri '%REPO_URL%/assets/1x/%%f' -OutFile '%RESOURCES%\resources\textures\1x\%%f'"
    powershell -command "Invoke-WebRequest -Uri '%REPO_URL%/assets/2x/%%f' -OutFile '%RESOURCES%\resources\textures\2x\%%f'"
)

:: Se descarcă game.lua, ro.lua și m6x11plus.ttf
powershell -command "Invoke-WebRequest -Uri '%REPO_URL%/game.lua' -OutFile '%RESOURCES%\game.lua'"
powershell -command "Invoke-WebRequest -Uri '%REPO_URL%/ro.lua' -OutFile '%RESOURCES%\localization\ro.lua'"
powershell -command "Invoke-WebRequest -Uri '%REPO_URL%/m6x11plus.ttf' -OutFile '%RESOURCES%\resources\fonts\m6x11plus.ttf'"


:fin
echo.
echo.
echo.
local end