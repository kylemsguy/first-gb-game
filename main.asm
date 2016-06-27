INCLUDE "defines.inc"
SECTION "rom", HOME
INCLUDE "header.inc" ; Include cartrdige boot header

; $0150: Code!
main:
	call MUSIC_INIT
	;call init_music_ram
	ldh A, [INT_ENABLE] ; Get status of interrupt enable register
	OR 1 ; enable VBLANK
	ldh [INT_ENABLE], A

.loop:
    ; TODO do stuff with button press
    halt
	call handle_joypad
    jr .loop

draw: ; VBLANK
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
	ld [$C100], A
	
	ei             ;- enable interrupts
	reti
stat:
	reti
timer:
	call SONG1_PLAYROUTINE
	;call playroutine
	reti
serial:
	reti
joypad:
    reti

handle_joypad:
	ld A, [$C100]
	and $8          ; Get state of start button
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
	call MUSIC_INIT
end_handle_joypad:
	xor A
	ld [$C100], A
	ret

init_snek:
	; initialize snake code
	ret

SECTION   "CoolStuff",ROM0[$0500]
INCBIN "zinnia.gbs", $70, $1d89