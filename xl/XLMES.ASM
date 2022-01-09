;--------------------------------------------------------------------
;
;	Message Display Program for XL
;
;				programed by Masato Kimura
;
;				24/05/1993
;--------------------------------------------------------------------
;	
;
	
	incpublics	xlmes.ext


message_control

	jsl	gamemessage
	jsr	decrececounter
	rtl
;--------------------------------------------------------------

decrececounter
	a8
	lda	time_flag
	bne	gotocount
	rts
gotocount
	
	a16
	lda	minutecounter
	sta.l	mminutecounter
	beq	skipcount
	cmp	#10
	bcs	over10minute
under10minute
	cmp	minutecountold
	beq	notcallsignal

	sta	minutecountold

	se_redsignal

notcallsignal
	lda	#08*26-16-8*3
	sta.l	messageh   
	lda	#0+8
	sta.l	messagev
	lda	#300h
	sta.l	messagezoomh	
	sta.l	messagezoomv


	executemario	ms_deccount1

	rts

skipcount
	longa
	lda	minutecountold
	beq	alreadysetexp
	stz	minutecountold

	se_lastexplosion	

alreadysetexp
	rts


over10minute	  
	longa
	sta	minutecountold	 
	lda	#08*26-16-8*3
	sta.l	messageh   
	lda	#0+8
	sta.l	messagev
	lda	#180h
	sta.l	messagezoomh	
	sta.l	messagezoomv

	executemario	ms_deccount2


	rts
;---------------------------------------------------------------


gamemessage

	ai8

.nolaptime
	shorta
	shorti


	lda	race_index
	cmp	#06h
	beq	racingstatus
	cmp	#08h
	beq	racingstatus

	rtl

racingstatus

	lda	lapdispcnt
	beq	.notdisplap
	jmp	.nowlapdisplay
.notdisplap
	a8i16
	ldx	playpt
	lda	lapstock
	cmp.l	alx_lapcnt,x	
	bcs	.noinclap
.lapdispinit
	lda	#02
	sta	lapdispcnt

	lda	lapstock
	inc	a
	sta	lapstock
	cmp	#2
	beq	.startfinallap
	bcs	.startgoalin

.startlap1

	a8
	se_startrace
	se_shout
	recordlaptime	0

	bra	.lap1
.noinclap
	rtl
	
.startlap2

       	a8
	se_checkline
	recordlaptime	1
	jmp	.lap2

.startfinallap
	jsr	incrececounter
	a8
	se_checkline
	se_shout
	recordlaptime	1 		;debug!!!!

	jmp	.finallap

.startgoalin
	a8
	lda	#0ffh
	sta	goalin_flag
	
	se_endengine
	se_interruptbgm
	se_goalin
	
	recordlaptime	2		;debug!!!!

	a16
	lda	#06*08
	sta.l	messagelength
	jmp	.goalin


.endmes1
	a8
	stz	lapdispcnt
	lda	#40h
	sta	laptimedispcnt
	rtl
.nowlapdisplay
	shorta


	lda	lapstock
	cmp	#2
	beq	.finallap
	bcc	.lap1
	jmp	.goalin
.lap1	
	a16i8
	lda	#05*08
	sta.l	messagelength
	ldx	lapdispcnt
	lda.l	lapzoom,x
	bmi	.endmes1
	sta.l	messagezoomh
	sta.l	messagezoomv

	executemario	ms_lap1

	inc	lapdispcnt	
	inc	lapdispcnt	
	rtl
.lap2	
	a16i8
	lda	#05*08
	sta.l	messagelength
	ldx	lapdispcnt
	lda.l	lapzoom,x
	bmi	.endmes2
	sta.l	messagezoomh
	sta.l	messagezoomv

	executemario	ms_lap2

	jsr	laptimedisp
	inc	lapdispcnt	
	inc	lapdispcnt	
	rtl
.endmes2
	a8
	stz	lapdispcnt
	lda	#40h
	sta	laptimedispcnt
	rtl
.finallap
	a16i8
	lda	#09*08
	sta.l	messagelength
	ldx	lapdispcnt
	lda.l	flapzoom,x
	bmi	.endmes3
	sta.l	messagezoomh
	sta.l	messagezoomv

	executemario	ms_finallap

	jsr	laptimedisp
	inc	lapdispcnt	
	inc	lapdispcnt	
	rtl
.endmes3
	a8
	stz	lapdispcnt
	lda	#40h
	sta	laptimedispcnt
	rtl
.goalin
	a16i8
	ldx	lapdispcnt
	lda.l	goalzoom,x
	bpl	.contgoalin

	se_restartbgm
	se_goalinbgm
	a8
;;;;;;;	stz	lapdispcnt
	inc	lapdispcnt
	inc	lapdispcnt
	rtl

	      
.contgoalin
	longa
	shorta
	beq	.displaplist
	sta.l	messagezoomh
	sta.l	messagezoomv
	inx
	inx
	stx	lapdispcnt



	ai16
	
	lda.l	m_testcar1

	tax
	lda.l	$700000h+CAR_FLAGS,x
	ora	#CARflag_computer
	sta.l	$700000h+CAR_FLAGS,x


	a8i16
	lda	#0
	sta	time_flag

	executemario	ms_finish
	
	rtl

.displaplist

	a16
	lda	goalin_cnt	 ;max=80h
	cmp	#40h
	bcs	.gotolaplist

	a8
	lda	map_number
	cmp	#02
	bcc	.trynext
.welldone

	a16
	lda	#220h
	sta.l	messagezoomh
	lda	#240h
	sta.l	messagezoomv
	lda	#11*08
	sta.l	messagelength
	
	executemario	ms_welldone

	rtl

.trynext

	a16
	lda	#120h
	sta.l	messagezoomh
	lda	#1e0h
	sta.l	messagezoomv
	lda	#19*08
	sta.l	messagelength

	executemario	ms_trynextcourse

	rtl
     	
.gotolaplist
	a16i8
	ldx	#01*06
	jsr	copylaptime

	lda	#2ch
	sta.l	messageh   
	lda	#40h-18h
	sta.l	messagev
	lda	#100h
	sta	messagezoomh	
	sta	messagezoomv
	
	executemario	ms_listlap1
	a16i8
	ldx	#02*06
	jsr	copylaptime	

	lda	#2ch
	sta.l	messageh   
	lda	#40h
	sta.l	messagev
	executemario	ms_listlap2

	rtl
;------------------------------------------------------------

incrececounter
	pha
	ai16
	lda	map_number
	and	#0ffh
	asl	a
	tax
	sed
	lda	minutecounter
	clc
;;;	adc	#50h
	adc.l	incrementdata,x
	cmp	#99h
	bcc	notoverincrece
	lda	#99h
notoverincrece	
	sta	minutecounter
	cld
	plp
	rts



;-------------------------------------------------------------
incrementdata
	dw	50h,50h,50h,50h
;-------------------------------------------------------------
	longa
	shorti
copylaptime
	lda.l	laptimebuffer+00h,x
	sta.l	mdecimallap
	lda.l	laptimebuffer+02h,x
	sta.l	msecondlap
	lda.l	laptimebuffer+04h,x
	sta.l	mminutelap
	rts
;-------------------------------------------------------------
lapzoom
	dw	00,100h,120h,140h,160h,180h
	dw	1c0h,200h,240h,280h,300h
	dw	300h,300h,300h
	dw	0ffffh
flapzoom
	dw	00,100h,120h,140h,160h,180h
	dw	1c0h,220h,240h,260h,280h,0ffffh
goalzoom
	dw	00,100h,180h,280h,300h,360h
	dw	300h,280h,200h
	dw	240h,2a0h,300h,360h
	dw	300h,200h,100h
	dw	0ffffh,000h


;-------------------------------------------------------------
laptimedisp

	a16i8
	lda	#08*08
	sta.l	messagelength
	lda	#180h
	sta.l	messagezoomh
	sta.l	messagezoomv

	executemario	ms_laptime

.returndisplap
	rts
	
;-------------------------------------------------------------


			;x=lap address

			;00   =lap 0	   ;lap0
			;01*06=lap 1	   ;lap1
			;02*06=lap2	   ;final lap
			;03*06=lap3	   ;goalin

pretimebuffer	equ	timebuffer-06

set_record
	longa
	shorti

	sed

	lda	secondtime
	sta.l	timebuffer+02,x
	lda	minutetime
	sta.l	timebuffer+04,x
	lda	decimaltime
	sta.l	timebuffer+00,x

	cpx	#0
	beq	notsetlaptime

	sec
	sbc.l	pretimebuffer+00,x
	sta.l	mdecimallap
	sta.l	laptimebuffer+00,x


	lda.l	timebuffer+02,x
	sbc.l	pretimebuffer+02,x
	bcs	notborrow
	sec
	sbc	#40h
	sta.l	msecondlap	
	sta.l	laptimebuffer+02,x
	clc
 	lda.l	timebuffer+04,x
	sbc.l	pretimebuffer+04,x
	sta.l	mminutelap
	sta.l	laptimebuffer+04,x
	cld
	rts
notborrow
	sta.l	msecondlap	
	sta.l	laptimebuffer+02,x
	sec
 	lda.l	timebuffer+04,x
	sbc.l	pretimebuffer+04,x
	sta.l	mminutelap
	sta.l	laptimebuffer+04,x


	cld
	rts

notsetlaptime

	lda	decimaltime
	sta.l	laptimebuffer+00,x
	lda	secondtime
	sta.l	laptimebuffer+02,x
	lda	minutetime
	sta.l	laptimebuffer+04,x

	cld
	rts
	
	
	




	
	
		



