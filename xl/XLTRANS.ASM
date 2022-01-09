
	INCPUBLICS	xltrans.ext


	printf	"aldead= ",:$aldead,"%n"

;-----------------------------------------------------------------------

transfer_l
	php
	a8i16
	phb
	phk
	plb
	lda	framec
	sta	framer
	stz	framec

	
	lda	#2		;start screen transferring
	sta	trans_flag



	a8i16

	jsr	dostrats

	a16
	lda	#$ffff
	sta.l	m_mariokey	

	testkeydown	b
	beq	.nd
	lda	#0
	sta.l	m_mariokey	
.nd

	
	a8i16
    
	stz	mariotimer	
	stz	mariotimer+1

	lda	#mdo_dynamics>>16
	ldx	#mdo_dynamics&WM
	jsl	runmario_l
	a16
	lda	mariotimer
	sta	dyntimer
	a8
	lda.l	m_indynamics
	beq	.ok
	blink
.ok

stratsfrozen


	a16
	lda	cont0l
	sta	lastcont0l
	lda	cont1l
	sta	lastcont1l

	jsl	palgoto_l
	jsl	fadepalto_l

;-------------------------------------------
; clear object view count.

	a16
	stz	numalx
	a8i16
	phb
	lda	#$7e
	pha
	plb
	a8
	ldx	alxlst
	lda	#1
.clrall	sta	al_whocanseeme,x
	inc	numalx
	ldy	al_next,x
	tyx	
	bne	.clrall	
	a8   
	plb

;-------------------------------------------

	a8
	stz	disptimer		; DEBUG - display time.
	stz	disptimer+1

	ai16
	ldx	playpt
	lda.l	alx_viewpt,x
	sta	viewpt	
	stx	viewtoobj
	jsl	calcbgscroll_l
	jsl	getview_l
	jsl	showview_l
	ai16
	jsl	do_3d_display_l
;;;;	jsl	stratdebug_print_l
	;jsl	backup_check

;	jsr	swapbitmap
;	jsr	swaptobitmap2


;	ai16
;	ldx	playpt2
;	lda.l	alx_viewpt,x
;	sta	viewpt	
;	stx	viewtoobj
;	jsl	getview_l
;	jsl	showview_l
;	ai16
;	jsl	do_3d_display_l
;	jsr	swaptobitmap1


	a8
	lda	framec
	sta	framerate
	lda	framecount
	clc
	adc	framer
	sta	framecount
	inc	frames
	lda	framecount
	cmp	#60		; per second
	bcc	.noreset
	lda	frames
	sta	framesb
	stz	frames
	lda	framecount
	sec
	sbc	#60
	sta	framecount

.noreset	

	a8
	lda	framec
	sta.l	m_framec
	lda	#0
	sta.l	m_framec+1


	jsl	engine_sound

	jsl	message_control

	jsl	game_control

	jsr swapbitmap ; ezbuild add


;change bitmap address

	a8
	plb
	plp
	rtl


swapbitmap
	a16
	lda	bitmap_status
	beq	swaptobitmap2


swaptobitmap1
	a16
	stz	bitmap_status
	ramnastyoff
	lda	#bitmap1
	sta.l	m_bitmapbase
	sta	drawmap
	ramnastyon
	a8
	lda	#bitmap1/1024
	sta.l	mscrbase
	rts

swaptobitmap2
	a16
	inc	bitmap_status	
	ramnastyoff
	lda	#bitmap2
	sta.l	m_bitmapbase
	sta	drawmap
	ramnastyon
	a8
	lda	#bitmap2/1024
	sta.l	mscrbase
	rts

;--------------------------------------------------------------

game_control
	a8
	lda	fade_control
	beq	.fadeingame
;--------------------------------------------------------------
.fadeoutgame
	a16
	lda	screen_contrast
	sec
	sbc	#500h
	bcs	.setcontrast
	lda	#8000h
.setcontrast
	sta	screen_contrast
	rtl
;-------------------------------------------------------------
.fadeingame
	
	ai8
	ldx	fade_cnt
	lda	fadeindata&WM,x
	cmp	#16
	bcs	race_control
	sta	screen_contrast+01
	inc	fade_cnt
.nomorefade
	rtl

fadeindata
	db	00,00,00,00,00
	db	01,03
	db	05
	db	08,10,12,15,16

;-------------------------------------------------------------
race_control
	ai8
	ldx	race_index
	jmp	(racetable&WM,x)
racetable
	irv	initdemo	   ;0
	irv	demo		   ;2
	irv	countdown	   ;4
	irv	racing		   ;6
	irv	clearrace	   ;8
	irv	gameoverrace	   ;10
	irv	timeup		   ;12
;---------------------------------------------------------------
	shorta
	shorti
initdemo	  


	lda	#11h
	sta	demo_cnt
	lda	#02
	sta	race_index

	rtl	
;---------------------------------------------------------------
demo
	shorta
	shorti

	;bra	startcount	;debug!!!!!


	lda	demo_cnt
	beq	startcount
	dec	demo_cnt
	cmp	#08h
	bcs	dispcourcenumber
	a16
	lda	#1e0h
	sta.l	messagezoomh
	lda	#220h
	sta.l	messagezoomv
	lda	#012*08
	sta.l	messagelength
	

	executemario	ms_2laps2go

	a8
	rtl

dispcourcenumber
	a16
	lda	#2e0h
	sta.l	messagezoomh
	lda	#380h
	sta.l	messagezoomv
	lda	#08*08
	sta.l	messagelength
	
	a8
	lda	map_number
	asl	a
	tax
	jmp	(dispcourse&WM,x)
startcount
  	a8
	stz	start_count
	lda	#04
	sta	race_index
	
	rtl
dispcourse
	irv	course1
	irv	course2
	irv	course3
	irv	course4
course1
	executemario	ms_course1
	a8
	rtl
course2
	executemario	ms_course2
	a8
	rtl
course3
	executemario	ms_course3
	a8
	rtl
course4
	executemario	ms_course4
	a8
	rtl
;---------------------------------------------------------------
countdown
	shorta
	shorti
		

	;jmp	startracing		;debug!!!!!	

	ldx	start_count
	inc	start_count
	inc	start_count
	jmp	(start_select&WM,x)
start_select
	irv	startthree
	irv	dispthree,d3,d3,d3,d3,d3,d3,d3,d3
	irv	d3,d3,d3,d3,d3,d3,d3,d3
	irv	d3,d3,d3,d3,d3,d3,d3,d3
	irv	d3,d3,d3,d3,d3,d3,d3,d3
	irv	starttwo
	irv	disptwo,d2,d2,d2,d2,d2,d2,d2,d2
	irv	d2,d2,d2,d2,d2,d2,d2,d2
	irv	d2,d2,d2,d2,d2,d2,d2,d2
	irv	d2,d2,d2,d2,d2,d2,d2,d2
	irv	startone
	irv	dispone,d1,d1,d1,d1,d1,d1,d1,d1
	irv	d1,d1,d1,d1,d1,d1,d1,d1
	irv	d1,d1,d1,d1,d1,d1,d1,d1
	irv	d1,d1,d1,d1,d1,d1,d1,d1
	irv	d1,d1
	irv	startracing
	irv	dispgo,dg,dg,dg
	irv	dg,dg,dg,dg,dg,dg,dg,dg
	irv	dg,dg,dg,dg,dg,dg,dg,dg
	irv	dg,dg,dg,dg,dg,dg,dg,dg
	irv	dg,dg,dg,dg,dg,dg,dg,dg
	irv	endgo
startthree
	se_redsignal
dispthree
d3
	a16
	lda	#01*08
	sta.l	messagelength
	lda	#300h
	sta.l	messagezoomv
	lda	#600h
	sta.l	messagezoomh

	a8i16
	lda	#ms_3>>16
	ldx	#ms_3&WM
	jsl	runmario_l
	rtl
starttwo
	se_redsignal
disptwo
d2
	a16
	lda	#01*08
	sta.l	messagelength
	lda	#300h
	sta.l	messagezoomv
	lda	#600h
	sta.l	messagezoomh

	a8i16
	lda	#ms_2>>16
	ldx	#ms_2&WM
	jsl	runmario_l
	rtl
startone
	se_redsignal	 
dispone	
d1 
	a16
	lda	#01*08
	sta.l	messagelength
	lda	#300h
	sta.l	messagezoomv
	lda	#600h
	sta.l	messagezoomh

	a8i16
	lda	#ms_1>>16
	ldx	#ms_1&WM
	jsl	runmario_l
	rtl

startracing
	se_greensignal
	a8
	lda	#01
	sta	time_flag	;set not zero value
	stz	control_flag
dispgo
dg
	a16
	lda	#02*08
	sta.l	messagelength
	lda	#300h
	sta.l	messagezoomv
	lda	#600h
	sta.l	messagezoomh

	a8i16
	lda	#ms_go>>16
	ldx	#ms_go&WM
	jsl	runmario_l
;;;;;	rtl
endgo
	a8
	lda	#06
	sta	race_index
	rtl
;---------------------------------------------------------------
racing
	shorta
	shorti


	;rtl


	lda	minutecounter
	bne	.notimeup

.starttimeup
	
	lda	#12
	sta	race_index
	sta	control_flag
	lda	#20h
	sta	timeup_cnt

	se_gameoverbgm
	

	rtl

.notimeup

	lda	goalin_flag
	beq	.notyetgoalin

.startgoalin
	lda	#08
	sta	race_index
	a16
	lda	#080h
	sta	goalin_cnt
	rtl
.notyetgoalin
	shorta
	lda	gameover_flag
	beq	.contrace
.startgameover
	stz	time_flag
	lda	#10	       ;>>>>>>gameover!!!!!
	sta	race_index
	a16
	lda	#080h
	sta	gameover_cnt
.contrace
	rtl
;---------------------------------------------------------------
clearrace
	shorti
	a16
	lda	goalin_cnt
	beq	clearfadeout

	cmp	#080h-028h
	bcs	disablefadeout
checkanykey
	lda	cont0l
	bit	#01111111111110000b
	beq	disablefadeout
	stz	goalin_cnt
	rtl
disablefadeout
	dec	goalin_cnt
	rtl

clearfadeout
	a8
	lda	screen_contrast+01
	bne	contfadeout
	sei			;IRQ disable

	lda	#80h
	sta	2100h
	stz	$4200			;Disable NMI&IRQ
	stz	$420b			;Disable M-DMA
	stz	$420c			;Disable H-DMA

	lda	map_number
	cmp	#02h
	bcs	gototitle
	inc	map_number

	i16
	ldx	#2ffh
	txs
	jmp.l	game_start	
contfadeout
	dec	screen_contrast+01
	lda	screen_contrast+01
	cmp	#014
	bne	.nosetfadeout
	jsl	clear_sound
	se_fadeoutbgm
	se_cutall
.nosetfadeout
	rtl
;---------------------------------------------------------------
gameoverrace
	shorti
	a16
	lda	gameover_cnt
	beq	overfadeout
	cmp	#60h
	bne	nogameoverbgm
	
	se_gameoverbgm
	   
nogameoverbgm
	dec	gameover_cnt
	rtl
overfadeout
	a8
	lda	screen_contrast+01
	bne	contfadeout
gototitle
	sei			;IRQ disable
	a8
	lda	#80h
	sta	2100h
	stz	$4200			;Disable NMI&IRQ
	stz	$420b			;Disable M-DMA
	stz	$420c			;Disable H-DMA

;gototitle	
	i16
	ldx	#2ffh
	txs
	jmp.l	title_start	


.contfadeout
	dec	screen_contrast+01
	lda	screen_contrast+01
	cmp	#008
	bne	.nosetfadeout
	jsl	clear_sound
	se_fadeoutbgm
	se_cutall
.nosetfadeout
	rtl


;---------------------------------------------------------------
timeup
	a16
	lda	#300h
	sta.l	messagezoomh
	lda	#380h
	sta.l	messagezoomv
	lda	#07*08
	sta.l	messagelength
	

	executemario	ms_timeup

	a8
	lda	timeup_cnt
	bne	notimeupfadeout

	a16
	lda	screen_contrast
	sec
	sbc	#080h
	sta	screen_contrast
	bcc	gototitle

 	a8
	xba
	cmp	#14h
	bne	.notsetfadeout
	
	
	se_cutall

.notsetfadeout
	sta.l	2100h
	rtl



notimeupfadeout
	dec	timeup_cnt
	rtl
;--------------------------------------------------------------


	shorta
	longi
transswap_l 
	rtl
;;;	jsr	transswap
;;;;	rtl
transswap
	rts
;	lda	transbmp1		;...but this isn't!
;	cmp	#2
;	bne	transswap
;
;	disable
;	lda	trans_flag
;	stz	trans_flag
;	pha
;	enable
;
;	a8			;DO BG CHANGES ETC.
;	lda	bgflags
;	bit	#bgf_restart
;	beq	.nores
;	jsl	restart_l
;.nores
;	ai16
;	lda	bgflags
;	bit	#bgf_bg
;	beq	.noreq
;;;;	jsl	dobgreq_l
;.noreq
;	ai16
;	lda	bgflags
;	bit	#bgf_info
;	beq	.noreqinfo
;	jsl	setbginforeq_l
;.noreqinfo
;	a8
;	lda	bgflags
;	and	#~(bgf_info+bgf_bg+bgf_restart)
;	sta	bgflags
;	pla
;	sta	trans_flag
;	rts
;
; ;
;-----------------------------------------------------------------------
dostrats
	a8       
 	incw	gameframe

	ldx	playpt
	jsl	update_objects_l
;	ldx	playpt2
;	jsl	update_objects_l

	a8i16
	phb
	lda	#$7e
	pha
	plb

	ldx	alxlst			;do all strategies

stratlp	stz	aldead
	
	phx
	jsl	do_strat_l
	plx
	a8
	lda	aldead
	bne	.killal

	ldy	al_next,x
.killed	tyx
	bne	stratlp
	bra	.cont


.killal	
	ldy	al_next,x
 	jsl	removedeadal_l
	
	bra	.killed
.cont	plb
	rts




;-----------------------------------------------------------------------
find_window_pri_l
	php
	a8i16
	jsr	find_window_pri
	plp
	rtl

find_window_pri
	stz	tpa+1
	lda	windowmode
	sta	tpa
	a16
	beq	.nothing
	ldx	#maxwindows
	lda	#windowarray
.findhighest
	ror	tpa
	bcs	.found
	adc	#wm_sizeof
	dex
	bne	.findhighest
.nothing	lda	#0
.found	sta	windowptr
	rts


;-----------------------------------------------------------------------
calcbg2voffsets_l
	jsr	calcbg2voffsets
	rtl
calcbg2voffsets
	ai16
	stz	dobg2
	lda	dovofs
	and	#$ff
	bne	.do
	rts
.do	longa
 
	lda	dozrot
	and	#$ff
	bne	.dorotz
	lda	#0
	bra	.gotzrot
.dorotz
	lda	plrotz		;max is $d00
	bmi	.neg
.gotzrot
	swa
	and	#7
	asl	a
	tax
	lda.l	bg2ptrs,x
	cmp	lastrot
	bne	.set
	rts
.set	sta	lastrot
	tax
	ldy	#0
.lp	lda	0,x
	clc
	adc	bg2scroll
	sta.w	bg2voffsbak,y
	iny
	iny
	inx
	inx
	cpy	#64
	bne	.lp
	lda	#1
	sta	dobg2
	rts

	longa
	longi
.neg
	nega
	swa
	and	#7
	asl	a
	tax
	lda.l	bg2ptrs,x
	cmp	lastrot
	bne	.set2
	rts
.set2	sta	lastrot
	clc
	adc	#62
	tax
	ldy	#0
.lp2	lda	0,x
	clc
	adc	bg2scroll
	sta.w	bg2voffsbak,y
	dex
	dex
	iny
	iny
	cpy	#64
	bne	.lp2
	lda	#1
	sta	dobg2
	rts


	shorta
	longi
dmabg2voffsets_l
	php
	a8i16
	jsr	dmabg2voffsets
	plp
	rtl
dmabg2voffsets
	lda	#$80
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch0addrb
	ldx	#bg2voffsbak
	stx	ch0addra1tl
	stz	ch0atbank
	ldx	#(bg2offsets+32)&WM
	stx	vmaddl
	ldx	#64
	stx	ch0dataddrl
	lda	#1
	sta	ch0params
	lda	#1
	sta	mdmaen
	rts


;------------------------------------------------------------------------------
clronehalf_l
; clears one half of the 3d screen
	php
	a8i16
	lda	#mclrbitmaps2>>16
	ldx	#mclrbitmaps2&WM
	jsl	runmario_l
	plp
	rtl


;------------------------------------------------------------------------------
clrotherhalf_l
; clears one half of the 3d screen
	php
	a8i16
	lda	#mclrbitmaps3>>16
	ldx	#mclrbitmaps3&WM
	jsl	runmario_l
	plp
	rtl


;------------------------------------------------------------------------------
do_hpositions_l
	jsr	do_hpositions
	rtl
do_hpositions
	ai16
	lda	dohofs
	and	#$ff
	bne	.ok
	rts
.ok	ldx	hposjmp
	jmp	(.jmp,x)
.jmp	dw	rotplanet&WM
	dw	tunnelgrad&WM
	dw	tunnelgrad&WM
	dw	waterhofs&WM
	dw	tunnelgrad&WM
	dw	nograd&WM
	dw	bhole&WM
	dw	bholescaledown&WM

	longa
bhole	lda	viewposx
	sta.l	m_viewposx
	a8
	lda	#mbhole>>16
	ldx	#mbhole&WM
	jsl	runmario_l
	rts

	longa
bholescaledown
;	lda.l	bholescaleval
;	cmp	#512
;	beq	.sk
;	inc	a
;	sta.l	bholescaleval
;.sk	sta.l	m_y1
;	lda	viewposx
;	sta.l	m_viewposx
;	a8
;	lda	#mbholescaledown>>16
;	ldx	#mbholescaledown&WM
;	jsl	runmario_l
;	rts

	longa
nograd	lda	viewposx
	sta.l	m_viewposx
	a8
	lda	#mnograd>>16
	ldx	#mnograd&WM
	jsl	runmario_l
	rts

	longa
waterhofs	lda	viewposx
	sta.l	m_viewposx
	a8
	lda	#mwibbletunnel>>16
	ldx	#mwibbletunnel&WM
	jsl	runmario_l
	rts

	longa
rotplanet	lda	plrotz
	sta.l	m_viewposx
	ldx	playpt
	lda	al_worldx,x
	sta.l	m_y1
	a8
	lda	#mrotplanet>>16
	ldx	#mrotplanet&WM
	jsl	runmario_l
	rts

	longa
tunnelgrad	lda	viewposx
	sta.l	m_viewposx
	a8
	lda	#mtunnelgrad>>16
	ldx	#mtunnelgrad&WM
	jsl	runmario_l
	rts



;------------------------------------------------------------------------------
	ifeq	1
dmahpos_l	jsr	dmahpos
	rtl
dmahpos	ai8
.vw	lda	slhvr		;wait for screen off
	ldx	ophctr
	lda	ophctr
	and	#1
	bne	.vw
	cpx	#90
	bcc	.vw
	cpx	#100
	bcs	.vw

	i16
	disable
	ldx	hdmabg2hofs2
	stx	wmaddl
	stz	wmaddh
	lda	#wmdata&$ff
	sta	ch0addrb
	ldx	#(bg_scrollbuffer)&WM
	stx	ch0addra1tl
	lda	#(bg_scrollbuffer)>>16
	sta	ch0atbank
	ldx	#224*3
	stx	ch0dataddrl
	stz	ch0params
	lda	#1
	sta	mdmaen
	enable
	rts
	endc


;------------------------------------------------------------------------------
calcmeters	a8i16
	ldx	pcboxobj_b
	lda	al_HP,x
	bpl	.ok
	lda	#0
.ok	sta.l	m_damage

boost	lda.l	m_boostcnt
	beq	.end
	lda.l	m_boostanim
	dec	a
	dec	a
	bpl	.ok
	lda	#0
	sta.l	m_boostcnt
.ok	sta.l	m_boostanim
	bra	.draw
.end	lda.l	m_boostanim
	cmp	#40
	beq	.draw
	lda.l	m_boostanim
	inc	a
	sta.l	m_boostanim
	and	#15
	beq	.draw
.draw
	rts



;------------------------------------------------------------------------------
init_wipe	macro
\1_circle	equ	*-circletab
	db	ct_init_wipe
	dw	\1&0ffffh
	endm

do_wipe	macro
	db	ct_wipe_do
	endm

circlegoto	macro
	db	ct_circle_goto
	dw	\1-circletab
	endm

wipeend	macro
	db	ct_wipe_end
	endm

ct_circle_init		equ	0
ct_circle_rad		equ	2
ct_circle_blue		equ	4
ct_circle_green	equ	6
ct_circle_red		equ	8
ct_circle_endifblue	equ	10
ct_circle_endifgreen	equ	12
ct_circle_endifred	equ	14
ct_circle_endifradius	equ	16
ct_circle_end		equ	18
ct_circle_loop		equ	20
ct_set_blue		equ	22
ct_set_green		equ	24
ct_set_red		equ	26
ct_circle_exit		equ	28
ct_set_rad		equ	30
ct_set_affect		equ	32
ct_init_wipe		equ	34
ct_wipe_do		equ	36
ct_circle_goto		equ	38
ct_wipe_end		equ	40

do_circle_explosion_l
	jsr	do_circle_explosion
	rtl


do_circle_explosion
	a8
	stz	doawipe
	ai16
	ldx	circleanim
	bne	circle_com
	a8
	dealloc_window	circle
	stz	doingwipe
	rts
circle_com	a16
	lda.l	circletab,x
	and	#$ff
	txy
	tax
	jmp	(circlejmp,x)
circlejmp	dw	circle_init&WM
	dw	circle_rad&WM
	dw	circle_blue&WM
	dw	circle_green&WM
	dw	circle_red&WM
	dw	circle_endifblue&WM
	dw	circle_endifgreen&WM
	dw	circle_endifred&WM
	dw	circle_endifradius&WM
	dw	circle_end&WM
	dw	circle_loop&WM
	dw	set_blue&WM
	dw	set_green&WM
	dw	set_red&WM
	dw	circle_exit&WM
	dw	set_rad&WM
	dw	set_affect&WM
	dw	wipe_init&WM
	dw	wipe_do&WM
	dw	circle_goto&WM
	dw	wipeend_do&WM

	longa
	longi
circle_goto	tyx
	lda.l	circletab+1,x
	sta	circleanim
	tax
	jmp	circle_com

	longa
	longi
circle_init	tyx
	stz	circlerad
	stz	circledestrad
	a8
	stz	circleblue
	stz	circlesrcblue
	stz	circlered
	stz	circlesrcred
	stz	circlegreen
	stz	circlesrcgreen
	lda	#1+2+4+32
	sta	circleaff
	inx
	stx	circleanim
	jmp	circle_com

	longa
	longi
circle_rad	tyx
	lda.l	circletab+1,x
	sta	circledestrad
	lda.l	circletab+3,x
	sta	circlespeed
	lda.l	circletab+5,x
	sta	circlespeedadd
	inx
	inx
	inx
	inx
	inx
	inx
	inx
	jmp	circle_com

	longa
	longi
circle_blue	tyx
	a8
	lda.l	circletab+1,x
	sta	circleblue
	lda.l	circletab+2,x
	sta	circleblueframe
	sta	circleblueframesrc
	lda.l	circletab+3,x
	sta	circlebluespeed
	inx
	inx
	inx
	inx
	jmp	circle_com
	longa
	longi
circle_green
	tyx
	a8
	lda.l	circletab+1,x
	sta	circlegreen
	lda.l	circletab+2,x
	sta	circlegreenframe
	sta	circlegreenframesrc
	lda.l	circletab+3,x
	sta	circlegreenspeed
	inx
	inx
	inx
	inx
	jmp	circle_com
	longa
	longi
circle_red	tyx
	a8
	lda.l	circletab+1,x
	sta	circlered
	lda.l	circletab+2,x
	sta	circleredframe
;;;	sta	circleredframesr
	lda.l	circletab+3,x
	sta	circleredspeed
	inx
	inx
	inx
	inx
	jmp	circle_com
	longa
	longi
circle_endifblue
	tyx
	a8
	lda.l	circletab+1,x
	cmp	circlesrcblue
	lbne	circlecomend
	inx
	inx
	stx	circleanim
	jmp	circle_com
	longa
	longi
circle_endifgreen
	tyx
	a8
	lda.l	circletab+1,x
	cmp	circlesrcgreen
	lbne	circlecomend
	inx
	inx
	stx	circleanim
	jmp	circle_com
	longa
	longi
circle_endifred
	tyx
	a8
	lda.l	circletab+1,x
	cmp	circlesrcred
	lbne	circlecomend
	inx
	inx
	stx	circleanim
	jmp	circle_com
	longa
	longi
circle_endifradius
	tyx
	lda.l	circletab+1,x
	cmp	circlerad
	lbne	circlecomend
	inx
	inx
	inx
	stx	circleanim
	jmp	circle_com

	longa
	longi
circle_end	stz	circleobj
	stz	circleanim
	stz	circlerad
	jmp	circlecomend
	longa
	longi
circle_loop	tyx
	inx
	stx	circleanim
	jmp	circlecomend

	longa
	longi
set_blue	tyx
	a8
	lda.l	circletab+1,x
	sta	circlesrcblue
	inx
	inx
	jmp	circle_com
	longa
	longi
set_green	tyx
	a8
	lda.l	circletab+1,x
	sta	circlesrcgreen
	inx
	inx
	jmp	circle_com
	longa
	longi
set_red	tyx
	a8
	lda.l	circletab+1,x
	sta	circlesrcred
	inx
	inx
	jmp	circle_com

	longa
	longi
circle_exit	tyx
	inx
	stx	circleanim
	jmp	circlecomend

	longa
	longi
set_rad	tyx
	lda.l	circletab+1,x
	sta	circlerad
	inx
	inx
	inx
	jmp	circle_com

	longa
	longi
set_affect	tyx
	a8
	lda.l	circletab+1,x
	sta	circleaff
	inx
	inx
	jmp	circle_com

circlecomend
	a16
	lda	circlerad
	cmp	circledestrad
	beq	.donerad
	bcc	.addrad
	sec
	sbc	circlespeed
	cmp	circledestrad
	bcs	.donerad
	lda	circledestrad
	bra	.donerad
.addrad	clc
	adc	circlespeed
	cmp	circledestrad
	bcc	.donerad
	lda	circledestrad
.donerad	cmp	#0
	bne	.radok5
	lda	#1
.radok5	sta	circlerad
	sta.l	m_rotx

	lda	circlespeed
	beq	.radok
	clc
	adc	circlespeedadd
	sta	circlespeed
.radok

	a8
	lda	circleblueframe
	dec	a
	sta	circleblueframe
	bne	.blueskip
	lda	circleblueframesrc
	sta	circleblueframe
	lda	circlesrcblue
	cmp	circleblue
	beq	.blueok
	bcc	.blueadd
	sec
	sbc	circlebluespeed
	bpl	.bluepos
	lda	#0
.bluepos	cmp	circleblue
	bcs	.blueok
	lda	circlesrcblue
	bra	.blueok
.blueadd	clc
	adc	circlebluespeed
	cmp	circleblue
	bcc	.blueok
	lda	circlesrcblue
.blueok	sta	circlesrcblue
.blueskip
	lda	circlegreenframe
	dec	a
	sta	circlegreenframe
	bne	.greenskip
	lda	circlegreenframesrc
	sta	circlegreenframe
	lda	circlesrcgreen
	cmp	circlegreen
	beq	.greenok
	bcc	.greenadd
	sec
	sbc	circlegreenspeed
	bpl	.greenpos
	lda	#0
.greenpos	cmp	circlegreen
	bcs	.greenok
	lda	circlesrcgreen
	bra	.greenok
.greenadd	clc
	adc	circlegreenspeed
	cmp	circlegreen
	bcc	.greenok
	lda	circlesrcgreen
.greenok	sta	circlesrcgreen
.greenskip
	lda	circleredframe
	dec	a
	sta	circleredframe
	bne	.redskip
	lda	circleredframesrc
	sta	circleredframe
	lda	circlesrcred
	cmp	circlered
	beq	.redok
	bcc	.redadd
	sec
	sbc	circleredspeed
	bpl	.redpos
	lda	#0
.redpos	cmp	circlered
	bcs	.redok
	lda	circlesrcred
	bra	.redok
.redadd	clc
	adc	circleredspeed
	cmp	circlered
	bcc	.redok
	lda	circlesrcred
.redok	sta	circlesrcred
.redskip



	a16
	ldx	circleobj		; get the centre of the screen
	beq	.default
	lda	#0		; LEAVE THIS FOR MERGE (giles)
;;;;;;;;jsl	rotproj_l
	lda	xs
	clc
	adc	#((32-gameNum_col)/2)*8	; centre of real screen
	sta	xs		; store it back for later use
	sta.l	m_bigx
	lda	ys
	clc
	adc	#gameStRow*8	; centre of real screen
	sta.l	m_bigy
	bra	.continue
.default	lda	#128
	sta.l	m_bigx
	sta	xs
	lda	#112
	sta.l	m_bigy
.continue

	a8
;	alloc_window circle		;allocate a window
;	stz	wm_coldata,x
;	lda	circlesrcblue
;	sta	wm_coldata_b,x
;	lda	circlesrcgreen
;	sta	wm_coldata_g,x
;	lda	circlesrcred
;	sta	wm_coldata_r,x
;	lda	#%00010000
;	sta	wm_cgswsel,x
;	lda	circleaff
;	sta	wm_cgadsub,x
;	stz	wm_ts,x
;
;	lda	#mcalc_circle>>16
;	ldx	#mcalc_circle&WM
;	jsl	runmario_l
;
;
copywh0wh1	a8
;	phb
;	lda	#$7e
;	pha
;	plb
;
;	ldx	#191*2
;	ldy	#191*3+3
;	lda	whichcircle
;	beq	.lp2
;.lp	lda.l	m_circlebuf,x
;	sta.w	xhdma_wh0wh1_1+2,y
;	lda.l	m_circlebuf2,x
;	sta.w	xhdma_wh0wh1_1+1,y
;	dey
 ;	dey
;	dey
;	dex
;	dex
;	bpl	.lp
;	plb
;	rts
;.lp2	lda.l	m_circlebuf,x
;	sta.w	xhdma_wh0wh1_2+2,y
;	lda.l	m_circlebuf2,x
;	sta.w	xhdma_wh0wh1_2+1,y
;	dey
;	dey
;	dey
;	dex
;	dex
;	bpl	.lp2
	plb
	rts




circletab
	db	0
	initcircle	fillscreen		;FILLSCREEN
	radiusto	200,4
	blueto		31,3
	greento		31,3
	redto		31,3
	setblue		14
	setgreen	14
	setred		14
	circleloop		
	circleendif	radius,200
	blueto		0,1,2
	greento		0,1,2
	radiusto	500,4
	circleloop
	circleendif	blue,0
	redto		0,1,2
	circleloop
	circleendif	red,0
	circleend

	initcircle	smartbomb		;SMART BOMB
	setrad		297
	setblue		28
	setgreen	28
	setred		28
	circleexit
	setrad		0

	radiusto	9,9
	blueto		31,7
	greento		31,15
	redto		31,3
	setblue		28
	setgreen	28
	setred		28
	circleexit
	radiusto	135,9
	redto		0,1,2
	circleloop
	circleendif	radius,135
	radiusto	297,9
	blueto		0,1
	greento		0,1
	circleloop
	circleendif	green,0
	circleend

	initcircle	whitefillscreen		;WHITE FILL SCREEN
	radiusto	197,18,-1
	blueto		31,1
	greento		31,1
	redto		31,1
	setblue		14
	setgreen	14
	setred		14
	circleloop
	circleendif	radius,171
	blueto		0,1
	greento		0,1
	circleloop
	circleendif	blue,0
	radiusto	10,4
	redto		0,1
	circleloop
	circleendif	radius,0
	circleend

	initcircle	redfillscreen		;RED FILL SCREEN
	radiusto	197,18,-1
	redto		31,1
	setred		14
	circleloop
	circleendif	radius,300
	circleend

	initcircle	laststage		;FILLSCREEN
	circle_aff	2+32
	radiusto	200,4
	blueto	31,3
	greento	31,3
	redto	31,3
	setblue	14
	setgreen	14
	setred	14
	circleloop
	circleendif	radius,200
	blueto	0,1,2
	greento	0,1,2
	circleloop
	circleendif	blue,0
	redto	0,1,2
	circleloop
	circleendif	red,0
	circleend

	init_wipe	mroundwipefill
	do_wipe
.lp	init_wipe	mwipefill
	do_wipe
	circlegoto	.lp
	wipeend

	init_wipe	mscramwipe
	do_wipe
	wipeend

	init_wipe	mroundwipeclear
	do_wipe
	wipeend

	init_wipe	mstarwipe
	do_wipe
	wipeend



wipe_init	tyx
	a16
	lda.l	circletab+1,x
	sta	wintabptr
	inx
	inx
	inx
	stx	circleanim
wipe_do	a8
	inc	doawipe
	rts

	longa
	longi
wipeend_do	stz	circleanim
	a8
	dealloc_window wipe
	rts


;------------------------------------------------------------
setpos	macro
	a16
	lda	#(\1&wm)
	sta.l	messageh
	lda	#(\2&wm)
	sta.l	messagev
	lda	#(\3&wm)
	sta.l	messageaddress
	endm

;------------------------------------------------------------

rtest6 	equ	70f849h
rtest7	equ	70fce1h
rtest8	equ	70ff28h

clock1	equ	70f820h
clock2	equ	70f943h
clock3	equ	70faeeh
clock4	equ	70fd0ch
clock5	equ	70fc3bh
clock6	equ	70fe11h
clock7	equ	70ff94h
clock8	equ	70fccch


staval	macro
	lda	#$\2
	sta.l	\1
	endm
	

	      
backup_check
	php
	a16
	lda.l	cont0l
	bmi	.setBbutton
	bit	#0000000010000000b
	bne	.setAbutton
	jmp	.debugtimer
.setAbutton
	staval	rtest1,abbd	
	staval	rtest2,0125	
	staval	rtest3,dc05	
	staval	rtest4,0010	
	staval	rtest5,824c	
	staval	rtest6,5565	
	staval	rtest7,7b05	
	staval	rtest8,21c9	
	bra	.debugtimer	

.setBbutton
	staval	rtest1,001f	
	staval	rtest2,d1e3	
	staval	rtest3,0f0a	
	staval	rtest4,21f4	
	staval	rtest5,25e0	
	staval	rtest6,c0f5	
	staval	rtest7,99a1	
	staval	rtest8,f43e	
	bra	.debugtimer	


.debugtimer
	a8
	lda	cont0l+01h
	bit	#01000000b
	beq	.notclear
	lda	#00h
	sta.l	clock1
	sta.l	clock2
	sta.l	clock3
	sta.l	clock4
	sta.l	clock5
	sta.l	clock6
	sta.l	clock7
	sta.l	clock8
.notclear
	lda.l	debug_count
	bne	.countmoving
	jmp	.notstartcount
.countmoving
	lda.l	cont0l+01h
	bit	#00100000b
	beq	.contcount
	lda	#00
	sta.l	debug_count
	jmp	.dispRAMS
.contcount	
	a8
	lda.l	clock1
	clc
	adc	#01h
	sta.l	clock1
	lda.l	clock2
	adc	#00h
	sta.l	clock2
	lda.l	clock3
	adc	#00h
	sta.l	clock3
	lda.l	clock4
	adc	#00h
	sta.l	clock4
	lda.l	clock5
	adc	#00h
	sta.l	clock5
	lda.l	clock6
	adc	#00h
	sta.l	clock6
	lda.l	clock7
	adc	#00h
	sta.l	clock7
	lda.l	clock8
	adc	#00h
	sta.l	clock8

	bra	.dispRAMS
.notstartcount
	a8
	lda.l	cont0l+01h
	
	bit	#00010000b
	beq	.dispRAMS
	lda	#0ffh
	sta.l	debug_count
.dispRAMS
	ai16

	setpos		00h,00h,rtest1
	executemario	dispramw
	setpos		00h,10h,rtest2
	executemario	dispramw
	setpos		00h,20h,rtest3
	executemario	dispramw
	setpos		00h,30h,rtest4
	executemario	dispramw
	setpos		00h,40h,rtest5
	executemario	dispramw
	setpos		00h,50h,rtest6
	executemario	dispramw
	setpos		00h,60h,rtest7
	executemario	dispramw
	setpos		00h,70h,rtest8
	executemario	dispramw

	setpos		068h,00h,clock1
	executemario	dispramb
	setpos		068h,10h,clock2
	executemario	dispramb
	setpos		068h,20h,clock3
	executemario	dispramb
	setpos		068h,30h,clock4
	executemario	dispramb
	setpos		068h,40h,clock5
	executemario	dispramb
	setpos		068h,50h,clock6
	executemario	dispramb
	setpos		068h,60h,clock7
	executemario	dispramb
	setpos		068h,70h,clock8
	executemario	dispramb

	


	plp
	rtl



















