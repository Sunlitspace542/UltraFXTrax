
	incpublics	ramstuff.ext

	incfile	xlirq.asm

	incfile	hdmatabs.asm

;-------------------------------------
; RUN MARIO ROUTINE ------------------
;-------------------------------------
	shorta
	longi
runmario_l
	sta.l	mcodebank	;code bank

	phb
	lda	#0
	pha
	plb

	lda	mario_draw_mode
	ora	#%00011000	;nasty
	sta	mio_mode

     	stx	mr15
.dowait	
	inc	mariotimer
	bne	.n
	inc	mariotimer+1
.n
	lda	mflags
	and	#$20
	bne	.dowait

	lda	mario_draw_mode
	sta	mio_mode
	plb
	rtl


cop	blink



do_3d_display_l
	ai16
	lda	defaultID
	sta.l	m_defaultID
	a8
	lda	#mdo_3d_display>>16
	ldx	#mdo_3d_display&WM
	sta	mcodebank	;code bank
	lda	mario_draw_mode
	ora	#%00011000	;nasty
	sta	mio_mode
	stx	mr15

	jsr	parallel_stuff

	a8
.dowait	
	inc	disptimer
	bne	.n
	inc	disptimer+1
.n
	lda	mflags
	and	#$20
	bne	.dowait
	lda	mario_draw_mode
	sta	mio_mode

	jsl	alienflags_l

	rtl
;--------------------------------------------------------------
nomal	equ	36h+00h
vflip	equ	36h+80h
;--------------------------------------------------------------
numdata	 *
;0
	db	10h,nomal
	db	10h,vflip
;01
	db	11h,nomal
	db	12h,nomal
;02
	db	13h,nomal
	db	14h,nomal
;03
	db	15h,nomal
	db	16h,nomal
;04
	db	17h,nomal
	db	18h,nomal
;05
	db	19h,nomal
	db	72h,nomal
;06
	db	73h,nomal
	db	74h,nomal
;07
	db	75h,nomal
	db	76h,nomal
;08
	db	77h,nomal
	db	77h,vflip
;09
	db	74h,vflip
	db	73h,vflip
;--------------------------------------------------------------
jewel_data
	db	2dh,2dh,2dh,00h
	db	2bh,2dh,2dh,00h
	db	2bh,2bh,2dh,00h
	db	2bh,2bh,2bh
hand_oam_data
	dw	hand00&WM	
	dw	hand01&WM	
	dw	hand02&WM	
	dw	hand03&WM	
	dw	hand04&WM	
	dw	hand05&WM	
	dw	hand06&WM	
	dw	hand07&WM	
hand00		*
hand01		*
hand05		*
hand06		*
hand07		*
	db	0f0h,0f0h,68h,36h
	db	000h,0f0h,6ah,36h
	db	0f0h,000h,6ch,36h
	db	000h,000h,6eh,36h
	db	0feh,0feh,0ffh
hand02		*
hand03		*
	db	0e8h,0f0h,68h,36h
	db	0f8h,0f0h,6ah,36h
	db	008h,0f0h,80h,36h
	db	0e8h,000h,6ch,36h
	db	0f8h,000h,6eh,36h
	db	008h,000h,82h,36h
	db	0ffh
hand04	*
	db	0e8h,0f0h,68h,36h
	db	0f8h,0f0h,6ah,36h
	db	008h,0f0h,80h,36h
	db	0e8h,000h,6ch,36h
	db	0f8h,000h,6eh,36h
	db	0feh,0ffh

;--------------------------------------------------------------

parallel_stuff
	 


	a8
	inc	game_counter	    ;increce counter
				;on each game frame

;-------------------------------------------------------------
hand_control
	bra	.end_hand_set		
	ai16
	ldy	#105*04			;OAM address!!!
	lda	hand_old
	and	#0ffh
	asl	a
	tax
	lda.l	hand_oam_data,x
	tax
	a8
.nexthand
	lda.l	7e0000h,x
	cmp	#0ffh
	beq	.end_hand_set	
	cmp	#0feh
	beq	.not_disp_hand
	clc
	adc	handh
	sta	spriteblk+00h,y
	lda	7e0001h,x
	clc
	adc	handv
	sta	spriteblk+01h,y
	lda	7e0002h,x
	sta	spriteblk+02h,y
	lda	7e0003h,x
	sta	spriteblk+03h,y
.incindex
	inx
	inx
	inx
	inx
	iny
	iny
	iny
	iny
	bra	.nexthand
.not_disp_hand
	sta	spriteblk+01h,y
	iny
	iny
	iny
	iny
	inx
	bra	.nexthand
.end_hand_set

;-------------------------------------------------------------
	
	ifeq	1

	a16
	lda	trig1
	bmi	.pressB
	bit	#%0100000000000000
	bne	.pressY
	bit	#0000000010000000b
	bne	.pressA
	bit	#0000000001000000b
	bne	.pressX
.notrigger
	bra	.quittrigger
.pressX
	dec	jewel_color
	bra	.quittrigger
.pressA
	inc	jewel_color
	bra	.quittrigger
.pressY
	dec	jewel_number
	bra	.quittrigger
.pressB
	inc	jewel_number
.quittrigger

	

	endc

jewel_display
	ai8

	lda	jewel_number
	and	#03
	asl	a
	asl	a
	tax
	lda.l	jewel_data+00,x
	sta	spriteblk+121*04+02
	lda.l	jewel_data+01,x
	sta	spriteblk+122*04+02
	lda.l	jewel_data+02,x
	sta	spriteblk+123*04+02



	ai16
	ramnastyoff
	lda.l	m_testcar1
	tax
	lda.l	$700000+CAR_TOTALDAMAGE,x
	pha
	lda.l	$700000+CAR_GNDSPEED,x
	pha
;-------------------------------------------------------------	
	lda.l	$700000+OBJ_WORLDX,x
	clc
	adc	addx
	lda.l	$700000+OBJ_WORLDX,x
	sta	posx	
	lda.l	$700000+OBJ_WORLDY,x
	clc
	adc	addy
	sta.l	$700000+OBJ_WORLDY,x
	sta	posy	
	lda.l	$700000+OBJ_WORLDZ,x
	clc
	adc	addz
	sta.l	$700000+OBJ_WORLDZ,x
	sta	posz   
;-------------------------------------------------------------w	
	ldx	playpt

	lda.l	alx_livesleft,x

	and	#$FF
	pha	;
	ramnastyon
.dispplayernum
	pla	;<<<<<<<<<<<<<<<<<<<<<<<<<<<<PLAYER NUM
	ai8
	cmp	#00
	bne	continue_race
	lda	gameover_flag
	bne	notcallfadeoutbgm
	dec	gameover_flag
	
	se_fadeoutbgm

notcallfadeoutbgm

	lda	#01
continue_race
	dec	a
contrace
	asl	a
	asl	a
	tax
	lda.l	numdata+00,x
	sta	spriteblk+126*4+02
	lda.l	numdata+01,x
	sta	spriteblk+126*4+03
	lda.l	numdata+02,x
	sta	spriteblk+127*4+02
	lda.l	numdata+03,x
	sta	spriteblk+127*4+03
;
set_velocity_meter
	

speedmain	equ	27*04*04+3*4


	a16
	pla	;<<<<<<<<<<<<<<<<<<<<<<<<<<<<CAR_GNDSPEED
	lsr	a
	lsr	a
	ldx	#0
	cmp	#999
	bcc	.100loop
	lda	#999
.100loop
	cmp	#100
	bcc	.end100
	sbc	#100
	inx
	bra	.100loop
.end100
	stx	spriteblk+speedmain+00*04+02
	a8
	ldx	#0
.10loop
	cmp	#10
	bcc	.end10
	sbc	#10
	inx	
	bra	.10loop
.end10
	stx	spriteblk+speedmain+01*04+02
	sta.l	spriteblk+speedmain+02*04+02


damagemain	equ	28*4*4+2*4     ;see xlinit.asm!!!



set_damage_meter

	a16	;<<<<<<<<<<<<<<<<<<<<<<CAR_TOTALDAMAGE
	pla
	a8
	asl	a
	cmp	#80h
	bcc	.under80h
.over80h
	cmp	#0c0h
	bcc	.underc0h
.overc0h

.checkflash
	pha
	lda	flashdamagecounter
	clc
	adc	framer
	cmp	#14
	bcc	.turnondamage
.turnoffdamage
	cmp	#28
	bcc	.notoverflash
	lda	#0
.notoverflash
	sta	flashdamagecounter
	pla
	lda	#0
	bra	.flashmeter
.turnondamage
	sta	flashdamagecounter
	pla	 
	sec
	sbc	#0c0h
	lsr	a
	lsr	a
	clc
	adc	#80h
	sta	spriteblk+damagemain+0*4+00

	lda	#27h
	sta.l	spriteblk+damagemain+00*04+02
	sta.l	spriteblk+damagemain+02*04+02
	sta.l	spriteblk+damagemain+03*04+02
	sta.l	spriteblk+damagemain+04*04+02
	lda	#25h
	sta.l	spriteblk+damagemain+05*04+02
	bra	.returnramstuff
.underc0h
	sec
	sbc	#80h
	lsr	a
	lsr	a
	clc
	adc	#70h
	sta	spriteblk+damagemain+00*04+00
	lda	#27h
	sta.l	spriteblk+damagemain+00*04+02
	sta.l	spriteblk+damagemain+02*04+02
	sta.l	spriteblk+damagemain+03*04+02
	lda	#25h
	sta.l	spriteblk+damagemain+04*04+02
	sta.l	spriteblk+damagemain+05*04+02
	bra	.returnramstuff
.under80h
	cmp	#40h
	bcc	.under40h
.over40h
	sbc	#40h
	lsr	a
	lsr	a
	clc
	adc	#60h
	sta	spriteblk+damagemain+00*04+00
	lda	#27h
	sta.l	spriteblk+damagemain+00*04+02
	sta.l	spriteblk+damagemain+02*04+02
	lda	#25h
	sta.l	spriteblk+damagemain+03*04+02
	sta.l	spriteblk+damagemain+04*04+02
	sta.l	spriteblk+damagemain+05*04+02
	bra	.returnramstuff
.under40h
	lsr	a
	lsr	a
.flashmeter
	clc
	adc	#60h
	sta	spriteblk+damagemain+00*04+00
	lda	#27h
	sta.l	spriteblk+damagemain+02*04+02
	lda	#25h
	sta.l	spriteblk+damagemain+00*04+02
	sta.l	spriteblk+damagemain+03*04+02
	sta.l	spriteblk+damagemain+04*04+02
	sta.l	spriteblk+damagemain+05*04+02





.returnramstuff
	rts


;;;;;;	incfile	coldet.asm


gamepalbuff	dw	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	IFEQ	1

tunnelgreen	dw	$25ab,$3620,$31e0,$2de0,$29a0,$25a0,$2160,$1d60,$1d40,$1520,$1500,$0ce0,$0cc0,$04a0,$0480,$0020
	dw	$25ab,$31e0,$3620,$29a0,$2de0,$2160,$25a0,$1d40,$1d60,$1500,$1520,$0cc0,$0ce0,$0480,$04a0,$0040
tunnelblue	dw	$25ab,$4dcf,$4def,$3d4b,$3d6b,$2cc7,$2ce7,$1c43,$1c63,$1000,$1020,$0000,$0020,$0000,$0020,$0402
	dw	$25ab,$4def,$458d,$3d6b,$3509,$2ce7,$2485,$1c63,$1401,$1020,$0800,$0020,$0000,$0020,$0803,$0402
tunnelpurple dw	$25ab,$354e,$354f,$2d0c,$2d0d,$24ca,$24cb,$1c88,$1c89,$1446,$1447,$0c04,$0c05,$0402,$0403,$0402
	dw	$25ab,$354f,$312d,$2d0d,$28eb,$24cb,$20a9,$1c89,$1867,$1447,$1025,$0c05,$0803,$0403,$0803,$0402
tunnelred	dw	$25ab,$017c,$019c,$00f8,$0118,$0074,$0094,$0010,$0030,$000c,$002c,$0008,$0028,$0004,$0024,$0000
	dw	$25ab,$019c,$013a,$0118,$00b6,$0094,$0032,$0030,$000e,$002c,$000a,$0028,$0006,$0024,$0002,$0000
tunnelcolony dw	$0000,$3dd2,$3dd4,$3590,$3592,$2d4e,$2d50,$250c,$250e,$1cca,$1ccc,$1488,$148a,$0c46,$0c48,$0404
	dw	$0000,$3dd4,$39b1,$3592,$316f,$2d50,$292d,$250e,$20eb,$1ccc,$18a9,$148a,$1067,$0c46,$0825,$0404
	ENDC
;	list	on macros


;---------------------------------------------------
cbeginz	=	3192

cstartz	=	cbeginz

cstep	=	128

citerations	=	cstartz/cstep

canimstep	=	4

cscr1	=	16+8
cscr2	=	256+16+8
cscrc	=	112

tmp	=	0

	REPT	cstep/canimstep

	run	"chequered_tab",tmp


;---------------------------------------------------
; inner loop of ceiling

cyval	=	10
ctoggle	=	1
czpos	=	-(cbeginz-cstartz)+cstep*2
cypos	=	-60

	REPT	citerations

tmp2	=	czpos

	IFLE	czpos
czpos	=	1
	ENDC

clastyval	=	cyval
cyval	=	(cypos*256)/(czpos)+cscrc
	IFLE	cyval-15
cyval	=	15
	ENDC
ctoggle	=	ctoggle+1
cdiff	=	cyval-clastyval
	IFNE	cdiff
	IFLT	cdiff-127
	db	cdiff!((ctoggle&1)<<7)
	ENDC	
	ENDC

	IFEQ	ctoggle&1
czpos	=	tmp2+cstep+(cstep/8)*4
	ELSEIF
czpos	=	tmp2+cstep-(cstep/8)*4
	ENDC
	ENDR


;---------------------------------------------------
; inner loop of floor

ctoggle	=	1
czpos	=	cstartz-cstep*2
cypos	=	60

	REPT	citerations

	IFLE	czpos
czpos	=	1
	ENDC

clastyval	=	cyval
cyval	=	(cypos*256)/(czpos)+cscrc
ctoggle	=	ctoggle+1
cdiff	=	cyval-clastyval
	IFNE	cdiff
	IFLT	cdiff-127
	db	cdiff!((ctoggle&1)<<7)
	ENDC	
	ENDC

czpos	=	czpos-cstep
	ENDR
;---------------------------------------------------
	db	0,0,0
cstartz	=	cstartz-canimstep*2
tmp	=	tmp+1
	ENDR

tmp	=	0
chequered_tables
	REPT	cstep/canimstep
	run	"%tdw%tchequered_tab",tmp,"&WM"
tmp	=	tmp+1
	ENDR



;--------------------------------------------------------------------------
redtunnel	dw	0000h,00d1h,00b0h,008fh,006eh,004dh,002ch,000bh
	dw	000ah,0009h,0008h,0007h,0006h,0005h,0004h,7fffh
	dw	0000h,00d1h,00b0h,008fh,006eh,004dh,002ch,000bh
	dw	000ah,0009h,0008h,0007h,0006h,0005h,0004h,0000h


;# = gamma  $ = beta  % = alpha
etesttrans	db	0,01ch,0,02ch,02bh,02ah,0,0,0,0
	db	029h,0,0,027h,028h,0,01dh,01eh,01fh,020h
	db	021h,022h,023h,024h,025h,026h,0,0,0,0
	db	0,0,0,2,3,4,5,6,7,8
	db	9,10,11,12,13,14,15,16,17,18
	db	19,20,21,22,23,24,25,26,27,28


thundercol	dw $0000,$7fff,$36fe,$32bd,$2e7b,$2e79,$2677,$1e35
	dw $15f3,$0db1,$016e,$77ee,$00c7,$00a6,$0085,$0043





