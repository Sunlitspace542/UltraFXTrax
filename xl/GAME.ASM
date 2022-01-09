
	incpublics	game.ext

getview_l
	a8
	phb
	lda	#$7e
	pha
	plb

	a8

	ifeq	1
	lda	viewtype
	and	#viewtype_fpos
	rlbne	.fpos


	a16i8
	lda	viewshakeX
	sexa
	clc
	adc	pviewposx
	sta	viewposx

	lda	viewshakeY
	sexa
	clc
	adc	pviewposY
	sta	viewposY

	lda	viewshakeZ
	sexa
	clc
	adc	pviewposZ
	clc
	adc	pviewposZoff
	sta	viewposZ

	lda	outvx
	sta	viewrotxw

	lda	outvy
	clc
	adc	outvyoff
	sta	viewrotyw

	lda	outvz
	sta	viewrotzw

	a8


;***************************************************************
;* I'M SORRY BUT THESE ARE 2 VERY BIG HACKS, BECAUSE I DON'T WANT
;* TO FUCK WITH PETE'S CODE. (Giles) 



;* JUST X ROTATE VIEW POS.
	a16
	lda	viewrotxw
	nega
	sta matxw
	stz matyw
	stz matzw
	a8
	jsl crotmat16_l

	a16
	copymat16 mat,wmat

	stz	x1
	stz	y1
	lda	outdist
	nega
	sta	z1
	a8
	jsl	wmatrotp16_l

;***************************************************************


;* NOW JUST Y ROTATE VIEW POS.
	a16
	stz matxw
	lda	viewrotyw
	nega
	sta matyw
	stz matzw
	a8
	jsl crotmat16_l

	a16
	copymat16 mat,wmat

	lda	bigx
	sta	x1
	lda	bigy
	sta	y1
	lda	bigz
	sta	z1
	a8
	jsl	wmatrotp16_l
	add bigx,viewposx,viewposx
	add bigy,viewposy,viewposy
	add bigz,viewposz,viewposz


;***************************************************************

.fpos
	endc

	ai16
	ldx viewpt
	lda al_worldx,x
	sta viewposx
	lda al_worldy,x
	sta viewposy
	lda al_worldz,x
	sta viewposz

	a8

	lda	viewtype
	and	#viewtype_toobj
	rlbeq	.ntpl

	lda	al_rotx,x
	sta	outvx+1
	stz	outvx

	ldy	viewtoobj
	lda.w	al_worldzh,y
	sta	viewmapz


	lda.w	al_rotx,y
	sta matx
	lda.w	al_roty,y
	sta maty
;	lda.w	al_rotz,y
	stz matz
	jsl crotmat16_l

	a16
	copymat16 mat,wmat

	lda	viewtopos_offX
	sta	x1
	stz	y1
	lda	viewtopos_offZ
	sta	z1
	a8
	jsl	wmatrotp16_l

	ai16
	ldx viewpt
	ldy	viewtoobj

	lda	bigx
	sta	x2
	lda	bigz
	sta	z2
	jsl	Yanglexy_off_l
	lda	#0
	sec
	sbc	viewrotYw
	adiv2
	clc
	adc	viewrotYw
	sta 	viewrotYw		
	sta 	outvy

	lda	bigx
	sta	x2
	lda	bigy
	nega
	sta	y2
	lda	bigz
	sta	z2
	jsl	Xanglexy_off_l
	nega
	sec
	sbc.l	alx_viewrotX,x
	sec
	sbc	outvx
	adiv2
	adiv2
	adiv2
	clc
	adc.l	alx_viewrotX,x
	sta	viewrotXw		


	lda	viewtype
	and	#viewtype_nolimits		
	bne	.nlim

	lda	viewrotYw
	range	-deg11*256,deg11*256
	sta	viewrotYw

	lda	viewrotXw
	range	-deg22*256,deg22*256
	sta	viewrotXw
.nlim
	lda	viewrotXw
	sta.l	alx_viewrotX,x


	a8
	lbra		.dviewrot
.ntpl

;------------------------------------------------------------------
	a8
	lda	viewtype
	and	#viewtype_mia
	rlbeq	.nmia

	ldy	viewtoobj
	lda.w	al_worldzh,y
	sta	viewmapz

;calculate X angle
	a16
	lda	al_rotx,x
	xba
	and	#$ff00
	pha

	jsl	xanglexy_l

	sta	x1
	pla
	clc
	adc	x1	

	nega
	sec
	sbc	viewrotXw
	asra
	asra
	clc
	adc	viewrotXw
	range	-(deg90-deg5)*256,(deg90-deg5)*256
	sta	viewrotXw

;calculate Y angle
;	jsl	yanglexy_l
;	sta	viewrotYw


	ifeq	0
	lda	al_roty,x
	xba
	sta	x1

	lda.w	al_roty,y
	xba
	nega
;	asra
	adiv2
	clc
	adc	x1

	sec
	sbc	viewrotYw
	and	#$ff00
	beq	.st
	bpl	.left
	lda	viewrotYw
	sec
	sbc	#64
	sta	viewrotYw
	bra	.st
.left
	lda	viewrotYw
	clc
	adc	#64
	sta	viewrotYw
.st
	endc


	lda	viewrotYw
	range	-(deg22+deg22)*256,(deg22+deg22)*256
	sta	viewrotYw

;	lda	viewrotYw
;	range	-deg90*256,deg90*256
;	sta	viewrotYw

	

	a8
	bra	.dviewrot

.nmia


	ldx viewpt
	lda al_rotx,x
	nega
	sta viewrotx
	sta 	outvx+1
	lda al_roty,x
	nega
	sta 	outvy+1	
	sta viewroty
	lda al_rotz,x
	nega
	sta 	outvz+1	
	sta viewrotz

.dviewrot

	a16
	lda viewrotxw
	sta matxw
	lda viewrotyw
	sta matyw
	lda viewrotzw
	sta matzw


.DoneMatAngles
	ai8
	jsl crotmat16_l

	a16
	copymat16 mat,wmat
	a8




	ifeq	1
;*****************************************************************
; cross hair calculation.


	php
	ai16
	ldx	playpt

	stz	y1
	lda	#crosshairdist
	sta	z1
	a8
	lda	al_rotx,x
	jsl	rotate_16yz_l

	a16
	lda	x2
	sta	x1
	lda	y2
	sta	y1
	lda	z2
	sta	z1

	a8
	lda	al_roty,x
	jsl	rotate_16xz_l

	a16
	lda	x2
	clc
	adc	al_worldx,x
	sec
	sbc	viewposx
	sta.l	m_x1

	lda	y2
	clc
	adc	al_worldy,x
	sec
	sbc	viewposy
	sta.l	m_y1

	lda	z2
	clc
	adc	al_worldz,x
	sec
	sbc	viewposz
	sta.l	m_z1


	a8
	s_jmp_varNE	B,splayerflymode,#spfm_inside,.nin
	a16
	lda.l	m_y1
	clc
	adc	#inviewLaserYoff
	sta.l	m_y1	
	a8
.nin



	lda	#mwmatrotp16>>16
	ldx	#mwmatrotp16&$ffff
	jsl	runmario_l
	a16
	lda.l	m_bigx
	sta	x1
	lda.l	m_bigy
	sta.l	y1
	lda.l	m_bigz
	sta	z1

	ai8
	jsl	projectlog_l
	plp


	a16
	lda	xs
	sec
	sbc	#mvanishx
	sta	arsebandX

	lda	ys
	sec
	sbc	#mvanishy
	sta	arsebandY

	a8
	
;*****************************************************************
	endc


	plb
	rtl






	IFEQ	1

irotcentre
	ldx viewrotx
	lda sintab,x
	sta sinvx
	lda costab,x
	sta cosvx

	ldx viewroty
	lda sintab,x
	sta sinvy
	lda costab,x
	sta cosvy

	ldx viewrotz
	lda sintab,x
	sta sinvz
	lda costab,x
	sta cosvz


; z

;	lda viewrotz
;	lbeq irotcen3

	mulslog168 x1,cosvz
	lda m4
	sta bigx
	lda m5
	sta bigx+1
	mulslog168 y1,sinvz
	lda m4
	clc
	adc bigx
	sta bigx
	lda m5
	adc bigx+1
	sta bigx+1

	mulslog168 x1,sinvz
	lda m4
	sta bigy
	lda m5
	sta bigy+1
	mulslog168 y1,cosvz
	lda m4
	sec
	sbc bigy
	sta bigy
	lda m5
	sbc bigy+1
	sta bigy+1

	mov bigx,x1
	mov bigy,y1


irotcen3


; x

;	lda viewrotx
;	lbeq irotcen2

	mulslog168 z1,sinvx
	lda m4
	sta bigy
	lda m5
	sta bigy+1
	mulslog168 y1,cosvx
	lda m4
	clc
	adc bigy
	sta bigy
	lda m5
	adc bigy+1
	sta bigy+1

	mulslog168 y1,sinvx
	lda m4
	sta bigz
	lda m5
	sta bigz+1
	mulslog168 z1,cosvx
	lda m4
	sec
	sbc bigz
	sta bigz
	lda m5
	sbc bigz+1
	sta bigz+1


	mov bigz,z1
	mov bigy,y1

irotcen2

; y

	mulslog168 x1,sinvy
	lda m4
	sta bigz
	lda m5
	sta bigz+1
	mulslog168 z1,cosvy
	lda m4
	clc
	adc bigz
	sta bigz
	lda m5
	adc bigz+1
	sta bigz+1

	mulslog168 z1,sinvy
	lda m4
	sta bigx
	lda m5
	sta bigx+1
	mulslog168 x1,cosvy
	lda m4
	sec
	sbc bigx
	sta bigx
	lda m5
	sbc bigx+1
	sta bigx+1

;	mov y1,bigy
;	mov bigx,x1
;	mov bigz,z1

	rts



	ENDC

;
; 6502 MATHS LIBRARY
;
; by P. R. Warnes, Copyright 1990
;
random_l
	jsr	random
	rtl
random

;	lda	rand
;	rol	a
;	eor	rand+1
;	sta	rand+1
;	adc	#4
;	sta	rand
	
	lda rand
	clc
	sbc rand+1
	sta rand+1
	sbc rand+2
	sta rand+2
	sbc rand+3
	sta rand+3
	sbc rand
	sta rand
	rts


	IFEQ	1
muls8log_l
	jsr	muls8log
	rtl
muls8log 
	ldx m1
	beq muls8log1
	ldy m2
	beq muls8log2
	lda logtab8s,x
	clc
	adc logtab8s,y
	tay
	txa
	ldx alogtab8s,y
	eor m2
	bpl muls8log1
	ldx nalogtab8s,y
muls8log1 
	stx m3
	rts
muls8log2
	ldx #0
	stx m3
	rts


muls816log0y 
	ldx #0
muls816log0 
	stx m3
	stx m4
	rts
	
muls816log_l
	jsr	muls816log
	rtl
muls816log 
	ldx m1
	beq muls816log0
	ldy m2
	beq muls816log0y
	lda logtab8s,x
	clc
	adc logtab8s,y
	tay
	txa
	ldx alogtab8s,y
	eor m2
	bpl muls816log1
	ldx nalogtab8s,y
muls816log1 
	stx m3
	ldx alogtab8sl,y
	cmp #0
	bpl muls816log2
	ldx nalogtab8sl,y
muls816log2 
	stx m4
	rts


	ENDC
muls816log16_l
	jsr	muls816log16
	rtl
muls816log16
	stz	m6
	stz	m7
	mla16mac	m1,m3,m4,m6
	rts


arctan16_l
	jsr	arctan16	
	a16
	rtl


; 16 bit arctan (x1/y1)
; a = arctan(x1/y1)
;
; 0 to 359 degrees is $0000 to $ffff
; x1 and y1 are signed
;
; tmpx,x1,x2,x3,y1,y2,px,pz,pr


arctan16
sarctan
	phx
	php

	a16
	lda	x1
	sta.l	m_x1
	lda	y1
	sta.l	m_y1

	a8i16
	lda	#mcallarctan16>>16
	ldx	#mcallarctan16&$ffff
	jsl	runmario_l
	
	a16
	lda.l	m_cnt

	plp
	plx
	rts



