@Echo Off

Echo WHDPacker v1.2 Copyright © 2020 SimJoy Free Software
Echo.
Echo This script converts a WHDLoad game archive into a
Echo standalone fullscreen "Windows Game" by packing it
Echo with WinUAE, Amiga Roms and WHDLoad.
Echo.
Echo You can just execute the resulting executable to
Echo enjoy the good old days.
Echo Have fun. :)
Echo. 

If [%1]==[] GoTo Usage

For /f "Tokens=1,2,3 Delims=_" %%A In ("%~n1") Do Set PckFile=%%A

Set WorkDir=%CD%

Set PckDir=%WorkDir%\Packed
Set ResDir=%WorkDir%\Resource
Set TmpDir=%WorkDir%\Temp

Set Startup=%TmpDir%\SYS\S\User-Startup
Set SFXFile=%ResDir%\SFX.fil
Set SFXIcon=%ResDir%\Amiga.ico

Set RAR=%ResDir%\WinRAR.exe

If Not Exist "%TmpDir%" MkDir "%TmpDir%"
If Not Exist "%PckDir%" MkDir "%PckDir%"

Echo Extracting Emulator Files
"%RAR%" x "%ResDir%\Emulator.rar" "%TmpDir%"

Echo Extracting WHDLoad System Files
"%RAR%" x "%ResDir%\Drives.rar" "%TmpDir%"

Echo Copying Configuration File
Copy "%ResDir%\Config_Scanline_1920x1080.uae" "%TmpDir%\WHDLoad.uae" >NUL

Echo Extracting %1
"%RAR%" x "%1" "%TmpDir%\WHD"

Cd "%TmpDir%\WHD\%PckFile%*"
For /f "Delims=\" %%I in ("%CD%") Do Set PckName=%%~nI
Cd %WorkDir%

Echo Generating User-Startup File
Echo echo ""; > "%Startup%"
Echo echo "WHDLoad Game Launcher v1.2 Copyright © 2020 SimJoy Free Software"; >> "%Startup%"
Echo echo ""; >> "%Startup%"
Echo echo "Running %PckName%..."; >> "%Startup%"
Echo echo ""; >> "%Startup%"
Echo cd DH1:%PckName%; >> "%Startup%"
Echo WHDLoad %PckName%.slave PRELOAD; >> "%Startup%"

Echo Generating WinRAR SFX Options File
Echo Setup=WHDLoad.exe -f WHDLoad.uae -portable > "%SFXFile%"
Echo Path=%PROGRAMDATA%\WHDPacker\%PckName% >> "%SFXFile%"
Echo Silent=1 >> "%SFXFile%"
Echo Overwrite=2 >> "%SFXFile%"

Echo Generating %PckName%.bat
Echo @Start WHDLoad.exe -f WHDLoad.uae -portable > "%TmpDir%\%PckName%.bat"

Echo Deleting Previously Generated Executable
If Exist "%PckDir%\%PckName%.exe" Del "%PckDir%\%PckName%.exe"

Echo Generating %PckName%.exe
Cd "%TmpDir%"
"%RAR%" a -m5 -sfx -s -rr -r -k -z"%SFXFile%" -iicon"%SFXIcon%" "%PckDir%\%PckName%.exe"
Cd ..

Echo Deleting Temporary Files
If Exist "%TmpDir%" RmDir /s /q "%TmpDir%"
If Exist "%SFXFile%" Del "%SFXFile%" 
Echo.

GoTo End

:Usage
Echo Usage: WHDPacker WHDLoadArchiveName.zip
Echo.
Echo Press any key to exit
Pause >NUL

:End
