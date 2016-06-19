INCLUDE "defines.inc"
SECTION "rom", HOME
INCLUDE "header.inc" ; Include cartrdige boot header

; $0150: Code!
main:
	;ld A, $FF ;
	;ldh [$24], A ; set volume

	;ldh [$25], A ; enable channels

	;ld A, $80 ;
	;ldh [ENABLE_SOUND], A ; enable sound channels

	;ldh [$23], A ; disable counter

	;ld A, $F0
	;ldh [NOISE_ENV], A ; set noise volume and disable envelope

	;ld A, $11
	;ldh [TMA], A ; load TMA

	;ld A, $04
	;ldh [TAC], A ; load TAC

	call MUSIC_INIT
	ldh A, [INT_ENABLE] ; Get status of interrupt enable register
	OR 1 ; enable VBLANK
	ldh [INT_ENABLE], A

.loop:
    halt
    jr .loop

draw:
	di             ;- disable interrupts
	ld A,$20       ;- bit 5 = $20
	ld [$FF00],A   ;- select P14 by setting it low
	ld A,[$FF00]
	ld A,[$FF00]   ;- wait a few cycles
	cpl            ;- complement A
	and $0F        ;- get only first 4 bits
	swap A         ;- swap it
	ld B,A         ;- store A in B
	ld A,$10
	ld [$FF00],A   ;- select P15 by setting it low
	ld A,[$FF00]
	ld A,[$FF00]
	ld A,[$FF00]
	ld A,[$FF00]
	ld A,[$FF00]
	ld A,[$FF00]   ;- Wait a few MORE cycles
	cpl            ;- complement (invert)
	and $0F        ;- get first 4 bits
	or B           ;- put A and B together
	; TODO do stuff with button press
	call handle_joypad
	ei             ;- enable interrupts
	reti
stat:
	reti
timer:
	call SONG1_PLAYROUTINE
	reti
serial:
	reti
joypad:
    reti

handle_joypad:
	AND $8          ; Get state of start button
	jr Z, end_handle_joypad ; skip if start button not pressed
	ldh A, [SOUND_ENABLE] ; get the sound enable status
	and $80
	jr Z, enable_sound
	ld A, $0
	ldh [SOUND_ENABLE], A
	jr end_handle_joypad
enable_sound:
	;ld A, $8F ; set sound enable
	;ldh [SOUND_ENABLE], A
	ei
	call MUSIC_INIT
	di
end_handle_joypad:
	ret

SECTION   "CoolStuff",ROM0[$0500]
INCBIN "zinnia.gbs", $70, $1d89