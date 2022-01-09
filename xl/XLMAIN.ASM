;--------------------------------------------------------------------
;
;	Main Program for XL
;
;				programed by Masato Kimura
;
;				04/02/1993
;--------------------------------------------------------------------
;
;
	incpublics	xlmain.ext


safeinidisptop	equ	1

initialise_l

	php
	a8

	lda	#40
	sta	fox			; hack to allow check for fox's hp
	sta	frog
	sta	bunny
	sta	cock
	sta	pepper
	sta	andorf

	jsl	playerstart_init_l
;	jsl	initplanets_l

	ai16
	stz	boss_ptr
	stz	specptr
	stz	specialobjtotal

	lda	#allcolscru&WM		;uncrunch colours and copy up
	sta.l	m_enddata
	lda	#$1000
	sta.l	m_decaddr
	lda	#0
	sta.l	m_decoffset
	a8
	lda	#allcolscru>>16
	sta.l	m_enddatabnk
	lda	#mdecrunch>>16
	ldx	#mdecrunch&WM
;	jsl	runmario_l

	a16
	ldx	#0
.lp	lda.l	$701000,x
	sta.l	gamepalettes,x
	inx
	inx
	cpx	#8192
	bne	.lp

	plp
	rtl

initgame_l

	php
	phb
 	a8
  	lda	#0
   	pha
   	plb

	disable

	a8
	stz	hdmaen
	lda	#$80
	setinidisp1
	sta	inidisp
	stz	fadedir
	stz	fade

	waitdma	110
	waitdma	100	; turn off screen and wait for sync


	ai16
	stz	levelfinished
	stz	circleanim
	stz	mapcnt
	stz	lastplayz
	stz	lastzchange
	stz	viewposz	; reset map position
	lda	#1
	sta.l	m_meters
	stz	levelfinished
	stz	cont0l
	stz	sdgpt3
	stz	sdspt3
	stz	sdpck3

	a8
	lda	#1
	sta	sheildon
	stz	showtype
	stz	msg_count1
	stz	msg_count2
	stz	restartcol
	stz	onecredspr
	stz	doneacircle
	stz	windowmode
	stz	nosetport3
	stz	pausesnd
	stz	sdpck3
	stz	prttraining

	jsl	kill_list_l	; format alien list


	jsl	makeplayer1_l
;	jsl	makeplayer2_l
	jsl	initgame3d_l


	jsl	find_window_pri_l
  	jsl	Initial_game		;initialize game 
	plb
 	plp
  	cli


	rtl

initgame3d_l
	php
	a16
	lda	#$1234
	sta.l	m_particlerand	
	lda	#1
	sta.l	m_clrbitmaps
;
	a8
	lda	#deg180
	sta	roty
	lda	#-1
	sta	mariocode
	stz	trans_flag
	ai8
	jsr	gameclipwindow


	jml	init3d1






;--------------------------------------------------------------------
dopause	php
	a8i16
	lda	doingwipe
	bne	.nop
	lda	stayblack
	cmp	#-1
	bne	.nop
	lda	#se_pauseon
	sta	pausesnd
	jsl	transfer_l		;transfer bitmap, do strats etc.
	jsl	transfer_l		;transfer bitmap, do strats etc.
	a8
.wait	waitdma	100
	lda	joy1h
	bit	#key_start
	bne	.wait
.wait2	waitdma	100
	lda	joy1h
	bit	#key_start
	beq	.wait2
.wait3	waitdma	100
	lda	joy1h
	bit	#key_start
	bne	.wait3
	stz	cont0
	stz	contl0
	stz	cont0l
	stz	contl0l
	lda	#se_pauseoff
	sta	pausesnd
.nop	plp
	rts


halfbg23	php
	a8i16
	phx

	alloc_window	halffade
	stz	wm_ts,x
	lda	#2
	sta	wm_cgswsel,x
	lda	#%11100110
	sta	wm_cgadsub,x
	lda	#%11100000
	ora	wm_val,x
	sta	wm_coldata,x
	lda	wm_val,x
	cmp	#15
	beq	.nc
	inc	a
	sta	wm_val,x
.nc	plx
	plp
	rts

fadehalf2norm	php
	a8i16
	phx
	alloc_window	halffade
	stz	wm_ts,x
	lda	#2
	sta	wm_cgswsel,x
	lda	#%11100110
	sta	wm_cgadsub,x

	lda	#%11100000
	ora	wm_val,x
	sta	wm_coldata,x

	lda	wm_val,x
	beq	.done
	dec	a
	sta	wm_val,x
	plx
	plp
	rts
.done	
	dealloc_window	halffade
	plx
	plp
	rts

setbg23toblack
	php
	a8i16
	phx
	alloc_window	halffade
	stz	wm_ts,x
	lda	#2
	sta	wm_cgswsel,x
	lda	#%11100110
	sta	wm_cgadsub,x

	lda	#%11111111
	sta	wm_coldata,x

	lda	#31
	sta	wm_val,x
	plx
	plp
	rts


dogameframe	php
	a8i16
.wait	lda	trans_flag
	bne	.wait
	lda	#2		;start screen transferring
	sta	trans_flag
	stz	framec
.twait	lda	transbmp1
	beq	.twait

	jsl	clronehalf_l
.twait2	lda	transbmp1
	cmp	#2
	bne	.twait2

	stz	transbmp1
	jsl	find_window_pri_l

;	jsl	dmahpos_l

	ai16
	lda	dotsflag
	sta.l	m_dotsorstars
	beq	.skip
	jsl	mshowgrid_l
.skip	jsl	showview_l
	jsl	do_3d_display_l
	plp
	rts



*****************************************************************************
*****************************************************************************
*****************************************************************************
*****************************************************************************



initscreen_l
	ai8

	disable

	stz	nmitimen
	stz	trans_flag
	stz	fade

	lda	timeupr		;clear IRQ's
	a16
	lda.l	mflags


;Set Mario Chip for 16 colours 192 pixel high
	lda	#gamemdm
	sta	mario_draw_mode

;clear video RAM
	screen_off

	stz	cgadd
	stz	vmaddl
	stz	vmaddh
	lda	#$80
	sta	inidisp
	sta	vmainc

;Clear VRAM
	lda	#$00
	ldx	#127
.ly	ldy	#0
.li	sta	vmdatal
	sta	vmdatah
	dey
	bne	.li
	dex
	bne	.ly


;Set screen to blank chars
	ai16
	lda	#vsc_base1
	sta	vmaddl
	lda	#gamenum_col*gamenum_row+1
	ldx	#1024
.cl	sta	vmdatal
	dex
	bne	.cl

;Set character map 22 wide by 20 high
	a8i16
	jsl	setcharmapgame_l

;Set double buffering (VRAM only)
	i16
	ldx	#vchr_base1
	stx	vmap1
	ldx	#vchr_base2
	stx	vmap2
	ldx	#bitmap1
	stx	drawmap
	ldx	#bitmap1
	stx	showmap
	lda	drawmap+1		;set mario draw base
	lsr	a
	lsr	a
	sta	mscrbase

;Set hardware pointers to screen
	lda	vmap1+1
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	ora	#(vchr_physback>>12)<<4
	sta	bg12nba

	lda	#3
	sta	objsel

;Set bg screen base address'
	lda	#vsc_base1>>8
	sta	bg1sc
	lda	#vsc_base2>>8+3
	sta	bg2sc
	lda	#2
	sta	bgmode

	jsl	calcbg2voffsets_l
	jsl	dmabg2voffsets_l

	a8i16
	lda	#1
	jsl	setpal_l
;;kesu	jsl	init_sprites_l
	dmacgram	0,128,spritepal,256

;Set window logic, position, size.
	stz	w12sel
	stz	w34sel		;wh0,1 set with hdma
	lda	#%00100000
	sta	wobjsel
	stz	wbglog
	lda	#%1100
	sta	wobjlog
	stz	tmw
	stz	tsw
	stz	wh0
	stz	wh1

	lda	#1+2+4+16
	sta	tm
	lda	#7
	sta	ts

;Setup HDMA tables
;	a16
;	ldx	#0
;.loop	lda.l	hdma_start,x
;	sta.l	xhdma_start,x
;	inx
;	inx
;	cpx	#hdma_end-hdma_start
;	bcc	.loop

	jsl	setnoclash_l

	a8
	lda	#0		;inidisp
	sta	ch1params
	lda	#inidisp&$ff
	sta	ch1addrb
	ldx	#xhdma_inidisp&WM
	stx	ch1addra1tl
	lda	#xhdma_inidisp>>16
	sta	ch1atbank
	stz	ch1databank

	lda	#%010		;bg2hofs
	sta	ch2params
	lda	#bg2hofs&$ff
	sta	ch2addrb
	ldx	#xhdma_bg2hofs1&WM
	stx	ch2addra1tl
	lda	#xhdma_bg2hofs1>>16
	sta	ch2atbank
	stz	ch2databank

	lda	#1		;wh0
	sta	ch3params
	lda	#wh0&$ff
	sta	ch3addrb
	ldx	#xhdma_wh0wh1_1&WM
	stx	ch3addra1tl
	lda	#xhdma_wh0wh1_1>>16
	sta	ch3atbank
	stz	ch3databank

	lda	#%010		;bg2vofs
	sta	ch4params
	lda	#bg2vofs&$ff
	sta	ch4addrb
	ldx	#xhdma_bg2vofs&WM
	stx	ch4addra1tl
	lda	#xhdma_bg2vofs>>16
	sta	ch4atbank
	stz	ch4databank

	lda	#%11110
	sta	hdmaen_gc

	ldx	#xhdma_bg2hofs1&WM
	stx	hdmabg2hofs1
	ldx	#xhdma_bg2hofs2&WM
	stx	hdmabg2hofs2

	ldx	#xhdma_wh0wh1_1&WM
	stx	hdmacirclebuf1
	ldx	#xhdma_wh0wh1_2&WM
	stx	hdmacirclebuf2
	stz	whichcircle

	jsl	clearhvofs_l

;Enable key pad reading + hdma tables (includes inidisp)
	a8
	ldx	#gamevw_pos
	stx	vtimel
	ldx	#0
	stx	htimel

	lda	#$80
	setinidisp1
	sta	inidisp
	stz	fade

	lda	#%10	; just inidisp
	sta	hdmaen

	waitdma	190		;wait for HDMA to init.(inidisp)
	waitdma	100		;wait for HDMA to init.(inidisp)


	lda	rdnmir

	lda	#%00110001
	sta	nmitimen

	lda	#255
	sta	crosshairon

	enable
	rtl



setcharmapfrommap_l
	php
	disable
	jsl	setcharmapgame_l
	enable
	plp
	rtl

SetCharMapgame_l
	a8
	phb
	lda	#0
	pha
	plb
	lda	#128
	sta	vmainc
	ai16
	lda	#vsc_base1+32*gameStRow		;128
	sta	vmaddl
	lda	#1024*pal3d
	ldy	#0
.lolv
	pha
	lda	#gamenum_col*gamenum_row+(6<<10)+(1<<13)
	rept	(32-gamenum_col)/2		;clear out borders
	sta	vmdatal
	endr
	pla

	ldx	#0
.lolh	sta	vmdatal
	clc
	adc	#gamenum_row
	inx
	cpx	#gamenum_col
	bne	.lolh

	pha
	lda	#gamenum_col*gamenum_row+(6<<10)+(1<<13)
	rept	(32-gamenum_col)/2
	sta	vmdatal
	endr
	pla

	sec
	sbc	#gamenum_col*gamenum_row-1
	iny
	cpy	#gamenum_row
	bne	.lolv

	lda.l	m_meters
	and	#255
	beq	.nometers

	lda	#vsc_base1+24*32+3	;damage
	sta	vmaddl
	lda	#46+(2<<10)+(1<<13)
	sta	vmdatal
	lda	#vsc_base1+24*32+4
	sta	vmaddl
	lda	#70+(2<<10)+(1<<13)
	sta	vmdatal
	lda	#vsc_base1+24*32+5
	sta	vmaddl
	lda	#94+(2<<10)+(1<<13)
	sta	vmdatal
	lda	#vsc_base1+24*32+6	;******************
	sta	vmaddl
	lda	#118+(2<<10)+(1<<13)
	sta	vmdatal
	lda	#vsc_base1+24*32+7
	sta	vmaddl
	lda	#142+(2<<10)+(1<<13)
	sta	vmdatal

	lda	#vsc_base1+24*32+22+2	;boost
	sta	vmaddl
	lda	#550+(2<<10)+(1<<13)
	sta	vmdatal
	lda	#vsc_base1+24*32+23+2
	sta	vmaddl
	lda	#574+(2<<10)+(1<<13)
	sta	vmdatal
	lda	#vsc_base1+24*32+24+2
	sta	vmaddl
	lda	#598+(2<<10)+(1<<13)
	sta	vmdatal
	lda	#vsc_base1+24*32+25+2
	sta	vmaddl
	lda	#622+(2<<10)+(1<<13)
	sta	vmdatal
	lda	#vsc_base1+24*32+26+2
	sta	vmaddl
	lda	#646+(2<<10)+(1<<13)
	sta	vmdatal

.nometers

	ldx	#((gamenum_col*gamenum_row)*16)+vchr_base1
	stx	vmaddl
	ldx	#-1
	ldy	#16
.lp	stx	vmdatal
	dey
	bne	.lp

	ldx	#((gamenum_col*gamenum_row)*16)+vchr_base2
	stx	vmaddl
	ldx	#-1
	ldy	#16
.lp2	stx	vmdatal
	dey
	bne	.lp2
	plb
	a8
	rtl

	shorta
	shorti
gameclipwindow_l
	jsr gameclipwindow
	rtl
gameclipwindow
	movi 0,clx1
	movi (gamenum_col)*8-1,clx2
	movi 0,cly1
	movi (gamenum_row)*8-1,cly2
	movi (gamenum_col)*4,vanishx
	movi (gamenum_row)*4,vanishy
	rts

clearhvofs_l
	php
	a8
	stz	bg1hofs
	stz	bg1hofs
	stz	bg1vofs
	stz	bg1vofs

	stz	bg2hofs
	stz	bg2hofs
	stz	bg2vofs
	stz	bg2vofs

	stz	bg3hofs
	stz	bg3hofs
	stz	bg3vofs
	stz	bg3vofs

	stz	bg4hofs
	stz	bg4hofs
	stz	bg4vofs
	stz	bg4vofs
	plp
	rtl



setpal_l	php
	ai16
	and #$ff
	xba
	lsr a
	lsr a
	lsr a
	tax

	a8
	lda	#16*pal3d
	sta	cgadd
	ldy	#0
.loop	lda.l	paladdr,x
	sta	cgdata
	lda.l	paladdr+1,x
	sta	cgdata
	inx
	inx
	iny
	iny
	cpy	#32
	bne	.loop
	plp
	rtl

setgamepal_l	php
	phb
	ai16
	and #$ff
	xba
	lsr a
	lsr a
	lsr a
	tax

	disable
	a8
	lda	#$7e
	pha
	plb		; so we can access ram without .L

	ldy	#0
	a16
.loop	lda.l	paladdr,x
	sta.w	gamepalbuff&WM,y
	sta.w	pal0palette+7*32,y
	inx
	inx
	iny
	iny
	cpy	#32
	bne	.loop
	enable
	plb
	plp
	rtl




kill_list_l	php
	
	a8
	phb
	lda	#$7e
	pha
	plb

	ai16
	stz	alxlst	;clear XAlien list
	FmtFreeLst	alxfreelst,alxblks,number_al,alx_size

	a8
	plb	


	plp
	rtl



showview_l
	php
	jsr	marioshowview
	a8i16
	call_mario	mallrotzsort
	plp
	rtl

;***************************************************************
alienflags_l
	php
	phb
	a8
	lda	#$7e
	pha
	plb

	i16
	ldx	#m_drawlist&WM
	ldy	alxlst
.next
	a16
	
	a8
	test_alsflag		y,invisible
	bne			.nextal
	test_alflag		y,inrngpl
	beq			.chkkill

;	a16
;	lda.w	al_shape,y
;	stx	tpa
;	tax
;	lda.l	sh_zmax,x
;	ldx	tpa
;	adc.l	dl_z,x
;	bpl	.dontkill

	bra	.dontkill

.chkkill
; kill the alien if its z is behind the view
	a8
; set view flags
	s_test_var	B,gameflags,#gf_nozremove
	bne	.dontkill	

	lda.w	al_type,y
	and	#atzremove
	beq	.dontkill
	
	a8
	lda.w	al_whocanseeme,y
	dec	a
	sta.w	al_whocanseeme,y
	bne	.dontkill

	phx
	tyx
	ldy	al_next,x
	jsl	removedeadal_l
	plx
	a16
;	pla
;	clc
;	adc	#dl_sizeof
;	tax
	tya
	bra	.killed


.dontkill
	a16
	lda.l	dl_x,x
	bpl	.right
.left	lda.w	al_flags,y
	ora	#afinviewpl+afleftpl
	sta.w	al_flags,y
	bra	.cont
.right	lda.w	al_flags,y
	ora	#afinviewpl
	sta.w	al_flags,y
.cont
	a16
	txa
	clc
	adc	#dl_sizeof
	tax

.nextal	a16
	lda.w	al_next,y
.killed
	tay
	lbne	.next

	plb
	plp
	rtl


;***************************************************************
marioshowview
	php
	phb
	a8
	lda	#$7e
	pha
	plb

	ai16
	stz	numshapes
	lda	shadowheight
	sta.l	m_shadowheight
	lda	viewposy
	sta.l	m_viewposy

	ldx	#m_Drawlist&WM
	ldy	alxlst
.next	
	a8
	sty	al1pt



; clear view flags
	lda.w	al_flags,y
	and	#~(affrontpl+afinviewpl+afleftpl+affrontpl)
	ora	#afinrngpl
	sta.w	al_flags,y

	lda.w	al_worldzh,y
	sec
	sbc	viewmapz
	bpl	.nn
	nega
.nn
	cmp	#2
	lbpl	.outrng


	s_jmp_alsflag	y,invisible,.nextal


	
; ground obj?
	lda.w	al_type,y
	bit	#atgnd
	a16
	beq	.notgndobj
	lda	#15000
	bra	.gndobj
.notgndobj	lda	#0
.gndobj	sta.l	dl_sortz,x

; copy x,y,z into the drawlist block
	lda.w	al_worldx,y
	sec
	sbc	viewposx
	sta.l	dl_x,x
	lda.w	al_worldy,y
	sec
	sbc	viewposy
	sta.l	dl_y,x

	lda.w	al_worldz,y
	sec
	sbc	viewposz
	sta.l	dl_z,x
	sta	z1

	lda.w	al_shape,y
	stx	tpa
	tax
	lda.l	sh_zmax,x
	ldx	tpa
	clc
	adc	z1

;	cmp	#-2000
	lbmi	.outrng
;	cmp	#15000
;	lbpl	.outrng

	lda.w	al_shape,y
	sta.l	dl_shape,x




	lda.w	al_rotx,y
	sta.l	dl_rotx,x
	lda.w	al_roty,y
	sta.l	dl_roty,x
	lda.w	al_rotz,y
	sta.l	dl_rotz,x

	

	a8
;	lda.w	al_flags,y
;	and	#afexp
;	beq	.noexp
;	lda.w	al_count,y
;	sta.l	dl_expcnt,x

;-----------------------------------------------
; put unique obj number in dl_shady if partobj.
	lda.w	al_sflags,y
	bit	#asf_partobj
	beq	.noexp		;exploded

	a16
	tya
	sta.l	dl_shady,x
	a8
	lda.w	al_sbyte1,y	; amount
	sta.l	dl_shadx,x
	lda.w	al_sbyte2,y	; life
	sta.l	dl_shadx+1,x
	lda.w	al_sbyte3,y	; type
	sta.l	dl_shadz,x


;-----------------------------------------------

	bra	.exploded
.noexp
	lda	#0
	sta.l	dl_expcnt,x

.exploded

	lda.w	al_sflags,y
	sta.l	dl_sflags,x

; mask out hitflash (only hitflashes for one frame)
	and	#~asf_hitflash
	sta.w	al_sflags,y

; copy the animation and colour animation frames over
	lda.w	al_animframe,y
	bmi	.standardframe
	lda	gameframe
.standardframe
	and	#127
	sta.l	dl_animframe,x

	lda.w	al_colframe,y
	bmi	.standardframe2
	lda	gameframe
.standardframe2
	and	#127
	sta.l	dl_colframe,x

; copy the depth offset in
	lda.w	al_depthoffset,y
	sta.l	dl_depth,x

; texture map coordinates
	lda.w	al_tx,y
	sta.l	dl_tscrollx,x
	lda.w	al_ty,y
	sta.l	dl_tscrolly,x

; check for debug mode (y = alientemp)
	a16
	cpy	alientemp
	bne	.normcoltab

	lda	gameframe
	and	#7
	cmp	#4
	bcc	.onecol
	lda	#white_C&WM
	bra	.connn
.onecol
	lda	#black_C&WM
	bra	.connn

.normcoltab
	lda.w	al_coltab,y
.connn
	sta.l	dl_coltab,x

; increment number of shapes
	inc	numshapes

; increment dl pointer
	txa
	clc
	adc	#dl_sizeof
	tax


.nextal
	a16
; next alien block (if any)
	lda.w	al_next,y
	tay
	lbne	.next
	lda	numshapes
	sta.l	m_numshapes

	plb
	plp


	rts



.outrng
; clr in view flag
	a8
	lda.w	al_flags,y
	and	#~afinrngpl
	sta.w	al_flags,y
	a16

	bra	.nextal



;---------------------------------------------------------------------------------------------------------
fadepalto_l	ai16
	ldy	palnum
	bne	.do
	rtl
.do
	ldx	palfade
	ldy	palnum

	lda.l	seapal,x
	sta.w	pal0palette+4*32,y

	dec	palfade
	dec	palfade
	dec	palnum
	dec	palnum
	rtl


palgoto_l	a8
	lda	pshipflags2
	and	#psf2_playerHP0
	beq	.set
	rtl
.set
	lda	fadepal
	bne	.fadeit
	rtl
.fadeit	dec	a
	sta	fadepal

	ai16
	ldx	palfrom
	ldy	palto
	lda	pallen
.lp
	pha
	lda.w	pal0palette,y
	and	#%111110000000000
	sta	tpa
	lda.l	mist2col,x
	and	#%111110000000000
	cmp	tpa
	beq	.skipb
	bcs	.incb
.decb	lda	tpa
	sec
	sbc	#%000010000000000
	bra	.skipb
.incb	lda	tpa
	clc
	adc	#%000010000000000
.skipb	sta	tpx

	lda.w	pal0palette,y
	and	#%1111100000
	sta	tpa
	lda.l	mist2col,x
	and	#%1111100000
	cmp	tpa
	beq	.skipg
	bcs	.incg
.decg	lda	tpa
	sec
	sbc	#%0000100000
	bra	.skipg
.incg	lda	tpa
	clc
	adc	#%0000100000
.skipg	sta	tpy

	lda.w	pal0palette,y
	and	#%11111
	sta	tpa
	lda.l	mist2col,x
	and	#%11111
	cmp	tpa
	beq	.skipr
	bcs	.incr
.decr	lda	tpa
	dec	a
	bra	.skipr
.incr	lda	tpa
	inc	a
.skipr	ora	tpx
	ora	tpy
	sta.w	pal0palette,y

	iny
	iny
	inx
	inx
	pla
	dec	a
	lbne	.lp
	rtl

fadered_l	php
	phy
	phx
	phb

	a8
	lda	#0
	pha
	plb

	
	ai16
	ldy	#0
	lda	#8*16
.lp
	pha
	lda.w	pal0palette,y
	and	#%111111111100000

	sta	tpx
	lda.w	pal0palette,y
	and	#%11111
	cmp	#3
	ja	.ok
	ora	#3
.ok
	asl	a
	cmp	#31
	bcc	.nsh
	lda	#31
.nsh	and	#%11111
	ora	tpx
	sta.w	pal0palette,y
	iny
	iny
	pla
	dec	a
	bne	.lp
.out
	lda	#0
	sta	pal0palette+6*32+30

	plb
	plx
	ply
	plp
	rtl

makeBG2black_l
	phx
	a8
	lda	#0
	ldx	#(7*32)-1
.clr	sta.w	pal0palette,x
	dex	
	bpl	.clr
	plx
    	rtl


seapal	dw $0000,$34c0,$38e0,$3d00,$4120,$4540,$4960,$4d80
	dw $51a0,$55c0,$59e0,$5e00,$6220,$6640,$6a60,$6e80
groundpal	dw $0000,$0088,$00c9,$04ea,$090b,$0d2c,$114d,$156e
	dw $198f,$1db0,$21d1,$25f2,$2a13,$2e34,$3255,$3676
mist2col	inccolfile	data\gfx\mist.col,6,8
daycol	inccolfile	data\gfx\bg2-c.col,1,2
	inccolfile	data\gfx\bg2-c.col,5,6
gameoverpal	inccolfile	data\gfx\over_d.col,7,8

;---------------------------------------------------------------------------


setinidisp1_l
	php
	a8
	sta.l	xinidisp1
	sta.l	xinidisp2
	sta.l	xinidisp1a
	plp
	rtl

;---------------------------------------------------------------------------

setnoclash_l
	php
	a8
	lda	#95
	sta.l	xinidisp1-1
	lda	#45
	sta.l	xinidisp2-1
	lda	#50
	sta.l	xinidisp1a-1
	plp
	rtl
;---------------------------------------------------------------------------
screenoff_l
	php
	a8i16
	stz	hdmaen
	lda	#$80
	sta	inidisp
	setinidisp1
	waitdma	150
	waitdma	140	; wait for it all to take effect
	plp
	rtl





Initialize_resister_l
	jsr	Initialize_resister
	rtl
Initialize_resister
	php
	ai8
	lda	#$8f
	sta	$2100
	lda	#0
	sta	$2101
	sta	$2102
	sta	$2103

	sta	$2105
	sta	$2106
	sta	$2107
	sta	$2108
	sta	$2109
	sta	$210a
	sta	$210b
	sta	$210c

	sta	$210d
	sta	$210d
	sta	$210e
	sta	$210e
	sta	$210f
	sta	$210f
	sta	$2110
	sta	$2110
	sta	$2111
	sta	$2112
	sta	$2112
	sta	$2113
	sta	$2113
	sta	$2114
	sta	$2114

	ldx	#$80
	stx	$2115
	
	sta	$2116
	sta	$2117

	sta	$211a

	ldx	#1
	sta	$211b
	stx	$211b
	sta	$211c
	sta	$211c
	sta	$211d
	sta	$211d
	sta	$211e
	stx	$211e
	sta	$211f
	sta	$211f
	sta	$2120
	sta	$2120

	sta	$2121

	sta	$2122
	sta	$2123
	sta	$2124
	sta	$2125
	sta	$2126
	sta	$2127
	sta	$2128
	sta	$2129
	sta	$212a
	sta	$212b
	sta	$212c
	sta	$212d
	sta	$212e

	ldy	#$30
	sty	$2130

	sta	$2131
	ldx	#$e0
	stx	$2132
	sta	$2133

	sta	$4200
	ldx	#$ff
	stx	$4201
	sta	$4202
	sta	$4203
	sta	$4204
	sta	$4205
	sta	$4206
	sta	$4207
	sta	$4208
	sta	$4209
	sta	$420a
	sta	$420b
	sta	$420c
	sta	$420d

	plp
	rts



; --------------------------------------------------
; waitdma_l
; called from the macro 'waitdma' to save memory

waitdma_l
	php
	ai16
	phx
	pha
	a8
	stz	dmatemp+1

.waitforline
	a8
	lda	slhvr
	lda	opvctr
	xba
	lda	opvctr
	xba

;	a16
;	and	#%111111111
	cmp	dmatemp
	bne	.waitforline

;.vw1	lda	slhvr		;wait for screen off
;	ldx	opvctr
;	lda	opvctr
;	and	#1
;	bne	.vw1
;	cpx	dmatemp
;	bne	.vw1

	ai16
	pla
	plx
	plp

	rtl





