dist1	equ	200
ctrlmapobj	equ	0
ctrlend	equ	2
ctrlloop	equ	4
ctrlmapdeb	equ	6
ctrlmapnop equ	8
ctrlmapmother equ	10
ctrlmapremove equ	12
ctrlsetstage equ 	14
ctrlsetbg	equ	16
ctrlmapwait	equ	18
ctrlsetbgm	equ	20
ctrlnodots	equ	22
ctrlgnddots	equ	24
ctrlspacedust equ	26
ctrlsetothmus equ	28
ctrlvofson	equ	30
ctrlvofsoff	equ	32
ctrlhofson	equ	34
ctrlhofsoff	equ	36
ctrlmapobjzrot equ	38
ctrlmapjsr	equ	40
ctrlmaprts	equ	42
ctrlmapif	equ	44
ctrlmapgoto	equ	46
ctrlsetxrot	equ	48
ctrlsetyrot	equ	50
ctrlsetzrot	equ	52
ctrlsetalvarb equ	54
ctrlsetalvarw equ	56
ctrlsetalvarl equ	58
ctrlsetalxvarb equ	60
ctrlsetalxvarw equ	62
ctrlsetalxvarl equ	64
ctrlsetfadeup equ	66
ctrlsetfadedown equ	68
ctrlsetalvarptrb equ	70
ctrlsetalvarptrw equ	72
ctrlsetvarobj equ	74
ctrlmapwaitfade equ	76
ctrlsetqfadeup equ	78
ctrlsetqfadedown equ	80
ctrlscreenoff equ	82
ctrlscreenon equ	84
ctrlzrotoff	equ	86
ctrlzroton	equ	88
ctrlmapspecial equ	90
ctrlsetvarb     equ	92
ctrlsetvarw     equ	94
ctrlsetvarl     equ	96
ctrlsetbgslow   equ	98
ctrlwaitsetbg   equ	100
ctrlsetbginfo   equ	102
ctrladdalvarptrb equ	104
ctrladdalvarptrw equ	106
ctrlfadetosea    equ 108
ctrlfadetoground equ 110
ctrlmapqobj	    equ 112
ctrlmapobj8	equ	114
ctrlmapdobj	equ	116
ctrlmapqobj2	equ	118
ctrl65816	equ	120
ctrlmapcodejsl equ	122
ctrlmapjmpvarless	equ	124
ctrlmapjmpvarmore	equ	126
ctrlmapjmpvareq	equ	128
ctrlsendmessage	equ	130
ctrlmapcspecial	equ	132
ctrlnobj		equ	134
ctrlmqnobj		equ	136
ctrlmapwait2		equ	138
ctrlmapsetpath		equ	140

;-----------------------------------------------------------------------------
mapdef	macro
	dw	((\1)&$7fff)
	db	(\1)>>16
	endm

mapsetpath	macro	[path]
	db	ctrlmapsetpath
	dw	path_{path}
	endm

wipein	macro
	mapcode_jsl	initblack_l
	setvar.b stayblack,30
	mapwait	300
	setvar.w circleanim,\1
	setvar.b stayblack,-1
	endm

wipeout	MACRO
	setvar.w circleanim,\1
	setvar.b doneacircle,1
	ENDM

markboss	macro
	start_65816
	ai16
	lda	#\1-endseqboss
	jsl	setboss_l
	end_65816
	endm

coursedef	macro
	dw	((\1)&$7fff)
	endm

;mapobj8	macro	frame,x,y,z,shape,strategy
;	db	ctrlmapobj8
;	db	(\1)>>2
;	db	(\2)>>2,(\3)>>2,(\4)>>4
;	dw	(\5)&WM
;	dw	(\6)&WM
;	db	(\6)>>16
;	endm

mapdobj	macro	frame,x,y,z,shape,strategy

	db	ctrlmapdobj		; control.
	dw	\1		; frame relative to last.
	dw	\2,\3,\4		; x,y,z position.
	db	is_\6
	endm

mapobj	macro	frame,x,y,shape,strategy
	mapnobj	\1,\2,\3,\4,\5,\6
	endm


mnobjnum	=	0
mapnobj	macro
mnobjnum	=	mnobjnum+1
	db	ctrlnobj
	dw	(\1)
	dw	(\2),(\3),(\4)
	dw	(\5)
	dw	(\6)&WM
	db	(\6)>>16
	endm





mapqnobj	macro	frame,x,y,z,shape,strategy
	db	ctrlmqnobj			; control.
	db	((\1)>>4)&$ff		; frame relative to last.
	db	((\2)>>2)&$ff		; x position.
	db	((\3)>>2)&$ff
	db	((\4)>>4)&$ff		; z pos
	dw	\5		; shape.
	dw	\6		; strategy
	db	\6>>16
	endm




mapqobj	macro	frame,x,y,z,shape,strategy
mqom	=	ctrlmapqobj
	IFD	is_\5
	IFEQ	sh_\6-is_\5
mqom	=	ctrlmapqobj2
	ENDC
	ELSEIF
	printf	"\5 is undefined in istrats.asm%n"
;	fail	; \5 is undefined in istrats.asm
	ENDC


	db	mqom			; control.
	db	((\1)>>4)&$ff		; frame relative to last.
	db	((\2)>>2)&$ff		; x position.
	db	((\3)>>2)&$ff
	db	((\4)>>4)&$ff		; z pos
	IFNE	mqom-ctrlmapqobj2
	db	is_\5		; shape.
	ELSEIF
	ENDC
	db	is_\6		; strategy
	endm

mapozrotnum	=	0
mapobjzrot	macro	x,y,strategy,zrot
mapozrotnum	=	mapozrotnum+1
	db	ctrlmapobjzrot	; control.
	dw	\1
	dw	\2,\3,\4		; x,y,z position.
	db	is_\5		; shape 
	db	is_\6
	db	\7		; z rot
	endm

maploop	macro	label
	db	ctrlloop
	dw	(\1)&$7fff
	dw	\2-1
	endm

mapend	macro
	IFEQ	NARG-1
	setvar	levelfinished,\1
	ELSEIF
	setvar	levelfinished,1
	ENDC
	db	ctrlend
	endm

mapdeb	macro
	db	ctrlmapdeb
	endm

mapnop	macro
	db	ctrlnopobj
	endm

setstage	macro
	db	ctrlsetstage
	endm

setbg	macro
c_SLOW	=	1234
c_SLOWLY	=	1234
c_WITHTIME	=	1234
c_TAKEYOURTIMEABOUTIT	=	1234
	IFEQ	(NARG-2)&(NARG-3)
	IFEQ	c_\2-1234
	db	ctrlsetbgslow
	IFEQ	NARG-3
	db	\3
	ELSEIF
	db	7
	ENDC
	ELSEIF
	error	"Illegal Parameter: \1"
	ENDC
	ELSEIF
	db	ctrlsetbg
	ENDC
	dw	bg_\1-bglists
	endm

setnodots	macro
	db	ctrlnodots
	endm

setgnddots	macro
	db	ctrlgnddots
	endm

setspacedust macro
	db	ctrlspacedust
	endm

setothmus	macro
	db	ctrlsetothmus
	db	\1
	endm

setbgm	macro
	db	ctrlsetbgm
	db	\1
	endm

vofson	macro
	db	ctrlvofson
	endm
vofsoff	macro
	db	ctrlvofsoff
	endm
hofson	macro
	db	ctrlhofson
	endm
hofsoff	macro
	db	ctrlhofsoff
	endm

mapjsr	macro
	db	ctrlmapjsr
	dw	(\1)&$7fff
	db	(\1)>>16
	endm

maprts	macro
	db	ctrlmaprts
	endm

mapif	macro
	db	ctrlmapif
	dw	\1&wm
	db	\1>>16
	dw	(\2)&$7fff
	endm

mapgoto	macro
	db	ctrlmapgoto
	dw	(\1)&$7fff
	db	(\1)>>16
	endm

setxrot	macro
	db	ctrlsetxrot
	db	\1
	endm
setyrot	macro
	db	ctrlsetyrot
	db	\1
	endm
setzrot	macro
	db	ctrlsetzrot
	db	\1
	endm


addalvarptr	macro				; alvar,value
	ifc	'\0','N'
	db	ctrladdalvarptrb
	endc
	ifc	'\0','W'
	db	ctrladdalvarptrw
	endc
	dw	al_\1
	dw	\2&wm
	db	\2>>16
	endm

setalvar	macro

	ifd	alx_\1
	error	<Can't do alx_var in setalvar>
	endc

	ifc	'\0','N'
	db	ctrlsetalvarb
	dw	al_\1
	db	\2
	endc
	ifc	'\0','W'
	db	ctrlsetalvarw
	dw	al_\1
	dw	\2
	endc
	ifc	'\0','L'
	db	ctrlsetalvarl
	dw	al_\1
	dw	\2&wm
	db	\2>>16
	endc
	endm

setalvarptr	macro				; alptr,ptr
	ifc	'\0','N'
	db	ctrlsetalvarptrb
	endc
	ifc	'\0','W'
	db	ctrlsetalvarptrw
	endc
	dw	al_\1
	dw	\2
	db	\2>>16
	endm



setvarobj	macro				; ptr
	db	ctrlsetvarobj
	dw	\1
	db	\1>>16
	endm

setvar	macro
	ifc	'\0','N'
	db	ctrlsetvarb
	db	\2
	endc
	ifc	'\0','B'
	db	ctrlsetvarb
	db	\2
	endc
	ifc	'\0','W'
	db	ctrlsetvarw
	dw	\2
	endc
	ifc	'\0','L'
	db	ctrlsetvarl
	dw	\2&wm
	db	\2>>16
	endc
	dw	\1
	db	\1>>16
	endm



setalxvar	macro
	ifc	'\0','N'
	db	ctrlsetalxvarb
	dw	al_\1-(alxblkstart&WM)
	db	\2
	endc
	ifc	'\0','W'
	db	ctrlsetalxvarw
	dw	al_\1-(alxblkstart&WM)
	dw	\2
	endc
	ifc	'\0','L'
	db	ctrlsetalxvarl
	dw	al_\1-(alxblkstart&WM)
	dw	\2&wm
	db	\2>>16
	endc
	endm

setfadeup	macro
	ifeq	narg
	db	ctrlsetfadeup
	elseif
	db	ctrlsetqfadeup
	endc
	endm
setfadedown	macro
	ifeq	narg
	db	ctrlsetfadedown
	elseif
	db	ctrlsetqfadedown
	endc
	endm
mapwaitfade	macro
	db	ctrlmapwaitfade
	endm
mapscreenoff macro
	db	ctrlscreenoff
	endm
mapscreenon macro
	db	ctrlscreenon
	endm

zrotoff	macro
	db	ctrlzrotoff
	endm

zroton	macro
	db	ctrlzroton
	endm

special	MACRO
	mapobj	0,\2,\3,\4,\5,\6
	mapspecial
	mapwait	\1
	ENDM

Cspecial	MACRO
	mapobj	0,\2,\3,\4,\5,\6
	mapCspecial
	mapwait	\1
	ENDM


mapspecial	MACRO
	db	ctrlmapspecial
	ENDM

mapCspecial	MACRO
	db	ctrlmapCspecial
	ENDM

waitsetbg	MACRO
	db	ctrlwaitsetbg
	ENDM

initbg	MACRO
	waitsetbg
	db	ctrlsetbginfo
	ENDM

;------------------------------------------------------------------------
ctrlmotherobj   equ	0
ctrlmotherloop  equ	2
ctrlmotherend   equ	4
ctrlmotherrnd   equ	6
ctrlmothergoto  equ	8
ctrlmotherwait  equ	10
ctrlmothercount equ	12
ctrlmotherjump  equ	14
ctrlmotherset   equ	16
;------------------------------------------------------------------------
mapmother	macro	frame,x,y,z,shape,strategy,map
	db	ctrlmapmother	; control
	dw	\1		; wait value
	dw	\2,\3,\4		; x,y,z
	dw	\5&wm		; shape
	dw	(\6)&wm		; strategy
	db	(\6)>>16	; strategy
	dw	(\7)&$7fff	; map
	endm

mapwait	macro	; map wait function
	db	ctrlmapwait
	dw	\1

;	IFNE	\1
;	IFLT	((\1)>>4)-256
;	db	ctrlmapwait2
;	db	(\1)>>4
;	ELSEIF
;	db	ctrlmapwait
;	dw	\1
;	ENDC
;	ENDC
	endm



maprem	macro	frame,shape to remove
	db	ctrlmapremove
	ifeq	narg-1
	dw	0
	dw	\1&wm
	elseif
	dw	\1
	dw	\2&wm
	endc
	endm

motherobj	macro	frame,x,y,z,shape,strat
	db	ctrlmotherobj		; control.
	dw	\1		; frame relative to last.
	dw	\2,\3,\4		; x,y,z position.
	dw	\5&wm		; shape.
	dw	(\6)&wm		; strategy.
	db	(\6)>>16
	endm

motherloop	macro	frame,addr,count or addr,count
	db	ctrlmotherloop
	ifeq	narg-2
	dw	0
	dw	(\1)&$7fff
	db	\2
	elseif
	dw	\1
	dw	(\2)&$7fff
	db	\3
	endc
	endm

mothergoto	macro	frame,addr or just addr only
	db	ctrlmothergoto
	ifeq	narg-1
	dw	0
	dw	(\1)&$7fff
	elseif
	dw	\1
	dw	(\2)&$7fff
	endc
	endm

motherend	macro	(deletes the current alien mother)
	db	ctrlmotherend
	endm

motherrnd	macro	frame,x,y,z,shape,strat
	db	ctrlmotherrnd		; control.
	dw	\1		; frame relative to last.
	dw	\2,\3,\4		; x,y,z random mask.
	dw	\5&wm		; shape.
	dw	(\6)&wm		; strategy.
	db	(\6)>>16
	endm

motherwait	macro	frame
	db	ctrlmotherwait
	dw	\1
	endm

motherset	macro	frame,b|w,alvar|var,alvar,value or b|w,type,alvar,value
	db	ctrlmotherset
	ifeq	narg-5
	dw	\1
type	=	0

	ifc	'\2','w'
type	=	type!1
	elseif
	ifcc	'\2','b'
	fail	; invalid parameter (b/w should be specified)
	endc
	endc

	ifc	'\3','alvar'
type	=	type!2
	endc
	elseif
	ifcc	'\3','var'
	fail	; invalid parameter (alvar!var should be specified)
	endc

	db	type

	dw	(\4)&wm
	db	(\4)>>16
	dw	\5
	elseif
	endc
	endm


mothercnt	macro	frame,shape or just shape to count
	db	ctrlmothercount
	ifeq	narg-1
	dw	0
	dw	\1
	elseif
	dw	\1
	dw	\2
	endc
	endm



pubalub	macro	frame,shape or just shape to count
	db	ctrlmothercount
	ifeq	narg-1
	dw	0
	dw	\1
	elseif
	dw	\1
	dw	\2
	endc
	endm


motherjump	macro	frame,cmp value,condition,address
	db	ctrlmotherjump

	ifeq	narg-3
	dw	0
	dw	\1
	dw	(\3)&$7fff

	ifc	'\2','EQ'
	db	mj_eq
	endc

	ifc	'\2','NE'
	db	mj_ne
	endc

	ifc	'\2','GT'
	db	mj_gt
	endc

	ifc	'\2','LT'
	db	mj_lt
	endc

	elseif

	dw	\1
	dw	\2
	dw	(\4)&$7fff

	ifc	'\3','eq'
	db	mj_eq
	endc

	ifc	'\3','ne'
	db	mj_ne
	endc

	ifc	'\3','gt'
	db	mj_gt
	endc

	ifc	'\3','lt'
	db	mj_lt
	endc
	endc

	endm


mapfadetosea macro
	db	ctrlfadetosea
	endm

mapfadetoground macro
	db	ctrlfadetoground
	endm


;-----------------------------------------------------------------

setrestart	MACRO
	start_65816
	a8i16

	IFEQ	NARG
	lda	#.\@>>16
	ldx	#.\@&$7fff
	ELSEIF
	lda	#\1>>16
	ldx	#\1&$7fff
	ENDC

	jsl	set_restart_position_l
	end_65816
.\@
	ENDM

;-----------------------------------------------------------------
; x is set up pointing to the last map object created
start_65816	MACRO
	db	ctrl65816
	shorta
	longi
	ENDM
;-----------------------------------------------------------------

end_65816	MACRO
	IFEQ	longi
	i16
	ENDC
	ldx	#.con\@&$7fff
	rtl
.con\@
	ENDM

;------------------------------------------------------------------
; switch out of 65816 into the map at the specified point
switch	MACRO
	IFC	"\0","N"
	IFEQ	LONGI
	i16
	ENDC
	ldx	#(\1)&$7fff
	rtl
	ELSEIF
tli_blob	=	longi
	b\0	.doit\@
	bra	.dontdoit\@
.doit\@
	IFEQ	LONGI
	i16
	ENDC
	ldx	#(\1)&$7fff
	rtl
	IFNE	tli_blob
	LONGI
	ELSEIF
	SHORTI
	ENDC
.dontdoit\@
	ENDC


	ENDM
;------------------------------------------------------------------

mapcode_jsl	MACRO
	db	ctrlmapcodejsl
	dw	((\1)-1)&WM
	db	((\1)>>16)
	ENDM
;------------------------------------------------------------------


meters_off	MACRO
	setvar	m_meters,0
	IFD	mo_\1
; only if screen is off! (and before a set or initbg)
	mapcode_jsl	setcharmapfrommap_l
	ENDC
		ENDM
mo_trans
meters_on	MACRO
	setvar	m_meters,1
	IFD	mo_\1
; only if screen is off! (and before a set or initbg)
	mapcode_jsl	setcharmapfrommap_l
	ENDC
		ENDM

;------------------------------------------------------------------
il_nofadenostage	equ	1
il_whitefadeout		equ	2
il_nometers		equ	3

initlevel	MACRO
wipedone	=	0
	setfadedown	quick
	mapwaitfade
	setbg	\1
	initbg
	setvar	specialobjtotal,0
	setvar	specials_dead,0


;	start_65816
;	a16
;	stz	lastplayz
;	stz	pviewposz
;	ldx	playpt
;	stz	al_worldz,x
;	a8
;	end_65816


	IFEQ	NARG-3

	IFEQ	il_\2-il_nofadenostage
	ifnc	"\3","0"
	wipein	\3
wipedone	=	1
	endc
	mapcode_jsl	initblack_l
	setvar		stayblack,2
	MEXIT
	ENDC

	IFEQ	il_\2-il_whitefadeout
	mapcode_jsl	initblack_l
	setvar		stayblack,-1
	mapcode_jsl	initfadewhite2norm_l
	ENDC

	ELSEIF

	ifnc	"\2","0"
	wipein	\2
wipedone	=	1
	endc
	mapcode_jsl	initblack_l
	setvar		stayblack,2
	ENDC

	mapwait	1
	mapwait	1
	setstage
	IFNE	wipedone
	setvar	stayblack,-1
	ENDC
	setfadeup	quick
	setrestart
	ENDM

;------------------------------------------------------------------
mapplayermode	MACRO		\1 mode name
	mapgotoifplayerdead	.skip\@
	start_65816
	phb
	lda	#$7e
	pha
	plb

	jsl		set_player\1_l
	a16
	lda	#set_player\1_l&WM
	sta	newplayerstrat
	a8
	lda	#set_player\1_l>>16
	sta	newplayerstrat+2

	plb
	end_65816
.skip\@
	ENDM


;------------------------------------------------------------------
mapgotoifplayerdead	MACRO	label
	start_65816
	a8
	lda		pshipflags2
	and		#psf2_playerHP0
	beq		.ok\@
	switch		\1
.ok\@
	end_65816
		ENDM

;------------------------------------------------------------------
mapCLplayermode	MACRO		\1 mode name
	start_65816
	phb
	lda	#$7e
	pha
	plb
	jsl	calcteamdamage_l
	jsl	set_player\1_l
	lda	playerflymode
	and	#~pfm_wobble
	sta	playerflymode
	plb
	end_65816

	ENDM


;------------------------------------------------------------------
mapplayercantdie	MACRO		
	start_65816
	a8
	lda		pstratflags
	ora		#pstf_notdie
	sta		pstratflags
	end_65816
	ENDM


;------------------------------------------------------------------
mapPLAYEROUTVIEW	MACRO
.wait\@	mapwait	5

	start_65816
	a8
	lda		pshipflags2
	and		#psf2_playerHP0
	beq		.cont
	switch	.wait\@
.cont
	lda		pstratflags
	ora		#pstf_inseq
	sta		pstratflags

	lda		splayerflymode
	cmp		#spfm_inside
	beq		.do\@
	switch		.cont\@
.do\@	lda		#spfm_tonorm
	sta		splayerflymode

	phb
	lda	#$7e
	pha
	plb
	jsl		changeviewmode_l
	plb

	end_65816
	mapwait		2000
.cont\@
	ENDM


;------------------------------------------------------------------
mapPLAYEROUTDIST	MACRO
	start_65816
	lda		#spfm_tonorm
	sta		splayerflymode
	a16
	lda	#outviewdist
	sta	viewdist
	end_65816
	ENDM




;------------------------------------------------------------------
maptexitwait	MACRO

	IFEQ	NARG-1
	mapwait	1000+\1
	ELSEIF
	mapwait	1000
	ENDC


	ENDM

;------------------------------------------------------------------
mapjmpvarless	macro	  ; var,value
	db	ctrlmapjmpvarless
	dw	\1&wm
	db	\1>>16
	db	\2
	dw	(\3)&$7fff
	endm
;------------------------------------------------------------------
mapjmpvarmore	macro	  ; var,value
	db	ctrlmapjmpvarmore
	dw	\1&wm
	db	\1>>16
	db	\2
	dw	(\3)&$7fff
	endm
;------------------------------------------------------------------
mapjmpvareq	macro	  ; var,value
	db	ctrlmapjmpvareq
	dw	\1&wm
	db	\1>>16
	db	\2
	dw	(\3)&$7fff
	endm




;**********************************************************************************
;**********************************************************************************
;**********************************************************************************
;**********************************************************************************
;** SPECIAL MAP MACROS



mapdebug	MACRO
	start_65816
	blink	3
	end_65816
	ENDM

mapnozremove	MACRO
	start_65816
	a8
	lda	gameflags
	ora	#gf_nozremove
	sta	gameflags
	end_65816
	ENDM
	
mapzremove	MACRO
	start_65816
	a8
	lda	gameflags
	and	#~gf_nozremove
	sta	gameflags
	end_65816
	ENDM

maphardRot	MACRO
	mapobj	0,\2,\3,\4,\5,hardRot_Istrat
	setalvar	sbyte1,\6
	setalvar	sbyte2,\7
	setalvar	sbyte3,\8
	mapwait	\1
	ENDM	



msfmem	=	0
;-------------------------------------------------------------------------------------
map_farships0	MACRO	
	mapobj		0300,\1,space_viewcy+\2,\3,ship_s_0,ships_Istrat
	setalvar.w	sword1,\4
	setalvar.w	sword2,\5
	setalxvar.w	depthoffset,\6
	setalvar	roty,deg180
	ENDM

map_farships1	MACRO	
	mapobj		0300,\1,space_viewcy+\2,\3,ship_s_1,ships_Istrat
	setalvar.w	sword1,\4
	setalvar.w	sword2,\5
	setalxvar.w	depthoffset,\6
	setalvar	roty,deg180
	ENDM

map_farships2	MACRO	
	mapobj		0300,\1,space_viewcy+\2,\3,ships,ships_Istrat
	setalvar.w	sword1,\4
	setalvar.w	sword2,\5
	setalxvar.w	depthoffset,\6
	ENDM

;-------------------------------------------------------------------------------------

fadeoutbgm	MACRO
	setbgm	$f1
	mapwait	medpspeed*30
	ENDM
;-------------------------------------------------------------------------------------
mapjmpfrienddead	MACRO	name,label
friendwait	=	medpspeed*30

	start_65816
	a8
	lda	\1
	beq	.dead\@
	switch	.ok2\@
.dead\@
	end_65816

	IFNE	NARG-3	
	mapwait	friendwait
	ENDC

	mapgoto	\2
.ok2\@
		ENDM

;-------------------------------------------------------------------------------------
map_sfish	MACRO	wait,x,y,z,number of fish
	mapobj	0,\2,\3,\4,s_fish,sfish_Istrat
	setvarobj	mapvar1
	rept	\5-1
	mapobj	0,0,0,4000,s_fish,sfish_Istrat
	setalvarptr.w	ptr,mapvar1
	endr
	mapwait	\1

	ENDM
;-------------------------------------------------------------------------------------
mapobjnomem	MACRO
	mapobj	\1,\2,\3,\4,\5,\6
	ENDM


;-------------------------------------------------------------------------------------
mapLRdoor	MACRO	wait,Z
	mapobj	0,-45,-60,\2,open_l,openlr_Istrat
	mapobj	0,45,-60,\2,open_l,openlr_Istrat
	setalvar	rotz,deg180
	mapwait	\1
	ENDM

;-------------------------------------------------------------------------------------
mapUPDNdoor	MACRO	wait,Z
	mapobj	\1,0,-60,\2,up_door,updoor_Istrat
	ENDM

;-------------------------------------------------------------------------------------
mapDNUPdoor	MACRO	wait,Z
	mapobj	0,0,-60,\2,up_door,updoor_Istrat
	setalvar	rotz,deg180
	mapwait	\1
	ENDM


;-------------------------------------------------------------------------------------
mappipe	MACRO
	IFEQ		NARG-6
	mapobjnomem	0,0,-60+((\1)*pipescale),pdist+((\2)*pipescale),pipe_\5,nocoll_Istrat
	ELSEIF
	mapobjnomem	0,0,-60+((\1)*pipescale),pdist+((\2)*pipescale),pipe_\5,gnd_Istrat
	ENDC
	setalvar	rotx,((deg360/12)*\3)
	setalvar	rotz,deg180*\4
;	setalvar	roty,-deg90
	ENDM

mappipewait	MACRO
	mapwait		((40*pipescale))
pdist	=	pdist-((40*pipescale))
	ENDM
;-------------------------------------------------------------------------------------

mapend__not	MACRO	[newmap]
	setvar	levelfinished,7
.chkagain\@
	start_65816
	a8
	lda	levelfinished
	bne	.andagain\@
	switch	{newmap}
.andagain\@	end_65816
	mapwait	1
	mapgoto	.chkagain\@

	ENDM

;-------------------------------------------------------------------------------------
mapblocksnd	MACRO
	start_65816
	trigse	$49
	end_65816
	ENDM
;-------------------------------------------------------------------------------------
mapendwipe	MACRO	circle type,wait
	wipeout	m\1_circle
	setbgm	$f1
	start_65816
	lda	pshipflags3
	and	#~psf3_enginesnd
	sta	pshipflags3
	end_65816
	mapwait	\2
	setvar.b	clb2,1
	ENDM
;-------------------------------------------------------------------------------------


mapexploderobot	macro
	mapcode_jsl	kill_robot_l
		endm

;-------------------------------------------------------------------------------------

skillfly_init	macro
	setvar.b	skillfly,0
		endm


skillfly_set	macro	[x,y,z,radius]
	mapobj	0,{x},{y},{z},nullshape,skillfly_istrat,10,10
	IFEQ	NARG-4
	setalvar.w	sword1,{radius}
	ENDC
		endm

skillfly_debug	macro	[x,y,z,radius]
	mapobj	0,{x},{y},{z},item_5,skillfly_istrat,10,10
	IFEQ	NARG-4
	setalvar.w	sword1,{radius}
	ENDC
		endm

skillfly_bonus	macro	[wait,x,y,z,shape,istrat]
	start_65816
	lda.l	skillfly
	beq	.c\@	
	switch	.\@
.c\@	end_65816
	mapobj	{wait},{x},{y},{z},{shape},{istrat}
.\@
		endm

skillfly_pathbonus	macro	[wait,x,y,z,shape,path,hp,ap]
	start_65816
	lda.l	skillfly
	beq	.c\@	
	switch	.\@
.c\@	end_65816
	pathobj	{wait},{x},{y},{z},{shape},{path},{hp},{ap}
.\@
		endm



skillfly_goto	macro	[address]
	start_65816
	lda.l	skillfly
	beq	.c\@
	switch	.\@
.c\@	end_65816
	mapgoto	{address}
.\@
	endm

eguchifly_goto	macro	[address]
	start_65816
	a16
	lda.l	eword1
	cmp	#15
	bcs	.c\@
	switch	.\@
.c\@	end_65816
	mapgoto	{address}
.\@
	endm

eguchi2fly_goto	macro	[address]
	start_65816
	lda.l	ebyte3
	bne	.c\@
	switch	.\@
.c\@	end_65816
	mapgoto	{address}
.\@
	endm


;-------------------------------------------------------------------------------------
maphalfdR	MACRO 	; wait,z
	mapobj	\1,60,-60,\2,half_d,halfd_Istrat
	ENDM
;-------------------------------------------------------------------------------------
maphalfdL	MACRO 	; wait,z
	mapobj	0,-60,-60,\2,half_d,halfd_Istrat
	setalvar	rotz,deg180
	mapwait	\1
	ENDM


;-------------------------------------------------------------------------------------
mapdpilarR	MACRO 	; wait,y,z
	mapobj	\1,60,\2,\3,d_pilar,dpilar_Istrat
	ENDM
;-------------------------------------------------------------------------------------
mapdpilarL	MACRO 	; wait,y,z
	mapobj	0,-60,\2,\3,d_pilar,dpilar_Istrat
	setalvar	rotz,deg180
	mapwait	\1
	ENDM

;-------------------------------------------------------------------------------------
mapgotoiflevel	MACRO	level(1-3),label
	start_65816
	a8
	lda	currentlevel
	cmp	#\1-1
	bne	.no\@
	switch	\2
.no\@
	end_65816
	ENDM

;-------------------------------------------------------------------------------------
mapgotoifnotlevel	MACRO	level(1-3),label
	start_65816
	a8
	lda	currentlevel
	cmp	#\1-1
	beq	.no\@
	switch	\2
.no\@
	end_65816
	ENDM

;**********************************************************************************
road_zdist	=	14000

road_Nx	=	0
road_Nz	=	4
road_Sx	=	0
road_Sz	=	-4
road_Ex	=	4
road_Ez	=	0
road_Wx	=	-4
road_Wz	=	0

defstep MACRO
road_N\1x	=	0
road_N\1z	=	\1
road_S\1x	=	0
road_S\1z	=	-\1
road_E\1x	=	\1
road_E\1z	=	0
road_W\1x	=	-\1
road_W\1z	=	0
        ENDM


        defstep 1
        defstep 2
        defstep 3
        defstep 4
        defstep 5
        defstep 6
        defstep 7
        defstep 8
        defstep 9
        defstep 10
        defstep 11
        defstep 12
        defstep 13
        defstep 14
        defstep 15
        defstep 16
        defstep 17
        defstep 18
        defstep 19
        defstep 20


road_xpos	=	0
road_zpos	=	road_zdist
road_size	=	30<<track_scale
road_ypos	=	-30<<track_scale
;road_ypos	=	0	



;**********************************************************************************
road	MACRO	road name,[direction(NSEW)],[direction(NSEW)]

	mapobj	0,road_xpos,0,road_zpos,\1,gnd_Istrat
	setalxvar.w	sword1,\1_xlen/2
	setalxvar.w	sword2,\1_zlen/2

	IFEQ	NARG-3
	roadpos	(road_\2x+road_\3x),(road_\2z+road_\3z)
	ENDC
	IFEQ	NARG-2
	roadpos	road_\2x,road_\2z
	ENDC	

	ENDM	

;**********************************************************************************
aroad	MACRO	road name,anim type,speed/frame,wait time/0,[direction(NSEW)],[direction(NSEW)]

anim_up	=	0
anim_down	=	0
anim_bounce	=	0
anim_stop	=	0
anim_\2	=	1
	IFNE	anim_up
	mapobj	0,road_xpos,road_ypos,road_zpos,\1,gndanimup_Istrat
	ENDC
	IFNE	anim_down
	mapobj	0,road_xpos,road_ypos,road_zpos,\1,gndanimdown_Istrat
	ENDC
	IFNE	anim_bounce
	mapobj	0,road_xpos,road_ypos,road_zpos,\1,gndanimbounce_Istrat
	ENDC
	IFNE	anim_stop
	mapobj	0,road_xpos,road_ypos,road_zpos,\1,gndanim_Istrat
	ENDC
	setalxvar	sbyte2,\3
	setalxvar	sbyte1,\1_frames
	setalxvar	sbyte3,\4

	setalxvar.w	sword1,\1_xlen/2
	setalxvar.w	sword2,\1_zlen/2

	IFEQ	NARG-6
	roadpos	(road_\5x+road_\6x),(road_\5z+road_\6z)
	ENDC
	IFEQ	NARG-5
	roadpos	road_\5x,road_\5z
	ENDC	

	ENDM
;**********************************************************************************
slope	MACRO	name,frame,[direction(NSEW)],[direction(NSEW)]
	
	IFEQ	NARG-2
	aroad	\1,stop,\2,0
	ENDC

	IFEQ	NARG-3
	aroad	\1,stop,\2,0,\3
	ENDC

	IFEQ	NARG-4
	aroad	\1,stop,\2,0,\3,\4
	ENDC

	ENDM
;**********************************************************************************
obj	MACRO	[name,X,Y,Z,strat]

	IFEQ	NARG-4
	mapobj	0,road_xpos+({X}<<track_scale),{Y}<<track_scale,road_zpos+({Z}<<track_scale),{name},gndobj_Istrat
	ELSEIF
	IFC	"{name}","null"
	mapobj	0,road_xpos+({X}<<track_scale),{Y}<<track_scale,road_zpos+({Z}<<track_scale),nullshape,{strat}_Istrat
	ELSEIF
	mapobj	0,road_xpos+({X}<<track_scale),{Y}<<track_scale,road_zpos+({Z}<<track_scale),{name},{strat}_Istrat
	ENDC
	ENDC	

	IFNC	"{name}","null"
	setalxvar.w	sword1,{name}_xlen/2
	setalxvar.w	sword2,{name}_zlen/2
	ENDC

	ENDM	

;**********************************************************************************
marker	MACRO	[X,Y,Z]
;	mapobj	0,road_xpos+({X}<<track_scale),{Y}<<track_scale,road_zpos+({Z}<<track_scale),post_00,markobj_Istrat
	mapobj	0,road_xpos+({X}<<track_scale),{Y}<<track_scale,road_zpos+({Z}<<track_scale),nullshape,markobj_Istrat
	ENDM		

;**********************************************************************************
lapobj	MACRO
	obj	nullshape,\1,\2,\3,gate
	ENDM




;**********************************************************************************
roadpos	MACRO	x,z
oldroad_zpos	=	road_zpos

road_xpos	=	road_xpos+(\1*road_size)
road_zpos	=	road_zpos+(\2*road_size)

	IFNE	road_zpos-oldroad_zpos
	roadwait	road_zpos-oldroad_zpos
	ENDC	    
	ENDM

;**********************************************************************************
road_start	MACRO
	ENDM	

road_end	MACRO
	ENDM

;**********************************************************************************
roadwait	MACRO
	mapwait	(\1)
road_zpos	=	road_zpos-(\1)
	ENDM


;**********************************************************************************
move	MACRO	direction(NSEW),[direction(NSEW)]

	IFEQ	NARG-2
	roadpos	(road_\1x+road_\2x),(road_\1z+road_\2z)
	ENDC
	IFEQ	NARG-1
	roadpos	road_\1x,road_\1z
	ENDC	

	ENDM

;**********************************************************************************
enemycar1	MACRO
;	mapobj	0,road_xpos+({X}<<track_scale),{Y}<<track_scale,road_zpos+({Z}<<track_scale),nullshape,car2_Istrat
	ENDM

;**********************************************************************************
enemytruck1	MACRO
;	mapobj	0,road_xpos+({X}<<track_scale),{Y}<<track_scale,road_zpos+({Z}<<track_scale),trk_1_1,truck1_Istrat
     	ENDM


