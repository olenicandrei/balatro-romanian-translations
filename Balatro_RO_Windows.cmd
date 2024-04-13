:: Traducere în română pentru Balatro
::
:: Script de instalare pentru pachetul de limbă RO pentru Balatro
:: Fișierul de limbă și resursele create de comunitatea Discord (Balatro RO - loc mod): https://discord.gg/kQMdHTXB3Z
:: Toate sursele actualizate sunt disponibile aici: https://github.com/olenicandrei/balatro-romanian-translations/
::
:: Acest script utilizează Balamod pentru a injecta resursele în joc (https://github.com/UwUDev/balamod)
::
::


@echo off
setlocal enabledelayedexpansion

set "colorReset=[0m"
set "resourcesFolder=Resurse_Localizare_Balatro"

echo ==========================================
echo ==  Traducere în română pentru Balatro  ==
echo ==  Instalarea pachetului de limbă RO   ==
echo ==========================================

set "download_assets=true"

:: Verificarea instalării implicite a Steam (prin libraryfolders.vdf pe C:)
set "steamLibraryFile=C:\Program Files (x86)\Steam\steamapps\libraryfolders.vdf"

:: Dacă nu există, deschideți explorer pentru selecția manuală a Balatro.exe
if not exist "!steamLibraryFile!" (
    echo.
    echo Vă rugăm să selectați unde se află Balatro.exe

    set "balatroFile="
    set "dialogTitle=Selectați balatro.exe"
    set "fileFilter=Executable Balatro (balatro.exe) | balatro.exe"

    for /f "delims=" %%I in ('powershell -Command "& { Add-Type -AssemblyName System.Windows.Forms; $dlg = New-Object System.Windows.Forms.OpenFileDialog; $dlg.Filter = '!fileFilter!'; $dlg.Title = '!dialogTitle!'; $dlg.ShowHelp = $true; $dlg.ShowDialog() | Out-Null; $dlg.FileName }"') do set "selectedFile=%%I"

    if defined selectedFile (
        set "balatroFile=!selectedFile!"
        echo Balatro.exe : !balatroFile!
    ) else (
        echo Balatro.exe : Fișier neselectat. Instalare anulată
        goto :fin
    )
)

:: Crearea folder-ului temporar de resurse
if not exist "%resourcesFolder%" mkdir "%resourcesFolder%"
if not exist "%resourcesFolder%\assets" mkdir "%resourcesFolder%\assets"
if not exist "%resourcesFolder%\assets\1x" mkdir "%resourcesFolder%\assets\1x"
if not exist "%resourcesFolder%\assets\2x" mkdir "%resourcesFolder%\assets\2x"

:: Recuperarea numelui ultimei versiuni de Balamod
for /f %%a in ('powershell -command "$tag = (Invoke-RestMethod -Uri 'https://api.github.com/repos/UwUDev/balamod/releases/latest').tag_name; $tag"') do set latestTag=%%a

:: Crearea numelor și linkurilor fișierelor. Valabil doar cât timp fișierul pentru Windows se numește corect balamod-v.y.z-windows.exe.
set "balamodFile=balamod-%latestTag%-windows.exe"
set "balamodFileUrl=https://github.com/UwUDev/balamod/releases/download/%latestTag%/%balamodFile%"
set "fr_repository=https://raw.githubusercontent.com/olenicandrei/balatro-romanian-translations/main/localization"
set "fr_translation=%fr_repository%/fr.lua"
set "fr_assetsBoosters1x=%fr_repository%/assets/1x/boosters.png"
set "fr_assetsBoosters2x=%fr_repository%/assets/2x/boosters.png"
set "fr_assetsTarots1x=%fr_repository%/assets/1x/Tarots.png"
set "fr_assetsTarots2x=%fr_repository%/assets/2x/Tarots.png"
set "fr_assetsVouchers1x=%fr_repository%/assets/1x/Vouchers.png"
set "fr_assetsVouchers2x=%fr_repository%/assets/2x/Vouchers.png"
set "fr_assetsIcons1x=%fr_repository%/assets/1x/icons.png"
set "fr_assetsIcons2x=%fr_repository%/assets/2x/icons.png"
set "fr_assetsBlindChips1x=%fr_repository%/assets/1x/BlindChips.png"
set "fr_assetsBlindChips2x=%fr_repository%/assets/2x/BlindChips.png"
set "fr_assetsJokers1x=%fr_repository%/assets/1x/Jokers.png"
set "fr_assetsJokers2x=%fr_repository%/assets/2x/Jokers.png"
set "fr_assetsShopSignAnimation1x=%fr_repository%/assets/1x/ShopSignAnimation.png"
set "fr_assetsShopSignAnimation2x=%fr_repository%/assets/2x/ShopSignAnimation.png"

:: Download Balamod
if not exist "%resourcesFolder%\%balamodFile%" (
    echo.
    echo Se descarcă Balamod...
    echo.
    curl --ssl-no-revoke -L -o "%resourcesFolder%\%balamodFile%" %balamodFileUrl%
    echo.
    echo Descărcarea Balamod finalizată
    echo.
)

:: Descărcarea pachetului de limbă RO
echo.
echo Se Descarcă mod-ul RO...
echo.
curl --ssl-no-revoke -L -o "%resourcesFolder%\fr.lua" %fr_translation%

if "%download_assets%"=="true" (
    curl --ssl-no-revoke -L -o "%resourcesFolder%\assets\1x\boosters.png" %fr_assetsBoosters1x%
    curl --ssl-no-revoke -L -o "%resourcesFolder%\assets\2x\boosters.png" %fr_assetsBoosters2x%
    curl --ssl-no-revoke -L -o "%resourcesFolder%\assets\1x\Tarots.png" %fr_assetsTarots1x%
    curl --ssl-no-revoke -L -o "%resourcesFolder%\assets\2x\Tarots.png" %fr_assetsTarots2x%
    curl --ssl-no-revoke -L -o "%resourcesFolder%\assets\1x\Vouchers.png" %fr_assetsVouchers1x%
    curl --ssl-no-revoke -L -o "%resourcesFolder%\assets\2x\Vouchers.png" %fr_assetsVouchers2x%
    curl --ssl-no-revoke -L -o "%resourcesFolder%\assets\1x\icons.png" %fr_assetsIcons1x%
    curl --ssl-no-revoke -L -o "%resourcesFolder%\assets\2x\icons.png" %fr_assetsIcons2x%
    curl --ssl-no-revoke -L -o "%resourcesFolder%\assets\1x\BlindChips.png" %fr_assetsBlindChips1x%
    curl --ssl-no-revoke -L -o "%resourcesFolder%\assets\2x\BlindChips.png" %fr_assetsBlindChips2x%
    curl --ssl-no-revoke -L -o "%resourcesFolder%\assets\1x\Jokers.png" %fr_assetsJokers1x%
    curl --ssl-no-revoke -L -o "%resourcesFolder%\assets\2x\Jokers.png" %fr_assetsJokers2x%
    curl --ssl-no-revoke -L -o "%resourcesFolder%\assets\1x\ShopSignAnimation.png" %fr_assetsShopSignAnimation1x%
    curl --ssl-no-revoke -L -o "%resourcesFolder%\assets\2x\ShopSignAnimation.png" %fr_assetsShopSignAnimation2x%
)

echo.
echo Descărcarea mod-ului RO finalizată
echo.

:: Injectarea pachetului de limbă RO
echo.
echo Instalarea pachetului de limbă...
echo.


if not defined balatroFile (
    :: Dacă Steam este instalat implicit, lăsați Balamod să caute fișierul Balatro.
    "./%resourcesFolder%\%balamodFile%" -x -i .\%resourcesFolder%\fr.lua -o localization/fr.lua
    if "%download_assets%"=="true" (
        "./%resourcesFolder%\%balamodFile%" -x -i .\%resourcesFolder%\assets\1x\boosters.png -o resources/textures/1x/boosters.png
        "./%resourcesFolder%\%balamodFile%" -x -i .\%resourcesFolder%\assets\2x\boosters.png -o resources/textures/2x/boosters.png
        "./%resourcesFolder%\%balamodFile%" -x -i .\%resourcesFolder%\assets\1x\Tarots.png -o resources/textures/1x/Tarots.png
        "./%resourcesFolder%\%balamodFile%" -x -i .\%resourcesFolder%\assets\2x\Tarots.png -o resources/textures/2x/Tarots.png
        "./%resourcesFolder%\%balamodFile%" -x -i .\%resourcesFolder%\assets\1x\Vouchers.png -o resources/textures/1x/Vouchers.png
        "./%resourcesFolder%\%balamodFile%" -x -i .\%resourcesFolder%\assets\2x\Vouchers.png -o resources/textures/2x/Vouchers.png
        "./%resourcesFolder%\%balamodFile%" -x -i .\%resourcesFolder%\assets\1x\icons.png -o resources/textures/1x/icons.png
        "./%resourcesFolder%\%balamodFile%" -x -i .\%resourcesFolder%\assets\2x\icons.png -o resources/textures/2x/icons.png
        "./%resourcesFolder%\%balamodFile%" -x -i .\%resourcesFolder%\assets\1x\BlindChips.png -o resources/textures/1x/BlindChips.png
        "./%resourcesFolder%\%balamodFile%" -x -i .\%resourcesFolder%\assets\2x\BlindChips.png -o resources/textures/2x/BlindChips.png
        "./%resourcesFolder%\%balamodFile%" -x -i .\%resourcesFolder%\assets\1x\Jokers.png -o resources/textures/1x/Jokers.png
        "./%resourcesFolder%\%balamodFile%" -x -i .\%resourcesFolder%\assets\2x\Jokers.png -o resources/textures/2x/Jokers.png
        "./%resourcesFolder%\%balamodFile%" -x -i .\%resourcesFolder%\assets\1x\ShopSignAnimation.png -o resources/textures/1x/ShopSignAnimation.png
        "./%resourcesFolder%\%balamodFile%" -x -i .\%resourcesFolder%\assets\2x\ShopSignAnimation.png -o resources/textures/2x/ShopSignAnimation.png
    )
) else (
    :: Altfel, trimiteți calea către folder-ul unde se află fișierul Balatro.exe selectat anterior.
    for %%A in ("!balatroFile!") do set "balatroFolder=%%~dpA"
    "./%resourcesFolder%\%balamodFile%" -b !balatroFolder! -x -i .\%resourcesFolder%\fr.lua -o localization/fr.lua
    if "%download_assets%"=="true" (
        "./%resourcesFolder%\%balamodFile%" -b !balatroFolder! -x -i .\%resourcesFolder%\assets\1x\boosters.png -o resources/textures/1x/boosters.png
        "./%resourcesFolder%\%balamodFile%" -b !balatroFolder! -x -i .\%resourcesFolder%\assets\2x\boosters.png -o resources/textures/2x/boosters.png
        "./%resourcesFolder%\%balamodFile%" -b !balatroFolder! -x -i .\%resourcesFolder%\assets\1x\Tarots.png -o resources/textures/1x/Tarots.png
        "./%resourcesFolder%\%balamodFile%" -b !balatroFolder! -x -i .\%resourcesFolder%\assets\2x\Tarots.png -o resources/textures/2x/Tarots.png
        "./%resourcesFolder%\%balamodFile%" -b !balatroFolder! -x -i .\%resourcesFolder%\assets\1x\Vouchers.png -o resources/textures/1x/Vouchers.png
        "./%resourcesFolder%\%balamodFile%" -b !balatroFolder! -x -i .\%resourcesFolder%\assets\2x\Vouchers.png -o resources/textures/2x/Vouchers.png
        "./%resourcesFolder%\%balamodFile%" -b !balatroFolder! -x -i .\%resourcesFolder%\assets\1x\icons.png -o resources/textures/1x/icons.png
        "./%resourcesFolder%\%balamodFile%" -b !balatroFolder! -x -i .\%resourcesFolder%\assets\2x\icons.png -o resources/textures/2x/icons.png
        "./%resourcesFolder%\%balamodFile%" -b !balatroFolder! -x -i .\%resourcesFolder%\assets\1x\BlindChips.png -o resources/textures/1x/BlindChips.png
        "./%resourcesFolder%\%balamodFile%" -b !balatroFolder! -x -i .\%resourcesFolder%\assets\2x\BlindChips.png -o resources/textures/2x/BlindChips.png
        "./%resourcesFolder%\%balamodFile%" -b !balatroFolder! -x -i .\%resourcesFolder%\assets\1x\Jokers.png -o resources/textures/1x/Jokers.png
        "./%resourcesFolder%\%balamodFile%" -b !balatroFolder! -x -i .\%resourcesFolder%\assets\2x\Jokers.png -o resources/textures/2x/Jokers.png
        "./%resourcesFolder%\%balamodFile%" -b !balatroFolder! -x -i .\%resourcesFolder%\assets\1x\ShopSignAnimation.png -o resources/textures/1x/ShopSignAnimation.png
        "./%resourcesFolder%\%balamodFile%" -b !balatroFolder! -x -i .\%resourcesFolder%\assets\2x\ShopSignAnimation.png -o resources/textures/2x/ShopSignAnimation.png
    )
)

echo %colorReset%
echo.
echo Instalarea pachetului de limbă finalizată

:: Ștergerea fișierelor de resurse
rd /s /q "%resourcesFolder%"
echo Balatro a fost actualizat!

:fin
echo.
echo.
echo.
pause