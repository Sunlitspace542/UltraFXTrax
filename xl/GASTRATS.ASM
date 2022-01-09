;***************************************************************************
;*                                                                         *
;*                                 XLR 8                                  *
;*                              -----------                                *
;*                                                                         *
;*                           SuperNES version.                             *
;*                                                                         *
;*                                                                         *
;*                           Argonaut Software.      		      *	   
;*                                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;*   File: GASTRATS.ASM                                                     *
;*                                                                         *
;*                                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;*  Descr: GILES' STRATEGIES.                                        *
;*                                                                         *
;*                                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;*   Date: 27/1/93                                                         *
;*                                                                         *
;*                                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;* Author:								      *
;*                                                                         *
;*		Giles Goddard.      				      *	
;*                                                                         *
;***************************************************************************

	incpublics	gastrats.ext

	strats_start

viewoffx	=	0<<car_scale
viewoffy	=	-100<<car_scale
viewoffz	=	-500<<car_scale

;viewoffx	=	0<<car_scale
;viewoffy	=	-50<<car_scale
;viewoffz	=	-250<<car_scale

numlives	=	3			6
maxdamage	=	128
smokedamage	=	115

eyesprsize		=	5
whlsprsize		=	10
bigwhlsprsize	=	20
poly_wheels	=	0	; 1 = polygons , 0 = sprites

smokezoff	equ	-55





	shorta
	longi

gablink	blink	2


;*****************************************************************************
exppiece	MACRO
	s_make_obj	#\1,.bad\@
	s_copy_pos	y,x
;	s_add_2pos	y,#\2<<car_scale,#0-\3<<car_scale,#\4<<car_scale
	s_set_strat	y,expstrat_Istrat
	s_set_alvar	B,y,al_exppos2x,#\2		<<car_scale
	s_set_alvar	B,y,al_exppos2y,#0-\3		<<car_scale
	s_set_alvar	B,y,al_exppos2z,#\4		<<car_scale
	s_clr_altype	y,zremove
	s_set_alvartobeobj	y,al_sword1,x

	IFEQ	NARG-5
	s_set_alsflag	y,sflag1		; is wheel flag.
;	s_set_alvar	W,y,al_sword2,svar_word1
	IFEQ			poly_wheels
	s_sprite_obj	y,#0,#\5
	s_set_alvar	W,y,al_coltab,#wheel1_c&wm
 	s_init_colanim	y,#15
	ENDC

	ENDC

	ifeq	expt
expt	=   	1
	elseif	
	s_set_alsflag	y,sflag2
expt	=   	0
	endc


.bad\@
	ENDM

doexprot
	lda	al_exppos2x,x
	sta	svar_byte1	
	lda	al_exppos2y,x
	sta	svar_byte2	
	lda	al_exppos2z,x
	sta	svar_byte3	
	ldy	al_sword1,x

;	s_add_Roffs2pos		size,TO obj,POS obj,ROT obj,x,y,z,0/1,0/1,0/1 (x,y,z)rot on,[X #scale,Y #scale,Z #scale] 
	s_add_Roffs2pos		B,0,0,y,svar_byte1,svar_byte2,svar_byte3,1,1,1,car_scale,car_scale,car_scale
	
	a16
	lda	x2	    
	sta	al_expposx,x
	lda	y2	    
	sta	al_expposy,x
	lda	z2	    
	sta	al_expposz,x
	a8
	rts

	


explode_car_l
	s_set_alvar	B,x,al_enginesnd,#enginesnd_core

	s_dec_alvar	B,x,al_livesleft

expt	=	0
	exppiece	car7_c01,0,5,55
	exppiece	car7_c02,0,10,60
	exppiece	car7_c03,0,26,-16
	exppiece	car7_c04,24,4,-15
	exppiece	car7_c05,-24,4,-15
	exppiece	car7_c06,0,7,-44
	exppiece	car7_c07,0,27,-65

	exppiece	wheel2,40,-10,65,whlsprsize
	exppiece	wheel2,-40,-10,65,whlsprsize
	exppiece	wheel2,-50,-10,-55,bigwhlsprsize
	exppiece	wheel2,50,-10,-55,bigwhlsprsize



	s_jmp_alvarNOTZERO	B,x,al_livesleft,.nlast
	se_lastexplosion
	bra	.doneexp
.nlast 	se_explosion
.doneexp


	rtl



expstrat_Istrat
	s_start_strat

	jsr	doexprot

	a16
	lda	al_worldx,x
	clc
	adc 	al_expposx,x
	sta	al_worldx,x
	lda	al_worldy,x
	clc
	adc 	al_expposy,x
	sta	al_worldy,x
	lda	al_worldz,x
	clc
	adc 	al_expposz,x
	sta	al_worldz,x
	a8

	s_set_alvar	B,x,al_sbyte3,#40

	a16
	lda	al_expposx,x
	asra
	asra
	sta	al_vx,x
	lda	al_expposz,x
	asra
	asra
	sta	al_vz,x
	lda	al_expposy,x
	sta	al_vy,x
	a8

	s_set_alvar2rnd	x,al_sbyte1,#15
	s_sub_alvar	B,x,al_sbyte1,#7
	s_set_alvar2rnd	x,al_sbyte2,#15
	s_sub_alvar	B,x,al_sbyte2,#7

.nvec

	s_set_strat	x,expstrat_strat
	s_init_anim	x,#0


	s_runmario		mmake_expobj


	a16
	lda		#0
	sta		al_immuneptr,x
	lda.l		m_dynvar1
	lbeq		gablink
	sta		al_collobjptr,x

	ifeq	0
	phx

	lda	al_sword1,x
	tay
	lda.w	al_collobjptr,y	; ptr. to car
	sta	svar_word1
	tax
	lda.l	mrambank+OBJ_VELX,x
	REPT	dynshift-1
	asra
	ENDR
	adiv2
	sta	tmp_velx
	lda.l	mrambank+OBJ_VELY,x
	REPT	dynshift-1
	asra
	ENDR
	adiv2
	sta	tmp_vely
	lda.l	mrambank+OBJ_VELZ,x
	REPT	dynshift-1
	asra
	ENDR
	adiv2
	sta	tmp_velz


	lda.l		m_dynvar1
	tax
	lda	svar_word1
	sta.l	mrambank+EXPOBJ_OBJECT,x		; save ptr. to car.


	plx

	lda	al_vx,x
	clc
	adc	tmp_velx
	sta	al_vx,x
	lda	al_vy,x
	clc
	adc	tmp_vely
	sta	al_vy,x
	lda	al_vz,x
	clc
	adc	tmp_velz
	sta	al_vz,x


	endc
	a8


	jsl		init_mobj_l
	jsl		init_mvels_l

	s_jmp_notalsflag	x,sflag1,.nwheel
	phx
	stz	svar_byte1
	stz	svar_byte2
	a16
	lda	al_sword1,x
	tay
	lda.w	al_collobjptr,y	; ptr. to car
	txy
	tax	
	a8
	jsr	wheelanim
	plx

.nwheel
	s_end_strat


expstrat_strat
	s_start_strat


	s_jmp_alvarNE		B,x,al_sbyte3,#30,.ngameover
	s_set_objtobealvar	y,x,al_sword1
	s_jmp_alvarNOTZERO	B,y,al_livesleft,.ngameover
 	s_set_alsflag		y,sflag2
.ngameover


	s_beqdec_alvar	B,x,al_sbyte3,revexpstrat_Istrat

	s_add_alvars	B,x,al_rotx,x,al_sbyte1
	s_add_alvars	B,x,al_roty,x,al_sbyte2


	s_jmp		gndobj_strat



revexpstrat_Istrat
	s_start_strat

	s_set_objtobealvar	y,x,al_sword1
	s_jmp_alvarNOTZERO	B,y,al_livesleft,.ngameover
	s_jmp			remove_Istrat
.ngameover


	s_set_strat	x,revexpstrat_strat
	s_set_alvar2rnd	x,al_sbyte1,#31
	s_add_alvar	B,x,al_sbyte1,#10
	s_set_alvar	B,x,al_sbyte3,#40
	s_set_vecs	x,#0,#0,#0

	s_end_strat
revexpstrat_strat

	s_start_strat

	jsr	doexprot

	s_beqdec_alvar	B,x,al_sbyte3,remove_Istrat

	s_dec_alvar	B,x,al_sbyte1
	
	s_jmp_alvarNE	B,x,al_sbyte1,#1,.nsnd1
	s_jmp_alsflag	x,sflag2,.3
	se_stick1
	bra	.nsnd
.3
	se_stick2
.nsnd1

	s_jmp_alvarNE	B,x,al_sbyte1,#10,.nsnd
	s_jmp_alsflag	x,sflag2,.2
	se_rebirth1
	bra	.nsnd
.2
	se_rebirth2
.nsnd

	s_jmp_alvarless	B,x,al_sbyte1,#10,.do

	lbra		gndobj_strat
.do

	ifeq	0

	s_add_vecs2pos		x

	s_set_objtobealvar	y,x,al_sword1
	s_copy_alvar2var	W,y,svar_word1,al_worldx
	s_varadd_alvar		W,x,svar_word1,al_expposx
	s_achase_alvar		W,x,al_worldx,svar_word1,1

	s_copy_alvar2var	W,y,svar_word1,al_worldy
	s_varadd_alvar		W,x,svar_word1,al_expposy
	s_achase_alvar		W,x,al_worldy,svar_word1,1

	s_copy_alvar2var	W,y,svar_word1,al_worldz
	s_varadd_alvar		W,x,svar_word1,al_expposz
	s_achase_alvar		W,x,al_worldz,svar_word1,1

	s_achase_alvar2alvar		B,x,al_rotx,y,al_rotx,1
	s_achase_alvar2alvar		B,x,al_roty,y,al_roty,1



	
	a16
	phx
	lda	al_sword1,x
	tay
	lda.w	al_collobjptr,y	; ptr. to car
	tax
	ply
	lda.l	mrambank+OBJ_VELX,x
	REPT	dynshift-1
	asra
	ENDR
	adiv2
	sta.w	al_vx,y
	lda.l	mrambank+OBJ_VELY,x
	REPT	dynshift-1
	asra
	ENDR
	adiv2
	sta.w	al_vy,y
	lda.l	mrambank+OBJ_VELZ,x
	REPT	dynshift-1
	asra
	ENDR
	adiv2
	sta.w	al_vz,y
	tyx
	a8

	endc

	s_jmp_notalsflag	x,sflag1,.nwheel
	phx
	stz	svar_byte1
	stz	svar_byte2
	a16
	lda	al_sword1,x
	tay
	lda.w	al_collobjptr,y	; ptr. to car
	txy
	tax	
	a8
	jsr	wheelanim
	plx

.nwheel



.ns
	s_end_strat
	


;*****************************************************************************
car1_Istrat			; player car.
	s_start_strat
	stx	playpt


	lda	#1
	sta.l	m_particlesON
	sta.l	m_particlesON+1

;	s_set_alvar	W,x,al_worldx,#-20<<track_scale
	s_set_alvar	W,x,al_worldy,#-25<<track_scale
;	s_add_alvar	W,x,al_worldx,#4090
;	s_set_alvar	W,x,al_worldx,#-500
;	s_add_alvar	W,x,al_worldz,#5000


	jsl	makecar2_l

	s_set_strat	x,car1_strat

	s_set_var	W,viewpos_offx,#viewoffx
	s_set_var	W,viewpos_offy,#viewoffy
	s_set_var	W,viewpos_offz,#viewoffz

	s_set_var	W,viewtopos_offX,#0
	s_set_var	W,viewtopos_offZ,#100<<car_scale


	s_set_var	W,outdist,#2000
	s_set_var	W,outvz,#0


	jsl	makeviewobj_l
	s_set_alvar	W,y,al_viewpostab,#0
;	s_set_var	B,viewtype,#viewtype_fpos!viewtype_toobj
	s_set_var	B,viewtype,#viewtype_mia

	s_set_alvar	W,x,al_expshape,#car7_c08

	lda	#6
.vl	pha
	jsl	viewposition_behind_l
	pla
	dec	a
	bne	.vl

	jsl	makeeyes_l

;	jsl	makeboost_l

car1_strat
	s_start_strat


;	s_jmp_random	.nspark,40
;	jsl	makespark_l
;.nspark

	s_set_var	B,sound_selecter,#0

 	s_jmp_alsflag		x,sflag2,.nstrat

;	lda.l	m_mariokey
;	beq	.debug1
	jsl	carposition_l
	jsl	wheelpositions_l
.debug1


	jsl	carcontrol_l

;	jsl	updateeyes_l	
;	jsl	updateboost_l

	jsl	viewcontrol_l
.nstrat
	jsl	viewposition_behind_l


	a8
	s_end_strat


;*****************************************************************************
car2_Istrat			; enemy car.
	s_start_strat

	s_set_alvar	W,x,al_worldy,#-25<<track_scale
;	s_add_alvar	W,x,al_worldz,#5000
;	s_add_alvar	W,x,al_worldz,#13000
;	s_set_alvar	W,x,al_worldx,#500


	jsl	makecar1_l

	s_set_strat	x,car2_strat

	s_set_alvar2rnd	x,al_sbyte1,#15
	s_add_alvar	B,x,al_sbyte1,#50

	jsl	makeviewobj_l
	s_set_alvar	W,y,al_viewpostab,#viewpostablen


	lda	#6
.vl	pha
	jsl	viewposition_behind_l
	pla
	dec	a
	bne	.vl

	jsl	makeeyes_l

car2_strat
	s_start_strat

	s_set_var	B,sound_selecter,#1

;	lda.l	m_mariokey
;	beq	.debug1
	jsl	carposition_l
	jsl	wheelpositions_l
.debug1

	jsl	viewposition_behind_l

	a16
	lda	al_shadowobj,x
	sta	testvar1
	a8


	a16
	lda	cont0l
	pha
	lda	trig0
	pha
	lda	trig1
	sta	trig0
	lda	cont1l
	sta	cont0l
	a8

	jsl	carcontrol_l
;	jsl	check_remove_l

; make car stop after timer runs out.
;	s_beqdec_alvar	B,x,al_sbyte1,.makestop
;	bra	.nmakestop
;.makestop
;	a16
;	phx
;	lda	al_collobjptr,x
;	tax
;	lda.l	mrambank+CAR_FLAGS,x
;	ora	#CARflag_makestop
;	sta.l	mrambank+CAR_FLAGS,x
;	a8
;	plx
;	s_set_alsflag	x,sflag1		; smoke
;.nmakestop


	a16
	pla
	sta	trig0
	pla
	sta	cont0l
	a8

	s_set_var	B,sound_selecter,#0

	s_end_strat


check_remove_l
;	s_jmp_alvarZERO	B,x,al_sbyte1,.dorem
	ldy	playpt
	s_jmp_zdistmore		x,y,#8000,.dorem
	s_jmp_objinfront	x,y,.nbeh
	s_jmp_zdistless		x,y,#1500,.nbeh
.dorem
	ldy	al_vx,x
	s_set_strat	y,remove_Istrat
	ldy	al_vy,x
	s_set_strat	y,remove_Istrat
	ldy	al_vz,x
	s_set_strat	y,remove_Istrat
	ldy	al_weapontype,x
	s_set_strat	y,remove_Istrat
	ldy	al_shadowobj,x
	s_set_strat	y,remove_Istrat
	s_set_strat	x,remove_Istrat
.nbeh
	rtl



;*****************************************************************************
car3_Istrat
	s_start_strat

	jsl	makecar3_l

	s_set_strat	x,car3_strat
car3_strat
	s_start_strat

	jsl	carposition_l
	jsl	wheelpositions_l

	s_end_strat



;*****************************************************************************
makecar1_l
	s_clr_alsflag	x,realobj

;	s_set_alsflag	x,shadow

	s_clr_altype	x,zremove	

;	s_set_alsflag	x,trackobj

	a16
	lda	#cartype_ant&WM
	sta.l	m_dynvar1
	a8
	s_runmario		mmake_car
	a16
	lda.l	m_dynvar2
;	lda	#nullshape&wm
	sta	al_shape,x
	a8

	a16
	lda.l		m_dynvar1
	lbeq	gablink
	sta		al_collobjptr,x

	txy
	lda.l		m_dynvar1
	tax
	lda.w	al_worldx,y
	sta.l	mrambank+OBJ_WORLDX,x
	lda.w	al_worldy,y
	sta.l	mrambank+OBJ_WORLDY,x
	lda.w	al_worldz,y
	sta.l	mrambank+OBJ_WORLDZ,x

	lda.l		mrambank+CAR_FLAGS,x
;	ora		#CARflag_computer
	sta.l		mrambank+CAR_FLAGS,x

	tyx
	a8
	s_set_alvar	W,x,al_immuneptr,#car1col

	s_set_alvar	W,x,al_sword1,#40<<(car_scale+2)
	s_set_alvar	W,x,al_sword2,#55<<(car_scale+2)

	jsl		init_mobj_l

	a16
	lda.l	m_dynvar3
    	jsl	makewheels_l
	a8
	
	jsl	makeshadow_l


	s_set_alvar	B,x,al_livesleft,#numlives

	s_set_alvar	B,x,al_enginesnd,#enginesnd_normal

	rtl


;*****************************************************************************
makecar2_l
	s_clr_alsflag	x,realobj

;	s_set_alsflag	x,shadow

	s_clr_altype	x,zremove	

;	s_set_alsflag	x,trackobj

	a16
	lda	#cartype_fzero&WM
	sta.l	m_dynvar1
	a8
	s_runmario		mmake_car
	a16
	lda.l	m_dynvar2
	sta	al_shape,x
	a8


	a16
	lda.l		m_dynvar1
	lbeq	gablink
	sta		al_collobjptr,x

	txy
	lda.l		m_dynvar1
	tax
	lda.w	al_worldx,y
	sta.l	mrambank+OBJ_WORLDX,x
	lda.w	al_worldy,y
	sta.l	mrambank+OBJ_WORLDY,x
	lda.w	al_worldz,y
	sta.l	mrambank+OBJ_WORLDZ,x

	lda.l		mrambank+CAR_FLAGS,x
;	ora		#CARflag_computer
	sta.l		mrambank+CAR_FLAGS,x

	tyx
	a8

	s_set_alvar	W,x,al_immuneptr,#car1col

	s_set_alvar	W,x,al_sword1,#40<<(car_scale+2)
	s_set_alvar	W,x,al_sword2,#55<<(car_scale+2)

	jsl		init_mobj_l

	a16
	lda.l	m_dynvar3
    	jsl	makewheels_l
	a8

	jsl	makeshadow_l

	s_set_alvar	B,x,al_livesleft,#numlives

	s_set_alvar	B,x,al_enginesnd,#enginesnd_normal


	rtl
;*****************************************************************************
makeshadow_l	
	s_make_obj	#carshadow,.bad1
	a16
	tya
	sta	al_shadowobj,x
	lda	#0
	sta.w	al_collobjptr,y
	a8
	s_clr_alsflag		y,realobj
	s_clr_altype	y,zremove	
.bad1	rtl

;*****************************************************************************
makeviewobj_l
	s_make_obj	#nullshape,.bad1
	s_clr_alsflag		y,realobj
	s_clr_altype	y,zremove	
	a16
	tya
	sta	al_viewpt,x
	lda	viewpos_offz
	sta.w	al_worldz,y
	a8
.bad1	rtl


;*****************************************************************************
updateshadow_l
	s_set_objtobealvar	y,x,al_shadowobj
	cpy	#0
	beq	.bad

	lda	al_worldzh,x
	sta.w	al_worldzh,y

	s_set_alsflag	y,invisible
	s_jmp_alvarNOTZERO	B,x,al_expcount,.isinv
	s_jmp_alsflag	x,invisible,.isinv
	s_clr_alsflag	y,invisible
.isinv
	
	phx
	a16
	lda	al_collobjptr,x
	tax	
	lda.l	mrambank+OBJ_WORLDX,x
	sta.w	al_worldx,y	
	lda.l	mrambank+OBJ_WORLDZ,x
	sta.w	al_worldz,y	
	lda.l	mrambank+CAR_SHADOWY,x
	sta.w	al_worldy,y	
	a8
	lda.l	mrambank+OBJ_ROTX+1,x
	sta.w	al_rotx,y	
	lda.l	mrambank+OBJ_ROTY+1,x
	sta.w	al_roty,y	
	lda.l	mrambank+OBJ_ROTZ+1,x
	sta.w	al_rotz,y	
	plx

.bad
	rtl


;*****************************************************************************
makecar3_l
	s_clr_alsflag	x,realobj

	s_set_alsflag	x,shadow

	s_clr_altype	x,zremove	

	a16
	lda	#cartype_pickup2&WM
	sta.l	m_dynvar1
	a8
	s_runmario		mmake_car
	a16
	lda.l	m_dynvar2
	sta	al_shape,x
	a8


	a16
	lda.l		m_dynvar1
	lbeq	gablink
	sta		al_collobjptr,x

	txy
	lda.l		m_dynvar1
	tax
	lda.w	al_worldx,y
	sta.l	mrambank+OBJ_WORLDX,x
	lda.w	al_worldy,y
	sta.l	mrambank+OBJ_WORLDY,x
	lda.w	al_worldz,y
	sta.l	mrambank+OBJ_WORLDZ,x
	tyx
	a8

	s_set_alvar	W,x,al_immuneptr,#car1col

	s_set_alvar	W,x,al_sword1,#40<<(car_scale+2)
	s_set_alvar	W,x,al_sword2,#55<<(car_scale+2)

	jsl		init_mobj_l

	a16
	lda.l	m_dynvar3
    	jsl	makewheels_l
	a8

	rtl

;*****************************************************************************
	longa

makewheels_l	; uses al_vx,al_vy,al_vz,al_weapontype

	phx
	tax
;	ldx	#8	
	lda.l	wheel_defs,x	; shape
	sta	svar_word1
	lda.l	wheel_defs+2,x	; size
	sta	svar_word2
	plx

	a8

	IFEQ	0
	s_make_obj		svar_word1,.bad1
	IFEQ			poly_wheels
	s_sprite_obj		y,#0,svar_word2
	s_set_alvar		W,y,al_coltab,#wheel1_c&wm
	ENDC
	s_clr_alsflag		y,realobj
	s_set_alvartobeobj	x,al_vx,y
	s_set_alvar	W,y,al_expshape,#swheel2
	s_clr_altype	y,zremove	
.bad1
	s_make_obj		svar_word1,.bad2
	IFEQ			poly_wheels
	s_sprite_obj		y,#0,svar_word2
	s_set_alvar		W,y,al_coltab,#wheel1_c&wm
	ENDC
	s_clr_alsflag		y,realobj
	s_set_alvartobeobj	x,al_vy,y
	s_set_alvar	W,y,al_expshape,#swheel2
	s_clr_altype	y,zremove	
.bad2

	s_make_obj		svar_word1,.bad3
	IFEQ			poly_wheels
	s_sprite_obj		y,#0,svar_word2
	s_set_alvar		W,y,al_coltab,#wheel1_c&wm
	ENDC
	s_clr_alsflag		y,realobj
	s_set_alvartobeobj	x,al_vz,y
	s_set_alvar	W,y,al_expshape,#swheel2
	s_clr_altype	y,zremove	
.bad3

	s_make_obj		svar_word1,.bad4
	IFEQ			poly_wheels
	s_sprite_obj		y,#0,svar_word2
	s_set_alvar		W,y,al_coltab,#wheel1_c&wm
	ENDC
	s_clr_alsflag		y,realobj
	s_set_alvartobeobj	x,al_weapontype,y
	s_set_alvar	W,y,al_expshape,#swheel2
	s_clr_altype	y,zremove	
.bad4
	ENDC

	rtl
;*****************************************************************************

viewposition_top_l
	ldy	al_viewpt,x
	s_copy_alvar2alvar	W,y,al_worldx,x,al_worldx
	s_copy_alvar2alvar	W,y,al_worldy,x,al_worldy
	s_copy_alvar2alvar	W,y,al_worldz,x,al_worldz
	s_add_alvar		W,y,al_worldy,#-600<<car_scale
	rtl


viewposition_side_l
	ldy	al_viewpt,x
	s_copy_alvar2alvar	W,y,al_worldx,x,al_worldx
	s_copy_alvar2alvar	W,y,al_worldy,x,al_worldy
	s_copy_alvar2alvar	W,y,al_worldz,x,al_worldz
	s_add_alvar		W,y,al_worldy,#-100<<car_scale
	s_add_alvar		W,y,al_worldx,#-600<<car_scale
	rtl


viewposition_behind_l
	phx
	ldy	al_viewpt,x
	s_copy_alvar2alvar	W,y,al_worldx,x,al_worldx
	s_add_alvar		W,y,al_worldx,viewpos_offx
	s_copy_alvar2alvar	W,y,al_worldy,x,al_worldy
	s_add_alvar		W,y,al_worldy,viewpos_offy	

	a16
	lda	al_worldz,x
	sec
	sbc.w	al_worldz,y
	bmi	.resetpos
	clc
	adc	viewpos_offz		
	bmi	.stop
	clc
	adc.w	al_worldz,y
	sta.w	al_worldz,y
.stop
	jsl	copyviewpos_l

	shorta

	s_jmp_alsflag		x,sflag2,.gameover
	s_set_alvar		B,y,al_roty,#0
	s_set_alvar		B,y,al_rotx,#-deg11

.endview
	plx
	rtl

.gameover
	s_jmp_alvarmore		B,y,al_rotx,#-deg45+deg22,.nmake
	s_jmp_alsflag		x,sflag3,.nmake
	s_set_alsflag		x,sflag3
	jsr			makegameover
.nmake

	s_achase_alvar		B,y,al_rotx,#-deg45,3
	bra	.endview


.resetpos
	a16
	phx	
	lda	al_collobjptr,x	; ptr. to car
	tax
	lda	#0
	sta.l	mrambank+OBJ_VELX,x
	sta.l	mrambank+OBJ_VELY,x
	sta.l	mrambank+OBJ_ROTX,x
	sta.l	mrambank+OBJ_ROTY,x
	sta.l	mrambank+OBJ_ROTZ,x
	sta.l	mrambank+CAR_TORQUEX,x
	sta.l	mrambank+CAR_TORQUEY,x
	sta.l	mrambank+CAR_TORQUEZ,x
	sta.l	mrambank+CAR_ENGINEROTY,x
	lda	#500
	sta.l	mrambank+OBJ_VELZ,x
	plx
	a8
	bra	.endview

viewlag	=	6
copyviewpos_l	
	phx
	phy

	a16

; copy position.
	lda.w	al_worldx,y
	sta	svar_word1
	lda.w	al_worldy,y
	sta	svar_word2
	lda.w	al_worldz,y
	sta	svar_word3
	

	lda	al_viewpt,x
	tax
	phx
	lda	al_viewpostab,x
	tax	   
	lda	svar_word1
	sta.l	viewpositions,x
	lda	svar_word2
	sta.l	viewpositions+2,x	
	lda	svar_word3
	sta.l	viewpositions+4,x	

	ply

; scroll buffer down	
	txa
	clc
	adc	#6*viewlag	
	tax
	phx	
.loop
	lda.l	viewpositions,x
	sta.l	viewpositions+6,x
	lda.l	viewpositions+2,x
	sta.l	viewpositions+2+6,x
	lda.l	viewpositions+4,x
	sta.l	viewpositions+4+6,x
	txa
	sec
	sbc	#6
	tax
	bpl	.loop

	plx
; copy new position.
	lda.l	viewpositions+2,x
	sta.w	al_worldy,y

;	lda.l	viewpositions,x
;	sta.w	al_worldx,y

	lda.l	viewpositions+4,x
	clc
	adc	viewpos_offz
;	sta.w	al_worldz,y

	ply
	plx

	a8
	rtl




	phx
	a16	
	lda	al_collobjptr,x	; ptr. to car
	tax
	lda.l	mrambank+CAR_WHEELS,x
	tax
	lda.l	mrambank+OBJ_ROTY,x
	sta	svar_word1
	a8
	plx


	s_achase_var		W,outdist,#500<<car_scale,2

;	s_jmp_alsflag		x,sflag1,.chaseind
;	s_achase_var		W,outdist,#500<<car_scale,2
;	brl			.doned
;.chaseind
;	s_achase_var		W,outdist,#1250<<car_scale,2
;
;.doned
	s_copy_alvar2var	W,x,pviewposx,al_worldx
	s_copy_alvar2var	W,x,pviewposy,al_worldy
	s_copy_alvar2var	W,x,pviewposz,al_worldz

	a16
	lda			al_worldy,x
;	sec
;	sbc			#-25<<car_scale
;	jsl	perc87A_l
	clc
	adc			#-25<<car_scale
	sta			pviewposy
	a8

	lda	al_rotx,x
	bpl	.nlimx
	lda	#0
.nlimx
	nega
	a16
	xba
	and	#$ff00
	asra
	clc
	adc	#-10*256
	sec
	sbc	outvx
	asra
	asra
;	asra
	clc
	adc	outvx
	sta	outvx
	a8


	s_jmpNOT_alsflag	x,sflag1,.nfixedY
	s_achase_var		W,outvy,#0,3
	brl			.doneviewYrot
.nfixedY
	a16
	lda	svar_word1+1
	nega	
	xba
	and	#$ff00
	sec
	sbc	outvy
	asra
	asra
	asra
	clc
	adc	outvy
	sta	outvy
	a8
.doneviewYrot




;	s_set_var	W,outvx,#-10*256

	ifeq	1
	a16
	lda	al_rotx,x
	and	#$00ff
	xba
	sta		outvx
	lda	al_roty,x
	and	#$00ff
	xba
	sta		outvy
	lda	al_rotz,x
	and	#$00ff
	xba
	sta		outvz
	a8
	endc

	rtl

;*****************************************************************************
viewcontrol_l
	a8
	
	s_jmp_keyup	start,.nview
	s_jmp_lastkeydown	start,.nview
;	s_not_alsflag	x,sflag5
.nview


;	s_jmp_alsflag	x,sflag5,.1

	s_achase_var	W,viewpos_offx,#viewoffx,3
	s_achase_var	W,viewpos_offy,#viewoffy,3
	s_achase_var	W,viewpos_offz,#viewoffz,3

;	jmp	.2
.1
;	s_achase_var	W,viewpos_offy,#-50<<car_scale,3
;	s_achase_var	W,viewpos_offz,#350/2<<car_scale,3
.2


	rtl

	a16
	s_jmp_keyup	left,.nleft2
	lda		outvyoff
	clc
	adc		#2*256
;	sta		outvyoff
	
.nleft2

	s_jmp_keyup	right,.nright2
	lda		outvyoff
	sec
	sbc		#2*256
;	sta		outvyoff
.nright2

;	a8
;	s_jmp_nottrigkey	select,.nvd
;	s_not_alsflag	x,sflag2		; gameover
;	s_clr_alsflag	x,sflag3
;.nvd

	rtl	


;*****************************************************************************
carcontrol_l
	a8
	s_jmp_alvarZERO	B,x,al_livesleft,.nocontrol


	a16
	phx
	txy
	lda	al_collobjptr,x	; ptr. to car
	tax




;-------------------------------------------------------
; 

	ifeq	1
	s_jmp_keyup	select,.nviewmove

	s_jmp_keyup	jup,.nvup
	lda	viewpos_offy
	clc
	adc	#-10<<car_scale
	sta	viewpos_offy
.nvup
	s_jmp_keyup	jdown,.nvdown
	lda	viewpos_offy
	clc
	adc	#10<<car_scale
	sta	viewpos_offy
.nvdown


	s_jmp_keyup	jleft,.nvleft
	lda	viewpos_offx
	clc
	adc	#-10<<car_scale
	sta	viewpos_offx
.nvleft
	s_jmp_keyup	jright,.nvright
	lda	viewpos_offx
	clc
	adc	#10<<car_scale
	sta	viewpos_offx
.nvright


	s_jmp_keyup	x,.nvin
	lda	viewpos_offz
	clc
	adc	#-10<<car_scale
	sta	viewpos_offz
.nvin
	s_jmp_keyup	b,.nvout
	lda	viewpos_offz
	clc
	adc	#10<<car_scale
	sta	viewpos_offz
.nvout


    	lbra	.end
.nviewmove
	endc

	lda.l		mrambank+CAR_FLAGS,x
	and		#~(CARflag_steerleft!CARflag_steerright!CARflag_steerHardLeft!CARflag_steerHardRight!CARflag_accel!CARflag_deccel!CARflag_brake!CARflag_squish!CARflag_suck!CARflag_boost!CARflag_jump!CARflag_wheely)
	sta.l		mrambank+CAR_FLAGS,x

	s_jmp_keyup	jleft,.nleft
	lda.l		mrambank+CAR_FLAGS,x
	ora		#CARflag_steerleft
	sta.l		mrambank+CAR_FLAGS,x
	bra		.nright
.nleft
	s_jmp_keyup	jright,.nright
	lda.l		mrambank+CAR_FLAGS,x
	ora		#CARflag_steerright
	sta.l		mrambank+CAR_FLAGS,x
.nright
	s_jmp_keyup	left,.nhleft
	lda.l		mrambank+CAR_FLAGS,x
	ora		#CARflag_steerhardleft
	sta.l		mrambank+CAR_FLAGS,x
	bra		.nhright
.nhleft
	s_jmp_keyup	right,.nhright
	lda.l		mrambank+CAR_FLAGS,x
	ora		#CARflag_steerhardright
	sta.l		mrambank+CAR_FLAGS,x
.nhright


;----------------------------------------------
	s_jmp_keyup	b,.nspu
	lda.l		mrambank+CAR_FLAGS,x
	ora		#CARflag_boost
	sta.l		mrambank+CAR_FLAGS,x

	a8
	lda.w	al_eyesize,y
	cmp	#eyesprsize*2
	beq	.nwow
	se_liftcar
	lda	#eyesprsize*2
	sta.w	al_eyesize,y
.nwow
	a16
	bra	.dwow
.nspu
	a8
	lda	#eyesprsize
	sta.w	al_eyesize,y
	a16
.dwow

;----------------------------------------------


;	s_jmp_keyup	y,.nspb
;	lda.l		mrambank+CAR_FLAGS,x
;	ora		#CARflag_brake
;	sta.l		mrambank+CAR_FLAGS,x
;.nspb
	s_jmp_keyup	y,.nspr
	se_skidend
	lda.l		mrambank+CAR_FLAGS,x
	ora		#CARflag_brake
	ora		#CARflag_deccel
	sta.l		mrambank+CAR_FLAGS,x
.nspr
	s_jmp_keyup	a,.nboost
	lda.l		mrambank+CAR_FLAGS,x
	ora		#CARflag_accel
	sta.l		mrambank+CAR_FLAGS,x
.nboost
	s_jmp_keyup	x,.njump
	lda.l		mrambank+CAR_FLAGS,x
	ora		#CARflag_jump
	sta.l		mrambank+CAR_FLAGS,x
.njump


; squishing.
	s_jmp_keyup	jdown,.ndown
;	lda.l		mrambank+CAR_FLAGS,x
;	ora		#CARflag_squish
;	sta.l		mrambank+CAR_FLAGS,x
	lda.l		mrambank+CAR_FLAGS,x
	ora		#CARflag_wheely
	sta.l		mrambank+CAR_FLAGS,x
.ndown
	s_jmp_keyup	jup,.nup
	lda.l		mrambank+CAR_FLAGS,x
	ora		#CARflag_boost
	sta.l		mrambank+CAR_FLAGS,x


;	lda.l		mrambank+CAR_FLAGS,x
;	ora		#CARflag_suck
;	sta.l		mrambank+CAR_FLAGS,x
;	lda.l		mrambank+CAR_FLAGS,x
;	ora		#CARflag_squish
;	sta.l		mrambank+CAR_FLAGS,x

.nup



	ifeq	1
; gears
	lda.l		mrambank+CAR_FLAGS,x
	and		#~(CARflag_gearup!CARflag_geardown)
	sta.l		mrambank+CAR_FLAGS,x

	s_jmp_trigkeyup	a,.ngearup
	lda.l		mrambank+CAR_FLAGS,x
	ora		#CARflag_gearup
	sta.l		mrambank+CAR_FLAGS,x
.ngearup
	s_jmp_trigkeyup	y,.ngeardown
	lda.l		mrambank+CAR_FLAGS,x
	ora		#CARflag_geardown
	sta.l		mrambank+CAR_FLAGS,x
.ngeardown
	endc
	


	lda.l		mrambank+CAR_FLAGS,x
	and		#~CARflag_dynoff
	sta.l		mrambank+CAR_FLAGS,x


	ifeq	0
	s_jmp_keyup	start,.nreset

	lda.l		mrambank+CAR_FLAGS,x
	ora		#CARflag_dynoff
	sta.l		mrambank+CAR_FLAGS,x


	s_jmp_keyup	jup,.nlup
	lda.l		mrambank+OBJ_WORLDY,x
	clc
	adc		#-100
	sta.l		mrambank+OBJ_WORLDY,x

.nlup

	s_jmp_keyup	jdown,.nldn
	lda.l		mrambank+OBJ_WORLDY,x
	clc
	adc		#100
	sta.l		mrambank+OBJ_WORLDY,x

.nldn


	s_jmp_keyup	jleft,.nll
	lda.l		mrambank+OBJ_WORLDX,x
	sec
	sbc		#50
	sta.l		mrambank+OBJ_WORLDX,x

.nll

	s_jmp_keyup	jright,.nlr
	lda.l		mrambank+OBJ_WORLDX,x
	clc
	adc		#50
	sta.l		mrambank+OBJ_WORLDX,x
.nlr

	s_jmp_keyup	left,.nlrl
	lda.l		mrambank+OBJ_ROTY,x
	clc
	adc		#3*256
	sta.l		mrambank+OBJ_ROTY,x
.nlrl


	s_jmp_keyup	right,.nlrr
	lda.l		mrambank+OBJ_ROTY,x
	sec
	sbc		#3*256
	sta.l		mrambank+OBJ_ROTY,x
.nlrr






	lda	#0
	sta.l		mrambank+OBJ_VELX,x
	sta.l		mrambank+OBJ_VELY,x
	sta.l		mrambank+OBJ_VELZ,x
	sta.l		mrambank+CAR_TORQUEX,x
	sta.l		mrambank+CAR_TORQUEY,x
	sta.l		mrambank+CAR_TORQUEZ,x
;	sta.l		mrambank+CAR_ENGINEROTY,x
	sta.l		mrambank+OBJ_ROTX,x
;	sta.l		mrambank+OBJ_ROTY,x
	sta.l		mrambank+OBJ_ROTZ,x
.nreset

	endc


	IFEQ	1
	s_jmp_keyup	jup,.nup
	lda.l		mrambank+OBJ_ROTX,x
	clc
	adc		#8*256
	sta.l		mrambank+OBJ_ROTX,x
	lda	#0
	sta.l		mrambank+CAR_TORQUEX,x
	sta.l		mrambank+CAR_TORQUEY,x
	sta.l		mrambank+CAR_TORQUEZ,x
;	sta.l		mrambank+OBJ_ROTZ,x

.nup
	s_jmp_keyup	jdown,.ndown
	lda.l		mrambank+OBJ_ROTX,x
	sec
	sbc		#8*256
	sta.l		mrambank+OBJ_ROTX,x
	lda	#0
	sta.l		mrambank+CAR_TORQUEX,x
	sta.l		mrambank+CAR_TORQUEY,x
	sta.l		mrambank+CAR_TORQUEZ,x
;	sta.l		mrambank+OBJ_ROTZ,x
.ndown
	ENDC

.end
	a8

	plx

.nocontrol
	rtl

;*****************************************************************************
wheelpositions_l
	a8
	stx	tmp_carptr
	lda	al_expcount,x
	sta	tmp_expcnt

	lda	al_livesleft,x
	sta	tmp_livesleft

; copy wheel positions.
	a16
	lda	al_vx,x			
	sta	smvar_word1
	lda	al_vy,x			
	sta	smvar_word2
	lda	al_vz,x			
	sta	smvar_word3
	lda	al_weapontype,x			
	sta	smvar_word4
	lda	al_mapz,x
	sta	smvar_word5	



	phx

	lda	al_collobjptr,x	; ptr. to car
	tax
	lda.l	mrambank+OBJ_VELX,x
	REPT	dynshift-1
	asra
	ENDR
	adiv2
	sta	tmp_velx
	lda.l	mrambank+OBJ_VELY,x
	REPT	dynshift-1
	asra
	ENDR
	adiv2
	sta	tmp_vely
	lda.l	mrambank+OBJ_VELZ,x
	REPT	dynshift-1
	asra
	ENDR
	adiv2
	sta	tmp_velz


	a8
	lda.l	mrambank+OBJ_ROTX+1,x
	sta	svar_byte1
	lda.l	mrambank+OBJ_ROTZ+1,x
	sta	svar_byte2
	a16
	
	lda.l	mrambank+CAR_WHEELS,x
	tax
	ldy	smvar_word1
	jsr	dowheelpos

	lda.l	mrambank+WHL_NEXT,x
	tax
	ldy	smvar_word2
	jsr	dowheelpos

	lda.l	mrambank+WHL_NEXT,x
	tax
	ldy	smvar_word3
	jsr	dowheelpos

	lda.l	mrambank+WHL_NEXT,x
	tax
	ldy	smvar_word4
	jsr	dowheelpos

	a8
	plx
	rtl


;*****************************************************************************
dodynamics_l

;	s_jmp_keyup		a,.do
;	s_jmp_keyup		y,.skip
;	s_jmp_lastkeydown	y,.skip
;.do
;	s_runmario	mdo_dynamics
;.skip
	rtl
	

;*****************************************************************************
carposition_l
	a8
	s_jmp_keyup	select,.nhand
	jsl	makehand_l
.nhand


	lda	al_offroadtime,x
	beq	.nmstop
	bit	#3
	bne	.norsnd
	pha
	se_outofroadcount
	pla
.norsnd

	cmp	#100		; 110
	bne	.npickup
;	jsl	makehand_l
.npickup

	cmp	#101
	bmi	.nmax
	lda	#101
	sta	al_offroadtime,x
.nmax


	cmp	#60		; 64
	bmi	.nmstop

	a16
	phx
	lda	al_collobjptr,x
	tax
	lda.l	mrambank+CAR_FLAGS,x
	ora	#CARflag_makestop
;	sta.l	mrambank+CAR_FLAGS,x
	a8
	plx
	bra	.doneoffroad
.nmstop
	a16
	phx
	lda	al_collobjptr,x
	tax
	lda.l	mrambank+CAR_FLAGS,x
	and	#~CARflag_makestop
;	sta.l	mrambank+CAR_FLAGS,x
	a8
	plx

.doneoffroad

;---------------------------------------------------------
; make smoke, if needed.
	s_jmp_notalsflag	x,sflag1,.bad1
	s_jmp_random	.bad1,30
	s_make_obj	#carscaleshp,.bad1
	s_set_strat	y,smoke_Istrat
	s_copy_pos	y,x
	s_set_alvartobeobj	y,al_sword1,x
.bad1
;---------------------------------------------------------


	jsl	updateshadow_l


	phx
	txy
	a16
	lda	al_collobjptr,x	; ptr. to car
	tax

	lda.l	mrambank+CAR_ENGINEROTY,x
	sta	wheelroty

	lda.w	al_mapz,y
	xba
	and	#255
	sta.l	mrambank+OBJ_MAPZ,x

	lda.l	mrambank+CAR_OFFROAD,x
	a8
	beq	.ison
	cmp	#4
	beq	.isoff
	s_jmp_alvarNOTZERO	B,y,al_offroadtime,.isoff
.ison	s_set_alvar	B,y,al_offroadtime,#0
	bra	.doneoff
.isoff
	s_inc_alvar	B,y,al_offroadtime

.doneoff

	a8
	s_clr_alsflag	y,invisible
	a16

;	lda.l	mrambank+CAR_FLAGS,x
;	and	#CARflag_invisible
;	beq	.ninv
;	a8
;;	s_set_alsflag	y,invisible
;	a16
;.ninv
	

	lda.l	mrambank+CAR_FLAGS,x
	and	#CARflag_hitflash
	a8
	beq	.nhit
	s_set_alvar	B,y,al_ap,#7
.nhit	

	s_clr_alsflag	y,hitflash
	lda.w	al_ap,y
	beq	.nhitfl
	dec	a
	sta.w	al_ap,y
	and	#1
	beq	.nhitfl
	s_set_alsflag	y,hitflash
.nhitfl
	a8
	lda.l	mrambank+CAR_SKID+1,x
	cmp.l	mrambank+CAR_LASTSKID+1,x
	beq	.dskid
	sta.l	mrambank+CAR_LASTSKID+1,x

	cmp	#12
	bpl	.nss
	se_skidend
	bra	.dskid
.nss	
	cmp	#15
	bpl	.n1s
	se_skidlevel1
	bra	.dskid
.n1s
	cmp	#18
	bpl	.n2s
	se_skidlevel2
	bra	.dskid
.n2s
	cmp	#21
	bpl	.n3s
	se_skidlevel3
	bra	.dskid
.n3s
	se_skidlevel4
;	bra	.dskid
;.nskidsnd
;	lda.l	mrambank+CAR_LASTSKID+1,x
;	beq	.dskid
;.stopskid	
;	lda	#0
;	sta.l	mrambank+CAR_LASTSKID+1,x
.dskid

	a16


	
	lda.l	mrambank+OBJ_ROTX,x
;	asl	a
;	asl	a
	a8
	xba
	sta.w	al_rotx,y

	a16
	lda.l	mrambank+OBJ_ROTZ,x
;	asl	a
;	asl	a
	a8
	xba
	sta.w	al_rotz,y


	lda.l	mrambank+OBJ_ROTY+1,x
	sta.w	al_roty,y

	a16

	lda.l	mrambank+OBJ_WORLDX,x
	sta.w	al_worldx,y
	lda.l	mrambank+OBJ_WORLDY,x
	sta.w	al_worldy,y
	lda.l	mrambank+OBJ_WORLDZ,x
	sta.w	al_worldz,y



	ifeq	1
	lda.w	al_enginesnd,y
	and	#$ff
	cmp	#enginesnd_core
	beq	.nexpt
	s_jmp_keyup	start,.nexpt
	lda		#maxdamage+10
	sta.l		mrambank+CAR_TOTALDAMAGE,x
.nexpt
	endc

;-------------------------------------------------
; check if car should explode
	lda.l	mrambank+CAR_TOTALDAMAGE,x
	cmp	#smokedamage
	bmi	.ns	
	s_set_alsflag	y,sflag1
	lda.l	mrambank+CAR_TOTALDAMAGE,x
.nsmoke

	cmp	#maxdamage
	bmi	.ns
	a8
	s_set_alvar	B,y,al_expcount,#81
	phx
	tyx
	jsl	explode_car_l
	txy
	plx
	s_swap_alvars	W,y,al_shape,y,al_expshape
.ns
	a8
	s_jmp_alvarNOTZERO	B,y,al_livesleft,.ninvis
	s_set_alsflag		y,invisible
.ninvis
	s_beqdec_alvar	B,y,al_expcount,.nexp
	s_clr_alsflag	y,sflag1
	lda	#-1
	sta.l	mrambank+CAR_TOTALDAMAGE,x
	sta.l	mrambank+CAR_TOTALDAMAGE+1,x
	s_jmp_alvarNE	B,y,al_expcount,#1,.nbumpsnd
	s_swap_alvars	W,y,al_shape,y,al_expshape
	s_set_alvar	B,y,al_enginesnd,#enginesnd_normal
.nexp

;-------------------------------------------------

	a16
	lda.l	mrambank+CAR_FLAGS,x
	and	#CARflag_collide
	beq	.nbumpsnd
	se_bump
.nbumpsnd
	a16

	lda.l	mrambank+CAR_SIZEANIM,x
	sta	svar_word1
	plx
	a8
	s_init_anim	x,svar_word1
	
	rtl

	

;*****************************************************************************
dowheelpos
	

;----------------------------------------------------
; skid smoke
	phy
	a16

	lda	smvar_word5
	sta.w	al_mapz,y
	xba
	and	#255
	sta.l	mrambank+OBJ_MAPZ,x

	lda.l	mrambank+WHL_flags,x
	bit	#WHLflag_offroad
	beq	.nofrsmk
	bit	#WHLflag_rear
	beq	.donesmoke
	lda.l	mrambank+OBJ_WORLDY,x
	cmp	#-20
	bmi	.donesmoke		
	lda.l	mrambank+OBJ_VELX,x
	ora.l	mrambank+OBJ_VELZ,x
	adiv2
	beq	.donesmoke
	jsr	makepuff
	a16
	bcc	.donesmoke
	shorta
	s_set_strat	y,brownpuff_Istrat
	bra	.donesmoke
.nofrsmk
	longa
	bit	#WHLflag_ongnd
	beq	.donesmoke
	bit	#WHLflag_skid
	beq	.donesmoke
	jsr	makepuff
	bcc	.donesmoke
	shorta
	s_set_strat	y,whitepuff_Istrat
.donesmoke
	ply


	a8


;----------------------------------------------------

	s_jmp_varEQ	B,tmp_expcnt,#80,.doswap
	s_jmp_varNE	B,tmp_expcnt,#1,.noswap
.doswap
	s_swap_alvars	W,y,al_shape,y,al_expshape
.noswap

	s_clr_alsflag		y,invisible
	phx
	ldx	tmp_carptr
	s_jmp_NOTalsflag	x,invisible,.ninv
	s_set_alsflag	y,invisible
.ninv
	plx




	a16



	lda.l	mrambank+OBJ_WORLDX,x
	clc
	adc.l	mrambank+WHL_SPRINGX,x
;	clc
;	adc	tmp_velx
	sta.w	al_worldx,y

	lda.l	mrambank+OBJ_WORLDY,x
	sec
	sbc	#20<<car_scale
	clc
	adc.l	mrambank+WHL_SPRINGY,x
;	clc
;	adc	tmp_vely
	sta.w	al_worldy,y

	lda.l	mrambank+OBJ_WORLDZ,x
	clc
	adc.l	mrambank+WHL_SPRINGZ,x
;	clc
;	adc	tmp_velz
	sta.w	al_worldz,y


	jsr	wheelanim

	a16
	rts
	
	a8
objwheelanim
	txy
	stz	svar_byte1	   
	stz	svar_byte2	   
	stz	svar_byte4	   
	tyx
	bra	wheelanim_cont		


wheelanim
	a8
	lda.l	mrambank+OBJ_ROTY+1,x
	sta.w	al_roty,y		
	lda	svar_byte1
	sta.w	al_rotx,y		
	lda	svar_byte2
	sta.w	al_rotz,y		
	lda.l	mrambank+OBJ_ROTX+1,x
	sta	svar_byte4

wheelanim_cont

	IFEQ	poly_wheels	
	lda	viewrotY
	sta	svar_byte3

	lda.w	al_roty,y
	clc
	adc	svar_byte3
	phy
	phx
	i8
	lsr	a
	lsr	a
	tax
	lda.l	wheelyrot_tab,x
	sta	svar_byte3
	i16
	plx
	ply


	lda	svar_byte4
	and	#7
	cmp	#3
	bmi	.nad
	lda	svar_byte3
	clc
	adc	#32
	sta	svar_byte3
.nad	
 	s_init_colanim	y,svar_byte3

	ELSEIF

	lda	svar_byte4
	nega
	and	#15
	sta	svar_byte3
	s_init_anim	y,svar_byte3
	ENDC
	rts


	shorta

whlrotf1	MACRO
	db	\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G
	ENDM

wheelyrot_tab
	whlrotf1	15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0				       			; 0-90 deg
	whlrotf1	16+15,16+14,16+13,16+12,16+11,16+10,16+9,16+8,16+7,16+6,16+5,16+4,16+3,16+2,16+1,16+0				       			; 0-90 deg

	whlrotf1	15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0				       			; 0-90 deg
	whlrotf1	16+15,16+14,16+13,16+12,16+11,16+10,16+9,16+8,16+7,16+6,16+5,16+4,16+3,16+2,16+1,16+0				       			; 0-90 deg
;	whlrotf1	0+16,1+16,2+16,3+16,4+16,5+16,6+16,7+16,8+16,9+16,10+16,11+16,12+16,13+16,14+16,15+16	; 270-360 deg

;	whlrotf1	0+16,1+16,2+16,3+16,4+16,5+16,6+16,7+16,8+16,9+16,10+16,11+16,12+16,13+16,14+16,15+16	; 90-180 deg
	whlrotf1	15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0				       			; 180-270 deg




;*****************************************************************************
gndanim_Istrat			; stay on 1 frame. 
	s_start_strat
	lda	al_sbyte2,x
	sta	svar_byte1
	s_init_anim	x,svar_byte1
	s_brl	gnd_Istrat


;*****************************************************************************
gndanimup_Istrat		; 0-max ; al_sbyte2=speed
	s_start_strat
	s_set_strat	x,gndanimup_strat
	s_init_anim	x,#0
	s_brl	gnd_Icont
gndanimup_strat
	s_start_strat

	s_inc_alvar	B,x,al_sbyte3
	lda		al_sbyte3,x
	cmp		al_sbyte2,x
	bne		.nnewf
	stz		al_sbyte3,x

	lda	al_sbyte1,x
	sta	svar_byte1
	s_add_anim	x,#1,svar_byte1
.nnewf	brl		gndanim_cont

;*****************************************************************************
gndanimdown_Istrat		; max-0 ; al_sbyte2=speed
	s_start_strat
	s_set_strat	x,gndanimdown_strat
	lda	al_sbyte1,x
	dec	a
	sta	svar_byte1
	s_init_anim	x,svar_byte1
	s_brl	gnd_Icont
gndanimdown_strat
	s_start_strat

	s_inc_alvar	B,x,al_sbyte3
	lda		al_sbyte3,x
	cmp		al_sbyte2,x
	bne		.nnewf
	stz		al_sbyte3,x

	lda	al_sbyte1,x
	sta	svar_byte1
	s_add_anim	x,#-1,svar_byte1
.nnewf	brl		gndanim_cont


;*****************************************************************************
gndanimbounce_Istrat		; max-0-max ; al_sbyte2=speed ; al_sbyte3= wait time
	s_start_strat
	s_set_strat	x,gndanimbounce_strat
	s_init_anim	x,#0
	lda	al_sbyte3,x
	sta	al_vx,x
	s_brl	gnd_Icont
gndanimbounce_strat
	s_start_strat
	lda	al_vx,x
	beq	.nw
	dec	al_vx,x
	bra	.nnewf
.nw
	lda	al_vy,x
	sta	svar_byte1
	s_init_anim	x,svar_byte1

	lda		al_sbyte1,x		
	sta		svar_byte1
	dec	a
	sta		svar_byte2
 
	s_inc_alvar	B,x,al_sbyte4
	lda		al_sbyte4,x
	cmp		al_sbyte2,x
	bne		.nnewf
	stz		al_sbyte4,x
	
	s_jmp_alsflag	x,sflag1,.nup
	s_cmp_anim	x,svar_byte2
	beq		.chg
.ncd
	s_inc_alvar	B,x,al_vy
;	s_add_anim	x,#1,svar_byte1
	bra		.newf
.nup
	s_cmp_anim	x,#0
	beq		.chg
.ncu	
	s_dec_alvar	B,x,al_vy
;	s_add_anim	x,#-1,svar_byte1

.newf
	
.nnewf	brl		gndanim_cont


.chg	s_not_alsflag	x,sflag1
	lda	al_sbyte3,x
	sta	al_vx,x
	bra	.nnewf


;*****************************************************************************
gndanim_cont
	txy
	a16
	lda    	al_collobjptr,x
	tax
	lda.w	al_animframe,y
	and	#127
	sta.l	mrambank+OBJ_FRAME,x
	tyx
	a8
	s_jmp	gnd_strat


;*****************************************************************************
gnd_Istrat
	s_start_strat
	s_set_alptrs		x,gnd_strat,0,0
	

gnd_Icont

	s_runmario		mmake_roadobj

	a16
	lda		al_shape,x
	sta		al_immuneptr,x
	lda.l		m_dynvar1
	lbeq		gablink
	sta		al_collobjptr,x
	a8

	jsl		init_mobj_l

	s_set_altype		x,gnd
	s_set_alsflag		x,colldisable		
	s_set_alsflag		x,trackobj
;	s_clr_altype	x,zremove	
	s_end_strat


gnd_strat
	s_start_strat

	s_clr_alsflag	x,hitflash
	txy
	a16
	lda		al_collobjptr,x
	tax
	lda.l		mrambank+TOBJ_FLAGS,x
	sta		svar_word1
	and		#TOBJflag_hitflash
	beq		.nhitf
	a8
	s_set_alsflag	y,hitflash
	a16
.nhitf
	lda		svar_word1
	and		#~TOBJflag_hitflash
	sta.l		mrambank+TOBJ_FLAGS,x
	a8

	tyx	
	s_end_strat



;*****************************************************************************
gndobj_Istrat
	s_start_strat
	s_set_alptrs		x,gndobj_strat,0,0
gndobj_Icont

	s_runmario		mmake_tobj

	a16
	lda		al_shape,x
	sta		al_immuneptr,x
	lda.l		m_dynvar1
	lbeq	gablink
	sta		al_collobjptr,x
	a8

	jsl		init_mobj_l

	s_set_altype		x,gnd
	s_set_alsflag		x,colldisable		
;	s_set_alsflag		x,trackobj
;	s_clr_altype	x,zremove	
	s_end_strat


gndobj_strat
	a16
	txy
	lda.w	al_collobjptr,y
	tax
	lda.l	mrambank+OBJ_WORLDX,x
	sta.w	al_worldx,y
	lda.l	mrambank+OBJ_WORLDY,x
	sta.w	al_worldy,y
	lda.l	mrambank+OBJ_WORLDZ,x
	sta.w	al_worldz,y
	tyx
	a8
	
	s_end_strat

;*****************************************************************************
spin1_Istrat
	s_start_strat
	s_init_colanim	x,#0
	s_set_alvar	B,x,al_roty,#48
	bra	spin_Icont
spin2_Istrat
	s_start_strat
	s_init_colanim	x,#1
	s_set_alvar	B,x,al_roty,#32
	bra	spin_Icont
spin3_Istrat
	s_start_strat
	s_init_colanim	x,#2
	s_set_alvar	B,x,al_roty,#16
	bra	spin_Icont
spin4_Istrat
	s_start_strat
	s_init_colanim	x,#3

spin_Icont
	s_start_strat
	s_set_strat	x,spin_strat
spin_strat
	s_start_strat
	s_add_alvar	B,x,al_roty,#8
	s_end_strat


;*****************************************************************************
markobj_Istrat
	s_start_strat
	s_set_alptrs		x,gndobj_strat,0,0

	s_runmario		mmake_markobj

	a16
	lda		#0
	sta		al_immuneptr,x
	lda.l		m_dynvar1
	lbeq	gablink
	sta		al_collobjptr,x
	a8

	jsl		init_mobj_l

;	s_set_altype		x,gnd
	s_set_alsflag		x,colldisable		
;	s_set_alsflag		x,trackobj
;	s_clr_altype	x,zremove	
	s_end_strat


;*****************************************************************************
makepuff
	a8
	phx
	tyx
;	jmp	.bad1
	s_jmp_random	.bad1,30
	s_make_obj	#carscaleshp,.bad1
	s_copy_pos	y,x
	s_set_alvar	W,y,al_sword1,tmp_carptr
	plx
	sec
	rts
.bad1
	plx
	clc
	rts
	

brownpuff_Istrat
	s_start_strat
	s_set_alvar	W,x,al_coltab,#brownpuff_c&wm
	s_sprite_obj	x,#0,#20
	s_jmp		puff_Icont

whitepuff_Istrat
	s_start_strat
	s_set_alvar	W,x,al_coltab,#whitepuff_c&wm
	s_sprite_obj	x,#0,#10
puff_Icont
	s_set_strat	x,puff_strat
	s_set_alvar	B,x,al_sbyte1,#0
	s_set_alsflag	x,sflag1
	s_add_alvar	W,x,al_worldy,#50
	s_jmp		smoke_Icont

smoke_Istrat
	s_start_strat
	s_set_strat	x,smoke_strat
	s_set_alvar	B,x,al_sbyte1,#0
	s_set_var2rnd	svar_word1,#15
	s_add_var	W,svar_word1,#smokezoff

	s_set_alvar	W,x,al_coltab,#smoke_c&wm
	s_sprite_obj	x,#0,#10

	ldy		al_sword1,x
	s_add_Roffs2pos		B,x,x,y,#0,#0,svar_word1,1,1,0,car_scale,car_scale,car_scale

smoke_Icont

	ldy		al_sword1,x
	a16
	lda.w	al_collobjptr,y	; ptr. to car
	txy
	tax
	lda.l	mrambank+OBJ_VELX,x
	rept	dynshift+1
	asra
	endr
	sta.w	al_vx,y	

	lda.l	mrambank+OBJ_VELZ,x
	rept	dynshift+1
	asra
	endr
	sta.w	al_vz,y	

	tyx
	a8


smoke_strat
	s_start_strat

	s_add_alvar	W,x,al_worldy,#-20
	s_copy_alvar2var	B,x,svar_byte1,al_sbyte1
	s_init_colanim	x,svar_byte1
	s_jmp_alvareq	B,x,al_sbyte1,#6,remove_Istrat
	s_inc_alvar	B,x,al_sbyte1

	s_add_vecs2pos	x
	s_end_strat


puff_strat
	s_start_strat

	s_copy_alvar2var	B,x,svar_byte1,al_sbyte1
	s_init_colanim	x,svar_byte1
	s_jmp_alvareq	B,x,al_sbyte1,#4,remove_Istrat
	s_inc_alvar	B,x,al_sbyte1

	s_add_vecs2pos	x
	s_end_strat


;*****************************************************************************
tree_Istrat	
	s_start_strat
	s_add_alvar	W,x,al_worldy,#-120
	
	s_sprite_obj	x,#0,#40
	s_set_alvar	W,x,al_coltab,#treestump_c&wm

	s_make_obj	#tree,.bad1
	s_sprite_obj	y,#0,#80
	s_set_alvar	W,y,al_coltab,#treetop_c&wm
	s_copy_pos	y,x
	s_add_alvar	W,y,al_worldy,#-320
.bad1

	s_set_strat	x,0
	s_end_strat	
;*****************************************************************************
bush1_Istrat
	s_set_alvar	W,x,al_coltab,#bush1_c&wm
	s_add_alvar	W,x,al_worldy,#-30
	bra	sprite_Icont
redtyres_Istrat
	s_set_alvar	W,x,al_coltab,#redtyres_c&wm
	bra	tyres_Icont
whitetyres_Istrat
	s_set_alvar	W,x,al_coltab,#whitetyres_c&wm
	bra	tyres_Icont
tyres_Icont
	s_add_alvar	W,x,al_worldy,#-100
sprite_Icont
	s_sprite_obj	x,#0,#20
	s_set_strat	x,0
	s_end_strat

;*****************************************************************************
truckwheel	MACRO
	s_make_obj	#bwheel2,.bad\@
	s_copy_pos	y,x
	s_add_2pos	y,#\1,#\2,#\3
	s_set_strat	y,\4_strat
	s_copy_rots	y,x
	s_sprite_obj	y,#0,#\5whlsprsize
	s_set_alvar	W,y,al_coltab,#wheel1_c&wm
.bad\@
	ENDM

;*****************************************************************************
truck1_Istrat
	s_start_strat
	s_add_alvar	W,x,al_worldy,#-100

	s_set_alvar	W,x,al_shape,#trk_1_1
	s_Set_alvar	B,x,al_roty,#deg90

	s_make_obj	#trk_1_2,.bad1
	s_copy_pos	y,x
	s_add_alvar	W,y,al_worldx,#700
	s_Set_alvar	B,y,al_roty,#deg90
	s_set_strat	y,truck1_strat
.bad1

	truckwheel	50,30,100,truck1whl,big
	truckwheel	50,30,-100,truck1whl,big

	truckwheel	900,30,100,truck1whl,big
	truckwheel	900,30,-100,truck1whl,big

	s_set_strat	x,truck1_strat
truck1_strat
	s_start_strat
	s_add_alvar	W,x,al_worldx,#-50
	s_end_strat


truck1whl_strat
	jsr	objwheelanim
	bra	truck1_strat


objcar1_Istrat
	s_start_strat
	s_add_alvar	W,x,al_worldy,#-50
	s_set_alvar	B,x,al_roty,#-deg90
	truckwheel	100,15,50,objcar1
	truckwheel	100,15,-50,objcar1
	truckwheel	-100,15,50,objcar1
	truckwheel	-100,15,-50,objcar1
	s_set_strat	x,objcar1_strat

objcar1_strat
	s_start_strat
	jsr	objwheelanim
	s_end_strat



;*****************************************************************************





; REPT RE_LOAD COMMENT
; REPT RE_LOAD COMMENT
; REPT RE_LOAD COMMENT
; REPT RE_LOAD COMMENT
; REPT RE_LOAD COMMENT
; REPT RE_LOAD COMMENT
; REPT RE_LOAD COMMENT
; REPT RE_LOAD COMMENT
; REPT RE_LOAD COMMENT
; REPT RE_LOAD COMMENT
; REPT RE_LOAD COMMENT
;*****************************************************************************
init_mvels_l
	a16
	txy
	lda		al_collobjptr,x
	tax
	lda.w		al_vx,y
	rept		dynshift
	asl	a
	endr	
	sta.l		mrambank+OBJ_VELX,x
	lda.w		al_vy,y
	rept		dynshift
	asl	a
	endr	
	sta.l		mrambank+OBJ_VELY,x
	lda.w		al_vz,y
	rept		dynshift
	asl	a
	endr	
	sta.l		mrambank+OBJ_VELZ,x
	tyx
	rtl

init_mobj_l
	a16
	txy
	lda		al_collobjptr,x
	tax
	lda.w		al_sword1,y
	sta.l		mrambank+OBJ_RADX,x
	lda.w		al_sword2,y
	sta.l		mrambank+OBJ_RADZ,x
	lda.w		al_immuneptr,y
	sta.l		mrambank+OBJ_COLLSHAPE,x
	lda.w		al_worldx,y
	sta.l		mrambank+OBJ_WORLDX,x
	lda.w		al_worldy,y
	sta.l		mrambank+OBJ_WORLDY,x
	lda.w		al_worldz,y
	sta.l		mrambank+OBJ_WORLDZ,x

	lda.w		al_animframe,y
	and		#127
	sta.l		mrambank+OBJ_FRAME,x
	lda.w		al_mapz,y
	xba
	and	#255
	sta.l		mrambank+OBJ_MAPZ,x
	a8
	tyx
          	rtl

copy_postomobj_l
	a16
	txy
	lda		al_collobjptr,x
	tax
	lda.w		al_worldx,y
	sta.l		mrambank+OBJ_WORLDX,x
	lda.w		al_worldy,y
	sta.l		mrambank+OBJ_WORLDY,x
	lda.w		al_worldz,y
	sta.l		mrambank+OBJ_WORLDZ,x
	tyx
	a8
	rtl


;*****************************************************************************
; makegameover - make game over objects.
;
; entry: a8i16
;	x - ptr. to car
;	y - ptr. to view object
;
; exit: same


makegoobj	MACRO
	s_make_obj		#\1,.bad1\@
	s_set_strat		y,gameover_Istrat
	s_set_vecs		y,#\2,#1000,#\4
	s_set_alvar		W,y,al_sword2,#\3
	s_set_alvartobeobj	y,al_sword1,x
	s_set_alvar		B,y,al_roty,#-\5*4
.bad1\@
	ENDM

makegameover
	phx
	phy
	tyx

	makegoobj	go_0,-450,-900,6000,0
	makegoobj	go_1,-150,-900,6000,1
	makegoobj	go_2,150,-900,6000,2
	makegoobj	go_3,450,-900,6000,3

	makegoobj	go_4,-450,-400,6000,4
	makegoobj	go_5,-150,-400,6000,5
	makegoobj	go_3,150,-400,6000,6
	makegoobj	go_6,450,-400,6000,7


	ply
	plx
	rts



;*****************************************************************************
gameover_Istrat
	s_start_strat
	s_set_strat	x,.strat1
	s_clr_altype	x,zremove
	s_set_alvar2rnd	x,al_rotx

.strat1
	s_start_strat	
	s_achase_alvar		B,x,al_rotx,#0,4
	s_add_alvar		B,x,al_roty,#8
	s_set_objtobealvar	y,x,al_sword1
	s_copy_pos		x,y
	s_add_vecs2pos		x
	s_achase_alvar2alvar	W,x,al_vy,x,al_sword2,3
	s_achase_alvar		W,x,al_vz,#1500,3
	s_end_strat

;*****************************************************************************
gate_Istrat
	s_start_strat

	s_jmp_alsflag		x,sflag1,.ninc
	s_set_objtobevar	y,playpt
	a16
	lda.w	al_worldz,y
	sec
	sbc	al_worldz,x
	bpl	.ok
	nega
.ok
	cmp	#500
	a8
	bpl	.ninc
	lda.w	al_lapcnt,y
	inc	a
	sta.w	al_lapcnt,y
	cmp	#1
	beq	.first
;	se_checkline
	bra	.dsnd
.first 	
;	se_startrace
.dsnd

	s_set_alsflag	x,sflag1

	
.ninc
	s_end_strat

	

;*****************************************************************************
handxspeed	equ	128		64
handyspeed	equ	128		32
handzspeed	equ	128		100

inithandspeed	MACRO
	s_set_alvar	W,x,al_vx,#0
	s_set_alvar	W,x,al_vy,#0
	s_set_alvar	W,x,al_vz,#0
	ENDM
	


makehand_l
	a8
	s_jmp_alsflag	x,sflag4,.bad1

	a16
	phx
	lda	al_collobjptr,x
	tax
	lda.l	mrambank+CAR_HANDOBJ,x
	lbne	.badhand	
	a8
	plx	


	s_make_obj	#handshape,.bad1

	s_set_alsflag	x,sflag4
	s_copy_pos	y,x
	s_add_alvar	W,y,al_worldy,#-500
	s_add_alvar	W,y,al_worldz,#1000
	s_sprite_obj	y,#0,#0
	s_set_alvar	W,y,al_coltab,#hand_c&wm
	s_set_strat	y,hand_Istrat
	s_copy_alvar2alvar	W,y,al_sword1,x,al_collobjptr
	s_runmario		mmake_handobj
	s_clr_altype	y,zremove
	a16
	lda.l	m_dynvar1
	lbeq	gablink
	sta.w	al_collobjptr,y
	a8
	s_set_alvar	W,y,al_expposx,svar_word1
	s_set_alvartobeobj	y,al_sword2,x
.bad1
	rtl

.badhand
	a8
	plx
	rtl


	
;-----------------------------------------------------------------	
hand_Istrat
	s_start_strat	
	s_set_strat	x,handget_strat
	s_init_colanim		x,#1

handget_strat
	s_start_strat	
	s_set_objtobealvar	y,x,al_sword2
	s_copy_alvar2var	W,y,svar_word1,al_worldx
	s_copy_alvar2var	W,y,svar_word2,al_worldy
	s_copy_alvar2var	W,y,svar_word3,al_worldz

	jsr	handgoto
	bcc	.nthere
	s_set_strat	x,handpickup_Istrat
	phx
	a16
	lda	al_sword1,x    		; ptr. to MARIO car
	ldy	al_collobjptr,x
	tax
	tya
	sta.l	mrambank+CAR_HANDOBJ,x
	a8
	plx	
	s_init_colanim		x,#2
	ldy	al_sword2,x		; ptr. to car.
	cpy	playpt
	bne	.nthere
	stx	viewtoobj
	s_set_var	W,viewpos_offy,#0
.nthere

handend	

	s_set_objtobealvar	y,x,al_sword2

	phx
	a16
	lda	al_sword1,x    		; ptr. to MARIO car
	tax
	lda.l	mrambank+CAR_GNDSPEED,x
	cmp	#100
	a8
	bmi	.nrem
	plx
	s_set_strat		x,handrem_strat
	s_set_alvar		B,x,al_sbyte1,#40
	bra	handend2
.nrem
	plx

handend2
	jsl	copy_postomobj_l
	s_end_strat

;-----------------------------------------------------------------	
handpickup_Istrat
	s_start_strat
	inithandspeed
	se_liftcar
	txy
	phx
	a16
	lda	al_sword1,x
	tax
	lda.l	mrambank+CAR_NEARMARKER,x
	tax
	lda.l	mrambank+OBJ_WORLDX,x
	sta.w	al_expposx,y
	lda.l	mrambank+OBJ_WORLDY,x
	clc
	adc	#-500
	sta.w	al_expposy,y
	lda.l	mrambank+OBJ_WORLDZ,x
	sta.w	al_expposz,y
	a8
	plx

	s_set_strat	x,handpickup_strat

handpickup_strat
	s_start_strat
	s_init_colanim		x,#2
	
	s_copy_alvar2var	W,x,svar_word1,al_expposx
	s_copy_alvar2var	W,x,svar_word2,al_expposy
	s_copy_alvar2var	W,x,svar_word3,al_expposz

	jsr	handgotoup
	bcc	.nthere			
	s_set_alvar	B,x,al_sbyte1,#5
	s_set_strat	x,handwait_strat
.nthere
	s_jmp		handend2
	
;-----------------------------------------------------------------	
handwait_strat
;	s_decbne_alvar	B,x,al_sbyte1,handend2
	phx
	a16
	lda	al_sword1,x
	tax
	lda	#0
	sta.l	mrambank+CAR_HANDOBJ,x

	lda.l	mrambank+CAR_FLAGS,x
	and	#~CARflag_makestop
	sta.l	mrambank+CAR_FLAGS,x

	a8
	plx	
	s_init_colanim		x,#1
	s_set_strat		x,handrem_strat
	s_set_alvar		B,x,al_sbyte1,#40
	
	s_set_objtobealvar	y,x,al_sword2
	cpy	playpt
	bne	.nplayer
	sty	viewtoobj
	s_set_var	W,viewpos_offy,#-100<<car_scale	
.nplayer


handrem_strat
	s_start_strat
	s_add_alvar	W,x,al_worldy,#-handyspeed
	s_beqdec_alvar	B,x,al_sbyte1,removehand
	jsl	copy_postomobj_l
	s_end_strat

removehand
	s_set_objtobealvar	y,x,al_sword2
	s_clr_alsflag	y,sflag4
          	s_jmp	remove_Istrat







;-----------------------------------------------------------------	
handspeed	equ	128
handaccel	equ	8
gethandspeed	MACRO
	a16
	lda	svar_word\2
	sec
	sbc	al_world\1,x

	cmp	#handspeed*8
	bmi	.less\@
	lda	#handspeed*8
	bra	.more\@
.less\@	
	cmp	#-handspeed*8
	bpl	.more\@
	lda	#-handspeed*8
.more\@	

	asra
	asra
;	asra
	adiv2

	sec
	sbc	al_v\1,x
;	sta	smvar_word1
	beq	.done\@
	bpl	.add\@
	s_sub_alvar	W,x,al_v\1,#handaccel	
	bra	.done2\@
.add\@
	s_add_alvar	W,x,al_v\1,#handaccel	
.done2\@
;	a16
;	lda	smvar_word1
;	bpl	.nn\@
;	nega
;.nn\@
;	cmp	#handaccel
;	bpl	.done\@
;	lda	smvar_word1
;	clc
;	adc	al_v\1,x	
;	sta	al_v\1,x	
.done\@


	a16
	lda	al_v\1,x
	bne	.nthere\@
	iny
.nthere\@


	a8
	ENDM

;-----------------------------------------------------------------	
handgotoup
	s_set_var	B,svar_byte1,#1
	bra	handgoto_cont
handgoto
	s_set_var	B,svar_byte1,#0
handgoto_cont
	s_add_var	W,svar_word1,#30
	s_add_var	W,svar_word2,#-110

	ldy	#0


	gethandspeed	y,2
	s_jmp_varZERO	B,svar_byte1,.ny
	cpy	#1
	lbne	.nthere
.ny
	gethandspeed	x,1
	gethandspeed	z,3


	cpy	#3
	bne	.nthere
	sec
	rts
.nthere
	s_add_vecs2pos	x
	clc
	rts




handctrl
	a16
	lda	cont0l
	pha
	lda	trig0
	pha
	lda	trig1
	sta	trig0
	lda	cont1l
	sta	cont0l
	a8

	s_jmp_keyup	jup,.nlup
	s_add_alvar	W,x,al_worldy,#-25
.nlup

	s_jmp_keyup	jdown,.nldn
	s_add_alvar	W,x,al_worldy,#25
.nldn


	s_jmp_keyup	jleft,.nll
	s_add_alvar	W,x,al_worldx,#-25

.nll

	s_jmp_keyup	jright,.nlr
	s_add_alvar	W,x,al_worldx,#25
.nlr

.nctrl

	a16
	pla
	sta	trig0
	pla
	sta	cont0l
	a8

	rts

;*****************************************************************************
makeeyes_l
	s_make_obj	#carscaleshp,.bad1
	s_set_alvar	W,y,al_vx,#-30
	s_set_alvar	W,y,al_vy,#-20
	s_set_alvar	W,y,al_vz,#45
	s_sprite_obj	y,#0,#eyesprsize
	s_set_alvar	W,y,al_coltab,#eyes1_c&wm
	s_clr_alsflag	y,realobj
	s_clr_altype	y,zremove	
	s_set_strat	y,eye_strat
	s_set_alvartobeobj	y,al_sword1,x
.bad1

	s_make_obj	#carscaleshp,.bad2
	s_set_alvar	W,y,al_vx,#30
	s_set_alvar	W,y,al_vy,#-20
	s_set_alvar	W,y,al_vz,#45
	s_sprite_obj	y,#0,#eyesprsize
	s_set_alvar	W,y,al_coltab,#eyes1_c&wm
	s_clr_alsflag	y,realobj
	s_clr_altype	y,zremove	
	s_set_strat	y,eye_strat
	s_set_alvartobeobj	y,al_sword1,x
.bad2
	s_set_alvar	B,x,al_eyesize,#eyesprsize

	rtl

;*****************************************************************************
eye_strat
	s_start_strat
	s_set_objtobealvar	y,x,al_sword1
	phx
	tyx
	ply
	jsr	updateeye
	tyx
	s_end_strat	


updateeye
	lda	al_eyesize,x
	sta.w	al_tx,y

	lda	al_worldzh,x
	sta.w	al_worldzh,y

	lda	wheelroty+1
	asl	a
	clc
	adc	al_roty,x
	clc
	adc	viewrotY
	phx
	phy
	i8
	lsr	a
	lsr	a
	lsr	a
	tax
	lda.l	eyerot_tab,x
	sta	svar_byte1
	i16
	ply
	plx

	a16
	lda.w	al_vx,y	
	sta	svar_word1
	lda.w	al_vy,y	
	sta	svar_word2
	lda.w	al_vz,y	
	sta	svar_word3	
	a8
	s_add_Roffs2pos		B,y,x,x,svar_word1,svar_word2,svar_word3,1,1,1,car_scale,car_scale,car_scale
	
	s_init_colanim	y,svar_byte1

	rts	

eyerot_tab
	db	6,6,5,5,4,4,3,3
	db	2,2,1,1,0,0,0,0
	db	0,0,11,11,10,10,9,9
	db	8,8,7,7,6,6,6,6

;*****************************************************************************
makespark_l
	s_make_obj	#wheel3,.bad1
;	s_particle_data	y,3,2,10
	s_set_strat	y,spark_Istrat
	s_set_alvartobeobj	y,al_sword1,x
	lda	al_worldzh,x
	sta.w	al_worldzh,y
	s_clr_alsflag		y,realobj
	s_clr_altype	y,zremove	
.bad1
	rtl


spark_Istrat
	s_start_strat
	s_set_alvar	B,x,al_sbyte4,#10
	s_set_strat	x,spark_strat
spark_strat
	s_start_strat
	s_set_objtobealvar	y,x,al_sword1
	lda.w	al_worldzh,y
	sta	al_worldzh,x
	s_add_Roffs2pos	B,x,y,y,#0,#-20,#smokezoff,1,1,0,car_scale,car_scale,car_scale
;	s_particle_data	x,0,0,0
	s_beqdec_alvar	B,x,al_sbyte4,remove_Istrat
	s_end_strat

;*****************************************************************************

makeboost_l
	s_set_alvar	W,x,al_boostobj,#0
	s_make_obj	#nullshape,.bad1
	s_copy_pos	y,x
	s_add_alvar	W,y,al_worldz,#2000
	s_particle_data	y,3,2,10
	s_set_alvartobeobj	x,al_boostobj,y
.bad1
	rtl

updateboost_l
	ldy	al_boostobj,x
	beq	.badboost	
	lda	al_worldzh,x
	sta.w	al_worldzh,y
	s_copy_pos	y,x
.badboost
	rtl	



;*****************************************************************************




;*****************************************************************************
stratdebug_print_l

	ifeq	0
	ai16
	ldx	playpt
	lda.l	alx_worldz,x
	printw	1,1
	a8
	lda.l	alx_worldzh,x
	printb	1,2
	lda	numalx
	printb	1,3
	lda.l	alx_roty,x
	printb	1,4

	a16
	lda.l	alx_collobjptr,x
	tax
	lda.l	mrambank+CAR_TWISTTIME,x
	printw	1,4
	lda.l	m_test1
	printw	1,5


	rtl
	endc

	a8
	lda.l	m_framec
	printd	1,1
	a16
	lda	dyntimer	
	printw	1,2
	lda	disptimer	
	printw	1,3


	i16
	ldx	playpt
	a8
	lda.l	alx_lapcnt,x
	printd	1,4
	lda.l	alx_offroadtime,x
	printd	1,5

	
	a16
	lda.l	m_testcar1
	tax
	lda.l	mrambank+CAR_REVS,x
	printw	1,8
	lda.l	mrambank+CAR_GEAR,x
	printw	1,9
	lda.l	mrambank+CAR_GNDSPEED,x
	printw	1,10
	lda.l	mrambank+CAR_ACCEL,x
	printw	1,11
	lda.l	mrambank+CAR_SKID,x
	printw	1,12

	lda.l	m_test1
	printw	1,13

	rtl


;****************************************************************************
	ifeq	1
	lda.l	mrambank+CAR_WHEELS,x
	tax
	lda.l	mrambank+WHL_ROTXSPEED,x
	printw	1,8

	lda.l	m_test1
	printw	1,9

	lda.l	m_groupblocks
	printw	1,10
	lda.l	m_groupblocks+10
	printw	1,11
	lda.l	m_groupblocks+20
	printw	1,12
	lda.l	m_groupblocks+30
	printw	1,13

	lda.l	m_groupblocks+2
	printw	6,10
	lda.l	m_groupblocks+2+10
	printw	6,11
	lda.l	m_groupblocks+2+20
	printw	6,12
	lda.l	m_groupblocks+2+30
	printw	6,13
	endc

;****************************************************************************



	a8

	rtl

	ai16

;	lda.l	m_carusedlist		; ptr. to car
;	tax

;	lda.l	mrambank+CAR_XSIZEANIM,x
;	lda.l	mrambank+CAR_FLAGS,x
;	lda.l	mrambank+OBJ_COLLOBJ,x
;	lda.l	mrambank+CAR_OFFROADTIME,x
;	lda.l	mrambank+CAR_TEST1,x
	lda	testvar1


	ifeq	1
	lda.l	mrambank+CAR_WHEELS,x
	tax
	lda.l	mrambank+WHL_SPRINGY,x
	sta	svar_word1
	lda.l	mrambank+WHL_NEXT,x
	tax
	lda.l	mrambank+WHL_SPRINGY,x
	clc
	adc	svar_word1
	sta	svar_word1
	lda.l	mrambank+WHL_NEXT,x
	tax
	lda.l	mrambank+WHL_SPRINGY,x
	clc
	adc	svar_word1
	sta	svar_word1
	lda.l	mrambank+WHL_NEXT,x
	tax
	lda.l	mrambank+WHL_SPRINGY,x
	clc
	adc	svar_word1
	ENDC
;	printw	1,5



;	lda.l	m_carusedlist		; ptr. to car
;	tax
;	lda.l	mrambank+CAR_GEAR,x
;	printw	1,22


	ifeq	1
	lda.l	m_carusedlist		; ptr. to car
	tax
	lda.l	mrambank+CAR_TEST1,x
	printw	1,12



	lda.l	mrambank+CAR_TORQUEY,x
	printw	1,10

	a16
	lda.l	m_TRACKusedlist
	tax	
	printw	1,12
	
	lda.l	mrambank,x
	tax	
	printw	1,13

	lda.l	mrambank,x
	tax	
	printw	1,14

	lda.l	mrambank,x
	tax	
	printw	1,15

	lda.l	mrambank,x
	tax	
	printw	1,16
	endc
	


	ifeq	1
	lda.l	m_torqueX
	printw	1,9
	lda.l	m_torqueY
	printw	6,9
	lda.l	m_torqueZ
	printw	11,9


	lda.l	m_dispX
	printw	1,10
	lda.l	m_dispY
	printw	6,10
	lda.l	m_dispZ
	printw	11,10
	endc

	ifeq	1
	lda.l	m_carusedlist		; ptr. to car
	tax
	lda.l	mrambank+CAR_WHEELS,x
	tax
	lda.l	mrambank+WHL_temp1,x
	printw	1,12
	lda.l	mrambank+WHL_NEXT,x
	tax
	lda.l	mrambank+WHL_temp1,x
	printw	1,13
	lda.l	mrambank+WHL_NEXT,x
	tax
	lda.l	mrambank+WHL_temp1,x
	printw	1,14		     
	lda.l	mrambank+WHL_NEXT,x
	tax
	lda.l	mrambank+WHL_temp1,x
	printw	1,15		     
	endc


	lda.l	m_test1
	printw	20,1

;	lda.l	#m_dynmem&WM
;	printw	3,11
	

ypos	=	2

printte	MACRO
	lda.l	mrambank+0,x
	pha
	printw	1,ypos
	lda.l	mrambank+2,x
	printw	6,ypos
	plx
ypos	=	ypos+1
	ENDM	



	ifeq	1
	lda.l	m_dynmem
	tax
	printw	1,ypos
	lda.l	m_dynmem+2
	printw	6,ypos
ypos	=	ypos+1

	rept	20
	printte	
	endr
	endc



printone	MACRO
	lda.l	mrambank+OBJ_NEXT,x
	printw	12,ypos
	tax
ypos	=	ypos+1
	ENDM	


	ifeq	1
ypos	=	2

	lda.l	m_objects
	printw	12,ypos
ypos	=	ypos+1
	tax
	rept	20
	printone	
	endr
	endc


	ifeq	1
	lda.l	m_test1
	printw	1,11
	lda.l	m_testcar1
	tax
	lda.l	mrambank+CAR_WHEELS,x
	tax
	lda.l	mrambank+WHL_TRACKFORCEX,x
	printw	1,12
	lda.l	mrambank+WHL_TRACKFORCEY,x
	printw	6,12
	lda.l	mrambank+WHL_TRACKFORCEZ,x
	printw	11,12

	ifeq	1
	lda.l	mrambank+WHL_NOFFSETX,x
	printw	1,14
	lda.l	mrambank+WHL_NOFFSETY,x
	printw	6,14
	lda.l	mrambank+WHL_NOFFSETZ,x
	printw	11,14
	endc
	endc



	rtl


	shorta
	

;****************************************************************************
; print link list.
	ifeq	1	
	a16
	lda.l	m_WHEELusedlist
	tax	
	printw	1,12
	
	lda.l	mrambank,x
	tax	
	printw	1,13

	lda.l	mrambank,x
	tax	
	printw	1,14

	lda.l	mrambank,x
	tax	
	printw	1,15

	lda.l	mrambank,x
	tax	
	printw	1,16

;--------------

	lda.l	m_WHEELusedlist
	tax	
	lda.l	mrambank+2,x
	printw	6,12
	
	lda.l	mrambank,x
	tax	
	lda.l	mrambank+2,x
	printw	6,13

	lda.l	mrambank,x
	tax	
	lda.l	mrambank+2,x
	printw	6,14

	lda.l	mrambank,x
	tax	
	lda.l	mrambank+2,x
	printw	6,15

	lda.l	mrambank,x
	tax	
	lda.l	mrambank+2,x
	printw	6,16



;--------------

	lda.l	m_WHEELusedlist
	tax	
	lda.l	mrambank,x
	printw	12,12
	
	lda.l	mrambank,x
	tax	
	lda.l	mrambank,x
	printw	12,13

	lda.l	mrambank,x
	tax	
	lda.l	mrambank,x
	printw	12,14

	lda.l	mrambank,x
	tax	
	lda.l	mrambank,x
	printw	12,15

	lda.l	mrambank,x
	tax	
	lda.l	mrambank,x
	printw	12,16

	endc



;****************************************************************************
; print link list.
	ifeq	1	
	a16
	lda.l	m_WHEELusedlist
	tax	
	printw	1,12
	
	lda.l	mrambank,x
	tax	
	printw	1,13

	lda.l	mrambank,x
	tax	
	printw	1,14

	lda.l	mrambank,x
	tax	
	printw	1,15

	lda.l	mrambank,x
	tax	
	printw	1,16

;--------------

	lda.l	m_WHEELusedlist
	tax	
	lda.l	mrambank+2,x
	printw	6,12
	
	lda.l	mrambank,x
	tax	
	lda.l	mrambank+2,x
	printw	6,13

	lda.l	mrambank,x
	tax	
	lda.l	mrambank+2,x
	printw	6,14

	lda.l	mrambank,x
	tax	
	lda.l	mrambank+2,x
	printw	6,15

	lda.l	mrambank,x
	tax	
	lda.l	mrambank+2,x
	printw	6,16



;--------------

	lda.l	m_WHEELusedlist
	tax	
	lda.l	mrambank,x
	printw	12,12
	
	lda.l	mrambank,x
	tax	
	lda.l	mrambank,x
	printw	12,13

	lda.l	mrambank,x
	tax	
	lda.l	mrambank,x
	printw	12,14

	lda.l	mrambank,x
	tax	
	lda.l	mrambank,x
	printw	12,15

	lda.l	mrambank,x
	tax	
	lda.l	mrambank,x
	printw	12,16

	endc
;****************************************************************************


	ifeq	1
	lda.l	m_test1
	printw	1,8


	lda.l	m_dispx
	printw	1,9
	lda.l	m_dispy
	printw	6,9
	lda.l	m_dispz
	printw	11,9

	lda.l	m_torquex
	printw	1,10
	lda.l	m_torquey
	printw	6,10
	lda.l	m_torquez
	printw	11,10


	lda.l	m_carusedlist		; ptr. to car
	tax
	lda.l	mrambank+CAR_WHEELS,x
	tax
	lda.l	mrambank+OBJ_ROToffx,x
	printw	1,12
	lda.l	mrambank+OBJ_ROToffy,x
	printw	1,13
	lda.l	mrambank+OBJ_ROToffz,x
	printw	1,14
	endc

;****************************************************************************
	ifeq	1
	lda.l	mrambank+WHL_NEXT,x
	tax
	lda.l	mrambank+OBJ_VELy,x
	printw	1,13


	lda.l	mrambank+WHL_NEXT,x
	tax
	lda.l	mrambank+OBJ_VELy,x
	printw	1,14


	lda.l	mrambank+WHL_NEXT,x
	tax
	lda.l	mrambank+OBJ_VELy,x
	printw	1,15

	endc


	ifeq	1
	lda.l	m_carusedlist		; ptr. to car
	tax
	lda.l	mrambank+OBJ_WORLDX,x
	printw	1,12
	lda.l	mrambank+OBJ_WORLDY,x
	printw	6,12
	lda.l	mrambank+OBJ_WORLDZ,x
	printw	11,12

;	lda.l	mrambank+CAR_WHEELS,x	; ptr. to WHL.
;	tax	
;	lda.l	mrambank+OBJ_WORLDX,x
;	printw	1,16
;	lda.l	mrambank+OBJ_WORLDZ,x
;	printw	6,16

	
	lda.l	m_torquex
	printw	1,14

	lda.l	m_torquey
	printw	6,14

	lda.l	m_torquez
	printw	11,14


	lda.l	m_dispx
	printw	1,16

	lda.l	m_dispy
	printw	6,16

	lda.l	m_dispz
	printw	11,16


	


	endc



	

