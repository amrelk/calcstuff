Program:     Lock 83/83+/86
Version:     1.7
Author:      James Vernon <james@calc.org>
Description: Security Program
Machines:    TI-83, TI-83+, TI-86
Platforms:   Ion, MirageOS, TI-86-OS, most TI-86 shells
Language:    Z80 Assembly Code
Released:    April 2001
Size:        TI-83 Ion:       253 bytes
             TI-83+ Ion:      258 bytes
             TI-83+ MirageOS: 391 bytes
             TI-86:           424 bytes


*********************
** Version History **
*********************
Sizes sited here are for TI-83 version.

v1.0: (512 bytes) - August 1999
- First public release
- Only for the TI-OS on the 83

v1.1: (480 bytes) - April 2000
- Compatible with AShell, SOS, ION 83 and ION 83+
- Just run program to turn calculator off
- Enter passwords of any length (only first 15 characters saved)
- Added backspace function
- Optimised

v1.2: (334 bytes) - April 2000
- Now an ION module
- No longer compatible with AShell or SOS
- Optimised a bit more
- Can only enter up to 15 chars.

v1.3: (342 bytes) - May 2000
- Module for ION83, ION83+
- Added APD (thanks Henk Poley for the idea)
- Released source code again
- Optimised more (again)
- Now you really can only enter up to 15 characters

v1.4: (312 bytes) - May 2000
- Fixed a bug
- Can enter heaps of characters again because this was the bit that caused the program to crash
- Reduced the size a bit

v1.5: (265 bytes) - July 2000
- Optimised way more!
- Only saves the first 10 characters of your password (to save a bit of space :)

v1.6: (261 bytes) - September 2000
- Shaved off another 4 bytes

v1.7: (253 bytes) - April 2001
- Optimised a tiny bit more
- Ported to TI-86
- Made a MirageOS version
- Code fully documented ;)


********************
** Included Files **
********************
PROGRAM FILES:
zmlock83.83p     TI-83 Ion version
zmlock83.8xp     TI-83+ Ion version
lock83p.8xp      TI-83+ MirageOS version
lock86.86p       TI-86 version

DOCUMENTATION:
readme.txt       This document

SOURCE CODE:
lock.asm         All source code included in this file
get_key.inc      GET_KEY equates
build.bat        Batch file to build lock.asm


***********
** Setup **
***********
TI-83 Ion:       Send zmlock83.83p to your calculator
TI-83+ Ion:      Send zmlock83.8xp to your calculator
TI-83+ MirageOS: Send lock83p.8xp to your calculator
TI-86:           Send lock86.86p to your calculator

Ion Users:
 You must have Ion (preferably the latest version) installed on your calculator. This can be obtained from http://joewing.calc.org. You also need at least one Ion program on your calculator because Lock 83(+) is a module and can only be used when Ion is running. The latest version of Ion at the time of release was v1.6.

MirageOS Users:
 You need MirageOS installed on your calculator. Run the program from the directory menu. Note that MirageOS has it's own password feature but I decided to make a MirageOS version just for the hell of it ;)

TI-86 Users:
 This program can be run using the AsmPrgm( command or a shell, such as Rascall. However, Rascall and some other shells come with their own password features so it's kinda pointless using Lock 86 with them unless you prefer it.


**************************
** Using Lock 83/83+/86 **
**************************
Ion Users:
 To set a password, press [TRACE] from the Ion program menu. You will be prompted for a password. Once you have set a password, you can press [GRAPH] from the Ion menu to turn off the calculator. When you turn the calculator back on, you will have to enter your password, otherwise you won't be allowed into the calculator. To disable Lock 83(+), press [TRACE] from Ion and enter your old password. Then for the new password, just leave it blank and press [ENTER]. Now pressing [GRAPH] from Ion will do nothing again.
 When you go to change your password and you are prompted to enter your old password, if you enter it wrong the module will exit back to Ion without changing the password.

MirageOS/TI-86 Users:
 When the program is run for the first time (or any other time it's disabled), you will be at the Main Menu. Here you can return to the OS or set/change the password by pressing the corresponding number key.

All Users:
 When entering a password, if you don't press a key for a couple of seconds, the calculator turns off. Don't worry - this is meant to happen, when you turn it back on you'll be right where you left off. This is just a little APD routine that I've added so the calculator can't sit there and drain your batteries.


************************
** Entering Passwords **
************************
 Any key can be pressed on the calculator for a password, except for the [ON] button, [DEL] and [ENTER]. The [DEL] button is used for backspace. Press [ENTER] when you have finished entering the password. The [ON] button won't do anything. Note that you can't backspace to a previous line.

 Remember that only the first 10 characters of any password you enter are saved.


****************
** Disclaimer **
****************
  If you forget your password and the calculator has been turned off through Lock 83/83+/86, there is nothing you can do. I take no responsibility for your forgetfulness!


Many thanks to the following people:
- Henk Poley for the APD idea!
- Dan Englender for helping me to optimise it and also for helping me find a bug with the 83+ version in v1.1!
- James Matthews for ASMGuru
- David Phillips for a bit of code used out of Zelda 86 for program writeback
- Bill Nagel for Password which gave me the idea
- Joe Wingerbermuehle for Ion
- Detached Solutions for MirageOS
- Assembly-83 Mailing List
- ticalc.org for hosting the mailing list
- Anyone else I forgot to mention!


 If you have any comments, bug reports or other interesting stuff please email me!

Lock 83/83+/86 v1.7
Copyright (c)1999-2001 TI-Calculator Programming Alliance
Written and Programmed by James Vernon <james@calc.org>
ICQ#: 71589304
http://tcpa.calc.org