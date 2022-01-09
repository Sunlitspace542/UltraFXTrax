;---------------------------------------------------------
;
;	Massage Display Program for XL
;
;				programed by Masato Kimura
;
;			       mvars.mc
;					14/04/1993
;---------------------------------------------------------
;    never BREAK r11 for LINK!!!!
;---------------------------------------------------------


;;;;		incpublics	mmessage.ext


rsp		equr	r10
rlink		equr	r11



;entry data

rnum		equr	00	;charecter (font) number
rxmax		equr	01	;for clipping routin
rymin		equr	02	;	;
rxzoom		equr	03
ryzoom		equr	04
rxbase		equr	06
rybase		equr	05	;>>>It's OK to break
rymax		equr	07	;	;

;inside data

rx		equr	01
ry		equr	02
rxcount		equr   	05
rycount		equr	06
rxdeci		equr	07
rydeci		equr	08		
rdata		equr	09	;data from ROM (2bit char)
rdatacopy	equr	10
rpallete	equr	11
rxwidth		equr	12
rywidth		equr	13
;---------------------------------------------------------
centerh	equ	26*08/2
center	equ	centerh
centerv	equ	18*08/2

mzclear	MACRO
	ibt	\1,#0
	ENDM		



mcallfont MACRO
	lm	rxbase,[messageh]
	lm	rybase,[messagev]
	lm	rxzoom,[messagezoomh]
	lm	ryzoom,[messagezoomv]
	
	sub r0	; ezbuild add
	cmode	; ezbuild add

	iwt	rnum,#\1
	iwt	rxmax,#192	   ;for one player mode!!
	iwt	rymax,#128
	iwt	rymin,#0
	mcall	mputfont
	nop
	lm	r0,[messagezoomh]	
	add	r0
	add	r0
	add	r0
	hib	r0
	lm	r1,[messageh]
	add	r1
	sbk
	
	ENDM

mblank	MACRO

	lm	r0,[messagezoomh]	
	add	r0
	add	r0
	add	r0
	hib	r0
	lm	r1,[messageh]
	add	r1
	sbk
	
	ENDM
;---------------------------------------------------------
mnumhigh MACRO
	lm	rxbase,[messageh]
	lm	rybase,[messagev]
	lm	rxzoom,[messagezoomh]
	lm	ryzoom,[messagezoomv]
	sub r0	; ezbuild add
	cmode	; ezbuild add

	lm	r0,[\1&WM]
	lsr
	lsr
	lsr
	lsr
	and	#0fh
	iwt	rxmax,#192	   ;for one player mode!!
	iwt	rymax,#128
	iwt	rymin,#0
	mcall	mputfont
	nop
	lm	r0,[messagezoomh]	
	add	r0
	add	r0
	add	r0
	hib	r0
	lm	r1,[messageh]
	add	r1
	sbk
	
	ENDM

mnumlow MACRO
	lm	rxbase,[messageh]
	lm	rybase,[messagev]
	lm	rxzoom,[messagezoomh]
	lm	ryzoom,[messagezoomv]
	sub r0	; ezbuild add
	cmode	; ezbuild add

	lm	r0,[\1&WM]
	and	#0fh
	iwt	rxmax,#192	   ;for one player mode!!
	iwt	rymax,#128
	iwt	rymin,#0
	mcall	mputfont
	nop 
	lm	r0,[messagezoomh]	
	add	r0
	add	r0
	add	r0
	hib	r0
	lm	r1,[messageh]
	add	r1
	sbk
	
	ENDM

;---------------------------------------------------------

nextcharacter	macro
	nop
	lm	rybase,[messagev]
	lm	r0,[messageh]
	add	#08h
	sbk	
	move	rxbase,r0
	iwt	rxzoom,#100h
	iwt	ryzoom,#100h
	iwt	rxmax,#192	   ;for one player mode!!
	iwt	rymax,#128
	iwt	rymin,#0
	    	endm

dispramb 	

	
 	sub	r0
	cmode
	nextcharacter
	lm	r0,[messageaddress]
	rept	12
	lsr
	endr
	and	#0fh
	mcall	mputfont
	nextcharacter

	lm	r0,[messageaddress]
	rept	08
	lsr
	endr
	and	#0fh
	mcall	mputfont
	nextcharacter

	lm	r0,[messageaddress]
	rept	04
	lsr
	endr
	and	#0fh
	mcall	mputfont
	nextcharacter

	lm	r0,[messageaddress]
	and	#0fh
	mcall	mputfont

	nextcharacter
	nextcharacter

	lm	r0,[messageaddress]
	ldw	[r0]
	rept	4
	lsr	
	endr
	and	#0fh
	mcall	mputfont

	nextcharacter
	lm	r0,[messageaddress]
	ldw	[r0]
	and	#0fh
	mcall	mputfont

	nop
	stop
	nop

;---------------------------------------------------------
dispramw 	
 	sub	r0
	cmode
	
	nextcharacter
	lm	r0,[messageaddress]
	rept	12
	lsr
	endr
	and	#0fh
	mcall	mputfont
	nextcharacter

	lm	r0,[messageaddress]
	rept	08
	lsr
	endr
	and	#0fh
	mcall	mputfont
	nextcharacter

	lm	r0,[messageaddress]
	rept	04
	lsr
	endr
	and	#0fh
	mcall	mputfont
	nextcharacter

	lm	r0,[messageaddress]
	and	#0fh
	mcall	mputfont

	nextcharacter
	nextcharacter

	
	lm	r0,[messageaddress]
	inc	r0
	ldw	[r0]
	rept	4
	lsr	
	endr
	and	#0fh
	mcall	mputfont

	nextcharacter
	lm	r0,[messageaddress]
	inc	r0
	ldw	[r0]
	and	#0fh
	mcall	mputfont

	nextcharacter
	lm	r0,[messageaddress]
	ldw	[r0]
	rept	4
	lsr	
	endr
	and	#0fh
	mcall	mputfont

	nextcharacter
	lm	r0,[messageaddress]
	ldw	[r0]
	and	#0fh
	mcall	mputfont
	nop
	stop
	nop

;---------------------------------------------------------
initfont	MACRO

	lm	r6,[messagezoomh]
	move	r1,r6
	lm	r0,[messagelength] 
	swap	
	lsr
	fmult
	ibt	r6,#centerh
	from	r6 
	to	rxbase
	sub	r0
	sm	[messageh],rxbase

	from	r1
	add	r1
	add	r0
	add	r0
	hib
	ibt	r6,#30h
	from	r6	     
	sub	r0
	sm	[messagev],r0

	ENDM
;---------------------------------------------------------
initcount	MACRO

	lm	r6,[messagezoomh]
	move	r1,r6
	lm	r0,[messagelength] 
	swap	
	lsr
	fmult
	ibt	r6,#centerh
	from	r6 
	to	rxbase
	sub	r0
	sm	[messageh],rxbase

	from	r1
	add	r1
	add	r0
	add	r0
	hib
	ibt	r6,#30h+05h
	from	r6	     
	sub	r0
	sm	[messagev],r0

	ENDM
;---------------------------------------------------------
initlap	MACRO

	lm	r6,[messagezoomh]
	move	r1,r6
	lm	r0,[messagelength] 
	swap	
	lsr
	fmult
	ibt	r6,#centerh
	from	r6 
	to	rxbase
	sub	r0
	sm	[messageh],rxbase

	from	r1
	add	r1
	add	r0
	add	r0
	hib
	ibt	r6,#50h+08h
	from	r6	     
	sub	r0
	sm	[messagev],r0

	ENDM
;---------------------------------------------------------
ms_timeup
	initfont
	
	mcallfont		ft
	mcallfont		fi
	mcallfont		fm
	mcallfont		fe
	mblank
	mcallfont		fu
	mcallfont		fp
	stop
	nop
;---------------------------------------------------------
ms_trynextcourse
	initfont
	mcallfont		ft
	mcallfont		fr
	mcallfont		fy
	mblank
	mcallfont		ft
	mcallfont		fh
	mcallfont		fe
	mblank
	mcallfont		fn
	mcallfont		fe
	mcallfont		fx
	mcallfont		ft
	mblank
	mcallfont		fc
	mcallfont		fo
	mcallfont		fu
	mcallfont		fr
	mcallfont		fs
	mcallfont		fe
	stop
	nop
;---------------------------------------------------------
ms_welldone
	initfont
	mcallfont		fw
	mcallfont		fe
	mcallfont		fl
	mcallfont		fl
	mblank
	mcallfont		fd
	mcallfont		fo
	mcallfont		fn
	mcallfont		fe
	mblank
	mcallfont		fexc
	stop
	nop

;---------------------------------------------------------
ms_2laps2go
	initfont
	mcallfont		f2
	mblank
	mcallfont		fl
	mcallfont		fa
	mcallfont		fp
	mcallfont		fs
	mblank
	mcallfont		ft
	mcallfont		fo
	mblank
	mcallfont		fg
	mcallfont		fo
	stop
	nop

;---------------------------------------------------------
ms_course1
	initfont
	mcallfont		fc
	mcallfont		fo
	mcallfont		fu
	mcallfont		fr
	mcallfont		fs
	mcallfont		fe
	mblank
	mcallfont		f1
	stop
	nop
;---------------------------------------------------------
ms_course2
	initfont
	mcallfont		fc
	mcallfont		fo
	mcallfont		fu
	mcallfont		fr
	mcallfont		fs
	mcallfont		fe
	mblank
	mcallfont		f2
	stop
	nop
;---------------------------------------------------------
ms_course3
	initfont
	mcallfont		fc
	mcallfont		fo
	mcallfont		fu
	mcallfont		fr
	mcallfont		fs
	mcallfont		fe
	mblank
	mcallfont		f3
	stop
	nop
;---------------------------------------------------------
ms_course4
	initfont
	mcallfont		fc
	mcallfont		fo
	mcallfont		fu
	mcallfont		fr
	mcallfont		fs
	mcallfont		fe
	mblank
	mcallfont		f4
	stop
	nop
;------------------------------------------------------------
ms_deccount1

	mnumlow		mminutecounter

	stop
	nop

;------------------------------------------------------------
ms_deccount2

	mnumhigh	mminutecounter
	mnumlow		mminutecounter

	stop
	nop

;------------------------------------------------------------
ms_listlap1
	mcallfont	fl
	mcallfont	fa
	mcallfont	fp
	mcallfont	fbar
	mcallfont	f1
	mblank
	mblank
	mblank
	mnumhigh	mminutelap
	mnumlow		mminutelap
	mcallfont	fqu
	mnumhigh	msecondlap
	mnumlow		msecondlap
	mcallfont	fdq	
	mnumhigh	mdecimallap+01
	mnumlow		mdecimallap+01
	stop
	nop

ms_listlap2	
	mcallfont	fl
	mcallfont	fa
	mcallfont	fp
	mcallfont	fbar
	mcallfont	f2
	mblank
	mblank
	mblank
	mnumhigh	mminutelap
	mnumlow		mminutelap
	mcallfont	fqu
	mnumhigh	msecondlap
	mnumlow		msecondlap
	mcallfont	fdq	
	mnumhigh	mdecimallap+01
	mnumlow		mdecimallap+01

	stop
	nop	
;---------------------------------------------------------
ms_laptime
	initlap
	mnumhigh	mminutelap
	mnumlow		mminutelap
	mcallfont	fqu
	mnumhigh	msecondlap
	mnumlow		msecondlap
	mcallfont	fdq	
	mnumhigh	mdecimallap+01
	mnumlow		mdecimallap+01
	stop
	nop

;---------------------------------------------------------
ms_lap1
	initfont
	mcallfont	fl
	mcallfont	fa
	mcallfont	fp
	mcallfont	fbar
	mcallfont	f1
	stop
	nop
;---------------------------------------------------------

ms_lap2
	initfont
	mcallfont	fl
	mcallfont	fa
	mcallfont	fp
	mcallfont	fbar
	mcallfont	f2
	stop
	nop
;---------------------------------------------------------

ms_finallap
	initfont
	mcallfont	ff
	mcallfont	fi
	mcallfont	fn
	mcallfont	fa
	mcallfont	fl
	mblank
	mcallfont	fl
	mcallfont	fa
	mcallfont	fp
	stop
	nop
;---------------------------------------------------------
ms_finish
	initfont
	mcallfont	ff
	mcallfont	fi
	mcallfont	fn
	mcallfont	fi
	mcallfont	fs
	mcallfont	fh
	stop
	nop
;---------------------------------------------------------
ms_1
	initcount
	mcallfont	f1
	stop
	nop
;---------------------------------------------------------
ms_2
	initcount
	mcallfont	f2
	stop
	nop
;---------------------------------------------------------
ms_3
	initcount
	mcallfont	f3
	stop
	nop
;---------------------------------------------------------
ms_go
	initcount
	mcallfont	fg
	mcallfont	fo
	stop
	nop
;---------------------------------------------------------
;
;
;	rx=start massage point  x
;	ry=	;		y
;	rxzoom	zoom data for x axis
;	ryzoom	zoom data for y axis
;	rnum=character number	>>>>>>>>r0 fixed!!!
;		;now 6ch!!!
;
;	rxmax=x screen width ;(because x min always 00)
;	rymin=minimum y position
;	rymax=maximum y ;(It depends upon 1&2play mode)
;
;
;---------------------------------------------------------

messtart	=	*
mputnomalfont
	
	iwt	rxzoom,#100h
	move	ryzoom,rxzoom
	iwt	rxmax,#208	   ;for one player mode!!
	iwt	rymax,#128
	ibt	rymin,#00


mputfont


	sm	[mwork+00h],r11	;push r11 resister	
	add	rnum
	add	rnum
	add	rnum
	add	rnum
	add	rnum	;1char10h!!! & 1 font 2 char20h!!!
	iwt	r14,#font12&WM
	to	r14
	add	r14		;set R14 for GET ROM data 
	ibt	r0,#font12>>16  ;set font 1*2  (2bit)
	romb			
	iwt	rpallete,#0ech
.xclip
	mtest	rxbase
	bmi	.clipcheck
.noxclip
	from	rybase
	sub	rymin
	bcc	.clipcheck
.noclipfont
	from	rxzoom
	add	rxzoom
	add	r0
	add	r0		;r0=xzoom* 08dost!!
	hib
	move	rxwidth,r0
	add	rxbase
	sub	rxmax
	bcc	.noclipx
	from	rxmax
	to	rxwidth
	sub	rxbase
.noclipx
	from	ryzoom
	add	ryzoom	
	add	r0
	add	r0
	add	r0		;r0=yzoom *16dots
	hib
	move	rywidth,r0
	add	rybase
	sub	rymax
	bcc	.dotset
	from	rymax
	to	rywidth
	sub	rybase
;---------------------------------------------------------
.dotset				;Start!!! plot fonts!
	move	rx,rxbase
	move	ry,rybase	;I can break rybase!
	mzclear	rydeci
	
.nextline
		   
	from	ryzoom
	add	rydeci
	to	rycount
	hib	
	to	rydeci
	lob	

.newline
	getbl
	inc	r14
	getbh
	inc	r14
	move 	rdata,r0
.sameline

	move	rdatacopy,rdata
	mzclear	rxdeci
	move	rxcount,rxwidth
.onelineloop

	from	rdatacopy
	and	#03  		;set r0
	beq	.nulldata
	nop
	add	rpallete
;;;;.nulldata
	with	rdatacopy
	lsr
	with	rdatacopy
	lsr
	colour		;set color data

	from	rxzoom
	add	rxdeci
	to	rxdeci
	lob	
	hib			;r0=set dots numer
	

.onedotloop
	dec	rxcount		;rxcount=dots num/1 line
	beq	.endoneline
	dec	r0
	bne	.onedotloop
	plot
	bra	.onelineloop
	nop

.nulldata
	with	rdatacopy
	lsr
	with	rdatacopy
	lsr
	from	rxzoom
	add	rxdeci
	to	rxdeci
	lob
	hib
.nullloop
	dec	rxcount
	beq	.endoneline
	dec	r0
	bne	.nullloop
	inc	rx
	bra	.onelineloop
	nop


.endoneline
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec	rywidth
	beq	.returnsub
	with	rx
	sub	rxwidth
	inc	rx
	dec	rycount
	bne	.sameline
	inc	ry
	bra	.nextline
;	bra	.newline
	nop
.returnsub
.clipcheck

	rpix


	lm	r11,[mwork]
	jmp	r11
	nop
	
;---------------------------------------------------------
	IFEQ	1
;backup



	move	rx,rxbase
	move	ry,rybase
	add	rnum
	add	rnum
	add	rnum
	add	rnum
	add	rnum	;1char10h!!! & 1 font 2 char20h!!!
	iwt	r14,#font12&WM
	to	r14
	add	r14		;set R14 for GET ROM data 
	ibt	r0,#font12>>16  ;set font 1*2  (2bit)
	romb			
	



	ibt	rcount,#16
.set_font_loop
	
	getbl	  ;rdata=bitmap data-2bit mode(4dot/1byte)
	inc	r14
	getbh
	inc	r14
	move	rdata,r0	;get 2byte data from ROM 

	from	rxzoom
	asl
	asl
	asl			;r0 resister!!!
	add	rxbase
	sub	rxbase
	cmp	rxclip
	bcc	.not_clip_x
	nop
	move	r0,rxclip
.not_clip_x		
	move	






	
	ibt	rloopcount,#08 ;loop 4 times
	move	rloopbase,pc	;loop base address!!!	

	
	from	rdata
	and	#03	;r0=#XXXXXX??b
	beq	.null_data
	nop
	add	rpalette  ;color palette data!!! 	
.null_data
	with	rdata
	lsr	
	with	rdata
	lsr
	colour
	move	r0,rxzoom
.xplotloop
	dec	r0
	bpl	.xplotloop	
	plot
	
.end_xloop
	nop

	move	rx,rxbase
	inc	ry


	dec	rcount
	bne	.set_font_loop
	nop

	rpix

	jmp	r11
	nop
	
	
	ENDC


;---------------------------------------------------------

	printf "messlen",*-messtart,"%n"

	
message_address
f0	equ	00
f1	equ	01
f2	equ	02
f3	equ	03	
f4	equ	04		
f5	equ	05		
f6	equ	06		
f7	equ	07		
f8	equ	08		
f9	equ	09		
fa	equ	10	
fb	equ	11	
fc	equ	12	
fd	equ	13	
fe	equ	14	
ff	equ	15	
fg	equ	16	
fh	equ	17	
fi	equ	18	
fj	equ	19	
fk	equ	20	
fl	equ	21	
fm	equ	22	
fn	equ	23	
fo	equ	24	
fp	equ	25	
fq	equ	26	
fr	equ	27	
fs	equ	28	
ft	equ	29	
fu	equ	30	
fv	equ	31	
fw	equ	32	
fx	equ	33	
fy	equ	34	
fz	equ	35	
fexc	equ	36	
fque	equ	37	
fbar	equ	38
fqu	equ	45
fdq	equ	46




