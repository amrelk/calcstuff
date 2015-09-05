;###########################################################;
;                                                           ;
; Lock 83/83+/86                                            ;
; Version 1.7                                               ;
;                                                           ;
; Copyright (c)1999-2001 TI-Calculator Programming Alliance ;
; Written and Programmed by James Vernon <james@calc.org>   ;
; ICQ#: 71589304                                            ;
; http://tcpa.calc.org                                      ;
;                                                           ;
; You may use parts of the code as long as you give me      ;
; credit. Changes are to be for personal use only! You      ;
; are not allowed to distribute a modified source without   ;
; my permission!                                            ;
;                                                           ;
;###########################################################;

;################################################
; TI-83 Ion Header
;################################################
#ifdef TI83
#define ION
#include "ion.inc"

.org    sram
        ret
.db     2
#endif

;################################################
; TI-83+ Ion Header
;################################################
#ifdef TI83P
#define ION
#include "ion.inc"

.org    sram-2
.db     $BB,$6D
        ret
.db     2
#endif

;################################################
; TI-83+ MirageOS Header
;################################################
#ifdef MIRAGE
#define EQU .equ
#include "ti83plus.inc"
#include "mirage.inc"

_homeup                 = $4558
tempPass                = saferam1

.org    $9D93
.db     $BB,$6D
        ret
.db     1

.db %00000000, %00000000
.db %00000000, %00000000
.db %00000000, %00000000
.db %00000011, %10000000
.db %00000100, %01000000
.db %00000100, %01000000
.db %00001111, %11100000
.db %00001111, %11100000
.db %00001110, %11100000
.db %00001110, %11100000
.db %00001111, %11100000
.db %00001111, %11100000
.db %00000000, %00000000
.db %00000000, %00000000
.db %00000000, %00000000
.db     "Lock 83+ v1.7",0
#endif

;################################################
; TI-86 Header
;################################################
#ifdef TI86
#define equ .equ
#include "ti86.inc"
#define GETKEY_8586
#define bcall(xxxx) call xxxx

_getcsc                 = $5371
curcol                  = _curcol
_clrscrnfull            = _clrscrn
tempPass                = _op5

.org    _asm_exec_ram
        nop
        jp      start
.dw     0
.dw     title
title:
.db     "Lock 86 v1.7",0
#endif

;################################################
; GET_KEY equates
;################################################
#include "get_key.inc"

;################################################
; Start of Program
;################################################
start:
#ifdef ION
        sub     GK_GRAPH                        ; [GRAPH]
        jr      z,testPowerOff                  ; If so, turn off if enabled
        dec     a                               ; [TRACE]
        ld      a,1                             ; If we exit to Ion, there's no need to restart
        ret     nz                              ; If [TRACE] not pressed, leave
#else
        ld      a,(passSlot)
        or      a
        jp      nz,powerOff                     ; If enabled, turn off!
startLoop:
        bcall(_clrscrnfull)
startLoop2:
        bcall(_homeup)                          ; Cursor to top left
        ld      hl,strMain
        call    puts                            ; Write heading, then linefeed
        bcall(_puts)                            ; Write options
        bcall(_getcsc)                          ; Get any key presses
        cp      GK_1                            ; [1]
#ifdef MIRAGE
        ret     z
#else
        jp      z,savePassword
#endif
        cp      GK_2                            ; [2]
        jr      nz,startLoop2                   ; If it wasn't [2], back to start of loop
#endif

changePassword:
        call    iniScreen                       ; Initialise screen
        ld      a,(passSlot)
        or      a                               ; Is there currently a password?
        jr      z,enable                        ; If not, no need to receive the old one

        ld      hl,strEnterOld                  ; HL => String to show
        call    puts                            ; "Old:"
        call    getPassword                     ; Get a password
        call    comparePasswords                ; Compare it to the old one
#ifdef ION
        jr      nc,exitWithRestart              ; If it's wrong, exit
#else
        jr      nc,startLoop
#endif
        bcall(_newline)                         ; Otherwise, line feed

enable:
        ld      hl,strEnterNew
        call    puts                            ; "New:"
        call    getPassword                     ; Get a password

        ld      hl,tempPass                     ; HL => Where password is stored
        ld      de,passSlot                     ; DE => Where to save it
        ld      bc,10                           ; BC = 10 characters to save
        ldir                                    ; Save new password

#ifndef ION
        jr      startLoop
#endif

#ifdef ION
exitWithRestart:
        xor     a                               ; Tell Ion to restart
        ret                                     ; Return to Ion
#endif

testPowerOff:
        ld      a,(passSlot)
        or      a                               ; Is program enabled?
        ret     z                               ; If not, leave

powerOff:
        call    calcOff                         ; Turn calculator off until [ON] is pressed

        call    iniScreen                       ; Clear screen, cursor to top left
        bcall(_getcsc)                          ; Catch last key press
        ld      hl,strEnterPassword
        call    puts                            ; "Password:"
        call    getPassword                     ; Get a password
        call    comparePasswords                ; Compare it to the correct password
        jr      nc,powerOff                     ; If it's wrong, turn off again!
#ifdef ION
        ret                                     ; Otherwise, leave
#else
        jr      startLoop
#endif

getPassword:
        ld      b,10                            ; B = 10 bytes to clear
        ld      hl,tempPass                     ; HL => Start of temp storage
        push    hl                              ; Save pointer
clearTempLoop:
        ld      (hl),0                          ; Clear byte
        inc     hl                              ; HL => Next byte
        djnz    clearTempLoop                   ; Repeat until finished clearing
        pop     hl                              ; HL => Start of temp storage

getPassLoop:
        push    hl                              ; Save pointer
        ld      de,0                            ; APD counter

getPassKey:
        inc     de                              ; Increment APD counter
        ld      a,d                             ; A = MSB of APD counter
        cp      $FF                             ; Is it 255 yet?
        call    nc,calcOff                      ; If so, APD
        bcall(_getcsc)                          ; Get key code
        or      a                               ; Was a key pressed?
        jr      z,getPassKey                    ; If not, try again
        push    af                              ; Save key code
        cp      GK_DEL                          ; [DEL]
        jr      z,delChar
        cp      GK_ENTER                        ; [ENTER]
        jr      z,getPasswordFinished

#ifdef TI86
        ld      a,231
#else
        ld      a,241                           ; A = Character to show
#endif
        bcall(_putc)                            ; Show the character
        pop     af                              ; A = Key code
        pop     hl                              ; Restore pointer
        ld      (hl),a                          ; Save character
        inc     hl                              ; HL => Next byte in temp storage
        jr      getPassLoop                     ; Loop

getPasswordFinished:
        pop     af                              ; Clear stack
        pop     hl
        ret

delChar:
        pop     af                              ; Useless so get it off the stack
        ld      a,(curcol)                      ; Get cursor column
        or      a                               ; Is it 0?
        jr      z,getPassKey                    ; If so, can't backspace
        dec     a                               ; Move back a spot
        ld      (curcol),a                      ; Save it
        ld      a,' '                           ; A = Character to show
        bcall(_putmap)                          ; Show character without updating cursor
        pop     hl                              ; Restore pointer
        dec     hl                              ; Move back byte to accomodate the backspace
        ld      (hl),0                          ; Clear byte
        jr      getPassLoop                     ; Back to loop

comparePasswords:
        ld      hl,tempPass                     ; HL => Start of temp storage
        ld      de,passSlot                     ; DE => Start of proper password
        ld      b,10                            ; B = 10 characters to show

compareLoop:
        ld      a,(de)                          ; A = Proper character
        cp      (hl)                            ; Compare it to character in temp storage
        jr      nz,wrong                        ; If wrong, get out of here!
        inc     de                              ; Increment both pointers
        inc     hl
        djnz    compareLoop                     ; Loop
        scf                                     ; Set Carry Flag to say that password is correct :)
        ret

wrong:
        or a                                    ; Clear carry to say password is wrong :(
        ret

iniScreen:
        bcall(_clrscrnfull)                     ; Clear screen
        bcall(_homeup)                          ; Cursor to top left
        ret

puts:
        bcall(_puts)                            ; Write string in large font
        bcall(_newline)                         ; Line feed
        ret

calcOff:
        ei                                      ; Enable interrupts
        ld      a,1
        out     (3),a                           ; Turn off
        halt                                    ; Wait for [ON]
        ld      a,11
        out     (3),a                           ; Turn on
        ld      de,0                            ; Reset APD counter for getPassword routine
        ret

#ifdef TI86
; This routine is pretty much taken straight out of Zelda 86
savePassword:
        ld      hl,prgmName-1                   ; HL => Name of program
        rst     20h                             ; Copy to op1
        rst     10h                             ; Call _findsym
        call    _ex_ahl_bde                     ; AHL => Start of program in RAM
        ld      de,passSlot-_asm_exec_ram+4     ; DE => Offset
        add     hl,de
        adc     a,0                             ; AHL => Where to copy data to
        call    _set_abs_dest_addr              ; Save destination
        sub     a                               ; A = 0
        ld      hl,passSlot                     ; AHL => Source
        call    _set_abs_src_addr               ; Save source
        ld      hl,10                           ; HL = 10 bytes to copy
        call    _set_mm_num_bytes               ; Save counter
        jp      _mm_ldir                        ; Copy data
#endif

;################################################
; Strings & Data
;################################################
strEnterOld:
.db     "Old:",0

strEnterNew:
.db     "New:",0

strEnterPassword:
.db     "Password:",0

passSlot:
.db     0,0,0,0,0,0,0,0,0,0

#ifdef MIRAGE
strMain:
.db     " Lock 83+  v1.7 "
.db     "By James Vernon ",0
.db     "1. Return to OS "
.db     "2. New Password",0
#endif

#ifdef TI86
strMain:
.db     "    Lock 86  v1.7    "
.db     "By James Vernon      ",0
.db     "1. Return to OS      "
.db     "2. Change Password",0
prgmName:
.db     6,"lock86"
#endif

#ifdef ION
tempPass:            ; Temporarily stores passwords after module
#endif

.end
