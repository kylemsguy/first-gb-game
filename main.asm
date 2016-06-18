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

	ld A, $F0
	ldh [$21], A ; set noise volume and disable envelope

.loop:
    halt
    jr .loop

draw:
stat:
timer:
serial:
joypad:
    reti