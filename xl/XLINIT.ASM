;	Initialize Game Program for XL
;
;				programed by Masato Kimura
;
;				10/02/1993
;--------------------------------------------------------------------


	incpublics	xlinit.ext


;--------------------------------------------------------------------


Initial_game



	php
	a8
	phb
	phk
	plb	 	;set data bank resister!!!

;;;	se_stopbgm
	lda	#00
	sta.l	debug_count
	jsl	clear_sound

	se_startingbgm
	se_startengine
	se_accelon

;--------------------------------------------------------------------

	jsr	Initial_resister

;--------------------------------------------------------------------



	jsl	InitVRAM_l  

;--------------------------------------------------------------------
;	open hand sprite data 
;--------------------------------------------------------------------
      

	ai16	
	lda	#(hand)&WM
	sta.l	m_enddata	   ;set data address
	lda	#(decrunchaddress)&WM
	sta.l	m_decaddr	;set mario RAM addres		
	lda	#0
	sta.l	m_decoffset


	a8
	lda	#(hand)>>16
	sta.l	m_enddatabnk	   ;set data bank
	lda	#mdecrunch>>16
	ldx	#mdecrunch&WM
	jsl	runmario_l

	blocktransfer	decrunchaddress,handsprite,handspritelength
	
;--------------------------------------------------------------------
;	Set Object  Character 	address=6800h
;--------------------------------------------------------------------

	ai16
	ldy	#(game_OBJ_character)&WM
	ldx	#(race_obj_address)&WM

	jsl	decrunch_VRAM_data


;--------------------------------------------------------------------
;	set back character
;--------------------------------------------------------------------

	ai16
	lda	map_number
	asl	a
	clc
	adc	map_number
	and	#0ffh
	clc
	pha	
	adc	#(back_character_address)&WM
	tax
	ldy	#(back_character)&WM

	jsl	decrunch_VRAM_data

;--------------------------------------------------------------------
;	set_back_screen
;--------------------------------------------------------------------

    	ai16
	pla
	pha
	clc
	adc	#(back_screen_address)&WM
	tax
	ldy	#(back_screen)&WM

	jsl	decrunch_VRAM_data

;--------------------------------------------------------------------
;	Set Game Color
;--------------------------------------------------------------------

        ai16
	pla
	clc
	adc	#(color_address)&WM
	tax
	ldy	#(color_data)&WM

	jsl	decrunch_data
		



;	a8i16
;	ldx	#0cah
;	lda	#020h
;	sta	2121h
;	lda	#00
;.loop
;	sta	2122h
;	sta	2122h
;	dex
;	bne	.loop
;;
;--------------------------------------------------------------------
;	Set Depth Address[let's refference bgmacs.asm (planet)]
;--------------------------------------------------------------------

	ai16

	setdepth	night

	set_zdepthtable	normal




;--------------------------------------------------------------------
;Set Game OAM
;--------------------------------------------------------------------



	jsr	OAM_clear



	a8i16
	ldy	#00h

	lda	player_mode
	bne	.set_two_player


.set_one_player
	ldx	#P1_main-Game_OAM_main
	bra	.set_main_lp
.set_two_player
	ldx	#P2_main-Game_OAM_main
.set_main_lp
	lda	Game_OAM_main&WM,x
	cmp	#0ffh
	beq	.end_main_OAM
	sta	spriteblk,y
	iny
	inx
	bra	.set_main_lp
.end_main_OAM
	ldy	#00h
	lda	player_mode
	bne	.set_two_sub
.set_one_sub
	ldx	#P1_sub-Game_OAM_sub
	bra	.set_sub_loop
.set_two_sub
	ldx	#P2_sub-Game_OAM_sub
.set_sub_loop
	lda	Game_OAM_sub&WM,x
	cmp	#0ffh
	beq	.end_sub_OAM
	sta	spriteblk+512,y
	iny
	inx	
	bra	.set_sub_loop
.end_sub_OAM

	jsl	transfer_sprite_l
	
;--------------------------------------------------------------------
;sect 1p or 2p
;--------------------------------------------------------------------

	lda	player_mode
	beq	p1_initialize
	jmp	p2_initialize

;--------------------------------------------------------------------
p1_initialize
;--------------------------------------------------------------------

	ai16
	ldy	#(bgpanel_character)&WM
	ldx	#(bgpanel_address)&WM

	jsl	decrunch_VRAM_data



;--------------------------------------------------------------------
;       Set  Polygon  screen
;--------------------------------------------------------------------

	jsr	set_polygon_screen1
	
;-------------------------------------------------------------------
;	1 player's scroll resister
;-------------------------------------------------------------------

;		;hight 128 mode!!!	
;		256 color mode !!!
	ai8
	stz	210dh			;BG1 scroll h
	stz	210dh
;;;	lda	#0dfh
	lda	#0dfh+10h
	sta	210eh
	ldx	#0ffh
	stx	210eh			;BG1 scroll v
	stz	210fh
	stz	210fh			;BG2 scroll h
	lda	#80h
	sta	2110h
	stz	2110h			;BG2 scroll v
;
;--------------------------------------------------------------
;	Initialize RAM value at 1 player mode 
;--------------------------------------------------------------


	lda	#04h
	sta	irq_index

	stz	trans_level+00

;--------------------------------------------------------------------
;p1_initialize	   for HDMA
;--------------------------------------------------------------------

	a8
	lda	#00h
	sta	4310h
	lda	#2ch
	sta	4311h
	lda	#(tm_buffer)>>16
	sta	4314h
	a16
	lda	#(tm_buffer)&WM	
	sta	4312h
	a8
	lda	#16h*08h/2			;line number=20h
	sta.l	tm_buffer+00
	lda	#13h	   		;debug!!!!!!!!!
	sta.l	tm_buffer+01
	lda	#16h*08h/2			;line num=7f
	sta.l	tm_buffer+02
	lda	#13h			;on bg 1,2$obj
	sta.l	tm_buffer+03
	lda	#01h			;line 01h
	sta.l	tm_buffer+04
	lda	#11h	       		;on obj only!!
	sta.l	tm_buffer+05
	lda	#00h	  		;end code
	sta.l	tm_buffer+06

	bra	next_p1_init
;--------------------------------------------------------------------
p2_initialize
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;       Set  Polygon  screen
;--------------------------------------------------------------------

	jsr	set_polygon_screen2
	

;--------------------------------------------------------------
;	Initialize RAM value at 1 player mode 
;--------------------------------------------------------------

	a8
	lda	#08h
	sta	irq_index
	lda	#0ch
	sta	trans_level+00
;--------------------------------------------------------------------
;p2_initialize	   for HDMA
;--------------------------------------------------------------------

	a8
	lda	#00h
	sta	4310h
	lda	#2ch
	sta	4311h
	lda	#(tm_buffer)>>16
	sta	4314h
	a16
	lda	#(tm_buffer)&WM	
	sta	4312h
	a8
	lda	#11h			;line number=20h
	sta.l	tm_buffer+00
	lda	#10h	   		;on obj only
	sta.l	tm_buffer+01
	lda	#6ch-11h		;line num
	sta.l	tm_buffer+02
	lda	#13h			;on bg 1,2$obj
	sta.l	tm_buffer+03
	lda	#09h			;line 01h
	sta.l	tm_buffer+04
	lda	#10h	       		;on obj only!!
	sta.l	tm_buffer+05
	lda	#01h			;
	sta.l	tm_buffer+06
	lda	#13h	       		;on obj only!!
	sta.l	tm_buffer+07
	lda	#00h	  		;end code
	sta.l	tm_buffer+08

	a16

	
      	;     someting ...........


;---------------------------------------------------------------
next_p1_init

	jsr	common_initialize


	plb	 	;A resister shoud be 8 bit mode
	plp

	cli		;IRQ START!!!



	rtl
;---------------------------------------------------------------

common_initialize

	a16

;clear lap time buffer


	clearram	laptimebuffer,06*06



	lda	#03h
	sta	mario_draw_mode	

	lda	#0000h
	sta	screen_contrast
;
	stz	bitmap_status
	lda	#bitmap1
	sta.l	m_bitmapbase	;bitmap will start from 702000
	sta	drawmap
	stz	decimaltime
	stz	secondtime
	stz	minutetime
	lda	#09999h
	sta	decimalcounter
	lda	#099h
	sta	secondcounter
	lda	#80h
	sta	minutecounter	
;--------------------------------------------------------------
	a8
	stz	trans_flag
	stz	gameover_flag
	stz	goalin_flag
	stz	fade_control
	stz	fade_cnt
	stz	race_index
	stz	lapdispcnt
	stz	laptimedispcnt
	stz	lapstock
	stz	engine_lebel
	stz	skid_lebel
	stz	dart_flag
	stz	brake_flag 
	stz	accel_index	

	stz	jewel_number
	stz	jewel_pattern

	stz	hand_old
	lda	#0ffh
	sta	hand_new

	lda	#010h
	sta	handh
	lda	#030h
	sta	handv

	lda	#00
	sta	time_flag
	lda	#17h
	sta	4209h	;v timer low
	stz	420ah	;v timer high
	lda	#040h
	sta	4207h	;h twimer low
	stz	4208h	;h timer high

;disable control
	
	lda	#0ffh
	sta	control_flag

	stz	transcole0
	stz	transcole1
	stz	transcole2
	stz	transcole3
	stz	transcolfont
;			 
	lda	#00110001b
	sta	4200h	;enable timer irq

	stz	210fh
	stz	210fh
	lda	#80h
	sta	2110h
	stz	2110h

	rts
;--------------------------------------------------------------------

offset_data	equ	0
increce_data	equ	2


	
set_polygon_screen1
    	php
	
	a16i8


	lda	#7800h

	sta	2116h		;set VRAM address(07800h)
	ldx	#80h
	stx	2115h		;low&high set and increment

	jsr	set_panel_top1
	
	a16i8
	lda	#0000000000000000b
	jsr	set_screen_sub1

	a16
	lda	#7800h+20h*12h

	sta	2116h		;set VRAM address(07800h)
	jsr	set_panel_bottom1


	lda	#7c00h
	sta	2116h		;set VRAM address(07c00h)


	jsr	set_panel_top2

	lda	#0000h+010h ;offset 10h!!!

	a16i8
	jsr	set_screen_sub1

	a16
	lda	#7c00h+20h*12h

	sta	2116h		;set VRAM address(07800h)
	jsr	set_panel_bottom2

	plp






	rts	


;--------------------------------------------------------------------
offset		equ	2
set_panel_top1
	pha
	ai16
	
	ldx	#(bgpanel_data_top-bgpanel_data)&WM
	lda	#2b0h
	bra	set_bg_panel	
set_panel_top2
	pha
	ai16
	
	ldx	#(bgpanel_data_top-bgpanel_data)&WM
	lda	#1b0h
	bra	set_bg_panel	

set_panel_bottom1

	pha
	ai16
	
	ldx	#(bgpanel_data_bottom-bgpanel_data)&WM
	lda	#2b0h
	bra	set_bg_panel	

set_panel_bottom2

	pha
	ai16
	
	ldx	#(bgpanel_data_bottom-bgpanel_data)&WM
	lda	#01b0h
	bra	set_bg_panel	

;-----------

set_bg_panel
	sta	offset

set_bg_loop
	lda	bgpanel_data&WM,x
	cmp	#0ffffh
	beq	return_set
	pha
	xba
	and	#01100000000000000b
	sta	tempolary
	pla
	and	#0000000000111111b
	clc
	adc	offset
	ora	tempolary
	sta	2118h
	inx
	bra	set_bg_loop
return_set
	pla
	rts	

		


;--------------------------------------------------------------------
set_polygon_screen2
    	php
	
	a16i8
	lda	#7800h
	sta	2116h		;set VRAM address(07800h)
	ldx	#80h
	stx	2115h		;low&high set and increment	

	lda	#0000000000000000b
	jsr	set_screen_sub2

;--------------

	lda	#7a00h
	sta	2116h		;set VRAM address(07800h)
	ldx	#80h
	stx	2115h		;low&high set and increment	

	lda	#0000000000000000b+68h
	jsr	set_screen_sub2


;---------------
	lda	#7c00h
	sta	2116h		;set VRAM address(07800h)
	ldx	#80h
	stx	2115h		;low&high set and increment	

	lda	#0000000000000000b+70h
	jsr	set_screen_sub2

;---------------
      
	lda	#7e00h
	sta	2116h		;set VRAM address(07800h)
	ldx	#80h
	stx	2115h		;low&high set and increment	

	lda	#0000000000000000b+0d8h
	jsr	set_screen_sub2

;---------------

	plp
	rts			 	;RETURN SUBROUTIN


;---------------------------------------------------------------------

	longa
	shorti 

set_screen_sub1

	sta	offset_data
	lda	#10h
	sta	increce_data
	bra	gotoloop

set_screen_sub2
	
	sta	offset_data
	lda	#0ch
	sta	increce_data

gotoloop
	tay

.loop1
	ldx	#20h		;h line =20h
	lda	offset_data
.loop2
	sta	2118h
	clc
	adc	increce_data	;0c or 	10h
	dex
	bne	.loop2
	inc	offset_data
	dey
	bne	.loop1
	rts

;--------------------------------------------------------------------
Initial_resister
	php
	a8i16
	lda	#00100011b		;set screen mode & size
				;b0,1,2=screen mode SCREEN 3!!
				;b4,5=set BG1 &2=16*16 size
	sta	2105h		
	stz	2106h		;MOZAIKU OFF
				
	lda	#00000011b
				;b5,6,7=sprite size000=8 or 16
				;b3,4=name select 00
				;b0,1,2=base address 03=6000h
	sta	2101h
	lda	#078h+02h
				;BG1 screen address=7800h>78h
				;screen size=02
				;	   vertical 2 screen

			
	sta	2107h		;BG1 screen bank
	lda	#5ch+00h
				;BG2 screen address=60h>60h
				;screen size=10b
	sta	2108h		;BG2 screen bank	


	lda	#01100000b
	sta	210bh
				;BG1&BG2 character name address


	stz	2121h		;reset cgram address
	stz	2121h

	stz	212dh		;Through sub!!
	stz	212eh		;Through main(window)
	stz	212fh		;Through sub (window)

				;for window
	stz	2123h
	stz	2124h
	stz	2125h
	stz	212ah
	stz	212bh

	stz	2130h
	stz	2131h		;Color brend OFF
	stx	2132h
	stz	2133h
				;b7=0 not super inpose
				;b6=0 not ext input
				;b4,5	 not use
				;b3=not 512 mode
				;b2=0 224 line/field
				;b1=0 OBJ V select
				;b0=0 NON interless
	stz	4207h
	stz	4208h
	stz	4209h
	stz	420ah		;Timer H&V clear!!!

	stz	4200h		;Disable Timer
	stz	420bh		;Disable M-DMA
	stz	420ch		;Disable H-DMA

;Mario Resister!!!
	

	lda	#01h
	sta	3039h		;21Mhz mode!!!
		
	lda	#070h
	sta	3037h

	lda	#bitmap1/1024	; 6bits used.
	sta	mscrbase	;screen base resister

	a16
	lda	#bitmap1
	sta.l	m_bitmapbase
	sta	drawmap

	plp
	rts
;--------------------------------------------------------------------

initial_title

	php
	ai8
	phb
	phk
	plb

	jsr	initial_resister

	jsl	clear_sound
	se_starttitle
	se_opening

	ai16

	ldy	#(title_character)&WM
	ldx	#(title_character_address)&WM

	jsl	decrunch_VRAM_data  


	ai16

	ldy	#(title_screen)&WM
	ldx	#(title_screen_address)&WM
	
	jsl	decrunch_VRAM_data  

	ai16
	ldy	#(color_data)&WM
	ldx	#(title_color_address)&WM

	jsl	decrunch_data

	jsr	OAM_clear
	
;;;	jsr	initial_resister

	jsr	common_initialize

	ai8
	lda	#0e8h
	sta	210dh			;BG1 scroll h
	ldx	#0ffh
	stx	210dh
	lda	#(0dfh-28h)&BM
	sta	210eh
	stx	210eh			;BG1 scroll v
	stz	210fh
	stz	210fh			;BG2 scroll h
;;;	lda	#80h
;;;;	sta	2110h
	stz	2110h
	stz	2110h			;BG2 scroll v
;--------------------------------------------------------------------
;     window initialize	   for HDMA
;--------------------------------------------------------------------

	a8
	lda	#00h
	sta	4310h
	lda	#27h		  ;resister 2123h 
				  ;window right position	
	sta	4311h
	lda	#(tm_buffer)>>16
	sta	4314h
	a16
	lda	#(tm_buffer)&WM	
	sta	4312h
	a8
	lda	#20h+28h			;cont line number
	sta.l	tm_buffer+00
	lda	#17h			;set data
	sta.l	tm_buffer+01
	lda	#7fh			;cont line number
	sta.l	tm_buffer+02
	lda	#0e7h			;set data
	sta.l	tm_buffer+03
	lda	#029h-28h		;count line number
	sta.l	tm_buffer+04
	lda	#17h
	sta.l	tm_buffer+05
	lda	#00h 			;endcode
	sta.l	tm_buffer+06


	lda	#03h
	sta	2123h		;window 1 enable  for BG1
	lda	#18h		
	sta	2126h		;window 1 left position
	lda	#01h
	sta	212eh		;window 1 window mask!!!

;;;   	ai16
;;;;	jsr	common_initialize

		     
	plb
	plp
	rtl

;--------------------------------------------------------------------
decrunchaddress		equ	703000h
;--------------------------------------------------------------------



decrunch_VRAM_data	  	;x=rom address!!!
	    			;y=set data address
			;x=ROM address  table pointer
			;
			;0,y=VRAM step
			;1,y(2byte)=VRAM address
			;3,y=DMA attribute
			;4,y=Abus address (21**h)
			;5,y=data lengtth

	longa
	longi

	phy

	ldax	0
	sta.l	m_enddata	   ;set data address
	lda	#(decrunchaddress)&WM
	sta.l	m_decaddr	;set mario RAM addres		
	lda	#0
	sta.l	m_decoffset
	a8
	ldax	2
	sta.l	m_enddatabnk	   ;set data bank
	lda	#mdecrunch>>16
	ldx	#mdecrunch&WM
	jsl	runmario_l



	a8i16
	plx

	ldax	0
	sta	2115h		;VRAM step
	ldax	1
	sta	2116h		;VRAM address low
	ldax	2
	sta	2117h		;VRAM address high
	


	ldax	3
	sta	4300h		;DMA attribute
	ldax	4
	sta	4301h		;A bus address (21**h)
	lda	#(decrunchaddress)&BM
	sta	4302h
	lda	#(decrunchaddress>>8)&BM
	sta	4303h
	lda	#(decrunchaddress>>16)&BM
	sta	4304h	     	;data from 701000h (fixed)
	ldax	5
	sta	4305h
	ldax	6
	sta	4306h		;transport data length
	lda	#01h
	sta	420bh	     	;goto trans!!!

	rtl

decrunch_data	  		;x=rom address!!!
	    			;y=set data address
	longa
	longi

	phy

	ldax	0
	sta.l	m_enddata	   ;set data address
	lda	#(decrunchaddress)&WM
	sta.l	m_decaddr	   ;set mario RAM addres		
	lda	#0
	sta.l	m_decoffset
	a8
	ldax	2
	sta.l	m_enddatabnk	   ;set data bank
	lda	#mdecrunch>>16
	ldx	#mdecrunch&WM
	jsl	runmario_l



	a8i16

	plx

	ldax	0
	sta	4300h		;DMA attribute
	ldax	1
	sta	4301h		;A bus address (21**h)
	lda	#(decrunchaddress)&BM
	sta	4302h
	lda	#(decrunchaddress>>8)&BM
	sta	4303h
	lda	#(decrunchaddress>>16)&BM
	sta	4304h	     	;data from 701000h (fixed)
	ldax	2
	sta	4305h
	ldax	3
	sta	4306h		;transport data length
	lda	#01h
	sta	420bh	     	;goto trans!!!


	rtl

;--------------------------------------------------------------------
;	Transpore ROM address table!!!!!
;--------------------------------------------------------------------
back_character_address
	dl	backcgx0
	dl	backcgx0
	dl	backcgx0
	dl	backcgx0
	
back_screen_address

	dl	backscr0
	dl	backscr0
	dl	backscr0
	dl	backscr0

color_address

	dl	racecol0
	dl	racecol3
	dl	racecol1
	dl	racecol2

race_obj_address
	dl	objcgx
	dl	objcgx
	dl	objcgx
	dl	objcgx

col_depth_address
	dl	night
	dl	night
	dl	night
	dl	night
bgpanel_address
	dl	bgpanel
;--------------------------------------------------------------------

title_character_address
	
	dl	titlecgx

title_color_address

	dl	titlecol
title_screen_address
	
	dl	titlescr
;--------------------------------------------------------------------
;
;	transport attribute data
;		
;--------------------------------------------------------------------

game_OBJ_character
	db	80h
	dw	6000h
	db	01
	db	18h
	dw	2000h
bgpanel_character
	db	80h
	dw	5600h
	db	01
	db	18h
	dw	0c00h
title_character
	db	80h
	dw	6000h
	db	01
	db	18h
	dw	3000h
;--------------------------------------------------------------------
back_character
	db	80h
	dw	6c00h
	db	01
	db	18h
	dw	1800h
;--------------------------------------------------------------------
back_screen
title_screen
	db	80h
	dw	5c00h
	db	01
	db	18h
	dw	800h
;--------------------------------------------------------------------
color_data
	db	00
	db	22h
	dw	200h
;--------------------------------------------------------------------
VRAMclear1			;for bitmap character
	db	%00001001	;b0,1,2=01 for VARM set
				;b3=1 Address fixed
	db	18h
	dw	(vramclearData)&WM
	db	(vramclearData)>>16
	dw	0c000h

;--------------------------------------------------------------------
VRAMclear2			;for bitmap screen
	db	%00001001	;b0,1,2=01 for VARM set
				;b3=1 Address fixed
	db	18h
	dw	(vramclearData)&WM
	db	(vramclearData)>>16
	dw	800h
vramclearData
	dw	0000h

;--------------------------------------------------------------------
Play01_OAM
Play02_OAM
	
;--------------------------------------------------------------------
vf	equ	80h	;V flip
hf	equ	40h	;H flip
hvf	equ	0c0h	;H&V flip
;--------------------------------------------------------------------
		
Game_OAM_main
P1_main

;---------0------------------------------timer (small!!!)
	db	20h,90h,00h,36h	       ;
	db	28h,90h,00h,36h	       ;   minute
	db	38h,90h,00h,36h
	db	40h,90h,00h,36h	       ;   second
;---------1
	db	50h,90h,00h,36h
	db	58h,90h,00h,36h	       ;   decimal
	db	30h,90h,0dh,36h	       ;	'
	db	48h,90h,0eh,36h	       ;	''
;
;left edge 	
	db	00,20h,24h,36h
	db	00,30h,24h,36h
	db	00,40h,24h,36h
	db	00,50h,24h,36h
	db	00,60h,24h,36h
	db	00,70h,24h,36h
	db	00,80h,24h,36h
	db	00,90h,24h,36h
;
	db	10h,20h,26h,36h
	db	10h,30h,26h,36h
	db	10h,40h,26h,36h
	db	10h,50h,26h,36h
	db	10h,60h,26h,36h
	db	10h,70h,26h,36h
	db	10h,80h,26h,36h
	db	10h,90h,26h,36h
;right edge
	db	0e0h,20h,26h,36h+hf
	db	0e0h,30h,26h,36h+hf
	db	0e0h,40h,26h,36h+hf
	db	0e0h,50h,26h,36h+hf
	db	0e0h,60h,26h,36h+hf
	db	0e0h,70h,26h,36h+hf
	db	0e0h,80h,26h,36h+hf
	db	0e0h,90h,26h,36h+hf
;
	db	0f0h,20h,24h,36h+hf
	db	0f0h,30h,24h,36h+hf
	db	0f0h,40h,24h,36h+hf
	db	0f0h,50h,24h,36h+hf
	db	0f0h,60h,24h,36h+hf
	db	0f0h,70h,24h,36h+hf
	db	0f0h,80h,24h,36h+hf
	db	0f0h,90h,24h,36h+hf
;
	db	0ffh

 	ifeq	1
;---------0------------------------------timer (small!!!)
	db	20h,90h,00h,36h	       ;
	db	28h,90h,00h,36h	       ;   minute
	db	38h,90h,00h,36h
	db	40h,90h,00h,36h	       ;   second
;---------1
	db	50h,90h,00h,36h
	db	58h,90h,00h,36h	       ;   decimal
	db	30h,90h,85h,36h		;'
	db	48h,90h,86h,36h		;''
;---------2-----------------------FX TRAX & top(big)
	db	60h,10h,88h,36h
	db	70h,10h,8ah,36h
	db	80h,10h,8ch,36h
	db	90h,10h,8eh,36h
;---------3
	db	20h,18h,53h,36h
	db	30h,18h,53h,36h
	db	40h,18h,53h,36h
	db	50h,18h,53h,36h
;---------4
	db	0a0h,18h,53h,36h
	db	0b0h,18h,53h,36h
	db	0c0h,18h,53h,36h
	db	0d0h,18h,53h,36h
;---------5---------------------edge part  left	 (big)
	db	00h,18h,20h,36h
	db	00h,28h,30h,36h
	db	00h,38h,30h,36h
	db	00h,48h,30h,36h
;---------6
	db	00h,58h,30h,36h
	db	00h,68h,30h,36h
	db	00h,78h,30h,36h
	db	00h,88h,30h,36h
;---------7
	db	08h,28h,31h,36h
	db	08h,38h,31h,36h
	db	08h,48h,31h,36h
	db	08h,58h,31h,36h
;---------8
	db	08h,68h,31h,36h
	db	08h,78h,31h,36h
	db	08h,88h,31h,36h
	db	00h,98h,20h,36h+vf
;---------9---------------------edge part  right (big)
	db	0f0h,18h,20h,36h+hf
	db	0f0h,28h,30h,36h+hf
	db	0f0h,38h,30h,36h+hf
	db	0f0h,48h,30h,36h+hf
;---------10
	db	0f0h,58h,30h,36h+hf
	db	0f0h,68h,30h,36h+hf
	db	0f0h,78h,30h,36h+hf
	db	0f0h,88h,30h,36h+hf
;---------11
	db	0e8h,28h,31h,36h+hf
	db	0e8h,38h,31h,36h+hf
	db	0e8h,48h,31h,36h+hf
	db	0e8h,58h,31h,36h+hf
;---------12
	db	0e8h,68h,31h,36h+hf
	db	0e8h,78h,31h,36h+hf
	db	0e8h,88h,31h,36h+hf
	db	0f0h,98h,20h,36h+hvf
;---------13--------------------edge part under (big)
	db	020h,98h,43h,36h
	db	030h,98h,43h,36h
	db	040h,98h,43h,36h
	db	050h,98h,43h,36h
;---------14
	db	060h,98h,43h,36h
	db	070h,98h,43h,36h
	db	080h,98h,43h,36h
	db	090h,98h,43h,36h
;---------15
	db	0a0h,98h,43h,36h
	db	0b0h,98h,43h,36h
	db	0c0h,98h,43h,36h
	db	0d0h,98h,43h,36h
;---------16
	db	010h,0b8h,44h,036h
	db	020h,0b8h,0ah,036h
	db	030h,0b8h,0ch,036h
	db	040h,0b8h,44h,036h+hf
;---------17
	db	050h,0b8h,43h,036h
	db	060h,0b8h,0eh,036h
	db	070h,0b8h,29h,036h
	db	080h,0b8h,48h,036h 
;---------18
	db	0b0h,0b8h,4ch,036h
	db	0c0h,0b8h,4eh,036h
	db	0d0h,0b8h,60h,036h
	db	0e0h,0b8h,44h,036h+hf
;---------19
	db	090h,0b8h,4ah,36h
	db	0a0h,0b8h,44h,36h
	db	018h,0a8h,46h,36h+hf	;rest buggy character
	db	020h,0a8h,46h,36h	;	 ;
;---------20-----------------------edge part (small!!!)
	db	10h,18h,22h,36h
	db	18h,18h,53h,36h
	db	10h,20h,32h,36h	;-----left up
	db	0e0h,18h,53h,36h
;---------21
	db	0e8h,18h,22h,36h+hf
	db	0e8h,20h,32h,36h+hf ;----right up
	db	10h,98h,32h,36h
	db	10h,0a0h,94h,36h
;---------22
	db	18h,0a0h,53h,36h    ;----left down
	db	0e8h,98h,42h,36h+hf
	db	0e0h,0a0h,53h,36h
	db	0e8h,0a0h,94h,36h+hf  ;---right down
;---------23		
	db	00h,0c0h,95h,36h+hf
	db	08h,0c0h,53h,36h
	db	0f0h,0c0h,53h,36h
	db	0f8h,0c0h,95h,36h     ;buttom
;---------24
	db	30h,0a8h,84h,36h
	db	30h,0b0h,84h,36h+vf	;kakeru!!!
	db	0c8h,90h,65h,36h
	db	0d0h,90h,66h,36h
;---------25
	db	0d8h,90h,67h,36h	;km/h
	db	0,0f0h,0,0
	db	0,0f0h,0,0
	db	0,0f0h,0,0
;---------26	   
	db	0,0f0h,0,0
	db	0,0f0h,0,0
	db	0,0f0h,0,0
	db	0,0f0h,0,0
;---------27
	db	0,0f0h,0,0
	db	0,0f0h,0,0
	db	0,0f0h,0,0     		;DUMMY!!!!!!
	db	0b0h,090h,00h,36h
;---------28
	db	0b8h,090h,00h,36h
	db	0c0h,090h,00h,36h	;speed number  (small)
 	db	90h,0a8h,25h,36h        ;variable damege
	db	50h,0a8h,23h,36h	; damage (big)
;---------29
	db	60h,0a8h,25h,36h	
	db	70h,0a8h,25h,36h
	db	80h,0a8h,25h,36h   	
	db	90h,0a8h,25h,36h
;---------30
	db	0a0h,0a8h,23h,36h+hf	;end damage
	db	0b0h,0a8h,2dh,36h
	db	0c0h,0a8h,2dh,36h
	db	0d0h,0a8h,2dh,36h     ;jewel
;---------31
	db	38h,0a8h,10h,36h
	db	38h,0b0h,10h,36h+vf
	db	40h,0a8h,19h,36h
	db	40h,0b0h,72h,36h      ;rest of buggy number
;---------
   	db	0ffh
	endc
;--------------------------------------------------------------------
Game_OAM_sub
P1_sub
;1p
	db	%01010101,%01010101,%10101010,%10101010
	db	%10101010,%10101010,%10101010,%10101010
	db	%10101010,%10101010
	db	%01010101,%01010101
	db	%01010101,%01010101,%01010101,%01010101
	db	%01010101,%01010101,%01010101,%01010101
	db	%01010101,%01010101,%01010101,%01010101
	db	%01010101,%01010101,%01010101,%01010101
	db	%01010101,%01010101,%01010101,%01010101
	db	0ffh
P2_sub


        db	%10101010,%10101010,%10101010,%10101010
        db	%10101010,%10101010,%10101010,%10101010
        db	%10101010,%10101010,%10101010,%10101010
        db	%10101010,%10101010,%10101010,%10101010
        db	%10101010,%10101010,%10101010,%10101010
        db	%10101010,%10101010,%10101010,%10101010
        db	%10101010,%10101010,%10101010,%10101010
        db	%10101010,%10101010,%10101010,%10101010


	db	0ffh


P2_main
;--------------upper left side

	db	00h,10h,47h,36h+hf	
	db	00h,20h,57h,36h+hf	
	db	00h,30h,57h,36h+hf	
	db	00h,40h,57h,36h+hf	
	db	00h,50h,57h,36h+hf	
	db	00h,60h,67h,36h+hf	

;--------------upper right side

;top
	db	0c0h,10h,47h,36h
	db	0d0h,10h,48h,36h
	db	0e0h,10h,48h,36h
	db	0f0h,10h,48h,36h
;player 1
	db	0b8h,20h,56h,36h
	db	0c8h,20h,4eh,36h	
	db	0d8h,20h,60h,36h
	db	0e8h,20h,62h,36h
	db	0f0h,20h,58h,36h
;lap up
	db	0dah,30h,6dh,36h
	db	0e2h,30h,6eh,36h
	db	0b8h,30h,56h,36h
	db	0c8h,30h,4ah,36h
	db	0f0h,30h,58h,36h
	db	0d0h,30h,4bh,36h
	db	0c8h,38h,5ah,36h
	db	0d0h,38h,5bh,36h
;jewel box
	db	0c8h,048h,4ah,36h
	db	0d8h,048h,4ah,36h
	db	0e8h,048h,4ah,36h
	db	0f0h,048h,4bh,36h
	db	0c8h,050h,5ah,36h
	db	0d8h,050h,5ah,36h
	db	0e8h,050h,5ah,36h
	db	0f0h,050h,5bh,36h
;lap down
	db	0c0h,40h,57h,36h
	db	0d0h,40h,58h,36h
	db	0e0h,40h,58h,36h
	db	0f0h,40h,58h,36h
;
	db	0c0h,050h,57h,36h
	db	0f0h,050h,58h,36h

;bottom
	db	0c0h,060h,67h,36h
	db	0d0h,060h,68h,36h
	db	0e0h,060h,68h,36h
	db	0f0h,060h,68h,36h

;--------------lower right side

	db	0f0h,70h,67h,36h+vf	
	db	0f0h,80h,57h,36h	
	db	0f0h,90h,57h,36h	
	db	0f0h,0a0h,57h,36h	
	db	0f0h,0b0h,57h,36h	
	db	0f0h,0c0h,47h,36h+vf	


;
;--------------lower left side
;
	db	000h,70h,68h,36h+vf
	db	010h,70h,68h,36h+vf
	db	020h,70h,68h,36h+vf
	db	030h,70h,67h,36h+hvf
;player2
	db	008h,80h,82h,36h
	db	018h,80h,84h,36h
	db	028h,80h,86h,36h

	db	000h,80h,58h,36h
	db	038h,80h,56h,36h+hf
;lap up
	db	08h,090h,6dh,36h
	db	10h,090h,6eh,36h
	db	24h,090h,4ah,36h
	db	2ch,090h,4bh,36h

	db	000h,90h,58h,36h
	db	018h,90h,58h,36h
	db	038h,90h,56h,36h+hf
;lap down
	db	024h,98h,5ah,36h
	db	02ch,98h,5bh,36h

	db	000h,098h,58h,36h
	db	010h,098h,58h,36h
	db	020h,098h,58h,36h
	db	030h,098h,57h,36h+hf
;box
;jewel box


	db	004h,0a8h,4ah,36h
	db	014h,0a8h,4ah,36h
	db	024h,0a8h,4ah,36h
	db	02ch,0a8h,4bh,36h
	db	004h,0b0h,5ah,36h
	db	014h,0b0h,5ah,36h
	db	024h,0b0h,5ah,36h
	db	02ch,0b0h,5bh,36h

	db	000h,0a8h,58h,36h
	db	000h,0b8h,58h,36h
	db	038h,0a8h,56h,36h+hf
	db	038h,0b8h,56h,36h+hf
;

;bottom
	db	000h,0c0h,48h,36h+vf
	db	010h,0c0h,48h,36h+vf
	db	020h,0c0h,48h,36h+vf
	db	030h,0c0h,47h,36h+hvf

;
	db 	0ffh



;--------------------------------------------------------------------
ClaerVRAM
	dw	0000
;--------------------------------------------------------------------
InitVRAM_l
	php
	ai8
	disable
	stz	4200h	;nmitimen
	stz	trans_flag
	lda	4211	;clear  IRQ
	a16
	lda.l	mflags

	lda	#03h	;256 mode!!
	sta	mario_draw_mode

;Clear VRAM
	ldx	#80h
	stx	2115h	;VARM step
	lda	#00h
	sta	2116h	;VRAM address	
	lda	#VRAMclear1&WM
	jsr	DMA_transfer
		;clear 0-6000h(0c000h)
		;for bitmap character
	lda	#7c00h
	sta	2116h	;VRAM address
	lda	#VRAMclear2&WM
	jsr	DMA_transfer	
		;clear 7c00h-7ffff
		;for bitmap screen	
	plp
	rtl
;--------------------------------------------------------------------

DMA_transfer_l
	jsr	DMA_transfer
	rtl
DMA_transfer
	php
	sta	00h
	ai8
	ldy	#06h
TransLoop  
	lda	(00h),y
	sta	4300h,y
	dey	
	bpl	Transloop
	lda	#01h
	sta	420bh
	plp
	rts

;--------------------------------------------------------------------

OAM_clear

	php
	
	ai16
	lda	#0e0e0h
	ldx	#1feh
Clear_main_loop

	sta	spriteblk,x
	dex
	dex
	bpl	Clear_main_loop
	lda	#0ffffh
	ldx	#1eh
Clear_sub_loop
	sta	spriteblk+512,x
	dex
	dex
	bpl	Clear_sub_loop
	plp
	rts



bgp	macro
		   
	db	$\1,$\2,$\3,$\4,$\5,$\6,$\7,$\8,$\9,$\10,$\11,$\12,$\13,$\14,$\15,$\16

	endm


	db	$2b+$0c0
;--------------------------------------------------------------------


vflip	equ	$080
h	equ	$040
hvflip	equ	$0c0	


bgpanel_data
bgpanel_data_top
  
	db	0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0+h

	db	03,04,02,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
	db	2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,02h+h,04h,03h+h

	db	00,00,00 ;;;;dummy

	dw	0ffffh

bgpanel_data_bottom	
	db	03h,04h,02h+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip
	db	2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,02h+hvflip,04h,03h+h

	db	0h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip
	db	1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,1h+vflip,0h+hvflip

	db	2fh,2fh,2fh,23h+h,22h,23h,26h,2fh,2fh,2fh,2fh,27h,28h,28h,28h,28h		
	db	28h,28h,28h,28h,27h+h,2fh,0ah,0bh,0ah,0bh,0ah,0bh,2fh,2fh,2fh,2fh

	db	2fh,2fh,2fh,25h+h,24h,25h,26h+vflip,2fh,2fh,2fh,2fh,27h+vflip,28h+vflip,28h+vflip,28h+vflip,28h+vflip		
	db	28h+vflip,28h+vflip,28h+vflip,28h+vflip,27h+hvflip,2fh,29h,2ah,29h,2ah,29h,2ah,2fh,2fh,2fh,2fh

	db	2fh,2fh,2fh,07h,0ch,0dh,0eh,0fh,07h+h,2fh,2fh,2fh,07h,13h,14h,15h
	db	16h,17h,18h,07h+h,2fh,07h,1ah,1bh,1ch,1dh,1eh,1fh,07h+h,2fh,2fh,2fh

	db	09h+hvflip,06h,06h,08h,10h,11h,11h,12h,08h+h,06h,06h,06h,08h,10h,11h,11h
	db	11h,11h,19h,08h+h,06h,08h,20h,11h,11h,11h,11h,21h,08h+h,06h,06h,09h

	dw	0ffffh
	
	ifeq	1

	bgp	03h,04h,02h+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip
	bgp	2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,2bh+vflip,02h+hvflip,04h,03h+h

	bgp	0+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1
	bgp	1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,1+vflip,0+hvflip

	bgp	2f,2f,2f,23+h,22,23,26,27,27,27,27,27,28,28,28,28		
	bgp	28,28,28,28,27+h,2f,0a,0b,0a,0b,0a,0b,2f,2f,2f.2f

	bgp	2f,2f,2f,25+h,24,25,26+vflip,2f,2f,2f,2f,27+vflip,28+vflip,28+vflip,28+vflip,28+vflip		
	bgp	28+vflip,28+vflip,28+vflip,28+vflip,27+hvflip,2f,29,2a,29,2a,29,2a,2f,2f,2f.2f

	bgp	2f,2f,2f,07,0c,0d,0e,0f,07+hflip,2f,2f,2f,07,13,14,15
	bgp	16,17,18,07+h,2f,07,1a,1b,1c,1d,1e,1f,07+h,2f,2f,2f

	bgp	09+hvflip,06,06,08,10,11,11,12,08+h,06,06,06,08,10,11,11
	bgp	11,11,19,08+h,06,08,20,11,11,11,11,21,08+h,06,06,09

	db	0ffh


	endc




