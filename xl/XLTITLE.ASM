;--------------------------------------------------------------------
;
;	Initialize Game Program for XL
;
;				programed by Masato Kimura
;
;				03/02/1993
;--------------------------------------------------------------------
;
;	if tirleselect=0 then goto title seqence
;	   titleselect=1 then skip title seqence 
					
titleselect	equ	0

;	playerselect=0 then 1 payer mode 
;		    =1      2 players mode 
;
playerselect    equ	0
	
;
	
	incpublics	xltitle.ext

;


Title_sequence


;---------------------------------------------------------------------
;debug mode !!!!
	ifne	titleselect	

	php

	ifne	playerselect
	a8
	lda	#02h
	sta.l	player_mode
	endc
	ifeq	playerselect
	a8
	lda	#00h
	sta.l	player_mode
	endc

	plp
	rtl			;skip title

	endc
;---------------------------------------------------------------------


	php
	ai8
	phb
	phk
	plb

;Initial_title

	jsl	initial_title

;Set_title_OBJ

	a8i16
	ldx	#00H

Title_main_loop
	lda	Title_OBJ_main&WM,x
	cmp	#0ffh
	beq	End_t_main
	sta	spriteblk,x
	inx
	bra	Title_main_loop
End_t_main
	ldx	#00h
Title_sub_loop
	lda	Title_OBJ_sub&WM,x
	cmp	#0ffh
	beq	End_t_sub
	sta	spriteblk+512,x
	inx
	bra	Title_sub_loop
End_t_sub
;Initialize Tlile Resister
	ai8
	lda	#12h
	sta	212ch	;Through main=only OBJ
	
;Initialize Title Variables
	a8
	stz	map_number
	stz	player_mode
	stz	irq_index
	lda	#4ch
	sta	cursor_posh
	lda	#0a8h
	sta	cursor_posv
	stz	screen_contrast+01
	stz	fade_control	;00=fade in
				;ff=fade out	 	

;--------------------------------------------------------------------
;Start title Pragram!!!
;	lda	#18h
;	sta	4209h	;v timer low
;	stz	420ah	;v timer high
;	lda	#0a0h
;	sta	4207h	;h timer low
;	stz	4208h	;h timer high
;
	lda	#%00110001 ;enable timer IRQ
	sta	4200h
	cli		;start irq!!!
;--------------------------------------------------------------------
Title_loop
	jsr	Title_routin
Wait_title
	a8
	lda	screen_contrast+01
	bmi	Exit_title	
	lda	irq_flag
	beq	Wait_title
;	
	stz	irq_flag
	bra	Title_loop
Exit_title
	stz	4200h	;disable timer
	sei		;stop irq !!!
	ai8
	plb
	plp
	rtl

;--------------------------------------------------------------------
Title_routin	      
	a8
	lda	fade_control
	beq	.fadeintitle
.fadeouttitle
	a16
	lda	screen_contrast
	sec
	sbc	#060h
	bcs	.contfadeout
	lda	#8000h
.contfadeout
	sta	screen_contrast
	rts
.fadeintitle
	a16
	lda	screen_contrast
	cmp	#0f00h
	bcs	.nomorefade
	clc
	adc	#050h
	cmp	#0f00h
	bcc	.contfadein
	lda	#0f00h
.contfadein
	sta	screen_contrast
	rts
.nomorefade





.skipcheck

	a16
	lda	cont0l
	bit	#0010000000000000b
	beq	.notdebugmode
	bit	#0000000000100000b
	beq	.notdebugmode
;;;;;	bit	#0001111100010000b
;;;;;	bne	.notdebugmode
	lda	trig0
	bmi	.pushB
	bit	#0100000000000000b
	bne	.pushY
	bit	#0000000010000000b
	beq	.notdebugmode
.pushA
	lda	#01
	bra	.setmapnumber
.pushY
	lda	#03
	bra	.setmapnumber
.pushB
	lda	#02
.setmapnumber
	a8
	sta	map_number
	a16
	dec	fade_control
	rts
.notdebugmode
	lda	trig0
	bit	#01101000011000000b
	beq	.conttitle

	lda	cont0l
	bit	#0000100000000000b
	beq	.p1mode

.p2mode
	a8
	lda	#0ffh
	sta	player_mode
	bra	.exit_title_routin
.p1mode
	a8
	stz	player_mode
.exit_title_routin

      	a16
	dec	fade_control ;=ffh(fade out !!!)
.conttitle
	rts
	

;--------------------------------------------------------------------
cursorvaddr equ	43*4+01
;--------------------------------------------------------------------

tr0v	equ	0b8h
tr0h	equ	068h
tr1v	equ	tr0v+08h
tr1h	equ	tr0h-20h
stv	equ	080h
sth	equ	58h
se0h	equ	0c8h
se0v	equ	080h
se1h	equ	se0h-18h
se1v	equ	se0v+08h
se2h	equ	se0h-28h
se2v	equ	se0v+10h
se3h	equ	se0h-28h
se3v	equ	se0v+18h
se4h	equ	se0h-28h
se4v	equ	se0v+20h
se5h	equ	se0h-28h
se5v	equ	se0v+28h
se6h	equ	se0h-20h
se6v	equ	se0v+30h

Title_OBJ_main

;upper	  NINTENDO     10

	db	tr0h+00h,tr0v,31h,%00110110
	db	tr0h+08h,tr0v,32h,%00110110
	db	tr0h+10h,tr0v,33h,%00110110
	db	tr0h+18h,tr0v,34h,%00110110
	db	tr0h+20h,tr0v,35h,%00110110
	db	tr0h+28h,tr0v,36h,%00110110
	db	tr0h+30h,tr0v,37h,%00110110
	db	tr0h+38h,tr0v,38h,%00110110
	db	tr0h+40h,tr0v,39h,%00110110
	db	tr0h+48h,tr0v,3ah,%00110110

;lower 	  NINTENDO	14

	db	tr1h+00h,tr1v,2dh,%00110110
	db	tr1h+08h,tr1v,2eh,%00110110
	db	tr1h+10h,tr1v,2fh,%00110110
	db	tr1h+18h,tr1v,30h,%00110110
	db	tr1h+20h,tr1v,3bh,%00110110
	db	tr1h+28h,tr1v,3ch,%00110110
	db	tr1h+30h,tr1v,3dh,%00110110
	db	tr1h+38h,tr1v,3eh,%00110110
	db	tr1h+40h,tr1v,3fh,%00110110
	db	tr1h+48h,tr1v,40h,%00110110
	db	tr1h+50h,tr1v,41h,%00110110
	db	tr1h+58h,tr1v,42h,%00110110
	db	tr1h+60h,tr1v,43h,%00110110
	db	tr1h+68h,tr1v,44h,%00110110
	
;push start		9

	db	sth+00h,stv,50h,%00110110
	db	sth+08h,stv,51h,%00110110
	db	sth+10h,stv,52h,%00110110
	db	sth+18h,stv,53h,%00110110
	db	sth+28h,stv,52h,%00110110
	db	sth+30h,stv,54h,%00110110
	db	sth+38h,stv,55h,%00110110
	db	sth+40h,stv,45h,%00110110
	db	sth+48h,stv,54h,%00110110



	db	0ffh
;ces
; 3
	db	se0h+00h,se0v,00h,%00110110
	db	se0h+08h,se0v,01h,%00110110
	db	se0h+10h,se0v,02h,%00110110
; 7 
	db	se1h+00h,se1v,03h,%00110110
	db	se1h+08h,se1v,04h,%00110110
	db	se1h+10h,se1v,05h,%00110110
	db	se1h+18h,se1v,06h,%00110110
	db	se1h+20h,se1v,07h,%00110110
	db	se1h+28h,se1v,08h,%00110110
	db	se1h+30h,se1v,09h,%00110110
; 9
	db	se2h+00h,se2v,0ah,%00110110
	db	se2h+08h,se2v,0bh,%00110110
	db	se2h+10h,se2v,0ch,%00110110
	db	se2h+18h,se2v,0dh,%00110110
	db	se2h+20h,se2v,0eh,%00110110
	db	se2h+28h,se2v,0fh,%00110110
	db	se2h+30h,se2v,10h,%00110110
	db	se2h+38h,se2v,11h,%00110110
	db	se2h+40h,se2v,12h,%00110110
; 9
	db	se3h+00h,se3v,13h,%00110110
	db	se3h+08h,se3v,14h,%00110110
	db	se3h+10h,se3v,15h,%00110110
	db	se3h+18h,se3v,16h,%00110110
	db	se3h+20h,se3v,17h,%00110110
	db	se3h+28h,se3v,18h,%00110110
	db	se3h+30h,se3v,19h,%00110110
	db	se3h+38h,se3v,1ah,%00110110
	db	se3h+40h,se3v,1bh,%00110110
; 8
	db	se4h+00h,se4v,1ch,%00110110
	db	se4h+08h,se4v,1dh,%00110110
	db	se4h+10h,se4v,1eh,%00110110
	db	se4h+18h,se4v,1fh,%00110110
	db	se4h+20h,se4v,20h,%00110110
	db	se4h+28h,se4v,21h,%00110110
	db	se4h+30h,se4v,22h,%00110110
	db	se4h+38h,se4v,23h,%00110110
;  6
	db	se5h+00h,se5v,25h,%00110110
	db	se5h+08h,se5v,26h,%00110110
	db	se5h+10h,se5v,27h,%00110110
	db	se5h+18h,se5v,28h,%00110110
	db	se5h+20h,se5v,29h,%00110110
	db	se5h+28h,se5v,2ah,%00110110
;  2
	db	se6h+00h,se6v,2bh,%00110110
	db	se6h+08h,se6v,2ch,%00110110
	
; total 77 ko		

	db	0ffh	      	;END CODE

Title_OBJ_sub
	db	0,0,0,0,0,0,0,0
	db	%01000000
	db	0ffh
;--------------------------------------------------------------------


	

