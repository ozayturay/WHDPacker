@Echo Off
Echo This script packs all games in the Files folder
Echo and puts packed files inside the Packed folder
Echo.
Echo If you don't have any files in the Files folder
Echo press CTRL+C now to terminate this batch file
Echo.
Echo To continue packing press any key
Echo.
Pause >NUL
For %%F in (Files\*.zip) Do Call WHDPacker_Classic.bat %%F
Echo Completed
Echo Press any key to quit
Pause >NUL