;*******************************************************************
; Link List macros 
; 
; All rtemp registers cannot be r0 because it is trashed in each macro.
;
; block offset 0 = next ptr.
; block offset 2 = prev ptr.
;


mfmt_linklist	MACRO	#free list ptr,#used list ptr,#mem blocks ptr,#no. of blocks,#block size,rtemp1

	iwt	r0,#\3&WM
	sm	[\1],r0		; ptr. to first block.
	iwt	r12,#\4		; number of blocks.	
	move	r13,pc		; loop ptr.
		
	move	\6,r0	 
	iwt	r0,#\5	 	; size of block.
	add	\6     	
	stw	[\6]		; next ptr.
	loop
	nop				
	sub	r0
	stw	[\6]		; null ptr = end of list.
	sm	[\2],r0		; clear used list ptr.
		ENDM

;-----------------------------------------------	
madd_block	MACRO	#used list ptr,#free list ptr,#block size,rtemp1 >- rtemp1 ptr. to new block / 0=error

	lm	r0,[\2]		; ptr. to first free block.
	moves	\4,r0
	beq	.end\@		; error if none free.
	nop
	ldw	[\4]		; ptr. to next free block.
	sm	[\2],r0		; first free block ptr to next free block 

	sub	r0
	stw	[\4]		; clear next ptr. 
	inc	\4
	inc	\4
	stw	[\4]		; clear prev ptr. (this should be optimised!)
	dec	\4
	dec	\4
	

	lm	r0,[\1]		; ptr. to first used block.
	moves	r0,r0
	beq	.first\@	; no used blocks.
	nop

	stw	[\4]		; free block next ptr to first used block.

	add	#2	
	from	\4
	stw	[r0]		; first used block prev ptr to free block

.first\@
	sm	[\1],\4		; used list ptr to free block.

	with	\4
	add	#4		; skip next, prev ptr.

	iwt	r12,#(\3)-4	; block size
	sub	r0
	move	r13,pc
	stw	[\4]		; clear the block
	inc	\4
	loop	
	nop
	iwt	r0,#(\3)
	with	\4
	sub	r0	

.end\@
		ENDM

;-----------------------------------------------	
mrem_block	MACRO	rblockptr(not r0),#used list ptr,#free list ptr,rtemp
	
	to	\4
	ldw	[\1]		; save next ptr.
	lm	r0,[\3]		; get ptr. to first free block
	stw	[\1]		; current block next ptr to first free block
	sm	[\3],\1		; first free block ptr to current block

	inc	\1
	inc	\1
	ldw	[\1]		; prev ptr.
	mtest	r0
	bne	.notfirst\@	; if 0 then...
	nop
	sm	[\2],\4		; used list ptr = next block
	sub	r0
	bra	.cont\@
	nop
.notfirst\@
	from	\4
	stw	[r0]		; prev block next ptr = next block 

.cont\@	mtest	\4		; if next ptr. 0 then last block.
	beq	.last\@
	nop
	inc	\4
	inc	\4
	stw	[\4]		; next block prev ptr = prev block
.last\@

		ENDM



;******************************************************************
; "Dynamics" block allocation macros

mmax_structs	MACRO	[struct_len,max_structs]
totaldynmem	=	totaldynmem+(({struct_len})*({max_structs}))
	ENDM


;******************************************************************

mround_down	MACRO	
	IFEQ	0
	moves	\1,\1
	bmi	.nsm1\@
	nop

	iwt	\2,#\3
	IFNE	\1
	with	\1
	ENDC			
	cmp	\2
	bpl	.nsm2\@
	nop
	ibt	\1,#0
	bra	.nsm2\@
	nop
.nsm1\@

	iwt	\2,#-\3
	IFNE	\1
	with	\1
	ENDC			
	cmp	\2
	bmi	.nsm2\@
	nop
	ibt	\1,#0
.nsm2\@
	ENDC

	ENDM
;-----------------------------------------------	
mrange	MACRO	reg,rmin,rmax

	IFNE	\1
	with	\1
	ENDC	
	cmp	\2
	bpl	.nmin\@
	nop
	move	\1,\2
	IFEQ	NARG-4
	bra	\4
	ENDC
.nmin\@
	IFNE	\1
	with	\1
	ENDC	
	cmp	\3
	bmi	.nmax\@
	nop
	move	\1,\3
	IFEQ	NARG-4
	bra	\4
	ENDC
.nmax\@
	ENDM


;-----------------------------------------------	





;************************************************************************

MCALC_D	MACRO		; m_normx,y,z = face norm. rfacepx,y,z = pnt. on face. robjpx,y,z = wheel position. >- r0 = D

;-----------------------------
; calculate D of obj.
	move	r6,robjpx
	from	rnormx
	to	rdtemp
	fmult	
		
	move	r6,robjpy
	from	rnormy
	fmult	
	with	rdtemp
	add	r0

	move	r6,robjpz
	from	rnormz
	fmult	
	add	rdtemp

	sm	[m_whlD],r0


;-----------------------------
; calculate D of face.

	lm	r6,[m_facePX]
	from	rnormx
	to	rdtemp
	fmult	
		
	lm	r6,[m_facePY]
	from	rnormy
	fmult	
	with	rdtemp
	add	r0

	lm	r6,[m_facePZ]
	from	rnormz
	fmult	
	add	rdtemp	


;-----------------------------

	lm	rdtemp,[m_whlD]
	sub	rdtemp

	ENDM


;************************************************************************
mcrossprod	MACRO	rx1,ry1,rz1,[x2],[y2],[z2],[x3],[y3],[z3]
		;        1   2   3    4   5    6    7    8    9

; V3x
	lms	r6,[\5]		; V1z*V2y
	from	\3
	lmult
	move	r7,r4	

	lms	r6,[\6]		; V1y*V2z
	from	\2
	to	r5
	lmult
	with	r7
	sub	r4
	sbc	r5	

	with	r7
	add	r7
	rol	  
	sms	[\7],r0

; V3y    
	lms	r6,[\6]		; V1x*V2z
	from	\1
	lmult
	move	r7,r4	

	lms	r6,[\4]		; V1z*V2x
	from	\3
	to	r5
	lmult
	with	r7
	sub	r4
	sbc	r5	

	with	r7
	add	r7
	rol	  
	sms	[\8],r0
	
; V3z
	lms	r6,[\4]		; V1y*V2x
	from	\2
	lmult
	move	r7,r4	

	lms	r6,[\5]		; V1x*V2y
	from	\1
	to	r5
	lmult
	with	r7
	sub	r4
	sbc	r5	

	with	r7
	add	r7
	rol	  
	sms	[\9],r0

	ENDM

;******************************************************************
cardef_wheel	MACRO	[xpos,ypos,zpos,grip,flag1,flag2,flag3,flag4]
	dw	{xpos}<<car_scale,{ypos}<<car_scale,{zpos}<<car_scale
	dw	{grip}
wflags	=	0

	IFGE	NARG-5
wflags	=	wflags!whlflag_{flag1}
	ENDC
	IFGE	NARG-6
wflags	=	wflags!whlflag_{flag2}
	ENDC
	IFGE	NARG-7
wflags	=	wflags!whlflag_{flag3}
	ENDC
	IFGE	NARG-8
wflags	=	wflags!whlflag_{flag4}
	ENDC

	dw	wflags

	ENDM

cardef	MACRO
\1
	ENDM

cardef_shape	MACRO
	dw	\1&WM
	ENDM


cardef_whltype	MACRO
	dw	\1
	ENDM

cardef_centg	MACRO	[xpos,ypos,zpos]
	dw	{xpos}<<car_scale,{ypos}<<car_scale,{zpos}<<car_scale
	ENDM

;******************************************************************
whldef	MACRO	; name,shape, size
whl\1
whltype_\1	=	whl\1-wheel_defs
    	dw	\2&wm
	dw	\3
	ENDM




;******************************************************************
geardata	MACRO	
gscaleup	=	327
		IFNE	NARG-17
		error  Gear data error!
		ENDC
		db	(32768/(\1))/256
		db	((\2)*gscaleup)/256	
		db	((\3)*gscaleup)/256		
		db	((\4)*gscaleup)/256		
		db	((\5)*gscaleup)/256		
		db	((\6)*gscaleup)/256		
		db	((\7)*gscaleup)/256		
		db	((\8)*gscaleup)/256		
		db	((\9)*gscaleup)/256		

		db	((\A)*gscaleup)/256		
		db	((\B)*gscaleup)/256		
		db	((\C)*gscaleup)/256		
		db	((\D)*gscaleup)/256		
		db	((\E)*gscaleup)/256		
		db	((\F)*gscaleup)/256		
		db	((\G)*gscaleup)/256		
		db	((\H)*gscaleup)/256		
		ENDM


geardatah	MACRO
	geardata	\1,\2/2,\3/2,\4/2,\5/2,\6/2,\7/2,\8/2,\9/2
	ENDM



;******************************************************************
msetreg	MACRO	reg,#value
	iwt	r0,#\2
	to	\1
	or	\1
	ENDM

;******************************************************************
mclrreg	MACRO	reg,#value
	iwt	r0,#~\2
	to	\1
	and	\1
	ENDM

;******************************************************************
mtestreg	MACRO	reg,#value
	iwt	r0,#\2
	and	\1
	ENDM


;******************************************************************
mcarhitflash	MACRO	ON/OFF
	mpush	r1
mchf_on		=	0
mchf_off	=	0
mchf_\1		=	1

	IFNE	mchf_on
	mloadw	r0,CAR_FLAGS,rcarptr
	iwt	r1,#CARflag_hitflash
	to	r1
	or	r1
	mstorew	r1,CAR_FLAGS,rcarptr
	ELSEIF
	mloadw	r0,CAR_FLAGS,rcarptr
	iwt	r1,#CARflag_hitflash
	to	r1
	bic	r1
	mstorew	r1,CAR_FLAGS,rcarptr
	ENDC


	mpop	r1
		ENDM


;******************************************************************
mdebug	MACRO	label
	lm	r0,[m_mariokey]
	mtest	r0
	mlbeq	\1
	ENDM


;******************************************************************
; THE FOLLWING MACROS NEED THESE REGISTERS SETUP:
;
; rcarptr  : ptr. to car
; rmactmp1 : scratch register 1.

mcar_jmp_faster	MACRO	speed,label
	mloadw	r0,CAR_GNDSPEED,rcarptr
	move	rmactmp1,\1
	cmp	rmactmp1
	bpl	\2
	nop
	ENDM
