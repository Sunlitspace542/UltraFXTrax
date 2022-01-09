;---------------------------------------------------------
;
;	Sound Control Program for XL
;
;				programed by Masato Kimura
;
;				11/05/1993
;---------------------------------------------------------


	
	incpublics	xlsound.ext


engine_sound
	php
	a8
	lda	control_flag
	bne	startinggrid
	ai16
	lda.l	m_testcar1
	tax
	lda.l	$700000+CAR_REVSnd,x
	cmp	#1023
	bcc	.not_over_speed
	lda	#1023
.not_over_speed			
	lsr	a
	lsr	a

	a8
	sta.l	2143h		;sound 03 port!!!

	plp
	rtl

startinggrid
	
	a16i8
	lda.l	cont0d
	bmi	.accelon
	bit	#80h
	bne	.accelon

.acceloff

	lda.l	enginesound
	sec	
	sbc	#3800h
	bcs	.contacceloff
	lda	#0000h
.contacceloff	
	sta.l	enginesound
	a8
	xba
	sta.l	2143h

	plp
	rtl
;
.accelon
	longa
	shorti
	lda.l	enginesound
	clc
	adc	#1400h
	cmp	#0e000h
	bcc	.contaccelon
.overaccel
	lda	#800h	
.contaccelon
	sta.l	enginesound
	a8
	xba
	sta.l	2143h		
	plp
	rtl





accelondata
	dw	 2400h,2500h,2800h,2700h
acceloffdata
	dw	 4800h,4a00h,4d00h,4f00h
accellimmit
	dw	 0c000h,0e000h,08000h,0f000h
minimumaccel
	dw	 0f00h,0d00h,0300h,0400h

	




















;;;;	lda	accel_flag
;;;;	bpl	.lastoff
;;;.laston
;;;;	a16
;;;;;;	lda	cont0l
;;	bmi	continuestatus
;;	bit	#%0000000010000000
;;	bne	continuestatus
;;.nowoff
;;	a8
;;	lda	#00
;;	sta	accel_flag
;;;	se_acceloff
;;	plp
;;	rtl
;;.lastoff
;;	a16
 ;;	lda	cont0l
 ;;;	bmi	.nowon
;;	bit	#%0000000010000000
;;;	beq	continuestatus
;;.nowon	
;;	a8
;;;	lda	#0ffh
;;;	sta	accel_flag
;;	se_accelon
;;	plp
;;	rtl
;;continuestatus
;;	longa
 ;;	lda	trig1
;	bmi	.hitB
;;     	bit	#4000h
;;	bne	.hitY
;;	bit	#0080h
;;	bne	.hitA
;;	bit	#0040h
;;	bne	.hitX
;;	plp
 ;;	rtl
  ;;	

.hitX
;	engine3
	ai16
;;;;;	bump
	plp
	rtl

.hitA
;;;;;	engine4
	plp
	rtl

.hitY
;;;;;	engine2
	plp
	rtl
.hitB
;;;;;	engine1
	plp
	rtl

;--------------------------------------------------------------


apu_initialize
	php
	ai16
	lda	#xlsnd0>>16
	ldy	#(xlsnd0)&WM

	jsl	boot_apu

	a8i16
	ldx	#4000h
.soundwait
	dex
	bne	.soundwait
	plp
	rtl
;--------------------------------------------------------------
;			engine_lebel=16.....nomal
;				     18.....core
;				     17.....tunnel
;
nomal_engine_call
	php
	a8
	lda	#nomalengine
	cmp	engine_lebel
	beq	nomorenomal
	sta	engine_lebel
	jsl	call_sound0
nomorenomal
	plp
	rtl	
core_engine_call
	php
	a8
	lda	#coreengine
	cmp	engine_lebel
	beq	nomorecore
	sta	engine_lebel
	jsl	call_sound0
nomorecore
	plp
	rtl	
tunnel_engine_call
	php
	a8
	lda	#nomalengine
	cmp	engine_lebel
	beq	nomoretunnel
	sta	engine_lebel
	jsl	call_sound0
nomoretunnel
	plp
	rtl	
;--------------------------------------------------------------

call_skid01
	php
	a8
	lda	#skid1 
	cmp	skid_lebel	
	bne	call_skid  
	plp
	rtl	
call_skid02
	php
	a8
	lda	#skid2	
	cmp	skid_lebel
	bne	call_skid
	plp
	rtl
call_skid03
	php
	a8
	lda	#skid3	
	cmp	skid_lebel
	bne	call_skid
	plp
	rtl
call_skid04
	php
	a8
	lda	#skid4	
	cmp	skid_lebel
	bne	call_skid
	plp
	rtl
call_skidend
	php
	a8
	lda	skid_lebel
	beq	nomoreend
	stz	skid_lebel
	se_cut5
	plp
	rtl

	shorta
call_skid
	sta	skid_lebel
       	jsl	call_sound0
nomoreend
	plp
	rtl
;------------------------------------------------------------
dart_on
	php
	a8
	lda	dart_flag
	bne	continue_dart
	dec	dart_flag
	lda	#dart_sound
	jsl	call_sound0	
continue_dart	
nomore_dart
	plp
	rtl
dart_off
	php
	a8
	lda	dart_flag
	beq	nomore_dart
	stz	dart_flag
	se_cut5			;dart se uses channel no.5
	plp
	rtl
;---------------------------------------------------------
brake_on
	php
	a8
	lda	brake_flag
	bne	continue_brake
	dec	brake_flag
	lda	#brake_sound
	jsl	call_sound0	
continue_brake	
nomore_brake
	plp
	rtl
brake_off
	php
	a8
	lda	brake_flag
	beq	nomore_brake
	stz	brake_flag
	se_cut5			;brake se uses channel no.5
	plp
	rtl
;---------------------------------------------------------
				;a=set data!!!
call_sound0
	phb
	pha
	phy
	phx
	php
	ai8
;;;	ldx	#0ffh
;;;;	stx	soundgate
	ldy	#07eh
	phy
	plb
	ldx	sound_selecter
	bne	.nomore0
	ldy	sound0number
	beq	.firstset0
	cpy	#10h
	bcs	.nomore0
	pha
	tya
	clc
	adc	sound0pointer
	cmp	#10h
	bcc	.notover0
	sbc	#10h
.notover0	
	tay
	pla
	sta	sound0buffer,y
	inc	sound0number
;;;	lda	#0
;;;;	sta.l	soundgate
	plp
	plx
	ply
	pla
	plb
	rtl
.firstset0
	inc	sound0number
	ldy	sound0pointer
	sta	sound0buffer,y
.nomore0
;;;	lda	#0
;;;	sta.l	soundgate											
	plp
	plx
	ply
	pla
	plb
	rtl

;---------------------------------------------------------
				;a=set data!!!
call_sound1
	phb
	pha
	phy
	phx
	php
	ai8
;;;	ldx	#0ffh
;;;;	stx	soundgate
	ldx	#07eh
	phx
	plb
	ldx	sound_selecter
	bne	.nomore1
	ldx	sound1number
	beq	.firstset1
	cpx	#10h
	bcs	.nomore1
	pha
	txa
	clc
	adc	sound1pointer
	cmp	#10h
	bcc	.notover1
	sbc	#10h
.notover1	
	tax
	pla
	sta	sound1buffer,x
	inc	sound1number
;;;   ;	lda	#0
;;;;	sta	soundgate
	plp
	plx
	ply
	pla
	plb
	rtl
.firstset1
	inc	sound1number
	ldx	sound1pointer
	sta	sound1buffer,x
.nomore1
;;;;	lda	#0
;;;;	sta	soundgate
	plp
	plx
	ply
	pla
	plb
	rtl
;---------------------------------------------------------
clear_sound
	php
	ai8
	lda	#00
	sta	sound_selecter
	sta	sound0stock
	sta	sound1stock
	sta	sound0pointer
	sta	sound1pointer
	sta	sound1number
	sta	sound0number
	sta.l	enginesound+00
	sta.l	enginesound+01
	sta.l	2143h
	plp
	rtl

;---------------------------------------------------------

boot_apu
	longi
	a8
	sty	address+0
	sta	address+2
	ldy	#0
;---------------------------------------------------------
	ldx	#0bbaah
boot_initial
	cpx  	apu_port0
	bne	boot_initial
	lda	#0cch
	bra	boot_entry1
;---------------------------------------------------------
boot_repeat
	jsr	get_data
	xba
	lda	#0
	bra	boot_entry2
boot_loop
	xba
	jsr	get_data
	xba
boot_wait1
	cmp	apu_port0
	bne	boot_wait1
	inc	a
;---------------------------------------------------------
boot_entry2
	a16
	sta	apu_port0
	a8
	dex
	bne	boot_loop
boot_wait2
	cmp	apu_port0
	bne	boot_wait2
boot_zero
	adc	#3
	beq	boot_zero
;---------------------------------------------------------
boot_entry1
	pha
	jsr	get_data
	xba
	jsr	get_data
	xba
	tax
	jsr	get_data
	sta	apu_port2
	jsr	get_data
	sta	apu_port3
;---------------------------------------------------------
	cpx	#1
	lda	#0
	rol	a
	sta	apu_port1
	adc	#07fh
	pla
	sta	apu_port0
boot_wait3
	cmp	apu_port0
	bne	boot_wait3
	bvs	boot_repeat
	rtl

get_data	
	lda	[address],y
	iny
	cpy	#08000h
	bne	get_exit
	inc	address+2
	ldy	#0
get_exit
	rts
