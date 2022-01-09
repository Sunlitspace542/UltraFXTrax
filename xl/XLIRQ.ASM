;--------------------------------------------------------------------
;
;	IRQ Control Program for XL
;
;				programed by Masato Kimura
;
;				24/02/1993
;--------------------------------------------------------------------
;

	
	incpublics	xlirq.ext


irq_routin
	ai16
	pha
	lda.l	mflags
	bmi	.qexit
	phb
	disable
	phx
	phy
	ai8
	lda	#0
	pha
	plb
	nastyon
	jsl	irqcode
	a8
	lda	timeupr
	bra	.exit
	longa
.qexit	pla
	rtl
.exit	ai16
	ply
	plx
	plb
	pla
	rtl
;-------------------------------------------
	shorta
	shorti
irqcode


	ai8
.wait_Hblanking
	lda.l	$4212			;b7 check V blanking
	bit	#%01000000
	beq	.wait_Hblanking

	ldx	irq_index
	jmp	(IRQ_table&WM,x)
;--------------------------------------------------------------------

irq_table
	irv	title_01
	irv	title_02
	irv	game1p_01
	irv	game1p_02
	irv	game2p_01
	irv	game2p_02
	irv	game2p_03
	irv	game2p_04

;--------------------------------------------------------------------

title_01
	lda	screen_contrast+01
	sta.l	2100h	;Screen contrast! 00-0f
	lda	#$0c8
	sta.l	4209h	;set V count timer low 1 byte
	lda	#02h
	sta	irq_index

	inc	framecounter
	inc	framec
;;;;	jsr	apu_control
	rtl	
title_02
	lda	#$80
	sta.l	$2100	;Blanking!!!
	lda	#$017
	sta.l	$4209	;set V count timer low 1byte
	lda	#00h
	sta	irq_index
	lda	#0ffh
	sta	irq_flag   ;IRQ FLAG ON!!!
	lda	#02h
	sta.l	$420ch			;HDMA switch on !!!
;;;;	jsr	set_scroll
	jsr	scan_controller
	jsr	transfer_sprite
	jsr	apu_control
	rtl	
;--------------------------------------------------------------------
game1p_01
	lda	screen_contrast+01
	sta.l	$2100			;Screen contrast! 00-0f
	lda	#$0d0
       	sta.l	$4209			;set V count timer low 1 byte
	lda	#06h
	sta	irq_index
	inc	framecounter
	inc	framec
	rtl	
game1p_02
	lda	#$80
	sta.l	$2100			;Blanking!!!
	lda	#$010
	sta.l	$4209			;set V count timer low 1byte

;	lda	#13h
;	sta	212ch

	lda	#02h
	sta.l	$420ch			;HDMA switch on !!!
	lda	#04h
	sta	irq_index
	jsr	set_scroll
	jsr	transfer_bitmap
	jsr	apu_control
	jsr	transfer_time
	jsr	transfer_color_anime
;;;;	jsr	transfer_character
	jsr	scan_controller_race
	rtl	
;--------------------------------------------------------------------

game2p_01


	lda	screen_contrast+01
	sta	$2100			;screen contrast!!!
	lda	#$06c
	sta	$4209			;set V count timer low 1 byte
	lda	#0ah
	sta	irq_index
	inc	framecounter
	inc	framec
	rtl
		
game2p_02
	lda	#$80
	sta	$2100			;Blanking!!!
;	
	lda	#02h+060h	;bg1=nane base address 02h
				;bg2=                  60h
	sta	210bh
;	 		
	lda	lower_screen+00
	sta	210eh		;bg 1 scrool V
	lda	lower_screen+01
	sta	210eh		;bg 1 scrool V
	lda	#0c0h
	sta	210dh		;bg1 scroll H
	lda	#0ffh
	sta	210dh		;bg1 scroll H
;	
	jsr	set_scroll2lower

	lda	#$074
	sta	$4209			;set V count timer low 1 byte

	lda	#0ch
	sta	irq_index
	rtl
game2p_03
	lda	screen_contrast+01
	sta	$2100			;screen contrasr!!!
	lda	#$0d4-04
	sta	$4209			;set V count timer low 1 byte
	lda	#0eh
	sta	irq_index
	rtl
game2p_04
	lda	#$80
	sta	$2100			;Blanking!!!


	lda	#00h+60h	;bg1 name base address=00h
				;bg2		      =60h		
	sta	210bh

	lda	#0f0h
	sta	210dh		;bg1 scroll H
	lda	#0ffh
	sta	210dh		;bg1 scroll H

	lda	#$0c+04
	sta	$4209			;set V count timer low 1 byte
	lda	#08h
	sta	irq_index
	lda	#02h
	sta	$420ch			;HDMA switch on !!!


	jsr	transfer_bitmap
;	jsr	apu_control
;	jsr	transfer_time
;	jsr	transfer_color_anime
;	jsr	transfer_character
	a8
	lda	upper_screen+00
	sta	210eh		;bg 1 scrool V
	lda	upper_screen+01
	sta	210eh		;bg 1 scrool V

	jsr	set_scroll2upper
	jsr	scan_controller_race

	rtl

;--------------------------------------------------------------------
set_scroll
	php
	a8	   
	lda	bg2Xscroll
	sta	210fh
	lda	bg2Xscroll+1
	sta	210fh
	
	lda	bg2Yscroll
	sta	2110h
	lda	bg2Yscroll+1
	sta	2110h

	plp
	rts

set_scroll2upper
	php
	a16	   
	lda	bg2Xscroll
	sec
	sbc	#10h
	a8
	sta	210fh
	xba
	sta	210fh
	a16
	lda	bg2Yscroll
	clc
	adc	#024h
	a8
	sta	2110h
	xba
	sta	2110h

	plp
	rts

set_scroll2lower
	php
	a16	   
	lda	bg2Xscroll
	sec
	sbc	#0040h
	a8
	sta	210fh
	xba
	sta	210fh
	a16
	lda	bg2Yscroll
	sec
	sbc	#040h	
	a8
	sta	2110h
	xba
	sta	2110h

	plp
	rts
;--------------------------------------------------------------------
transfer_bitmap
	php

	ai16
	ldx	trans_level
	jmp	(trans_address&WM,x)
trans_address

				;for 1player's game
	irv	trans_000
	irv	trans_002
	irv	trans_004
	irv	trans_006
	irv	trans_008
	irv	trans_00a
			 	;for 2player's game

				;for upper screen
	irv	trans_00c
	irv	trans_00e
	irv	trans_010
	irv	trans_012
				;for lower screen
	irv	trans_014
	irv	trans_016
	irv	trans_018
	irv	trans_01a


;--------------------------------------------------------------------
	shorta
disable_trans
notrans006
notrans000
	a8
	lda	#1
	sta	gamevwpos      ;>>>>>>>NOT NESSESARY!!!!!!!
	plp
	rts
;--------------------------------------------------------------------

trans_000
			;from 702000h to VRAM 000h
	

	longa
	longi

	lda	bitmap_status
	beq	notrans000
	   	
	ldx	#02h
	stx	trans_level
	ldx	#bitmap1		;mario RAM address
	ldy	#00000h		;     VRAM address
	lda	#02200h		;transport value
       	jsr	execute_transfer
	plp
	rts
;--------------------------------------------------------------------
trans_002
	longa
	longi
	ldx	#04h
	stx	trans_level
	ldx	#bitmap1+$2200		;mario RAM address
	ldy	#01100h		;     VRAM address
	lda	#02200h		;transport value
       	jsr	execute_transfer
	jsr	transfer_vsprite
	plp
	rts
	
;--------------------------------------------------------------------
trans_004
	longa
	longi
	ldx	#06h
	stx	trans_level
	ldx	#bitmap1+$4400		;mario RAM address
	ldy	#02200h		;     VRAM address
	lda	#02400h		;transport value
       	jsr	execute_transfer


	a8
	stz	trans_flag	;trans complete
	lda	#00h+060h
				;00h=bg1 0000h
				;60h=bg2 6000h
	sta	210bh		;bg1&2 name base address
	lda	#078h
	sta	2107h		;screen address

	plp
	rts
;--------------------------------------------------------------------
trans_006
	longa
	longi

	lda	bitmap_status
	bne	notrans006
	ldx	#08h
	stx	trans_level
	ldx	#bitmap2+$2400		;mario RAM address
	ldy	#03400h		;     VRAM address
	lda	#02200h		;transport value
       	jsr	execute_transfer
	plp
	rts
;--------------------------------------------------------------------
trans_008
	longa
	longi
	ldx	#0ah
	stx	trans_level
	ldx	#bitmap2+$4600		;mario RAM address
	ldy	#04500h		;     VRAM address
	lda	#02200h		;transport value
       	jsr	execute_transfer
	jsr	transfer_vsprite
	plp
	rts

;--------------------------------------------------------------------
trans_00a

	longa
	longi
	stz	trans_level
	ldx	#bitmap2		;mario RAM address
	ldy	#02200h		;     VRAM address
	lda	#02400h		;transport value
       	jsr	execute_transfer

	a8
	stz	trans_flag	;trans complete
	lda	#02h+60h
				;02h=bg1 2000h
				;60h=bg2 6000h
	sta	210bh		;bg1&2 name base address
	lda	#07ch
	sta	2107h		;screen address
	
	plp
	rts


;--------------------------------------------------------------------


;	2 PLAYER's MODE !!!!!!!!!


;--------------------------------------------------------------------
block01		equ	0d00h
;block02		equ	1400h
block02		equ	1400h
block03		equ	block01+block02

upper_voffset	equ	0fff3h
lower_voffset	equ	0ff8ch
;--------------------------------------------------------------------
trans_00c
			;from 702000h to VRAM 000h
	

	longa
	longi

	lda	bitmap_status
	beq	.notrans
	   	
	ldx	#0eh
	stx	trans_level
	lda	#bitmap1+0000		;mario RAM address
	ldx	#00000h		;     VRAM address
	ldy	#08h		;transport value
       	jsr	execute_transfer_2p

	ai16
	lda	#40h*08		;	transfer 08h chara!!!
	ldy	#0d00h-08h*20h	;	vram address
	ldx	#bitmap1+08h*40h*10h  ;mario RAM address
	jsr	execute_transfer
.notrans
	plp
	rts
;--------------------------------------------------------------------
trans_00e
	longa
	longi
	lda	#0000+upper_voffset
	sta	upper_screen
	ldx	#10h
	stx	trans_level
	lda	#bitmap1+40h*09h*10h	;mario RAM address
	ldx	#000h+20h*09h*0ch	;     VRAM address
	ldy	#13		;transport value
       	jsr 	execute_transfer_2p
	

	a8
	stz	trans_flag	;trans complete
	ai16
	lda	#40h*04		;	transfer 08h chara!!!
	ldy	#0d00h 		;	vram address
	ldx	#bitmap1+08h*40h*10h+08h*40h  ;mario RAM address
	jsr	execute_transfer

	plp
	rts
	
;--------------------------------------------------------------------

trans_010
			;from 702000h to VRAM 000h
	

	longa
	longi

	lda	bitmap_status
	bne	.notrans
	   	
	ldx	#12h
	stx	trans_level
	lda	#bitmap2+0000		;mario RAM address
	ldx	#02e00h		;     VRAM address
	ldy	#08		;transport value
       	jsr	execute_transfer_2p
	ai16
	lda	#40h*08		;	transfer 08h chara!!!
	ldy	#03b00h-08h*20h	;	vram address
	ldx	#bitmap2+08h*40h*10h  ;mario RAM address
	jsr	execute_transfer
.notrans
	plp
	rts
;--------------------------------------------------------------------
trans_012
	longa
	longi
	lda	#(0100h+lower_voffset)&WM
	sta	lower_screen
	ldx	#14h
	stx	trans_level
	lda	#bitmap2+40h*09h*10h		;mario RAM address
	ldx	#02E00H+20H*09H*0ch		;     VRAM address
	ldy	#13		;transport value
       	jsr	execute_transfer_2p

	a8
	stz	trans_flag	;trans complete

	ai16
	lda	#40h*04		;	transfer 08h chara!!!
	ldy	#03b00h 		;	vram address
	ldx	#bitmap2+08h*40h*10h+08h*40h  ;mario RAM address
	jsr	execute_transfer
	plp
	rts
	
;--------------------------------------------------------------------

trans_014
			;from 702000h to VRAM 000h
	

	longa
	longi

	lda	bitmap_status
	beq	.notrans
	   	
	ldx	#16h
	stx	trans_level
	lda	#bitmap1+40h*10h*14	;mario RAM address
	ldx	#2100h+20h*08h		;     VRAM address
	ldy	#08		;transport value
       	jsr	execute_transfer_2p
	ai16
	lda	#40h*08		;	transfer 08h chara!!!
	ldy	#02100h		;	vram address
	ldx	#bitmap1+0dh*10h*40h+04h*40h  ;mario RAM address
	jsr	execute_transfer
.notrans
	plp
	rts
;--------------------------------------------------------------------
trans_016
	longa
	longi
	ldx	#18h
	stx	trans_level
	lda	#bitmap1+$0000     	;mario RAM address
	ldx	#0d00h		;     VRAM address
	ldy	#13			;transport value
       	jsr	execute_transfer_2p


	lda	#(080h+upper_voffset)&WM
	sta	upper_screen

	a8
	stz	trans_flag	;trans complete

	ai16
     
	lda	#40h*04		;	transfer 08h chara!!!
	ldy	#02100h-04h*20h	;	vram address
	ldx	#bitmap1+0dh*10h*40h	  ;mario RAM address
	jsr	execute_transfer
	plp
	rts
	
;--------------------------------------------------------------------

trans_018
			;from 702000h to VRAM 000h
	

	longa
	longi

	lda	bitmap_status
	bne	.notrans
	   	
	ldx	#1ah
	stx	trans_level
	lda	#bitmap2+40h*10h*14		;mario RAM address
	ldx	#04f00h+20h*08h		;     VRAM address
	ldy	#08		;transport value
       	jsr	execute_transfer_2p
	ai16
	lda	#40h*08		;	transfer 08h chara!!!
	ldy	#04f00h		;	vram address
	ldx	#bitmap2+0dh*10h*40h+04h*40h  ;mario RAM address
	jsr	execute_transfer
.notrans
	plp
	rts
;--------------------------------------------------------------------
trans_01a
	longa
	longi
	ldx	#0ch
	stx	trans_level
	lda	#bitmap2+$0000		;mario RAM address
	ldx	#03b00h		;     VRAM address
	ldy	#13			;transport value
       	jsr	execute_transfer_2p


	lda	#(0180h+lower_voffset)&WM
	sta	lower_screen

	a8
	stz	trans_flag	;trans complete

	ai16
     
	lda	#40h*04		;	transfer 08h chara!!!
	ldy	#04f00h-04h*20h	;	vram address
	ldx	#bitmap2+0dh*10h*40h	  ;mario RAM address
	jsr	execute_transfer
	plp
	rts
	
;--------------------------------------------------------------------
	longa
	longi

execute_transfer

	sta	4300h+05h	;trans length
	txa
	sta	4300h+02h	;set bitmap address
	tya
	sta	2116h		;VRAM address


	lda	#01801h
	sta	4300h+00h	;set param + (21)18h DATA write
	
	a8

	lda	#070h
	sta	4300h+04h	;set bitmap BANK
	lda	#%10000000
	sta	2115h		;VRAM step(address increment);

	ramnastyoff
	lda	#01
	sta	420bh		;start bitmap data trans! 
	ramnastyon
	rts
;----------------------------------------------------------
	longa
	longi

				;a=mario ram address
				;x=VRAM address
				;y=loop counter


execute_transfer_2p


	
	stx	2116h		;VRAM address


	ldx	#01801h
	stx	4300h+00h	;set param + (21)18h DATA write

	i8      
	ldx	#070h
	stx	4300h+04h	;set bitmap BANK
	ldx	#%10000000
	stx	2115h		;VRAM step(address increment);



	pha
	ramnastyoff
	pla
.trans_loop
	sta	4300h+02h	;set bitmap address

	i16
	ldx	#40h*0ch	;0ch line !!!
	stx	4300h+05h
	i8
	ldx	#01
	stx	420bh		;start bitmap data trans! 

	dey	
	beq	.nomoretrans
	clc
	adc	#040h*010h
	bra	.trans_loop

.nomoretrans
	ramnastyon

	rts

;----------------------------------------------------------
transfer_sprite_l     		;all OAM data transfer!!!
	jsr	transfer_sprite
	rtl
transfer_sprite
	php
	a16
	lda	#(spriteblk)&WM
	sta.l	4302h			;data address 
	lda	#00h
	sta.l	2102h
	lda	#400h
	sta.l	4300h	
	lda	#220h
	sta.l	4305h	
	a8
	lda	#(spriteblk)>>16
	sta.l	4304h			;data bank
	lda	#01
	sta.l	420bh			;set DMA switch
	plp
	rts
;----------------------------------------------------------
transfer_panel	      ;stable OBJ character at race
	php
	a16
	lda	#(spriteblk+paneladdress)&WM
	sta.l	4302h			;data address 
	lda	#(paneladdress)&WM
	sta.l	2102h
	lda	#400h
	sta.l	4300h	
	lda	#(panellength)&WM
	sta.l	4305h	
	a8
	lda	#(spriteblk)>>16
	sta.l	4304h			;data bank
	lda	#01
	sta.l	420bh			;set DMA switch
	plp
	rts
;----------------------------------------------------------
transfer_vsprite       
	php
	a16
	lda	#(spriteblk+vspriteaddress)&WM
	sta.l	4302h			;data address 
	lda	#(vspriteaddress/2)&WM
	sta.l	2102h
	lda	#400h
	sta.l	4300h	
	lda	#(vspritelength)&WM
	sta.l	4305h	
	a8
	lda	#(spriteblk)>>16
	sta.l	4304h			;data bank
	lda	#01
	sta.l	420bh			;set DMA switch
	plp
	rts
;----------------------------------------------------------
transfer_time
	php
	a8
	lda.l	time_flag
	bne	.gotime
	plp
	rts
.gotime
	a16
	sed
	lda	decimaltime
	clc
	adc	#166h
	sta	decimaltime
	bcs	.incsecond
	a8
	xba
	pha
	and	#0f  
	sta	spriteblk+05*04+02	
	pla
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	sta	spriteblk+04*04+02
	bra	.settimeblk
.incsecond
	a8
	xba
	pha
	and	#0f  
	sta	spriteblk+05*04+02	
	pla
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	sta	spriteblk+04*04+02
	a16
	lda	secondtime
	clc
	adc	#01h
	cmp	#60h
	bcs	.incminute
.setsecond
	sta	secondtime
	a8
	pha
	and	#0f
	sta	spriteblk+03*04+02
	pla
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	sta	spriteblk+02*04+02
	bra	.settimeblk
.incminute
	longa
	lda	#0	
	sta	secondtime
	a8
	pha
	and	#0f
	sta	spriteblk+03*04+02
	pla
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	sta	spriteblk+02*04+02

	lda	minutetime
	clc
	adc	#1
	sta	minutetime
	a8
	pha
	and	#0f
	sta	spriteblk+01*04+02
	pla	 
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	sta	spriteblk+00*04+02

.settimeblk
	a16
	lda	#(spriteblk+timeaddress)&WM
	sta.l	4302h			;data address 
	lda	#(timeaddress/2)&WM
	sta.l	2102h
	lda	#400h
	sta.l	4300h	
	lda	#(timelength)&WM
	sta.l	4305h	
	a8
	lda	#(spriteblk)>>16
	sta.l	4304h			;data bank
	lda	#01
	sta.l	420bh			;set DMA switch

decrecetimer
	a16

	lda	decimalcounter
	sec
	sbc	#166h
	bcs	.notdeclap
	lda	#9999h
	lda	secondcounter
	beq	.decminute
	sec
	sbc	#01h
	sta	secondcounter
	bra	.returntime
.decminute
	lda	minutecounter
	beq	.endcounter
	sec
	sbc	#01h
	sta	minutecounter
       	lda	#059h
	sta	secondcounter
	bra	.returntime

.endcounter
	stz	decimalcounter
	stz	secondcounter
	stz	minutecounter	

.notdeclap
	sta	decimalcounter
.returntime

	cld
	plp
	rts

;----------------------------------------------------------
transfer_character    
	a8
	lda	jewel_number
	beq	.skipjewel
	lda	framecounter
	and	#011b
	cmp	#011b
	bne	.skipjewel
.dotransjewel
	lda	#07fh		;character bank!!!!
	sta.l	4304h
	lda	#80h
	sta.l	2115h

	lda	jewel_color
	asl	a
	asl	a
	asl	a
	clc
	adc	jewel_pattern
	asl	a
	tax
	a16
	lda.l	transjeweldata,x
	sta.l	4302h
	pha			;>>>>keep address!!!
	
	lda	#01801h
	sta.l	4300h+00h	;set param + (21)18h DATA write
	lda	#20H*2		;2 character transfer!!
	sta.l	4305h
	lda	#6000H+2bh*10h
	sta.l	2116h		;VRAM Address!!!
	a8
	lda	#01
	sta.l	420bh
	a16
	lda	#6000h+3bh*10h
	sta.l	2116h
	pla
	clc
	adc	#10h*20h
	sta.l	4302h
	lda	#20h*02
	sta.l	4305h		;trans length
	a8
		
	lda	#01
	sta.l	420bh

	lda	jewel_pattern
	inc	a
	cmp	#08
	bcc	.notoverpattern
	lda	#0
.notoverpattern
	sta	jewel_pattern
	rts
.skipjewel


.transHANDS
	ai8
	lda	hand_new
	bmi	.no_handtrans
	sta	hand_old
	asl	a
	tax
	lda	#0ffh
	sta	hand_new
	lda	#7fh
	sta.l	4304h
	lda	#80h
	sta.l	2115h
	ai16
	lda	#1801h
	sta.l	4300h
	a16
	lda.l	handaddress,x
	tax
.transhandloop
	lda.l	7e0000h,x
	cmp	#0ffffh
	beq	.endhandtrans
	sta.l	2116h
	lda.l	7e0002h,x
	sta.l	4302h
	lda.l	7e0004h,x
	sta.l	4305h	
	a8
	lda	#01h
	sta.l	420bh
	a16
	txa
	clc
	adc	#06h
	tax
	bra	.transhandloop

.endhandtrans

.no_handtrans
	rts

;----------------------------------------------------------
jewelbase	equ	(jewelstart)&WM
transjeweldata


;red
	dw	jewelbase+00h*20h
	dw	jewelbase+02h*20h
	dw	jewelbase+14h*20h
	dw	jewelbase+16h*20h
	dw	jewelbase+18h*20h
	dw	jewelbase+1ah*20h
	dw	jewelbase+1ch*20h
	dw	jewelbase+1eh*20h
;blue	
	dw	jewelbase+20h*20h
	dw	jewelbase+22h*20h
	dw	jewelbase+34h*20h
	dw	jewelbase+36h*20h
	dw	jewelbase+38h*20h
	dw	jewelbase+3ah*20h
	dw	jewelbase+3ch*20h
	dw	jewelbase+3eh*20h
;yellow	
	dw	jewelbase+40h*20h
	dw	jewelbase+42h*20h
	dw	jewelbase+54h*20h
	dw	jewelbase+56h*20h
	dw	jewelbase+58h*20h
	dw	jewelbase+5ah*20h
	dw	jewelbase+5ch*20h
	dw	jewelbase+5eh*20h
;	
;----------------------------------------------------------
handbase	equ	(handsprite)&WM
vhand0		equ	6000h+68H*10h
vhand1		equ	6000h+78H*10h
vhand2		equ	6000h+6cH*10h
vhand3		equ	6000h+7cH*10h
vhand4		equ	6000h+80H*10h
vhand5		equ	6000h+90H*10h
vhand6		equ	6000h+82H*10h
vhand7		equ	6000h+92H*10h

handaddress		
		 	;VRAM address & 7f RAM address
	dw	hans00&WM
	dw	hans01&WM
	dw	hans02&WM
	dw	hans03&WM
	dw	hans04&WM
	dw	hans05&WM
	dw	hans06&WM
	dw	hans07&WM
hans00	*
	dw	vhand0,handbase+00h*20h,20h*04
	dw	vhand1,handbase+10h*20h,20h*04
	dw	vhand2,handbase+04h*20h,20h*04
	dw	vhand3,handbase+14h*20h,20h*04
	dw	0ffffh
hans01	*
	dw	vhand0,handbase+08h*20h,20h*04
	dw	vhand1,handbase+18h*20h,20h*04
	dw	vhand2,handbase+0ch*20h,20h*04
	dw	vhand3,handbase+1ch*20h,20h*04
	dw	0ffffh
hans02	*
	dw	vhand0,handbase+20h*20h,20h*04
	dw	vhand1,handbase+30h*20h,20h*04
	dw	vhand2,handbase+24h*20h,20h*04
	dw	vhand3,handbase+34h*20h,20h*04
	dw	vhand4,handbase+28h*20h,20h*02
	dw	vhand5,handbase+38h*20h,20h*02
	dw	vhand6,handbase+2ah*20h,20h*02
	dw	vhand7,handbase+3ah*20h,20h*02
	dw	0ffffh
hans03	*
	dw	vhand0,handbase+2ch*20h,20h*04
	dw	vhand1,handbase+3ch*20h,20h*04
	dw	vhand2,handbase+24h*20h,20h*02
	dw	vhand3,handbase+34h*20h,20h*02
	dw	vhand2+20h,handbase+40h*20h,20h*02
	dw	vhand3+20h,handbase+50h*20h,20h*02
	dw	vhand4,handbase+42h*20h,20h*02
	dw	vhand5,handbase+52h*20h,20h*02
	dw	vhand6,handbase+2ah*20h,20h*02
	dw	vhand7,handbase+3ah*20h,20h*02
	dw	0ffffh
hans04	*
	dw	vhand0,handbase+2ch*20h,20h*02
	dw	vhand1,handbase+3ch*20h,20h*02
	dw	vhand0+20h,handbase+44h*20h,20h*02
	dw	vhand1+20h,handbase+54h*20h,20h*02
	dw	vhand2,handbase+24h*20h,20h*02
	dw	vhand3,handbase+34h*20h,20h*02
	dw	vhand2+20h,handbase+46h*20h,20h*02
	dw	vhand3+20h,handbase+56h*20h,20h*02
	dw	vhand4,handbase+42h*20h,20h*02
	dw	vhand5,handbase+52h*20h,20h*02
	dw	0ffffh
hans05	*
	dw	vhand0,handbase+00h*20h,20h*04
	dw	vhand1,handbase+10h*20h,20h*04
	dw	vhand2,handbase+04h*20h,20h*04
	dw	vhand3,handbase+14h*20h,20h*04
	dw	0ffffh
hans06	*
	dw	vhand0,handbase+60h*20h,20h*04
	dw	vhand1,handbase+70h*20h,20h*04
	dw	vhand2,handbase+62h*20h,20h*04
	dw	vhand3,handbase+72h*20h,20h*04
	dw	0ffffh
hans07	*
	dw	vhand0,handbase+60h*20h,20h*04
	dw	vhand1,handbase+62h*20h,20h*04
	dw	vhand2,handbase+68h*20h,20h*04
	dw	vhand3,handbase+78h*20h,20h*04
	dw	0ffffh
;----------------------------------------------------------
transfer_color_l

	jsr	transfer_color
	rtl

transfer_color
	php
	a8
	stz	$2121			;CGRAM address

	php
	a8i16
	stz	$2121			;CGRAM address
		
	ldx	#$2200
	stx	$4300			;DMA control parametar
					;B bus address
	lda	#(color_buffer)>>16
	sta	$4304			;data bank
	ldx	#(color_buffer)&WM
	stx	$4302			;data address 
	ldx	#$0200
	stx	$4305	;data length
	lda	#01
	sta	$420b		:set DMA switch
	plp
	rts

;--------------------------------------------------------------
transfer_color_anime
	
	php
	ai8
	lda	framecounter
	bit	#1
	bne	col01
;---------------------------------------------------------------
col00
	bit	#2
	beq	color_e0
color_e2
	lda	#0e2h
	sta.l	2121h	    	;CG RAM address=0e2h
	ldx	transcole2
	lda.l	transe2data,x
	sta.l	2122h
	lda.l	transe2data+01,x
	sta.l	2122h
	inx
	inx
	cpx	#10h
	bcc	oke2
	ldx	#00
oke2
	stx	transcole2
color_e0

	lda	#0e0h
	sta.l	2121h	      ;CG RAM address=0e0h
	ldx	transcole0
	lda.l	transe0data,x
	sta.l	2122h
	lda.l	transe0data+01,x
	sta.l	2122h
	inx
	inx
	cpx	#10h
	bcc	oke0
	ldx	#00
oke0
	stx	transcole0
	plp
	rts
;---------------------------------------------------------------
col01
	bit	#2
	beq	color_e1
color_e3

	lda	#0e3h
	sta.l	2121h
	ldx	transcole3
	lda.l	transe3data,x
	sta.l	2122h
	lda.l	transe3data+01,x
	sta.l	2122h
	inx
	inx
	cpx	#10h
	bcc	oke3
	ldx	#00
oke3
	stx	transcole3
color_e1
	lda	#0e1h
	sta.l	2121h
	ldx	transcole1
	lda.l	transe1data,x
	sta.l	2122h
	lda.l	transe1data+01,x
	sta.l	2122h
	inx
	inx
	cpx	#10h
	bcc	oke1
	ldx	#00
oke1
	stx	transcole1
colfont
	lda	#0eeh
	sta.l	2121h
	ldx	transcolfont
	lda.l	transefontdata,x
	sta.l	2122h
	lda.l	transefontdata+01,x
	sta.l	2122h
	inx
	inx
	cpx	#20h
	bcc	okfont
	ldx	#00
okfont
	stx	transcolfont

	plp

notsetsound

	rts


;---------------------------------------------------------------
transe0data
	dw	02a0h,441fh,03ffh,7c0eh
	dw	02a0h,441fh,03ffh,7c0eh	
transe1data
	dw	0084h,0129h,01adh,0252h
	dw	02f7h,037bh,03ffh,53ffh	
transe2data				     
	dw	0004h,000bh,0011h,0017h
	dw	009bh,005fh,01bfh,029fh	
transe3data
	dw	2000h,3800h,4c00h,6060h
	dw	7d40h,7de5h,7e8ah,7f2fh	
transefontdata
	dw	001eh,101ch,2018h,3014h
	dw	4010h,500ch,6008h,7004h
	dw	7c00h,7004h,6008h,500ch
	dw	4010h,3014h,2018h,101ch
;---------------------------------------------------------
		;requier this routin at every video frame


apu_control


	lda	framecounter
	bit	#1
	bne	checksound
	rts
checksound
	ramnastyoff
	
	phb
	php
	ai8

	lda	#07eh
	pha
	plb


.checksound0

;;;;	lda.l	soundgate
;;;;	bne	.skiptrigger


	lda	sound0number
	beq	.checksound1	;no trigger 0	


	lda.l	apu_port0
	beq	.gotoset0
	lda	sound0stock
	cmp.l	apu_port0
	bne	.checksound1 ;preseet data is't read yet
.gotoset0
	ldx	sound0pointer
	lda	sound0buffer,x
	cmp	sound0stock
	bne	.notsame0
				;set same trigger continuous
	
	lda	#0
	bra	.setsound0
.notsame0
	dec	sound0number
	beq	.nomore0
	inx
	cpx	#10h
	bcc	.notover0
	ldx	#0
.notover0
	stx	sound0pointer
.nomore0
.setsound0
	sta.l	apu_port0
	sta	sound0stock



.checksound1
	lda	sound1number
	beq	.checksound2	;no trigger 0	

	lda.l	apu_port1
	beq	.gotoset1

	lda	sound1stock
	cmp.l	apu_port1
	bne	.checksound2 ;preseet data is't read yet
				;.check next trigger
.gotoset1
	ldx	sound1pointer
	lda	sound1buffer,x
	cmp	sound1stock
	bne	.notsame1
				;set same trigger continuous
	
	lda	#0
	bra	.setsound1
.notsame1
	dec	sound1number
	beq	.nomore1
	inx
	cpx	#10h
	bcc	.notover1
	ldx	#0
.notover1
	stx	sound1pointer
.nomore1
.setsound1
	sta.l	apu_port1
	sta	sound1stock


.skiptrigger


.checksound2


;	now ! sound port 2 is not use!!!



.checksound3

	plp
	plb
	
	ramnastyon

	rts

;---------------------------------------------------------------
scan_controller
scan_controller_nomal
	php
	a16i8
	lda.l	joy1l
	pha
	eor	cont0l
	and.l	joy1l
	sta	trig0
	
	lda.l	joy2l
	pha
	eor	cont1l
	and.l	joy2l
	sta	trig1
	
	pla
	sta	cont1l
	pla
	sta	cont0l
	plp
	rts
;-------------------------------------------------------------

scan_controller_race

	php
	a8
	lda	control_flag
	bne	disable_control
	a16i8
	lda.l	joy1l
	pha
	eor	cont0l
	and.l	joy1l
	sta	trig0
	
	lda.l	joy2l
	pha
	eor	cont1l
	and.l	joy2l
	sta	trig1
	
	pla
	sta	cont1l
	pla
	sta	cont0l
	plp
	rts
disable_control

	a16i8
;
	stz	cont0l
	stz	trig0
	stz	cont1l
	stz	trig1
;
	lda.l	joy1l
	pha
	eor	cont0d
	and.l	joy1l
	sta	trig0d
	
	lda.l	joy2l
	pha
	eor	cont1d
	and.l	joy2l
	sta	trig1d
	
	pla
	sta	cont1d
	pla
	sta	cont0d

	plp
	rts


;--------------------------------------------------------------
