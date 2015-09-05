@ECHO OFF

ECHO ----- Assembling Lock 83+ for TI-83+ Ion...
ECHO #define TI83P > temp.asm
TYPE lock.asm >> temp.asm
TASM -80 -I -B temp.asm zmlock83.bin
IF ERRORLEVEL 1 GOTO ERRORS
DEVPAC8X zmlock83

ECHO ----- Assembling Lock 83+ for TI-83+ MirageOS...
ECHO #define MIRAGE > temp.asm
TYPE lock.asm >> temp.asm
TASM -80 -I -B temp.asm lock83p.bin
IF ERRORLEVEL 1 GOTO ERRORS
DEVPAC8X lock83p

ECHO ----- Assembling Lock 83 for TI-83 Ion...
ECHO #define TI83 > temp.asm
TYPE lock.asm >> temp.asm
TASM -80 -I -B temp.asm zmlock83.bin
IF ERRORLEVEL 1 GOTO ERRORS
DEVPAC83 zmlock83

ECHO ----- Assembling Lock 86 for TI-86...
ECHO #define TI86 > temp.asm
TYPE lock.asm >> temp.asm
TASM -80 -I -B temp.asm lock86
IF ERRORLEVEL 1 GOTO ERRORS
PRGM86 lock86

ECHO.
ECHO.
ECHO ----- Success
ECHO TI-83 Ion version is zmlock83.83p
ECHO TI-83+ Ion version is zmlock83.8xp
ECHO TI-83+ MirageOS version is lock83p.8xp
ECHO TI-86 version is lock86.86p
GOTO DONE

:ERRORS
ECHO ----- There were errors

:DONE
IF EXIST temp.asm DEL temp.asm > NUL
IF EXIST zmlock83.bin DEL zmlock83.bin > NUL
IF EXIST lock86 DEL lock86 > NUL
IF EXIST lock83p.bin DEL lock83p.bin > NUL
IF EXIST temp.lst DEL temp.lst > NUL