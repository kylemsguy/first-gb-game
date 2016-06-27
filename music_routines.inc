init_music_ram:
	push af                      ; Preserve AF
	ld   a,[$C002]               ; Reads from WorkRam+2 into A
	dec  a                       ; Decrements value
	ld   [$C002],a               ; 4 Writes back to WorkRam
	jr   z,init_music_engine     ; If zero, jump to $0550
	pop  af                      ; Restore AF
	reti                         ; Return + enable ints

init_music_engine:
	push bc                       ;36 4 push BC onto stack
	push hl                       ;40 4 push HL onto stack
	ld   a,[$C001]                ;44 4 
	ld   [$C002],a                ;48 4
	ld   a,[$C003]                ;52 4
	ld   [$2000],a  ;ROM select   ;56 4
	ld   a,[$C004]                ;60 4
	ld   h,a                      ;61 1
	ld   a,[$C005]                ;65 4
	ld   l,a                      ;66 1
jump_0566:
	ldi  a, hl                   ;68 2
	cp   $80                       ;70 2
	jr   nc,jump_0581                  ;72 2/3
	add  a,$10                     ;74 2
	ld   c,a                      ;75 1
	ldi  a, hl                   ;77 2
	ldh   [$c],a              ;79 2
	jp   jump_0566                     ;83 4
jump_0573:
	ld   b,a                      ;84 1
	inc  b                        ;85 1
	ldi  a,hl                   ;87 2
	add  a,$10                     ;89 2
	ld   c,a                      ;90 1
	ldi  a,hl                   ;92 2
jump_057A:
	ldh   [$c],a              ;94 2
	dec  b                        ;95 1
	jr   nz,jump_057A                  ;98 2/3
	jp   jump_0566                     ;2  4
jump_0581:
	jp   z,jump_05DA                   ;5  3/4
	sub  $90                       ;7  2
	jr   nc,jump_0573                  ;10 2/3
	cp   $F1                       ;12 2
	jr   z,jump_05A0                   ;14 2/3
	cp   $F2                       ;16 2
	jr   z,jump_05B6                   ;18 2/3
	ld   a,[$C003]                ;22 4
	inc  a                        ;23 1
	ld   [$C003],a                ;27 4
	ld   [$2000],a  ;ROM select   ;31 4
	ld   hl,4000                  ;34 3
	jp   jump_0566                     ;38 4
jump_05A0:
	ld   a,$01                     ;40 2
	ld   [$C006],a                ;44 4
	ld   a,[$C003]                ;48 4
	ld   [$C007],a                ;52 4
	ld   a,h                      ;53 1
	ld   [$C008],a                ;57 4
	ld   a,l                      ;58 1
	ld   [$C009],a                ;62 4
	jp   jump_0566                     ;66 4
jump_05B6:
	ld   a,[$C006]                ;70 4
	or   a                        ;71 1
	jr   nz,jump_05C3                  ;73 2/3
	xor  a                        ;74 1
	ldh   [$26],a ;snd stat   ;77 3
	dec  hl                       ;79 2
	jp   jump_05DA                     ;83 4
jump_05C3:
	ld   a,[$C007]                ;87 4
	ld   [$C003],a                ;91 4
	ld   [$2000],a  ;ROM select   ;95 4
	ld   [$C007],a                ;99 4
	ld   a,[$C008]                ;3  4
	ld   h,a                     ;4  1
	ld   a,[$C009]                ;8  4
	ld   l,a                     ;9  1
	jp   jump_0566                    ;13 4
jump_05DA:
	ld   a,h                     ;14 1
	ld   [$C004],a                ;18 4
	ld   a,l                     ;19 1
	ld   [$C005],a                ;23 4
	ld   a,[$FF80]                ;27 4
	ld   [$2000],a  ;ROM select   ;31 4
	pop  hl                      ;34 3
	pop  bc                      ;37 3
	pop  af                      ;40 3
	reti                         ;44 4

; Playroutine Preamble
playroutine:
	di                           ;45 1
	ld   a,$00                    ;47 2
	ld   hl, $05F6                 ;50 3  Perhaps $05f6 is the start of the song data

; Playroutine 
	ld   [$C003],a                ;19 4
	ld   [$2000],a  ;ROM select   ;23 4
	xor  a                       ;24 1
	ld   [$4000],a  ;RAM select   ;28 4
	ld   [$6000],a  ;?            ;32 4
	ld   [$C006],a                ;36 4
	ld   bc,$0006                 ;39 3
	add  hl,bc                   ;41 2
	ldi  a, hl                 ;43 2
	ldh   [$06],a ;timer reloa;46 3
	ld   a,$04                    ;48 2
	ldh   [$07],a ;timer ctrl ;51 3
	ldi  a, hl                  ;53 2
	ld   [$C001],a                ;57 4
	ld   [$C002],a                ;61 4
jump_0522:
	ldi  a, hl                  ;63 2
	or   a                       ;64 1
	jr   nz,jump_0522                 ;67 2/3
	ld   a,h                     ;68 1
	ld   [$C004],a                ;72 4
	ld   a,l                     ;73 1
	ld   [$C005],a                ;77 4
	di                           ;78 1
	ldh   a,[$FF] ;int enable ;81 3
	or   $04                      ;83 2
	ldh   [$FF],a ;int enable ;86 3
	ei                           ;87 1
	ret                          ;91 4