@Echo Off

Echo WHDPacker v1.1 Copyright © 2010 SimJoy Free Software
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

Set WORKDIR=%CD%

Set RAR=%WORKDIR%\Progs\WinRAR.exe

For /f "Tokens=1,2,3 Delims=_" %%A In ("%~n1") Do Set PACK=%%A

Set OUT=Temp\SYS\S\User-Startup

If Not Exist Temp MkDir Temp
If Not Exist Packed MkDir Packed

Echo Extracting WHDLoad System Files
"%RAR%" x Drives.rar Temp

Echo Extracting Emulator Files
"%RAR%" x Emulator.rar Temp

Echo Extracting %1
"%RAR%" x %1 Temp\WHD

Cd Temp\WHD\%PACK%*
For /f "Delims=\" %%I in ("%CD%") Do Set NAME=%%~nI
Cd ..\..\..

If Exist Packed\%NAME%.exe Del Packed\%NAME%.exe

Echo echo "";>%OUT%
Echo echo "WHDLoad Game Launcher v1.0 Copyright © 2010 SimJoy Free Software";>>%OUT%
Echo echo "";>>%OUT%
Echo echo "Running %NAME%...";>>%OUT%
Echo echo "";>>%OUT%
Echo cd DH1:%NAME%;>>%OUT%
Echo WHDLoad %NAME%.slave PRELOAD;>>%OUT%

Echo Creating Packed\%NAME%.exe
Cd Temp
"%RAR%" a -m5 -sfx -iadm -s -rr -r -k -z"%WORKDIR%\Progs\SFX.fil" -iicon"%WORKDIR%\Amiga.ico" "%WORKDIR%\Packed\%NAME%"
Cd ..

Echo Deleting Temporary Files
If Exist Temp RmDir /s /q Temp
Echo.

GoTo End

:Usage
Echo Usage: WHDPacker WHDLoadArchiveName.zip
Echo.
Echo Press any key to exit
Pause >NUL

:End
