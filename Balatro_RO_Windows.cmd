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

:: Verificare dacă 7-Zip este instalat
where /q 7z.exe
if %errorlevel% neq 0 (
    echo 7-Zip nu este instalat. Se instalează 7-Zip...
    powershell -command "Invoke-WebRequest -Uri 'https://www.7-zip.org/a/7z1900-x64.exe' -OutFile '%TEMP%\7z_installer.exe'"
    start /wait %TEMP%\7z_installer.exe /S
    echo 7-Zip a fost instalat.
    setx PATH "%PATH%;C:\Program Files\7-Zip"
)

:: Definire director temporar
set "TEMP_DIR=%~dp0temp"
mkdir "%TEMP_DIR%" 2>nul


:: Închidere orice instanță a lui Balatro.exe care rulează
echo Se încearcă închiderea Balatro.exe...
taskkill /IM "balatro.exe" /F
if %ERRORLEVEL% neq 0 echo Nu s-a putut găsi sau închide Balatro.exe. Se presupune că nu rulează.

:: Backup pentru EXE-ul original
echo Se face backup pentru EXE-ul original...
copy /y "!balatroFile!" "!balatroFile!.bak"
if %ERRORLEVEL% neq 0 (
    echo Backup-ul pentru EXE-ul original a eșuat. Procesul este oprit.
    goto fin
)

:: Extrage EXE-ul
echo Se extrag fișierele din EXE...
7z x "!balatroFile!" -o"%TEMP_DIR%"
if %ERRORLEVEL% neq 0 (
    echo Eroare la extragerea fișierelor. Procesul este oprit.
    goto fin
)

:: Definirea URL-ului de bază al repository-ului
set "REPO_URL=https://raw.githubusercontent.com/olenicandrei/balatro-romanian-translations/main/localization"

:: Se descarcă fișierele specifice în structura corectă
echo Se descarcă resursele actualizate...
set "files=boosters.png Tarots.png Vouchers.png icons.png Jokers.png ShopSignAnimation.png"
for %%f in (%files%) do (
    powershell -command "Invoke-WebRequest -Uri '%REPO_URL%/assets/1x/%%f' -OutFile '%TEMP_DIR%\resources\textures\1x\%%f'"
    powershell -command "Invoke-WebRequest -Uri '%REPO_URL%/assets/2x/%%f' -OutFile '%TEMP_DIR%\resources\textures\2x\%%f'"
)

:: Se descarcă game.lua și ro.lua
powershell -command "Invoke-WebRequest -Uri '%REPO_URL%/game.lua' -OutFile '%TEMP_DIR%\game.lua'"
mkdir "%TEMP_DIR%\localization" 2>nul
powershell -command "Invoke-WebRequest -Uri '%REPO_URL%/ro.lua' -OutFile '%TEMP_DIR%\localization\ro.lua'"

:: Se repachetează arhiva în locația executabilului original
echo Se repachetează EXE-ul modificat...
if exist "!balatroFile!" del "!balatroFile!"
7z a -sfx "!balatroFile!" "%TEMP_DIR%\*"
if %ERRORLEVEL% neq 0 (
    echo Eroare la repachetarea executabilului. Se restaurează din backup...
    copy /y "!balatroFile!.bak" "!balatroFile!"
    goto fin
)

:: Curățenie
echo Se curăță fișierele temporare...
rmdir /s /q "%TEMP_DIR%"

echo Procesul s-a încheiat cu succes.
pause

:fin
echo.
echo.
echo.
pause