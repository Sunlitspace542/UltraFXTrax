;***************************************************************************
;*                              -----------                                *
;*                              StarGlider                                 *
;*                              -----------                                *
;*                                                                         *
;*                           SuperNES version.                             *
;*                                                                         *
;*                           Argonaut Software.     	 		   * 
;*_________________________________________________________________________*
;*                                                                         *
;*   File: ENDSEQ.ASM                                                      *
;*_________________________________________________________________________*
;*                                                                         *
;*  Descr: End sequence code                                               *
;*_________________________________________________________________________*
;*                                                                         *
;*   Date: 10/9/92                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;* Author:   Krister Wombell.                                              *
;*                                                                         *
;***************************************************************************

bg3xinit	equ	128
bg3yinit	equ	-17
bg2xinit	equ	0
bg2yinit	equ	256
bg1xinit	equ	0
bg1yinit	equ	0

bg1xmove	equ	6*8
bg1ymove	equ	3*8
bg2xmove	equ	6*8
bg2ymove	equ	3*8
bg3xmove	equ	12*8
bg3ymove	equ	6*8

bg1xspd	equ	2
bg1yspd	equ	1
bg2xspd	equ	2
bg2yspd	equ	1
bg3xspd	equ	4
bg3yspd	equ	2

	incpublics	endseq.ext

;-------------------------------------------------------------------
; INTRO SEQUENCE

intro_l
	a8i16

	ifne	fast21mhz
	fast
	endc

	lda	#1
	sta.l	oncewipe

;;;;;	bgm	init
	a8i16
	ldx	#0
.ll	dex
	bne	.ll
;;;;	bgm	intro
	disable


	a8i16
	lda	map_number
	cmp 	#0
     	bne	.nmap1
	lda	#testmap1>>16
	ldx	#testmap1&$7fff
	bra	.domap
.nmap1
	cmp 	#1
     	bne	.nmap2
	lda	#testmap2>>16
	ldx	#testmap2&$7fff
	bra	.domap
.nmap2
	cmp 	#2
     	bne	.nmap3
	lda	#testmap3>>16
	ldx	#testmap3&$7fff
	bra	.domap
.nmap3
	lda	#testmap4>>16
	ldx	#testmap4&$7fff
.domap

	sta	mapbank
	stx	mapptr
	jsl	initgame_l
	s_and_var		B,pshipflags3,#~psf3_enginesnd




	lda	#0
	sta.l	m_meters
	sta	exitintro
;	sta.l	oncewipe
	stz	gameframe

	lda	#1
	sta	freezestrats

	a8i16
	lda	#minit_dynamics>>16
	ldx	#minit_dynamics&WM
	jsl	runmario_l




.lp3
	jsl	setblack_l
	jsl	transfer_l
	a8
;	inc	gameframe
	lda	gameframe
	cmp	#30
	bcc	.lp3


	stz	freezestrats

	bra	.lp3

;	lda	exitintro
;	bne	.waitup
;	lda	cont0
;	ora	contl0
;	beq	.lp3
;.waitup
	lda	#-2
	sta	fadedir
	lda	#11
	sta	fade
.finishlp
	jsl	setblack_l
	jsl	transfer_l
	a8
	lda	fadedir
	bne	.finishlp
	rtl


tit_istrat
	s_start_strat
	s_set_alvar	B,x,al_rotx,#-deg45+deg11+deg11+3-deg5
	s_set_alvar	B,x,al_roty,#deg45+deg90	;+deg11
	s_set_alvar	B,x,al_rotz,#0
	s_set_strat	x,tit_strat
tit_strat
	s_start_strat
	s_add_alvar	B,x,al_rotz,#2
	s_add_playerz x
	s_end_strat





