INCLUDE "defines.inc"
SECTION "rom", HOME
INCLUDE "header.inc" ; Include cartrdige boot header

; $0150: Code!
main:
	call DEFLEMASK_MUSIC_INIT
	;call init_music_ram
	ldh A, [INT_ENABLE] ; Get status of interrupt enable register
	OR 1 ; enable VBLANK
	ldh [INT_ENABLE], A

.loop:
    ; TODO do stuff with button press
    halt
   	call update_pos
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
	;call SONG1_PLAYROUTINE
	;call playroutine
	reti
serial:
	reti
joypad:
    reti

handle_joypad:
	; code goes here
end_handle_joypad:
	ld [$C101], A ; store current val as previous
	xor A
	ld [$C100], A ; clear 
	ret

update_pos:
	ret

init_snek:
	; initialize snake code
	; Copy all tiles to char mem
	ld HL, TileLabel ; init pointer to char mem
	ld BC, 	$8000 ; destination pointer
	ld A, 7 ; we plan on copying 7 sprites
do_cpy:
	ld C, A ; store the accumulator
	ld A, [HL] ; copy byte into register B
	ld [BC], A ; copy byte into charmem
	inc HL ; increment pointer
	inc BC ; increment pointer
	ld A, C ; restore counter
	dec A ; decrement counter
	jp NZ, do_cpy ; loop
	ret

INCLUDE "sprites.inc" 

;SECTION   "CoolStuff",ROM0[$0500]
;INCBIN "zinnia.gbs", $70, $1d89
