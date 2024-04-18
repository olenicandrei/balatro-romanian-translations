:: Traducere în română pentru Balatro
::
:: Script de instalare pentru pachetul de limbă RO pentru Balatro
:: Toate sursele actualizate sunt disponibile aici: https://github.com/olenicandrei/balatro-romanian-translations/
::


@echo off
setlocal enabledelayedexpansion
setlocal EnableExtensions


echo ==========================================================
echo ==========  Traducere in romana pentru Balatro  ==========
echo ==========  Instalarea pachetului de limba RO   ==========
echo ==========================================================
echo.
echo.
echo.


:: Verificare dacă 7-Zip este instalat
echo ==========================================
echo Se verifica daca 7-Zip este instalat...
if exist "C:\Program Files\7-Zip\7z.exe" (
    echo 7-Zip este instalat.
) else if exist "C:\Program Files (x86)\7-Zip\7z.exe" (
    echo 7-Zip este instalat.
) else (
    color 09
    echo 7-Zip nu este instalat. Se instaleaza 7-Zip...
    powershell -command "Invoke-WebRequest -Uri 'https://www.7-zip.org/a/7z2301-x64.exe' -OutFile '%TEMP%\7z2301-x64.exe'"
    start /wait %TEMP%\7z2301-x64.exe /S
    echo 7-Zip a fost instalat.
    setx PATH "%PATH%;C:\Program Files\7-Zip"
)
color 07
echo ==========================================

echo.
echo.

:: Definire folder
set "RESOURCES=%~dp0BalatRO Files"
mkdir "%RESOURCES%" 2>nul
mkdir "%RESOURCES%\resources\textures\1x" 2>nul
mkdir "%RESOURCES%\resources\textures\2x" 2>nul
mkdir "%RESOURCES%\resources\fonts" 2>nul
mkdir "%RESOURCES%\localization" 2>nul

:: Definirea URL-ului de bază al repository-ului
set "REPO_URL=https://raw.githubusercontent.com/olenicandrei/balatro-romanian-translations/main/loc_files"

:: Se descarcă fișierele specifice în structura corectă
echo ==========================================
echo Se descarca fisierele de traducere in limba romana...
color 09
set "files=boosters.png Tarots.png Vouchers.png icons.png Jokers.png ShopSignAnimation.png"
for %%f in (%files%) do (
    powershell -command "Invoke-WebRequest -Uri '%REPO_URL%/assets/1x/%%f' -OutFile '%RESOURCES%\resources\textures\1x\%%f'"
    powershell -command "Invoke-WebRequest -Uri '%REPO_URL%/assets/2x/%%f' -OutFile '%RESOURCES%\resources\textures\2x\%%f'"
)

:: Se descarcă game.lua, ro.lua și m6x11plus.ttf
powershell -command "Invoke-WebRequest -Uri '%REPO_URL%/game.lua' -OutFile '%RESOURCES%\game.lua'"
powershell -command "Invoke-WebRequest -Uri '%REPO_URL%/ro.lua' -OutFile '%RESOURCES%\localization\ro.lua'"
powershell -command "Invoke-WebRequest -Uri '%REPO_URL%/m6x11plus.ttf' -OutFile '%RESOURCES%\resources\fonts\m6x11plus.ttf'"
echo Fisierele au fost descarcate
color 07
echo ==========================================


echo.
echo.


echo ==========================================
echo Se cauta fisierul Balatro.exe
color 09
set "balatroFile="
set "appId=2379780"
set "regPath64=HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Valve\Steam"
set "regPath32=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam"
set "keyName=InstallPath"
set "gameFound=0"  ; Indicator pentru a urmari daca jocul a fost gasit

:: Incercare de a obtine calea Steam de la registru pe 64 de biti
for /f "tokens=2*" %%a in ('reg query "%regPath64%" /v %keyName% 2^>nul') do set "steamPath=%%b"

:: Daca nu a fost gasita, incearca sa obtii calea de la registru pe 32 de biti
if not defined steamPath (
    for /f "tokens=2*" %%a in ('reg query "%regPath32%" /v %keyName% 2^>nul') do set "steamPath=%%b"
)

:: Verifica daca calea a fost gasita
if defined steamPath (
    set "libraryFile=!steamPath!\steamapps\libraryfolders.vdf"

    :: Verifica daca fisierul libraryfolders.vdf exista
    if exist "!libraryFile!" (
        set "libraries="
        for /f "tokens=1*" %%a in ('type "!libraryFile!" ^| findstr /i "\"path\""') do (
            set "line=%%b"
            set "line=!line:"=!"
            set "line=!line:\\=\!"
            if not "!line!"=="" (
                set "libraries=!libraries!;!line!"
                if exist "!line!\steamapps\appmanifest_%appId%.acf" (
                    echo Balatro a fost gasit in: !line!
		    set "balatroFile=!line!\steamapps\common\Balatro\Balatro.exe"
		    set "gameFound=1"
		    goto GameFound
                )
            )
        )
        if not defined libraries (
            echo Nu s-au gasit biblioteci Steam. Va trebui sa instalati mod-ul manual.
        )
    ) else (
        echo Fisierul libraryfolders.vdf nu a fost gasit sau este inaccesibil. Verifica calea si permisiunile fisierului. Va trebui sa instalati mod-ul manual.
    )
)

:GameFound
if %gameFound%==0 (
    set "defaultLibPath=!steamPath!\steamapps"
    if exist "!defaultLibPath!\appmanifest_%appId%.acf" (
	echo Balatro a fost gasit in: !defaultLibPath!
	set "balatroFile=!defaultLibPath!\steamapps\common\Balatro\Balatro.exe"
	set "gameFound=1"
    )
)

color 07
echo ==========================================
echo.
echo.
echo ==========================================

if %gameFound%==0 (
    color 04
    echo Nu a fost gasit jocul Balatro. Navigati catre Balatro.exe si selectati-l.
    set "dialogTitle=Selecteaza balatro.exe"
    set "fileFilter=Balatro Executable (balatro.exe) | balatro.exe"

    for /f "delims=" %%I in ('powershell -Command "& { Add-Type -AssemblyName System.Windows.Forms; $dlg = New-Object System.Windows.Forms.OpenFileDialog; $dlg.Filter = '!fileFilter!'; $dlg.Title = '!dialogTitle!'; $dlg.ShowHelp = $true; $dlg.ShowDialog() | Out-Null; $dlg.FileName }"') do set "selectedFile=%%I"

    if defined selectedFile (
        set "balatroFile=!selectedFile!"
        echo Balatro.exe : !balatroFile!
	set "gameFound=1"
    ) else (
	echo Nu a fost selectat jocul Balatro. Va trebui sa instalati mod-ul manual. Pentru a face asta, urmati urmatoarele instructiuni:
	echo 1. Se va deschide automat folder-ul BalatRO in care aveti fisierele de localizare in limba Romana ale jocului. Tineti fereastra deschisa, veti avea nevoie mai tarziu de aceste fisiere
	echo 2. Acum deschideti folder-ul unde se afla executabilul Balatro.exe. Daca nu stiti unde se afla Balatro.exe, il puteti gasi in biblioteca Steam apasand clic dreapta pe jocul Balatro, iar apoi pe Gestioneaza si pe Rasfoieste Fisierele Locale
	echo 3. Faceti clic dreapta pe Balatro.exe (pe Windows 11 apasati pe "Show more options"^), apoi duceti cursorul mouse-ului pe 7zip si faceti clic pe ^"Open Archive^"^. ^(Daca nu aveti 7zip instalat, va trebui sa il instalati pentru a continua procesul de instalare^)
	echo 4. Inapoi in fereastra BalatRO, selectati tot ce se afla in acesta si trageti fisierele in fereastra 7zip. 7zip va intreba daca sunteti sigur ca vreti sa copiati fisiere inauntrul arhivei Balatro.exe. Faceti clic pe "Yes"
	echo 5. Mod-ul este instalat acum! Puteti inchide fereastra 7zip, si puteti deschide jocul Balatro in mod obisnuit prin Steam. In joc, trebuie sa selectati limba romana din meniul principal
	explorer "!RESOURCES!" 
    )
)

if %gameFound%==1 (
	color 07
	echo Se instaleaza mod-ul in jocul Balatro...
	"C:\Program Files\7-Zip\7z.exe" a -bso0 "!line!\steamapps\common\Balatro\Balatro.exe" ".\BalatRO Files\*"
	echo Mod-ul a fost instalat. Distractie placuta!

	rmdir /s /q "!RESOURCES!"
	echo ==========================================

	"!balatroFile!"

) 
echo ==========================================

:fin
echo.
echo.
echo.
pause