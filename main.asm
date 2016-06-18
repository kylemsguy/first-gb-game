INCLUDE "defines.inc"
SECTION "rom", HOME
INCLUDE "header.inc" ; Include cartrdige boot header

; $0150: Code!
main:
	ld A, $FF ;
	ldh [$24], A ; set volume

	ldh [$25], A ; enable channels

	ld A, $80 ;
	ldh [$26], A ; enable sound channels

	ldh [$23], A ; disable counter

	;ld A, $F0
	;ldh [$21], A ; set noise volume and disable envelope

	ld A, $11
	ldh [$06], A ; load TMA

	ld A, $04
	ldh [$07], A ; load TAC

	call MUSIC_INIT

.loop:
    halt
    jr .loop

draw:
stat:
	reti
timer:
	call SONG1_PLAYROUTINE
	reti
serial:
joypad:
    reti

SECTION   "CoolStuff",ROM0[$0500]
INCBIN "zinnia.gbs", $70, $4d9