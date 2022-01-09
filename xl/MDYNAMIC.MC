; CAR DYNAMICS FOR XLR8
;
;         By 
;    Giles Goddard


;*******************************************************************
; MEMORY ALLOCATION MACROS.
;
; A little slow but only uses a next ptr. and a size word
; for each block, so it's good for small block allocation.
;
;
; All sizes must be word multiples and at least 4 bytes long.
; First word  = next ptr.
; Second word = size of block.
;
; If you free a large number of blocks in one go, then use
; 'munfrag_mem' to unfragmentate the memory heap.
;
;
; If you are always allocating a small number of different sized
; blocks, it's better not to un-fragment the memory heap. Because
; the amount of fragmentation tends to equal out to the maximum
; number of blocks allocated.
;



;------------------------------------------------------------
; minit_mem - intialize "memptr" to "size" bytes
;
; uses: register "rmemptr"

minit_mem	MACRO	[memptr,size,rmemptr] 	
	iwt	{rmemptr},#{memptr}&WM
	sub	r0
	mstwi	{rmemptr}	; ptr. to next free block.
	iwt	r0,#{size} 	
	stw	[{rmemptr}]	; size of this free block
	ENDM

;------------------------------------------------------------
; malloc_mem - returns ptr. to "size" bytes in reg. "rmemptr" from "memheap"
;
; uses: registers "rmemptr","rtemp1","rmemheap"
; "size" can be immediate, register or RAM.

malloc_mem	MACRO	[memheap,rmemptr,size,rtemp1,rmemheap]	; 

	mcache

	iwt	{rmemheap},#{memheap}&WM
	move	{rmemptr},{size}




; make first pass to find an exact size block.
.nextblock\@
	to	{rtemp1}
	mldwi	{rmemheap}		; ptr. to next free block
	ldw	[{rmemheap}]		; size of this free block
	sub	{rmemptr}		; size wanted
	beq	.gotmem3\@		; if size=size wanted
	nop
	moves	{rmemheap},{rtemp1}
	bne	.nextblock\@
	nop

; make second pass to find a larger block.
	iwt	{rmemheap},#{memheap}&WM

.nextblock2\@
	to	{rtemp1}
	mldwi	{rmemheap}		; ptr. to next free block
	ldw	[{rmemheap}]		; size of this free block
	sub	{rmemptr}		; size wanted
	bpl	.gotmem\@		; if size>size wanted
	nop
	moves	{rmemheap},{rtemp1}
	bne	.nextblock2\@
	nop

	ibt	{rmemptr},#0
	bra	.nomem\@
	nop


.gotmem3\@
	mneg	{rmemptr}	
	sub	r0
	bra	.gotmem2\@
	nop 

.gotmem\@
	sub	#4
	bpl	.nallocall\@
	nop
	add	#4
	with	{rmemptr}
	add	r0
	mneg	{rmemptr}
	ibt	r0,#-4
.nallocall\@
	add	#4
 	stw	[{rmemheap}]		; save new free block size
.gotmem2\@
	from	{rmemheap}
	to	{rtemp1}
	add	r0			; get ptr. to allocated block
	from	{rmemptr}
	stw	[{rtemp1}]		; size of allocated block

	dec	{rtemp1}
	dec	{rtemp1}
	move	{rmemptr},{rtemp1}
.nomem\@
	ENDM

;------------------------------------------------------------
; mfree_mem - free memory block "rmemptr" from "memheap"
;
; uses: register "rmemheap"

mfree_mem	MACRO	[memheap,rmemptr,rmemheap]
	

	move	{rmemheap},{rmemptr}
	inc	{rmemheap}	
	inc	{rmemheap}	
	ldw	[{rmemheap}]
	mtest	r0			; if size is negative 
	bpl	.nfullalloc\@		; block is still in free list.
	nop
	mneg	r0			; so neg the size
	stw	[{rmemheap}]		; and return.
	bra	.done\@
	nop
.nfullalloc\@
	iwt	{rmemheap},#{memheap}&WM
	ldw	[{rmemheap}]		; ptr. to next	
	stw	[{rmemptr}]		; copy ptr. to next
	from	{rmemptr}	
	stw	[{rmemheap}]		; next free block is this block.
.done\@

	ENDM	


;------------------------------------------------------------
; mcount_blocks	- count the number of active memory blocks
;
;
mcount_blocks	MACRO	[memheap,rmemheap,rcount]

	iwt	{rmemheap},#{memheap}&WM
	ibt	{rcount},#-1

.loop\@	ldw	[{rmemheap}]
	moves	{rmemheap},r0
	bne	.loop\@
	inc	{rcount}


	ENDM






 
;------------------------------------------------------------
; munfrag_mem	- coalesce free memory blocks 
;
; 

munfrag_mem	MACRO	[memheap,rmemheap,rtemp1,rtemp2]

	iwt	{rmemheap},#{memheap}&WM
.loop\@
	to	{rtemp1}
	mldwi	{rmemheap}	
	mtest	{rtemp1}
	beq	.fin\@
	nop
	ldw	[{rmemheap}]		; size of this block.
	mtest	r0
	bmi	.next\@
	nop
	sub	#2			; allow for next ptr. skip

	to	{rtemp2}		; check if the end of this block..
	add	{rmemheap}		; ..points to next block
	with	{rtemp2}
	cmp	{rtemp1}		
	bne	.next\@
	nop

; adjust size of first block.
	inc	{rtemp1}		
	inc	{rtemp1}
	to	{rtemp2}
	ldw	[{rtemp1}]		; size of next block
	mtest	{rtemp2}
	bmi	.next2\@
	nop
	add	{rtemp2}
	add	#2			
	dec	{rtemp1}
	dec	{rtemp1}
	stw	[{rmemheap}]

; update next ptrs.
	dec	{rmemheap}
	dec	{rmemheap}
	ldw	[{rtemp1}]
	stw	[{rmemheap}]
	inc	{rmemheap}
	inc	{rmemheap}


.next\@
	move	{rmemheap},{rtemp1}
	bra	.loop\@
	nop
.next2\@
	dec	{rtemp1}
	dec	{rtemp1}
	move	{rmemheap},{rtemp1}
	bra	.loop\@
	nop


.fin\@
	ENDM
	

		


;*******************************************************************


;******************************************************************
minit_dynamics	; INITIALISE DYNAMICS. 

	sub	r0	
	RAMB

	sm	[m_lastroadobj],r0
	sm	[m_lastmarkobj],r0
	sm	[m_objects],r0
	sm	[m_dynframe],r0
	sm	[m_testcar1],r0
	sm	[m_test1],r0

	minit_mem	m_dynmem,totaldynmem,r1
;	minit_mem	m_dynmem,1000,r1


;	minit_mem	m_testmem,100,r1
;	malloc_mem	m_testmem,r4,#60,r2,r3
;	malloc_mem	m_testmem,r1,#40,r2,r3
;	mfree_mem	m_testmem,r4,r2
;	mfree_mem	m_testmem,r1,r2
;	malloc_mem	m_testmem,r4,#36,r2,r3
;	mfree_mem	m_testmem,r4,r2
;
;	malloc_mem	m_testmem,r4,#4,r2,r3
;;	mfree_mem	m_testmem,r4,r2
;
;;	sm	[m_test1],r1



	stop
	nop 




;*******************************************************************
; mmake_obj	
;
; entry:
;	r4 = size of block
;
; exit:
;	r1 = ptr. to object
;
; uses:
;      r1-r4,r12,r13
;


mmake_obj
	
;	lm	r0,[m_dynframe]
;	and	#7
;	add	r0
;	with	r4
;	add	r0	

	malloc_mem	m_dynmem,r1,r4,r2,r3

	mtest	r1
	beq	.error


; clear object block.
	iwt	r2,#2
	with	r2
	add	r1
	mldwi	r2
	mabs	r0,r0
	sub	#4
	beq	.skip
	nop     
	bmi	.skip
	nop
	move	r12,r0
	sub	r0
	move	r13,pc
	stb	[r2]
	inc	r2
	loop
	nop
.skip

	
; store in list.
	lm	r2,[m_objects]
	mstorew	r2,OBJ_NEXT,r1
	sm	[m_objects],r1
	
	mtest	r2
	beq	.nprev
	nop
	mstorew	r1,OBJ_PREV,r2
.nprev	

.error
	move	pc,r11
	nop

;.error
;	bra	.error
;	nop




;*******************************************************************
; mrem_obj	
;
; entry:
;	r1 = ptr. to object
;
; exit:
;
; trashes: r0-r3
;


mrem_obj_snes
	miwt	r10,m_stack&WM
	lm	r1,[m_dynvar1]
	mcall	mrem_obj
	nop
	stop
	nop


mrem_obj
	mpush	r11
	

	mloadw	r0,OBJ_TYPE,r1
	iwt	r2,#OBJTYPE_car
	and	r2
	beq	.ncar
	nop
	mcall	mrem_car
	nop

.ncar


	
	mloadw	r2,OBJ_PREV,r1
	mloadw	r3,OBJ_NEXT,r1

	mtest	r2
	beq	.nprev
	nop
	mstorew	r3,OBJ_NEXT,r2
	bra	.nprev2
	nop
.nprev
	sm	[m_objects],r3
.nprev2


	mtest	r3
	beq	.nnext
	nop
	mstorew	r2,OBJ_PREV,r3
.nnext

	mfree_mem	m_dynmem,r1,r2

	mpop	pc
	nop


mrem_car
	mpush	r11
	mpush	r1

	mloadw	r4,CAR_WHEELS,r1
.loop
	mtest	r4
	beq	.nowheels
	nop
	move	r1,r4		
	mloadw	r4,WHL_NEXT,r1
	mcall	mrem_obj
	nop
	move	r1,r4
	bra	.loop
	nop	

.nowheels
	mpop	r1
	mpop	pc
	nop




;*******************************************************************
; mmake_handobj	; make hand object.

mmake_handobj
	miwt	r10,m_stack&WM

	iwt	r4,#HANDOBJ_LEN
	mcall	mmake_obj
	nop
	sm	[m_dynvar1],r1

	stop
	nop	



;*******************************************************************
; mmake_expobj	; make an exploding piece.

mmake_expobj
	miwt	r10,m_stack&WM

	

	iwt	r4,#EXPOBJ_LEN
	mcall	mmake_obj
	nop
	sm	[m_dynvar1],r1




; set explode flag
	mloadw	r2,OBJ_TYPE,r1
	msetreg	r2,OBJTYPE_exppiece
	mstorew	r2,OBJ_TYPE,r1

; set strategy
	iwt	r2,#mdo_expobj&WM
	mstorew	r2,OBJ_STRATPTR,r1  

	stop
	nop	

;*******************************************************************
; mmake_roadobj ; make a road object.

mmake_roadobj
	miwt	r10,m_stack&WM


	iwt	r4,#TOBJ_LEN
	mcall	mmake_obj
	nop
	sm	[m_dynvar1],r1
	
	mtest	r1
	beq	.error

; set last road piece's next ptr. to this piece.	
	lm	r2,[m_lastroadobj]
	mtest	r2
	beq	.first
	nop
	mstorew	r1,TOBJ_NEXT,r2
.first
	sm	[m_lastroadobj],r1

; set road flag
	mloadw	r2,OBJ_TYPE,r1
	msetreg	r2,OBJTYPE_road
	mstorew	r2,OBJ_TYPE,r1

	
.error
	stop
	nop	


;*******************************************************************
; mmake_markobj	; make a marker object.
mmake_markobj
	miwt	r10,m_stack&WM

	iwt	r4,#TOBJ_LEN
	mcall	mmake_obj
	nop
	sm	[m_dynvar1],r1

; set last road piece's next ptr. to this piece.	
	lm	r2,[m_lastmarkobj]
	mtest	r2
	beq	.first
	nop
	mstorew	r1,TOBJ_NEXT,r2
.first
	sm	[m_lastmarkobj],r1

; set marker flag
	mloadw	r2,OBJ_TYPE,r1
	msetreg	r2,OBJTYPE_marker
	mstorew	r2,OBJ_TYPE,r1

	
; set strategy
;	iwt	r2,#mdo_expobj&WM
;	mstorew	r2,OBJ_STRATPTR,r1  



	stop
	nop

;*******************************************************************
; mmake_TOBJ ; make a normal object.

mmake_TOBJ
	miwt	r10,m_stack&WM
	
	iwt	r4,#TOBJ_LEN
	mcall	mmake_obj
	nop
	sm	[m_dynvar1],r1


; set strategy
;	iwt	r2,#mdo_expobj&WM
;	mstorew	r2,OBJ_STRATPTR,r1  

	stop
	nop




;*******************************************************************
; mmake_car	: make a new car of type in m_dynvar1(WORD).
;		  returns ptr. to car in m_dynvar1(WORD)
;		  returns car shape in m_dynvar2(WORD)
;		  returns wheel shape in m_dynvar3(WORD)

mmake_car	
	miwt	r10,m_stack&WM

	iwt	r0,#car_defs>>16
	romb
	lm	r14,[m_dynvar1]

	iwt	r4,#CAR_LEN
	mcall	mmake_obj
	nop
	sm	[m_dynvar1],r1	

; car strategy
	iwt	r2,#mdo_car&WM
	mstorew	r2,OBJ_STRATPTR,r1

; car shape
	mgetwi	r0		
	sm	[m_dynvar2],r0	

; wheel shape
	mgetwi	r0		
	sm	[m_dynvar3],r0	

; centre of gravity
	mgetwi	r0	; X
	mgetwi	r2	; Y
	mstorew	r2,CAR_CENTGY,r1	
	mgetwi	r0	; Z
;	mstorew	r2,CAR_CENTGZ,r1	


	mcall	minit_car
	nop	

; set car flag
	mloadw	r2,OBJ_TYPE,r1
	msetreg	r2,OBJTYPE_car
	mstorew	r2,OBJ_TYPE,r1

	lm	r0,[m_testcar1]
	mtest	r0
	bne	.nfc
	nop
	sm	[m_testcar1],r1
.nfc

	stop
	nop







;*******************************************************************
; mmake_WHEEL	: make a wheel from definition ptr. in r14 and ROMB 
;		  and add it to a car (ptr. in r1) 
;
; entry:
;	r1  	- ptr. to CAR block
;	r14 	- wheel def. ptr
;	ROMB 	- wheel def. ROM bank
;
; exit: 
;	r1 	- ptr. to CAR block
;	r2 	- ptr. to new WHEEL
;	r14 	- ptr. to next wheel def.
;	ROMB 	- wheel def. ROM bank
;
; uses: r3	


mmake_WHEEL
	mpush	r11

	mpush	r1
	iwt	r4,#WHL_LEN
	mcall	mmake_obj
	nop
	move	r2,r1
	mpop	r1

; position.
	mgetwi	r3		; X
  	mneg	r3
	mstorew	r3,WHL_OFFSETX,r2

	mgetwi	r3		; Y
	mstorew	r3,WHL_OFFSETY,r2
	
	mgetwi	r3		; Z
	mstorew	r3,WHL_OFFSETZ,r2


; maxgrip.
	mgetwi	r3		
	mstorew	r3,WHL_MAXGRIP,r2

; flags.
	mgetwi	r3		
	mstorew	r3,WHL_FLAGS,r2


	mloadw	r3,CAR_WHEELS,r1
	mstorew	r3,WHL_NEXT,r2
	mstorew	r2,CAR_WHEELS,r1

; set wheel flag
	mloadw	r3,OBJ_TYPE,r2
	msetreg	r3,OBJTYPE_wheel
	mstorew	r3,OBJ_TYPE,r2


	mpop	pc
	nop





;*******************************************************************
; minit_car	: make a car from definition ptr. in r14 and ROMB 
;
; entry:
;	r14 	- wheel def. ptr
;	ROMB 	- wheel def. ROM bank
;	r1	- ptr. to car.

minit_car	

	mpush	r11

; make wheels.
	mcall	mmake_wheel
	nop	
	mcall	mmake_wheel
	nop	
	mcall	mmake_wheel
	nop	
	mcall	mmake_wheel
	nop	


	iwt	r2,#13107		offroad_friction		; mod
;	iwt	r2,#offroad_friction
	mstorew	r2,CAR_OFFROADFRICTION,r1
;	iwt	r2,#26214		road_friction
	iwt	r2,#road_friction
	mstorew	r2,CAR_ROADFRICTION,r1

	iwt	r2,#car1_boosttime
	mstorew	r2,CAR_BOOSTTIME,r1

	mpop	pc
	nop




;*******************************************************************
; mdo_dynamics	: do the dynamics.

rcarptr		=	r8
robjptr		=	r8
rWHEELptr	=	r9
rt1		=	r1


mdo_dynamics
	miwt	r10,m_stack&WM

	sub	r0
	sm	[m_test1],r0

	iwt	r0,#$ffff
	sm	[m_indynamics],r0

	lm	r0,[m_dynframe]
	inc	r0
	sm	[m_dynframe],r0



	
;----------------------------------------
; dynamics for all objects.		
	lm	r0,[m_objects]
.loop
	moves	robjptr,r0
	beq	.noobjs
	nop

	mloadw	r0,OBJ_STRATPTR,robjptr
	mtest	r0
	beq	.nextobj
	nop
	move	r12,r0
	mcallreg	r12
	nop
.nextobj
	mloadw	r0,OBJ_NEXT,robjptr
	bra	.loop
	nop
.noobjs


;----------------------------------------
;	munfrag_mem	m_dynmem,r1,r2,r3

	mcount_blocks	m_dynmem,r1,r2
;	sm	[m_test1],r2

;----------------------------------------


	sub	r0
	sm	[m_indynamics],r0

	stop
	nop

;*******************************************************************
; mdo_expobj	; explsion object strategy

mdo_expobj
	mpush	r11

	mloadw	rt1,OBJ_VELY,robjptr
	iwt	r0,#gravityPF/2
	to	rt1
	add	rt1
	mstorew	rt1,OBJ_VELY,robjptr

	ibt	r1,#3
	mcall	madd_vecs
	nop

;-------------------------------------------
; collisions.
	move	r9,r8
	mloadw	r8,EXPOBJ_OBJECT,r9		; ptr. to car.	
	mcall	mfind_objcolls
	nop

	
	move	r8,r9

	sub	r0
	sm	[m_oldshape],r0
	sm	[m_oldframenum],r0

	mloadw	r0,OBJ_COLLOBJ1,robjptr
	moves	r7,r0
	beq	.nocollobj1
	nop
	mcall	mchk_objcoll
	nop

	mloadw	r2,OBJ_COLLOBJ1,robjptr
	mcall	mdo_objcoll	
	nop


.nocollobj1

	mloadw	r0,OBJ_COLLOBJ2,robjptr
	moves	r7,r0
	beq	.nocollobj2
	nop
	mcall	mchk_objcoll
	nop

	mloadw	r2,OBJ_COLLOBJ2,robjptr
	mcall	mdo_objcoll	
	nop
.nocollobj2


	mloadw	r2,OBJ_WORLDY,robjptr	

	mcall	mset_gndgroup
	nop

	iwt	r3,#m_groupblocks&WM
	ibt	r2,#0
	mcall	mdo_objcollforce
	nop

;-------------------------------------------

	
	
	mpop	pc
	nop


;*******************************************************************
; mdo_OBJ	; do dynamics for normal object.
; 
; entry:
;	r8 	- ptr. to obj.
;
; exit:
;	r8 	- ptr. to obj.
;
; trashed:	r0-r7,r12,r13,r14	


robjptr	=	r8

mdo_OBJ

	mpop	pc
	nop

;************************************************************************
; mdo_objcoll - do the actual forces on an object from groups.
;
; entry:
;	r2		= ptr. to collision object. 0 if ground.
;	r9 		= ptr. to object

robjptr		=	r9
rgroupptr	=	r3
rgroupcnt	=	r13

mdo_objcoll
	mpush	r11


	iwt	rgroupptr,#(m_groupblocks+10)&WM
	ibt	rgroupcnt,#0

.grouploop
	inc	rgroupcnt
	ibt	r0,#max_groups
	cmp	rgroupcnt
	mlbeq	.groupend

	mcall	mdo_objcollforce
	nop

	mlbra	.grouploop

.groupend
	mpop	pc
	nop


;************************************************************************
; mdo_objcollforce - do forces on object from group.
;
; entry:
;	r3	= ptr. to group	data.
;	r2	= ptr. to collision object. 0 if ground.
;	r9	= ptr. to object.
; exit:
;	r3	= ptr. to next group.
;	r9	= ptr. to object.


rgroupptr	=	r3
rcollobjptr	=	r2
rD		=	r7
robjptr		=	r9

mdo_objcollforce

	mldwi	rgroupptr	; flags for group
	mtest	r0
	mlbne	.nogroup	

	to	rD
	mldwi	rgroupptr		


	mpush	r11

;---------------------------------------------------
; link collided object with wheel.
;
;	mtest	rcollobjptr
;	beq	.isgnd
;	nop
;	mstorew	robjptr,OBJ_COLLOBJ,rcollobjptr
;.isgnd
;
;---------------------------------------------------

	REPT	1
	with	rD	
	add	rD
	ENDR
	

; get force X
	move	r1,rD
	to	r6
	mldwi	rgroupptr	; normal X
	sm	[m_normx],r6
	with	r1
	fmult
	move	r4,r1

; get force Y
	move	r5,rD
	to	r6
	mldwi	rgroupptr	; normal Y
	sm	[m_normy],r6
	with	r5
	fmult

; get force Z
	to	r6
	mldwi	rgroupptr	; normal Z
	sm	[m_normz],r6
	from	rD
	to	r6
	fmult


	ifeq	0
	mloadw	r0,OBJ_WORLDX,robjptr
	to	r1
	add	r4	
	mstorew	r1,OBJ_WORLDX,robjptr

	mloadw	r0,OBJ_WORLDY,robjptr
	to	r1
	add	r5	
	mstorew	r1,OBJ_WORLDY,robjptr

	mloadw	r0,OBJ_WORLDZ,robjptr
	to	r1
	add	r6	
	mstorew	r1,OBJ_WORLDZ,robjptr
	endc

	iwt	r1,#0

	mloadw	r0,OBJ_VELX,robjptr
	add	r0
	lm	r6,[m_normx]
	fmult
	with	r1
	add	r0

	mloadw	r0,OBJ_VELY,robjptr
	add	r0
	lm	r6,[m_normy]
	fmult
	with	r1
	add	r0

	mloadw	r0,OBJ_VELZ,robjptr
	add	r0
	lm	r6,[m_normz]
	fmult
	with	r1
	add	r0

	move	r0,r1
	add	r0
	to	r1
	add	r1



	lm	r6,[m_normx]
	move	r0,r1
	fmult
	mloadw	r6,OBJ_VELX,robjptr
	with	r6
	sub	r0
	mstorew	r6,OBJ_VELX,robjptr

	lm	r6,[m_normy]
	move	r0,r1
	fmult
	mloadw	r6,OBJ_VELY,robjptr
	with	r6
	sub	r0
	mstorew	r6,OBJ_VELY,robjptr

	lm	r6,[m_normz]
	move	r0,r1
	fmult
	mloadw	r6,OBJ_VELZ,robjptr
	with	r6
	sub	r0
	mstorew	r6,OBJ_VELZ,robjptr

	
	mpop	pc
	nop

.nogroup
	ibt	r0,#(5*2)-2	
	with	rgroupptr
	add	r0
	move	pc,r11
	nop






;*******************************************************************
; mdo_CAR	: do the dynamics for a CAR.
; 
; entry:
;	r8 	- ptr. to car.
;
; exit:
;	r8 	- ptr. to car.
;
; trashed:	r0-r7,r12,r13,r14	
;

rcarptr		=	r8
rwheelptr	=	r9
rt1		=	r1
rt2		=	r2
rt3		=	r3
rt4		=	r4
rt5		=	r5
rt6		=	r6
rt7		=	r7

;----------------------------
; mrotpnty
rx	equr	1
ryrot	equr	2
rt	equr	2
rz	equr	3
rcosy	equr	5
rprodlo	equr	7
rprodhi	equr 	8
rsiny	equr	9

mdo_car
	mpush	r11



;-------------------------------------------------------------------
; CAR'S INTERNAL CAR DYNAMICS

	mloadw	r0,CAR_FLAGS,rcarptr
	iwt	r1,#CARflag_computer
	and	r1
	beq	.notcomp
	nop
	mcall	mdo_carAI
	nop
.notcomp


	mloadw	r0,CAR_FLAGS,rcarptr
	iwt	r1,#CARflag_dynoff
	and	r1
	mlbne	.end


;---------------------------------------------------------------------
	ibt	r1,#6
	mcall	madd_vecs
	nop


;---------------------------------------
; clear torque and displacement accums.
	sub	r0
	sm	[m_DISPx],r0
	sm	[m_DISPy],r0
	sm	[m_DISPz],r0
	sm	[m_TORQUEx],r0
	sm	[m_TORQUEy],r0
	sm	[m_TORQUEz],r0


;	mloadw	r0,CAR_FLAGS,rcarptr
;	sm	[m_carflags],r0	


;---------------------------------------
; gravity
;	mdebug	.ng
	iwt	rt1,#gravityPF
	sm	[m_DISPy],rt1
.ng



;---------------------------------------
; copy car's world x,y,z position.
	mloadw	r0,OBJ_WORLDX,rcarptr
	sm	[m_carworldx],r0
	mloadw	r0,OBJ_WORLDY,rcarptr
	sm	[m_carworldy],r0
	mloadw	r0,OBJ_WORLDZ,rcarptr
	sm	[m_carworldz],r0


;---------------------------------------
; copy car parameters
	mloadw	rt2,CAR_FLAGS,rcarptr
	iwt	rt1,#CARflag_hitflash!CARflag_collide
	with	rt2
	bic	rt1
	mstorew	rt2,CAR_FLAGS,rcarptr
	


	mloadw	rt3,CAR_OFFROADFRICTION,rcarptr
	mloadw	rt4,CAR_ROADFRICTION,rcarptr
	iwt	r0,#CARflag_computer
	and	rt2
	beq	.normalfr
	nop
	iwt	rt3,#comp_road_friction
	iwt	rt4,#comp_offroad_friction
.normalfr
	mloadw	rt1,CAR_TWISTTIME,rcarptr
	mtest	rt1
	beq	.ntwf
	nop
	dec	rt1
	mstorew	rt1,CAR_TWISTTIME,rcarptr
	iwt	rt3,#twist_friction
	move	rt4,rt3
.ntwf	

	iwt	r0,#CARflag_steerHardLeft!CARflag_steerHardRight
	and	rt2
	beq	.nshg

	mtest	rt1
	bne	.nresty
	nop
	iwt	rt1,#twist_time
	mstorew	rt1,CAR_TWISTTIME,rcarptr
.nresty

	ibt	rt1,#0
	mstorew	rt1,CAR_TORQUEY,rcarptr
.nshg

	
	sm	[m_offroadfriction],rt3
	sm	[m_onroadfriction],rt4



;---------------------------------------------------
; if off-road limit accel and boost.
	ifeq	0
	mloadw	r0,CAR_OFFROAD,rcarptr
	sub	#4
	bne	.noffroadlim
	nop
	mloadw	r0,CAR_GNDSPEED,rcarptr
	iwt	rt1,#100
	cmp	rt1
	bmi	.noffroadlim
	nop
	iwt	rt1,#CARflag_brake
	with	rt2
	or	rt1
	iwt	rt1,#CARflag_accel!CARflag_boost
	with	rt2
	bic	rt1
	mstorew	rt2,CAR_FLAGS,rcarptr
.noffroadlim
	endc

;---------------------------------------------------
; if hand present limit control.
	mloadw	r0,CAR_HANDOBJ,rcarptr
	mtest	r0
	bne	.domakestop
	nop
	iwt	r0,#CARflag_makestop
	and	rt2
	beq	.nmakestop
	nop
.domakestop
	iwt	rt1,#CARflag_accel!CARflag_deccel!CARflag_suck!CARflag_squish!CARflag_boost!CARflag_jump
	with	rt2
	bic	rt1
	mstorew	rt2,CAR_FLAGS,rcarptr
.nmakestop


;-----------------------------------------------------------------------



;-----------------------------------------------------
; jumping.
	mloadw	r1,CAR_JUMP,rcarptr
	mtest	r1
	beq	.jumpok
	nop
	dec	r1
	mstorew	r1,CAR_JUMP,rcarptr
	bra	.njump
	nop
.jumpok


	iwt	r0,#CARflag_jump
	and	rt2
	beq	.njump
	nop

	iwt	r1,#600
	lm	r0,[m_dispY]
	sub	r1
	sm	[m_dispY],r0

	iwt	r1,#20
	mstorew	r1,CAR_JUMP,rcarptr

.njump
;-----------------------------------------------------
; squishing. i.e. makeing car flat

	mloadw	r1,CAR_SQUISHY,rcarptr
	mtest	r1
	bne	.dosquish
	nop

	iwt	r0,#CARflag_squish
	and	rt2
	beq	.donesquish
	nop
.dosquish
	mtest	r1
	bpl	.nnegsq
	nop
	inc	r1
	bra	.donesquish2
	nop
.nnegsq

	iwt	r0,#car1_squishy_rate
	with	r1
	add	r0
	
	iwt	r0,#car1_squishy_max
	cmp	r1
	bpl	.donesquish2
	nop

	move	r1,r0
	iwt	r0,#CARflag_squish
	and	rt2
	bne	.donesquish2
	nop

	with	r1
	div2
;	from	r1
;	div2
;	div2
;	with	r1
;	sub	r0

	lm	r0,[m_dispY]
	sub	r1
;	sm	[m_dispY],r0
	ibt	r1,#-20

.donesquish2
	mstorew	r1,CAR_SQUISHY,rcarptr

.donesquish



;-----------------------------------------------------
; suck. i.e. making car thin

	mloadw	r1,CAR_SUCK,rcarptr
	mtest	r1
	bmi	.nsuck
	nop
	bne	.dosuck
       	nop

	iwt	r0,#CARflag_suck
	and	rt2
	beq	.nsuck
	nop

.dosuck
	iwt	r0,#car1_suck_max-1
	cmp	r1	
	bmi	.finsuck
	nop
	inc	r1
	bra	.donesuck
	nop
.finsuck
	iwt	r0,#CARflag_suck
	and	rt2
	bne	.donesuck
	nop

	mneg	r1
.nsuck
	mtest	r1
	beq	.suckz
      	nop
	inc	r1
.donesuck
	mstorew	r1,CAR_SUCK,rcarptr
.suckz	


;-----------------------------------------------------
; steering.


	mloadw	r0,CAR_FLAGS,rcarptr
	iwt	r1,#CARflag_computer
	and	r1
	mlbne	.donesteer
	

	IFEQ	1
	mloadw	r0,CAR_GNDSPEED,rcarptr
	iwt	rt5,#350
	cmp	rt5
	bmi	.nlim
	nop
	iwt	r0,#350
.nlim
	with	rt5
	sub	r0

	with	rt5
	add	rt5
	with	rt5
	add	rt5
	with	rt5
	add	rt5
	with	rt5
	add	rt5

	iwt	r0,#CARflag_deccel!CARflag_accel
	and	rt2
	bne	.nfasts
	nop
	with	rt5
	add	rt5	
.nfasts
	ENDC

	ifeq	1
 	iwt	rt5,#(deg11*256)*2

	iwt	rt3,#0
	iwt	rt4,#0
	endc


; Target Aim System.
	mpush	rt2

	iwt	r1,#deg5*256
	mcall	mget_best_line
	nop

	mloadw	r0,CAR_HANDOBJ,rcarptr
	mtest	r0
	beq	.nhanddir
	nop
	mloadw	r0,OBJ_ROTY,rcarptr
	move	rt3,r0
	sub	r1
	div2	
	div2
	with	rt3
	sub	r0
	mstorew	rt3,OBJ_ROTY,rcarptr
.nhanddir



;	move	rt3,r1
;	with	rt3
;	div2
;	with	rt3
;	div2
;	with	rt3
;	div2
;	with	r1
;	sub	rt3
	iwt	rt3,#0
	

 	iwt	rt5,#(deg11*256)
	moves	rt4,r1
	bmi	.isleft
	nop
	move	rt5,rt4	
 	iwt	rt4,#-(deg11*256)
.isleft

	mpop	rt2


	iwt	rt3,#0
	iwt	rt4,#((-deg22*256)*60)/100		; mod
	iwt	rt5,#((deg22*256)*60)/100



	iwt	r0,#CARflag_steerLeft!CARflag_steerRight!CARflag_steerHardLeft!CARflag_steerHardRight
	and	rt2
	mlbeq	.nosteer

	ifeq	1
	mloadw	rt4,CAR_WHLTURNSPEED,rcarptr
	mtest	rt4
	bne	.nreset
	nop
	iwt	rt4,#32767
.nreset

	iwt	r0,#16384
	with	rt4
	cmp	r0 
	bmi	.ndec
	nop

	iwt	r0,#8000
	with	rt4
	sub	r0  
.ndec
	endc


;------------------------
; steer left.	
	iwt	r0,#CARflag_steerLeft
	and	rt2
	beq	.nsleft
	nop
	with	rt3
	add	rt5

;	mloadw	rt1,OBJ_ROTY,rcarptr
;	iwt	r0,#3*256
;	with	rt1
;	add	r0
;	mstorew	rt1,OBJ_ROTY,rcarptr

.nsleft

;------------------------
; steer right.	
	iwt	r0,#CARflag_steerRight
	and	rt2
	beq	.nsright
	nop
	with	rt3
	add	rt4

;	mloadw	rt1,OBJ_ROTY,rcarptr
;	iwt	r0,#3*256
;	with	rt1
;	sub	r0
;	mstorew	rt1,OBJ_ROTY,rcarptr

.nsright

;------------------------
; steer hard left.	
	iwt	r0,#CARflag_steerHardLeft
	and	rt2
	beq	.nshleft
	nop
	mloadw	r1,OBJ_ROTY,rcarptr
	iwt	r0,#256*8
	with	r1
	add	r0
	mstorew	r1,OBJ_ROTY,rcarptr
	
;	with	rt3
;	add	rt5
.nshleft

;------------------------
; steer hard right.	
	iwt	r0,#CARflag_steerHardRight
	and	rt2
	beq	.nshright
	nop
	mloadw	r1,OBJ_ROTY,rcarptr
	iwt	r0,#256*8
	with	r1
	sub	r0
	mstorew	r1,OBJ_ROTY,rcarptr

;	with	rt3
;	add	rt4
.nshright

	bra	.dosteer
	nop

.nosteer



.dosteer

;	mstorew	rt4,CAR_WHLTURNSPEED,rcarptr
;	move	r6,rt4
;	with	rt3
;	fmult	

	mstorew	rt3,CAR_ENGINEROTY,rcarptr


.donesteer

;-----------------------------------------------------
; gears



	iwt	r0,#mcar1gears_speeds>>16
	romb
	iwt	r14,#mcar1gears_speeds&WM
	ibt	rt4,#0
	ibt	rt5,#0
	mloadw	rt3,CAR_GNDSPEED,rcarptr
	iwt	r12,#car1_maxgear
	move	r13,pc
	mgetwi	r0
	cmp	rt3
	bpl	.gearend
	nop
	move	rt5,r0
	loop
	nop

.gearend
	ibt	r0,#car1_maxgear+1
	to	rt4
	sub	r12




;-------------------------------------
; check if on ground.
	ifeq	1
	mloadw	rt1,CAR_WHEELS,rcarptr
	sub	r0
	mloadw	rt6,WHL_FLAGS,rt1
	or	rt6

	mloadw	rt3,WHL_NEXT,rt1	
	mloadw	rt6,WHL_FLAGS,rt3
	or	rt6

	mloadw	rt1,WHL_NEXT,rt3	
	mloadw	rt6,WHL_FLAGS,rt1
	or	rt6

	mloadw	rt3,WHL_NEXT,rt1	
	mloadw	rt6,WHL_FLAGS,rt3
	or	rt6


;	move	rt4,r0
;	mstorew	rt4,CAR_TEST1,rcarptr

	iwt	rt3,#WHLflag_ongnd
	and	rt3
	bne	.ongnd
	nop
	iwt	r0,#50<<car_scale
	with	rt5
	sub	r0
.ongnd

	mstorew	rt5,CAR_TEST1,rcarptr
	endc

;-------------------------------------


;	mloadw	r0,CAR_GEAR,rcarptr
;	cmp	rt4
;	beq	.ongear
;	nop
;	bmi	.gearup
;	nop
;.geardown
;	bra	.stgear	
;	inc	r0
;.gearup
;
;
;.stgear

	lm	r0,[m_dynframe]
	and	#3
	bne	.ongear
	nop	
.gotgear
	mstorew	rt4,CAR_GEAR,rcarptr

.ongear

	ifeq	1
	mloadw	rt1,CAR_GEAR,rcarptr
	iwt	r0,#CARflag_gearup
	and	rt2
	beq	.ngearup
	nop
	iwt	r0,#car1_maxgear
	cmp	rt1
	beq	.ngearup
	nop
	inc	rt1
.ngearup

	iwt	r0,#CARflag_geardown
	and	rt2
	beq	.ngeardown
	nop
	iwt	r0,#car1_mingear
	cmp	rt1
	beq	.ngeardown
	nop
	dec	rt1
.ngeardown


	mstorew	rt1,CAR_GEAR,rcarptr
	endc


;-----------------------------------------------------
; acceleration/decceleration/brakeing

	ibt	rt1,#0
	iwt	r0,#CARflag_accel
	and	rt2
	beq	.naccel
	nop
	iwt	rt1,#car1_accel
.naccel
	iwt	r0,#CARflag_deccel
	and	rt2
	beq	.ndeccel
	nop
	iwt	rt1,#-car1_accel/2
.ndeccel

	mloadw	r6,CAR_BOOSTTIME,rcarptr

	iwt	r0,#CARflag_boost
	and	rt2
	beq	.nboost
	nop
	iwt	rt1,#0
	
	mtest	r6
	beq	.nresboost
	dec	r6
	mstorew	r6,CAR_BOOSTTIME,rcarptr
	iwt	rt1,#car1_boost
	bra	.nresboost
	nop
.nboost
	iwt	r0,#car1_boosttime
	cmp	r6
	beq	.nresboost
	inc	r6
	mstorew	r6,CAR_BOOSTTIME,rcarptr
.nresboost

;	mstorew	rt1,CAR_ACCEL,rcarptr


	iwt	r0,#mcar1gears_data>>16
	romb
	iwt	r14,#mcar1gears_data&WM
	
	mloadw	r0,CAR_GEAR,rcarptr
	iwt	r6,#17
	mult	r6
	with	r14
	add	r0	
	sub	r0
	to	r6
	getbh			; get gear ratio
	move	rt4,r6
	inc	r14		; skip gear ratio
	mloadw	r0,CAR_GNDSPEED,rcarptr
	add	r0		; * 2 for fmult
	fmult			; find gear state (0-16)
	ibt	rt3,#16
	cmp	rt3
	bmi	.nacmax
	nop
	move	r0,rt3
.nacmax

	with	r14
	add	r0	
	sub	r0
	to	r6
	getbh			; get current gear power

	with	rt1
	add	rt1
	with	rt1
	fmult

.nogears
	mloadw	rt3,CAR_GNDSPEED,rcarptr	
	iwt	r0,#400
	cmp	rt3
	bpl	.nmaxspeed
	nop	
	ibt	rt1,#0
.nmaxspeed
.gotaccel
	mstorew	rt1,CAR_ACCEL,rcarptr

	with	rt3
	sub	rt5
	with	rt3
	mult	#4	


	move	r6,rt4
	with	rt5
	add	rt5
	with	rt5
	fmult	
	ibt	r0,#31
	with	rt5
	mult	r0

	with	rt5
	add	rt3
	
	mloadw	rt1,CAR_REVS,rcarptr
	from	rt5
	sub	rt1
	div2

	with	rt1
	add	r0

	mstorew	rt1,CAR_REVS,rcarptr
.noaccel



	iwt	rt1,#wheel_friction

	iwt	r0,#CARflag_accel!CARflag_boost
	and	rt2
	bne	.accelfr
	nop
	iwt	rt1,#freewheel_friction
.accelfr

	iwt	r0,#CARflag_brake
	and	rt2
	beq	.nbrake
	nop
	iwt	rt1,#car1_brake*4		; mod
.nbrake

	iwt	r0,#CARflag_makestop
	and	rt2
	beq	.nmakestopfr
	nop
	iwt	rt1,#16384
.nmakestopfr


	mstorew	rt1,CAR_WHLFRICTION,rcarptr


;-----------------------------------------------------
; create car's engine power matrix. - rmat
	mpush	rcarptr
	sub	r0
	sms	[m_rotx],r0
	sms	[m_rotz],r0
	mloadw	r0,CAR_ENGINEROTY,rcarptr
	mneg	r0
	sms	[m_roty],r0
	iwt	r9,#m_rmat11&WM
	mcall	mcrotmatzxy16
	nop
	iwt	r9,#m_rmat11&WM
	mcall	mtransmat16
	nop
	mpop	rcarptr

;-----------------------------------------------------
; engine power force.

	iwt	r1,#0
	move	r2,r1
	mloadw	r3,CAR_ACCEL,rcarptr
	mdotprod16mq	m_rmat11,m_rmat21,m_rmat31
	sm	[m_engineX],r0
	mdotprod16mq	m_rmat12,m_rmat22,m_rmat32
	sm	[m_engineY],r0
	mdotprod16mq	m_rmat13,m_rmat23,m_rmat33
	sm	[m_engineZ],r0

;-----------------------------------------------------
; create full car rotation matrix. - wmat
	mpush	rcarptr
	mloadw	r0,OBJ_ROTX,rcarptr
	mneg	r0
	sms	[m_rotx],r0
	mloadw	r0,OBJ_ROTY,rcarptr
	mneg	r0
	sms	[m_roty],r0
	mloadw	r0,OBJ_ROTZ,rcarptr
	mneg	r0
	sms	[m_rotz],r0
	iwt	r9,#m_wmat11&WM
	mcall	mcrotmatzxy16
	nop
	iwt	r9,#m_wmat11&WM
	mcall	mtransmat16
	nop
	mpop	rcarptr



	
	
;-----------------------------------------------------
; check if collision with other car.

	mcall	mcar2carcoll
	nop

;-----------------------------------------------------
; wheely

	mloadw	r2,CAR_FLAGS,rcarptr
	iwt	r0,#carflag_wheely
	and	r2
	beq	.nwheely
	nop

	mcall	minit_force
	nop

	iwt	r4,#0
	iwt	r5,#-400
	iwt	r6,#0
	mcall	madd_intforce
	nop

;	iwt	r1,#0
;	iwt	r2,#10
;	iwt	r3,#50<<car_scale
;	mcall	mcalc_disp
;	nop


	iwt	r1,#0
	iwt	r2,#0
	iwt	r3,#512
	mcall	mcalc_torque
	nop

	

	
.nwheely



;-----------------------------------------------------
; check if hand object present.

; used by the rotate.
rx		=	r1
ry		=	r2
rz		=	r3



	mloadw	r7,CAR_HANDOBJ,rcarptr
	mtest	r7
	mlbeq	.nhand
	
;	mloadw	r1,OBJ_WORLDX,r7
;	mstorew	r1,OBJ_WORLDX,rcarptr
;	mloadw	r1,OBJ_WORLDY,r7
;	iwt	r0,#100
;	with	r1
;	add	r0
;	mstorew	r1,OBJ_WORLDY,rcarptr
;	mloadw	r1,OBJ_WORLDZ,r7
;	mstorew	r1,OBJ_WORLDZ,rcarptr

	

	ifeq	0

	mcall	minit_force
	nop

;	iwt	r1,#30<<car_scale


	mloadw	r4,OBJ_WORLDX,r7
	mloadw	r0,OBJ_WORLDX,rcarptr
	with	r4
	sub	r0


	mloadw	r5,OBJ_WORLDY,r7
	mloadw	r0,OBJ_WORLDY,rcarptr
	with	r5
	sub	r0
	iwt	r0,#110
	with	r5
	add	r0


	mloadw	r6,OBJ_WORLDZ,r7
	mloadw	r0,OBJ_WORLDZ,rcarptr
	with	r6
	sub	r0

	rept	dynshift+2
	with	r4
	add	r4
	with	r5
	add	r5
	with	r6
	add	r6
	endr

	mloadw	r0,OBJ_VELX,rcarptr
	div2
	with	r4
	sub	r0

	mloadw	r0,OBJ_VELY,rcarptr
	div2
	with	r5
	sub	r0
	
	mloadw	r0,OBJ_VELZ,rcarptr
	div2
	with	r6
	sub	r0

;	iwt	r1,#-400
;	iwt	r2,#400
;	mrange	r4,r1,r2	
;	mrange	r5,r1,r2	
;	mrange	r6,r1,r2	

	mcall	madd_extforce
	nop

	


	iwt	r1,#-20<<car_scale
	iwt	r2,#-20<<car_scale
	iwt	r3,#-20<<car_scale			100<<car_scale
	mcall	mcalc_disp		rot
	nop


	iwt	r1,#0
	iwt	r2,#-8192		-2048		8192		-20<<car_scale
	iwt	r3,#0			100<<car_scale
	mcall	mcalc_torque
	nop


	mloadw	r0,OBJ_ROTX,rcarptr
	move	r1,r0
	div2
	div2
	div2
	with	r1
	sub	r0
	mstorew	r1,OBJ_ROTX,rcarptr

	mloadw	r0,OBJ_ROTZ,rcarptr
	move	r1,r0
	div2
	div2
	with	r1
	sub	r0
	mstorew	r1,OBJ_ROTZ,rcarptr

	ibt	r1,#0
	mstorew	r1,CAR_TORQUEY,rcarptr
	mstorew	r1,CAR_TORQUEZ,rcarptr
	mstorew	r1,CAR_TORQUEX,rcarptr
	



	endc

.nhand




;-----------------------------------------------------



	mcall	mdo_wheels
	nop



;---------------------------------------
; limit X,Y,Z rotation to 45 degress

	ifeq	0
	ibt	r2,#0
	mloadw	r0,OBJ_ROTZ,rcarptr
	iwt	r1,#(deg90-deg22)*256
	cmp	r1
	bmi	.zmaxok
	nop
	dec	r1
	mstorew	r1,OBJ_ROTZ,rcarptr
	mstorew	r2,CAR_TORQUEZ,rcarptr	
	bra	.zminok
	nop
.zmaxok
	iwt	r1,#-(deg90-deg22)*256
	cmp	r1
	bpl	.zminok
	nop
	inc	r1
	mstorew	r1,OBJ_ROTZ,rcarptr
	mstorew	r2,CAR_TORQUEZ,rcarptr	
.zminok


	mloadw	r0,OBJ_ROTX,rcarptr
	iwt	r1,#deg45*256
	cmp	r1
	bmi	.xmaxok
	nop
	dec	r1
	mstorew	r1,OBJ_ROTX,rcarptr
	mstorew	r2,CAR_TORQUEX,rcarptr	
	bra	.xminok
	nop
.xmaxok
	iwt	r1,#-deg45*256
	cmp	r1
	bpl	.xminok
	nop
	inc	r1
	mstorew	r1,OBJ_ROTX,rcarptr
	mstorew	r2,CAR_TORQUEX,rcarptr	
.xminok

	
	IFEQ	1			allow360
	mloadw	r0,OBJ_ROTY,rcarptr
	iwt	r1,#(deg45+deg22)*256
	cmp	r1
	bmi	.ymaxok
	nop
	dec	r1
	mstorew	r1,OBJ_ROTY,rcarptr
	mstorew	r2,CAR_TORQUEY,rcarptr	
	bra	.yminok
	nop
.ymaxok
	iwt	r1,#-(deg45+deg22)*256
	cmp	r1
	bpl	.yminok
	nop
	inc	r1
	mstorew	r1,OBJ_ROTY,rcarptr
	mstorew	r2,CAR_TORQUEY,rcarptr	
.yminok
	ENDC

	endc



;---------------------------------------------------------------------
; ADD CALCULATED DISPLACEMENT AND TORQUE VALUES
	
	iwt	r1,#-3000
	iwt	r2,#3000
	lm	r0,[m_dispy]	
	mrange	r0,r1,r2
	sm	[m_dispy],r0

	lm	r0,[m_torquez]	
	mrange	r0,r1,r2
	sm	[m_torquez],r0

	lm	r0,[m_torquey]	
	mrange	r0,r1,r2
	sm	[m_torquey],r0



	mcache
	iwt	rt4,#m_DISPx&WM
	iwt	rt2,#OBJ_VELX
	with	rt2
	add	rcarptr

	ibt	r12,#6
	move	r13,pc

	mldwi	rt4	; disp. x
	to	rt3
	ldw	[rt2]	; vel x
	add	rt3
	mstwi	rt2
	loop
	nop





.endmaxzrot


;---------------------------------------------------------------------
; round down velocties to stop wobble.
rounddown	=	64	

	iwt	r1,#CAR_TORQUEX
	with	r1
	add	rcarptr

	mloadw	r2,CAR_ACCEL,rcarptr
	moves	r2,r2
	mlbne	.power

	iwt	r1,#OBJ_VELX
	with	r1
	add	rcarptr

	ldw	[r1]
	mround_down	r0,r2,rounddown		; vel x
	mstwi	r1

	inc	r1				; vel y
	inc	r1

	ldw	[r1]
	mround_down	r0,r2,rounddown		; vel z
	mstwi	r1

.power
	ldw	[r1]
	mround_down	r0,r2,rounddown*2		; torque x
	mstwi	r1

	ldw	[r1]
	mround_down	r0,r2,rounddown*2		; torque y
	mstwi	r1

	ldw	[r1]
	mround_down	r0,r2,rounddown*2		; torque z
	stw	[r1]



;---------------------------------------------------------------------
; calc. ground speed.

	mloadw	r0,OBJ_VELX,rcarptr
	mloadw	r1,OBJ_VELY,rcarptr
	mloadw	r2,OBJ_VELZ,rcarptr
	mabs	r0,r0
;	mabs	r1,r1	
	mabs	r2,r2	
;	add	r1
	add	r2
	REPT	dynshift
	div2
	ENDR
	move	r1,r0
	mstorew	r1,CAR_GNDSPEED,rcarptr	

;---------------------------------------------------------------------
; save Y acceleration for animation.

	mloadw	r1,CAR_ACCELY,rcarptr
	lm	r0,[m_dispY]
	sub	r1
	div2
	to	r1
	add	r1	
	mstorew	r1,CAR_ACCELY,rcarptr
		   
;---------------------------------------------------------------------
; car animations.

	ibt	r0,#car1_anims>>16
	romb

;---------------------------------------------------------------------
; calculate relative Z acceleration of car.
	
	ifeq	1
	lm	r1,[m_dispx]
 	lm	r2,[m_dispy]
	lm	r3,[m_dispz]
	mdotprod16mq	m_wmat31,m_wmat32,m_wmat33
	mabs	r0,r0
	iwt	r1,#car1_zanim_max
	cmp	r1
	bmi	.notzamax
	nop
	move	r0,r1	
.notzamax

	iwt	r6,#car1_zanim_scale
	fmult	
	moves	r1,r0
	beq	.nzanim
	nop
	mstorew	r1,CAR_ZIMPACT,rcarptr

	iwt	r14,#(car1_anims+car1_zanim)&wm
	with	r14
	add	r1	
	getb
	lob
	mlbra	.danim
.nzanim
	endc


;---------------------------------------------------------------------
; calculate the total squish and suck of car.

	iwt	r14,#(car1_anims+car1_anim_norm)&wm

	mloadw	r0,CAR_SQUISHY,rcarptr
	mtest	r0
	beq	.nsquishy
	nop
	bmi	.nsquishy
	nop

	iwt	r6,#car1_squishy_anim_scale
	fmult	
	with	r14
	add	r0

.nsquishy
	mloadw	r0,CAR_SUCK,rcarptr
	mtest	r0
	beq	.ncsuck
	nop
	bmi	.nsuckn
	nop
	mneg	r0	
.nsuckn	

	with	r14
	add	r0

.ncsuck
	getb

.danim
	move	r1,r0
	mstorew	r1,CAR_SIZEANIM,rcarptr	


;---------------------------------------------------------------------


	mloadw	r2,CAR_FLAGS,rcarptr
	iwt	r0,#CARflag_computer
	and	r2
	bne	.ndam
	nop
	
	lm	r1,[m_totaldamage]
	mstorew	r1,CAR_TOTALDAMAGE,rcarptr
.ndam

;---------------------------------------------------------------------
	mloadw	r2,CAR_REVS,rcarptr
	mloadw	r0,CAR_OFFGND,rcarptr
	ibt	r1,#4
	cmp	r1
	bmi	.nhirev
	nop
	with	r2
	add	r2
.nhirev

	mloadw	r1,CAR_REVSND,rcarptr
	from	r2
	sub	r1
	div2
	to	r1
	add	r1
	mstorew	r1,CAR_REVSND,rcarptr




.end

	mpop	pc
	nop

; REPT RE_LOAD COMMENT
; REPT RE_LOAD COMMENT
; REPT RE_LOAD COMMENT
; REPT RE_LOAD COMMENT
; REPT RE_LOAD COMMENT
; REPT RE_LOAD COMMENT
; REPT RE_LOAD COMMENT



;*******************************************************************
mcar2carcoll
	mpush	r11

	iwt	r1,#CARflag_collide
	mloadw	r0,CAR_FLAGS,rcarptr
	to	r1
	bic	r1
	mstorew	r1,CAR_FLAGS,rcarptr

	mloadw	r7,OBJ_COLLOBJ,rcarptr
	mtest	r7
	mlbeq	.ncol1

	iwt	r1,#CARflag_collide
	mloadw	r0,CAR_FLAGS,rcarptr
	to	r1
	or	r1
	mstorew	r1,CAR_FLAGS,rcarptr

	ibt	r1,#0
	mstorew	r1,OBJ_COLLOBJ,rcarptr
	

;	mloadw	r0,OBJ_LASTCOLLOBJ,rcarptr
;	cmp	r7
;	mlbeq	.ncol
;	mstorew	r7,OBJ_LASTCOLLOBJ,rcarptr


	mcall	minit_force
	nop


	mloadw	r4,OBJ_VELX,r7
	mloadw	r0,OBJ_VELX,rcarptr
	with	r4
	sub	r0
	mloadw	r5,OBJ_VELY,r7
	mloadw	r0,OBJ_VELY,rcarptr
	with	r5
	sub	r0
	mloadw	r6,OBJ_VELZ,r7
	mloadw	r0,OBJ_VELZ,rcarptr
	with	r6
	sub	r0


	REPT	1
	with	r4
	add	r4
	with	r5
	add	r5
	with	r6
	add	r6
	ENDR
	mcall	madd_extforce	
	nop


	mloadw	r1,OBJ_WORLDX,r7
	lm	r0,[m_carworldx]
	with	r1
	sub	r0
	sms	[m_rotx],r1
	mloadw	r2,OBJ_WORLDY,r7
	mloadw	r4,CAR_CENTGY,r7
	with	r2
	add	r4
	lm	r0,[m_carworldy]
	mloadw	r4,CAR_CENTGY,rcarptr
	add	r4
	with	r2
	sub	r0
	ibt	r2,#0
	sms	[m_roty],r2
	mloadw	r3,OBJ_WORLDZ,r7
	lm	r0,[m_carworldz]
	with	r3
	sub	r0
	sms	[m_rotz],r3
	mcall	mcalc_disp		; world coord input !
	nop	 

	
	lms	r1,[m_rotx]
	lms	r2,[m_roty]
	lms	r3,[m_rotz]
	mdotprod16mq	m_wmat11,m_wmat12,m_wmat13	
	sms	[m_rotx],r0
	mdotprod16mq	m_wmat21,m_wmat22,m_wmat23
	sms	[m_roty],r0		
	mdotprod16mq	m_wmat31,m_wmat32,m_wmat33
	sms	[m_rotz],r0
	lms	r1,[m_rotx]
	lms	r2,[m_roty]
	lms	r3,[m_rotz]
	mcall	mcalc_torque
	nop	 


	bra	.ncol
	nop

.ncol1
	ibt	r7,#0
	mstorew	r7,OBJ_LASTCOLLOBJ,rcarptr

.ncol
	mpop	pc
	nop	



;*******************************************************************
; madd_vecs : add vectors for an object.
;
; entry:
;	r8	= ptr. to object
;	r1	= number of vectors to add (3/6) (vel/vel&torque)

robjptr	=	r8


addvec	MACRO	0/1, no scale/scale
	mldwi	r5
;	lmult
;	masrl	r0,r4	
;	masrl	r0,r4
;	lob
;	swap
;	with	r4
;	hib	
;	or	r4	


	IFNE	\1
	REPT	dynshift
	div2
	ENDR
	ENDC
	to	r3
	ldw	[r2]	; world x
	add	r3
	mstwi	r2
	ENDM

madd_vecs

	lm	r6,[m_framec]
	ibt	r0,#7
	cmp	r6
	bpl	.ok
	nop
	move	r6,r0
.ok
	iwt	r0,#256
	lmult	
	move	r6,r4


	iwt	r5,#OBJ_VELx
	with	r5
	add	robjptr
	iwt	r2,#OBJ_WORLDX
	with	r2
	add	robjptr

	
	addvec	1
	addvec	1
	addvec	1

	from	r1
	sub	#6
	bne	.nt
	nop
	addvec	0
	addvec	0
	addvec	0
.nt
	
;	loop
;	nop

	move	pc,r11
	nop






;*******************************************************************
; mdo_wheels	: do the dynamics for the wheels.
; 
; entry:
;	r8 	- ptr. to car.

rcarptr	=	r8

; used by the rotate.
rx		=	r1
ry		=	r2
rz		=	r3
rinptr		=	r8
routptr		=	r11
rcarptrtemp	=	r12

; other
rwheelptr	=	r9
rt1		= 	r1 
rt2		= 	r2
rt3		= 	r3
rt4		= 	r4


mdo_wheels


	mpush	r11



	sub	r0
	sm	[m_oldshape],r0
	sm	[m_oldframenum],r0
	sm	[m_test2],r0
	sm	[m_totaldamage],r0

	ibt	r1,#0
	mstorew	r1,CAR_OFFGND,rcarptr
	mstorew	r1,CAR_OFFROAD,rcarptr
	mstorew	r1,CAR_SKID,rcarptr



;--------------------------------------------------------	
; do wheel rotations.

	mloadw	r0,CAR_WHEELS,rcarptr

.nextWHEELrot
	moves	rWHEELptr,r0
	mlbeq	.donewheelrots
	nop


;-----------------------------------	
; scale X depending on car's x anim frame
	
	mloadw	r1,WHL_OFFSETX,rwheelptr

	mloadw	r0,CAR_SIZEANIM,rcarptr
	sub	#car1_anim_normframe
	beq	.skipxan
	nop
	iwt	r6,#car1_xanim_scale
	lmult	
	move	r6,r4

	move	r0,r1
	fmult	     
	to	r1
	sub	r1  
.skipxan 

	mstorew	r1,WHL_NOFFSETX,rwheelptr

	mloadw	r2,WHL_OFFSETY,rwheelptr
	mloadw	r3,WHL_OFFSETZ,rwheelptr

	mstorew	r2,WHL_NOFFSETY,rwheelptr
	mstorew	r3,WHL_NOFFSETZ,rwheelptr

	

;-----------------------------------	
; rotate the WHEEL - uses r0-r7,r12,r13
	
	move	rcarptrtemp,rcarptr
	iwt	rinptr,#WHL_NOFFSETX
	with	rinptr
	add	rWHEELptr

	iwt	routptr,#m_whlrotposx&WM

	to	rx
	mldwi	rinptr
	to	ry
	mldwi	rinptr
	to	rz
	mldwi	rinptr
	

	mdotprod16mq	m_wmat11,m_wmat21,m_wmat31
	mstwi	routptr			    
	mdotprod16mq	m_wmat12,m_wmat22,m_wmat32
	mstwi	routptr
	mdotprod16mq	m_wmat13,m_wmat23,m_wmat33
	mstwi	routptr

	move	rcarptr,rcarptrtemp

;------------------------------------	
; add world position of car to wheel.

	iwt	r6,#1<<dynshift

	lm	rt1,[m_whlrotposx]
	mstorew	rt1,WHL_ROTOFFX,rwheelptr
	lm	r0,[m_carworldx]
	mloadw	rt2,OBJ_WORLDX,rwheelptr
	with	rt1
	add	r0
	mstorew	rt1,OBJ_WORLDX,rwheelptr
	with	rt1
	sub	rt2
	with	rt1
	lmult
	mstorew	r4,OBJ_VELX,rwheelptr

	lm	rt1,[m_whlrotposy]
	mstorew	rt1,WHL_ROTOFFY,rwheelptr
	lm	r0,[m_carworldy]
	mloadw	rt2,OBJ_WORLDY,rwheelptr
	with	rt1
	add	r0
	mstorew	rt1,OBJ_WORLDY,rwheelptr
	with	rt1
	sub	rt2
	with	rt1
	lmult
	mstorew	r4,OBJ_VELY,rwheelptr

	lm	rt1,[m_whlrotposz]
	mstorew	rt1,WHL_ROTOFFZ,rwheelptr
	lm	r0,[m_carworldz]
	mloadw	rt2,OBJ_WORLDZ,rwheelptr
	with	rt1
	add	r0
	mstorew	rt1,OBJ_WORLDZ,rwheelptr
	with	rt1
	sub	rt2
	with	rt1
	lmult
	mstorew	r4,OBJ_VELZ,rwheelptr


	mloadw	r0,WHL_NEXT,rWHEELptr
	mlbra	.nextWHEELrot
	nop
.donewheelrots



;----------------------------------------------------------------------------------
; do dynamics of the wheels

; create car x,y,z rotation matrix  - wmat
	mpush	rcarptr
	mloadw	r0,OBJ_ROTX,rcarptr
	mneg	r0
	sms	[m_rotx],r0
	mloadw	r0,OBJ_ROTY,rcarptr
	mneg	r0
	sms	[m_roty],r0
	mloadw	r0,OBJ_ROTZ,rcarptr
	sub	r0
	sms	[m_rotz],r0
	iwt	r9,#m_wmat11&WM
	mcall	mcrotmatzxy16
	nop
	iwt	r9,#m_wmat11&WM
	mcall	mtransmat16
	nop
	mpop	rcarptr
;-----------------------------------

	mloadw	r0,CAR_WHEELS,rcarptr

.nextWHEELchk
	moves	rWHEELptr,r0
	beq	.donewheelchk
	nop


	mcall	mfind_objcolls
	nop


	mcall	mwheel_dynamic
	nop


	mloadw	r0,WHL_NEXT,rwheelptr
	bra	.nextWHEELchk
	nop
.donewheelchk


;	mcall	mchk_carhalfon
;	nop

.end
	mpop	pc
	nop


;*******************************************************************
; mchk_carhalfon	; check if car is half on the track.
;			; N.B. only to be called if car has 4 wheels.
;			;      NO check is made (for speed) 
;
; entry:
;	r8 	- ptr. to car.
;

rwheelptr1	=	r1
rwheelptr2	=	r2

mchk_carhalfon
	mpush	r11

	mloadw	rwheelptr1,CAR_WHEELS,rcarptr
	
	mpush	rwheelptr1


	mloadw	rwheelptr2,WHL_NEXT,rwheelptr1
	mcall	mchk_2wheelshalfon
	nop
	move	rwheelptr1,rwheelptr2

	mloadw	rwheelptr2,WHL_NEXT,rwheelptr1
	mcall	mchk_2wheelshalfon
	nop
	move	rwheelptr1,rwheelptr2

	mloadw	rwheelptr2,WHL_NEXT,rwheelptr1
	mcall	mchk_2wheelshalfon
	nop
	move	rwheelptr1,rwheelptr2
	

	mpop	rwheelptr2
	mcall	mchk_2wheelshalfon
	nop


	mpop	pc
	nop


;*******************************************************************
; mchk_2wheelshalfon	; check if 1 wheel on, 1 wheel off
;
; entry:
;	r1 - wheel ptr. 1	
;	r2 - wheel ptr. 2	
;


rwheelptr1	=	r1
rwheelptr2	=	r2

mchk_2wheelshalfon	
	mpush	r11

	iwt	r3,#whlflag_ongnd

	
	mloadw	r0,WHL_FLAGS,rwheelptr1
	mloadw	r1,WHL_FLAGS,rwheelptr2
	xor	r1
	and	r3
	mlbeq	.nhalf
	

	mloadw	r0,WHL_TRACKFORCEX,rwheelptr1
	mloadw	r1,WHL_TRACKFORCEY,rwheelptr1
	mloadw	r2,WHL_TRACKFORCEZ,rwheelptr1

	mloadw	r4,WHL_TRACKFORCEX,rwheelptr1
	mloadw	r5,WHL_TRACKFORCEY,rwheelptr1
	mloadw	r6,WHL_TRACKFORCEZ,rwheelptr1

	with	r4
	add	r0
	with	r5
	add	r1
	with	r6
	add	r2

	mcall	minit_force
	nop

	mcall	madd_extforce
	nop


	mloadw	r0,WHL_OFFSETX,rwheelptr1
	mloadw	r1,WHL_OFFSETX,rwheelptr2
	add	r1
	to	r1
	div2

	mloadw	r0,WHL_OFFSETY,rwheelptr1
	mloadw	r1,WHL_OFFSETY,rwheelptr2
	add	r1
	to	r2
	div2

	mloadw	r0,WHL_OFFSETZ,rwheelptr1
	mloadw	r1,WHL_OFFSETZ,rwheelptr2
	add	r1
	to	r3
	div2

	mcall	mcalc_torque
	nop	 


	mloadw	r0,WHL_ROTOFFX,rwheelptr1
	mloadw	r1,WHL_ROTOFFX,rwheelptr2
	add	r1
	to	r1
	div2

	mloadw	r0,WHL_ROTOFFY,rwheelptr1
	mloadw	r1,WHL_ROTOFFY,rwheelptr2
	add	r1
	to	r2
	div2

	mloadw	r0,WHL_ROTOFFZ,rwheelptr1
	mloadw	r1,WHL_ROTOFFZ,rwheelptr2
	add	r1
	to	r3
	div2
	mcall	mcalc_disp
	nop	 


.nhalf
	
	mpop	pc
	nop	
















;*******************************************************************
; mwheel_dynamic	: do the dynamics for a WHEEL.
; 
; entry:
;	r8 	- ptr. to car.
; 	r9	- ptr. to WHEEL
;
;
; exit:
;	r8 	- ptr. to car.
; 	r9	- ptr. to WHEEL
;
; trashed:	r0-r7,r12,r13,r14	
;


; normal use.
rcarptr		=	r8
rwheelptr	=	r9

mwheel_dynamic
	
	mpush	r11
	


	mcall	minit_force
	nop


	iwt	r0,#1			; default unsed
	iwt	r1,#32000
gcnt	=	10
	REPT	max_groups-1
	sm	[m_groupblocks+gcnt],r0		; group default flags
	sm	[m_groupblocks+gcnt+2],r1	; default D
gcnt	=	gcnt+10
	ENDR




;------------------------------------------------------------------------------------------
; clear spring.
	sub	r0
	sm	[m_whlspringx],r0
	sm	[m_whlspringy],r0
	sm	[m_whlspringz],r0


;------------------------------------------------------------------------------------------
; do wheel collision forces.

; default distance from nearest group to very far.
	iwt	r0,#32000
	sm	[m_wheelgndoff],r0

; off-road ground friction.
	lm	r0,[m_offroadfriction]
	sm	[m_whlgndfriction],r0

;--------------------------------------------------
; clear wheel flags
	mloadw	r0,WHL_FLAGS,rwheelptr
	iwt	r1,#WHLflag_offroad!WHLflag_ongnd!WHlflag_skid!WHLflag_onslope
	to	r1
	bic	r1
	mstorew	r1,WHL_FLAGS,rwheelptr
	



;--------------------------------------------------
; do normal object collisions.
;	mloadw	r1,WHL_COLLOBJ1,rwheelptr
;	mstorew	r1,WHL_TEMP1,rwheelptr


	mloadw	r0,OBJ_COLLOBJ1,rwheelptr
	moves	r7,r0
	beq	.nocollobj1
	nop
	mcall	mchk_objcoll
	nop

	mloadw	r2,OBJ_COLLOBJ1,rwheelptr
	mcall	mdo_wheelcoll
	nop
.nocollobj1


;	mloadw	r0,OBJ_COLLOBJ2,rwheelptr
;	moves	r7,r0
;	beq	.nocollobj2
;	nop
;	mcall	mchk_objcoll
;	nop
;
;	mloadw	r2,OBJ_COLLOBJ2,rwheelptr
;	mcall	mdo_wheelcoll
;	nop
;.nocollobj2




;--------------------------------------------------
; check for offroad

	mloadw	r0,OBJ_COLLOBJ1,rwheelptr
	mloadw	r1,OBJ_COLLOBJ2,rwheelptr
	or	r1
	bne	.notoff
	nop

	mloadw	r1,CAR_OFFROAD,rcarptr
	inc	r1
	mstorew	r1,CAR_OFFROAD,rcarptr

	mloadw	r0,WHL_FLAGS,rwheelptr
	iwt	r1,#WHLflag_offroad
	to 	r1
	or	r1
	mstorew	r1,WHL_FLAGS,rwheelptr
.notoff	




;--------------------------------------------------
; do ground collision, if offroad then make bumpy.

	mloadw	r0,WHL_FLAGS,rwheelptr
	iwt	r1,#WHLflag_onslope
;	and	r1
;	bne	.noground
;	nop
	

	mloadw	r2,OBJ_WORLDY,rwheelptr	

	IFEQ	1
	mloadw	r0,WHL_FLAGS,rwheelptr
	iwt	r1,#WHLflag_offroad
	and	r1
	beq	.notoffroad
	nop

	mloadw	r0,OBJ_WORLDX,rwheelptr
	mloadw	r1,OBJ_WORLDZ,rwheelptr
	add	r1
	div2
	div2
	div2
	ibt	r1,#31
	and	r1
	mneg	r0
	with	r2
	add	r0
.notoffroad
	ENDC

	mcall	mset_gndgroup
	nop

	iwt	r3,#m_groupblocks&WM
	ibt	r2,#0

	mcall	mdo_wheelcollforce
	nop

.noground








;--------------------------------------------------------	
; get shadow Y position.

rgroupptr	=	r1
rminD		=	r2
rmingroup	=	r3
rtemp		=	r4


;	sub	r0
;	sm	[m_test1],r0

; find minimum distance group.
	iwt	rtemp,#32000
	iwt	rgroupptr,#m_groupblocks&wm
	iwt	rminD,#32000
	iwt	rmingroup,#0
	iwt	r12,#max_groups
	move	r13,pc

		
	inc	rgroupptr
	inc	rgroupptr
	ldw	[rgroupptr]
	cmp	rtemp
	beq	.nextgr
	nop
	mabs	r0,r0
	cmp	rminD
	bpl	.nextgr
	nop
	move	rminD,r0
	move	rmingroup,rgroupptr
.nextgr
	with	rgroupptr
	add	#10-2
	loop
	nop	


	mtest	rmingroup
	beq	.nostick
	nop

	mldwi	rmingroup	; D of group
	add	r0

	inc	rmingroup
	inc	rmingroup


	to	r6
	ldw	[rmingroup]
	mtest	r6
	beq	.nostick
	nop

;	sm	[m_test1],rmingroup


	fmult	
	move	r5,r0
	iwt	r0,#(50)<<car_scale
	with	r5
	add	r0
	mloadw	r0,OBJ_WORLDY,rcarptr
	with	r5
	add	r0
	mstorew	r5,CAR_SHADOWY,rcarptr

.nostick

	
;------------------------------------------------------------------------------------------

	mloadw	r1,OBJ_ROTY,rcarptr
	mstorew	r1,OBJ_ROTY,rwheelptr


	mloadw	r2,WHL_FLAGS,rwheelptr
	iwt	r0,#whlflag_front
	and	r2
	beq	.nfr
	nop
	mloadw	r1,OBJ_ROTY,rwheelptr
	mloadw	r0,CAR_ENGINEROTY,rcarptr
	with	r1
	add	r0
	mstorew	r1,OBJ_ROTY,rwheelptr
;	bra	.donewrot
;	nop
.nfr		
;	mloadw	r1,CAR_FLAGS,rcarptr
;	iwt	r0,#carflag_brake
;	and	r1
;	beq	.donewrot
;	nop
;	lm	r0,[m_whlgndfriction]	
;	div2
;	div2
;	sm	[m_whlgndfriction],r0
;
;.donewrot





;--------------------------------------------------------	
; wheel rotation from power.
	iwt	r0,#whlflag_power
	and	r2
	beq	.nwpower
	nop
	mloadw	r1,CAR_ACCEL,rcarptr
	mloadw	r0,WHL_ROTXSPEED,rwheelptr
	to	r1
	add	r1
	mstorew	r1,WHL_ROTXSPEED,rwheelptr
.nwpower

;--------------------------------------------------------	





	lm	r0,[m_wheelgndoff]
	iwt	r1,#-20<<car_scale
	cmp	r1
	mlbmi	.notongnd
	iwt	r1,#32000
	cmp	r1
	mlbeq	.notongnd

.ongnd


;--------------------------------------------------------	
; flag as on the ground.
	mloadw	r0,WHL_FLAGS,rwheelptr
	iwt	r1,#whlflag_ongnd
	to	r1
 	or	r1
	mstorew	r1,WHL_FLAGS,rwheelptr



;--------------------------------------------------------	
; perpindicular ground friction.


; make wheel's rotation vector.
	ibt	r0,#sintab>>16
	romb
	mloadw	r0,OBJ_ROTY,rwheelptr
	mloadw	r1,OBJ_ROTY,rcarptr
	sub	r1
	hib
	move	r1,r0

	mgetsin8
	sm	[m_mat13],r0

	move	r0,r1
	mgetcos8
	mtest	r0
	bpl	.nnz
	nop
	mneg	r0
.nnz
	sm	[m_mat33],r0




	mloadw	r1,OBJ_VELX,rwheelptr
	mneg	r1

	mloadw	r2,OBJ_VELY,rwheelptr
	mneg	r2

	mloadw	r3,OBJ_VELZ,rwheelptr
	mneg	r3


; rotate wheel's velocity relative to car.
	mdotprod16mq	m_wmat11,m_wmat12,m_wmat13
	sm	[m_frictdispX],r0
	mdotprod16mq	m_wmat31,m_wmat32,m_wmat33
	sm	[m_frictdispZ],r0

	move	r1,r0
	mloadw	r0,OBJ_ROTX,rwheelptr
	to	r1
 	add	r1
	mstorew	r1,OBJ_ROTX,rwheelptr

	lm	r1,[m_frictdispX]
	lm	r3,[m_frictdispZ]

	lms	r6,[m_mat33]
	with	r1
	fmult

	lms	r6,[m_mat13]
	from	r3
	add	r3
	fmult
	add	r1
	add	r0
	

	lm	r6,[m_whlgndfriction]
	add	r0
	fmult	

	add	r0
	move	r4,r0
	move	r1,r0

	mloadw	r5,WHL_MAXGRIP,rwheelptr
	move	r6,r5
	mneg	r5

	mabs	r2,r4
	from	r2
	sub	r6
	bmi	.noskid
	nop
	mloadw	r2,CAR_SKID,rcarptr
	with	r2
	add	r0
	iwt	r3,#(5*256)/4		; was 1024/4 : mod
	cmp	r3
	bmi	.nskfl
	nop
	mloadw	r0,WHL_FLAGS,rwheelptr
	iwt	r3,#WHLflag_skid
	to	r3
	or	r3	
	mstorew	r3,WHL_FLAGS,rwheelptr
.nskfl
	mstorew	r2,CAR_SKID,rcarptr
.noskid

	mloadw	r2,WHL_FLAGS,rwheelptr
	iwt	r0,#whlflag_front
	and	r2
	beq	.nrearg
	nop
;	mloadw	r2,CAR_FLAGS,rcarptr
;	iwt	r0,#carflag_accel
;	and	r2
;	beq	.nrearg
;	nop
	mrange	r4,r5,r6
	move	r1,r4

;	ibt	r4,#0
;	ibt	r1,#0
;	with	r5
;	div2
;	with	r6
;	div2
	bra	.donemax
	nop
.nrearg


	ifeq	0
	with	r4
	cmp	r5
	bmi	.dolim
	nop

	move	r5,r6

	with	r4
	cmp	r6
	bmi	.nmax
	nop
.dolim
	from	r4
	sub	r5
	div2
	div2
	div2
	from	r5
	to	r4
	add	r0
;	move	r4,r5
.nmax


	endc

.donemax


	
; add a bit of roll bar upward force as well
	ifeq	1
	moves	r0,r1
	bmi	.nng
	nop
	mneg	r0
.nng	
	div2
	div2
;	div2
	move	r5,r0
	elseif
	iwt	r5,#0
	endc



	iwt	r6,#0

	mcall	madd_intforce
	nop	 






;--------------------------------------------------------	
; engine acceleration

	mloadw	r2,WHL_FLAGS,rwheelptr

	mloadw	r3,CAR_FLAGS,rcarptr
	iwt	r0,#carflag_boost
	and	r3
	bne	.isboost

	iwt	r0,#whlflag_power
	and	r2
	beq	.npower
	nop

.isboost
	iwt	r0,#carflag_boost!carflag_accel
	and	r3
	beq	.npsk
	nop
	mloadw	r0,CAR_ACCEL,rcarptr
	iwt	r3,#car1_boost/2
	cmp	r3
	bmi	.npsk
	nop
	iwt	r1,#WHLflag_skid
	with	r2
	or	r1	
	mstorew	r2,WHL_FLAGS,rwheelptr
.npsk

	lm	r6,[m_whlgndfriction]

	lm	r0,[m_enginex]
	lm	r1,[m_enginey]
	lm	r2,[m_enginez]

	ifeq	1
	add	r0
	fmult
	move	r4,r0

	with	r1
	add	r1
	from	r1
	to	r5
	fmult

	with	r2
	add	r2
	with	r2
	fmult
	move	r6,r2

	elseif
	move	r4,r0
	move	r5,r1
	move	r6,r2
	endc
	
	mcall	madd_intforce
	nop

;	lm	r0,[m_forceY]
;	sub	r2
;	sm	[m_forceY],r0


.npower	
	



;--------------------------------------------------------	
; normal ground friction (i.e. brakeing.)

	mloadw	r6,CAR_WHLFRICTION,rcarptr
	mloadw	r0,WHL_ROTXSPEED,rwheelptr
	move	r1,r0
	add	r0
	fmult
	with	r1
	sub	r0
	mstorew	r1,WHL_ROTXSPEED,rwheelptr

	lm	r0,[m_frictdispZ]
	add	r0
	to	r6
	fmult	
	move	r4,r6

	iwt	r1,#-200		-20
	iwt	r2,#200			20
	mrange	r6,r1,r2

	mabs	r0,r4
	mabs	r1,r6
	sub	r6
	add	r0
	mloadw	r1,CAR_SKID,rcarptr
	with	r1
	add	r0

	iwt	r3,#1700/4		; was 1024/4 : mod
	cmp	r3
	bmi	.nbrskfl
	nop
	mloadw	r0,WHL_FLAGS,rwheelptr
	iwt	r3,#WHLflag_skid
	to	r3
	or	r3	
	mstorew	r3,WHL_FLAGS,rwheelptr
.nbrskfl

	mstorew	r1,CAR_SKID,rcarptr

 
	ibt	r4,#0
	ibt	r5,#0
	mcall	madd_intforce
	nop	 


	bra	.donegnddyn
	nop
.notongnd
	mloadw	r1,CAR_OFFGND,rcarptr
	inc	r1
	mstorew	r1,CAR_OFFGND,rcarptr

.donegnddyn




;--------------------------------------------------------	
; wheel X rotation.
	
	mloadw	r0,WHL_ROTXSPEED,rwheelptr
;	add	r0
	mloadw	r1,OBJ_ROTX,rwheelptr
	with	r1
	sub	r0
	mstorew	r1,OBJ_ROTX,rwheelptr
;--------------------------------------------------------	

	




	mloadw	r1,WHL_NOFFSETX,rwheelptr
	mloadw	r2,WHL_NOFFSETY,rwheelptr
	mloadw	r3,WHL_NOFFSETZ,rwheelptr
	mloadw	r0,CAR_CENTGY,rcarptr
	with	r2
	add	r0
	mcall	mcalc_torque
	nop	 


	mloadw	r1,WHL_ROTOFFX,rwheelptr
	mloadw	r2,WHL_ROTOFFY,rwheelptr
	mloadw	r3,WHL_ROTOFFZ,rwheelptr
	mcall	mcalc_disp
	nop	 


	ibt	r1,#0
	ibt	r2,#0
	ibt	r3,#0


;------------------------------------------------------------------
; calculate damage of wheel.

	mabs	r0,r1
	mabs	r2,r2
	mabs	r3,r3
	add	r2	
	add	r3	
	rept	dynshift+2	; was +3
	div2
	endr

	mloadw	r1,WHL_DAMAGE,rwheelptr

	ibt	r2,#40		; was 35
	cmp	r2
	bmi	.dammaxok
	nop
	move	r0,r2
.dammaxok	
	ibt	r2,#15
	cmp	r2
	bmi	.nodam
	nop
	sub	#5

	with	r1
	add	r0

	ibt	r0,#64
	cmp	r1
	bpl	.damok
	nop	
	move	r1,r0
.damok
	mstorew	r1,WHL_DAMAGE,rwheelptr
	
	mloadw	r0,CAR_FLAGS,rcarptr
	iwt	r1,#CARflag_hitflash!CARflag_collide
	to	r1
	or	r1
	mstorew	r1,CAR_FLAGS,rcarptr
.nodam


	
; calc damage shake.
	mloadw	r0,CAR_TOTALDAMAGE,rcarptr
	mtest	r0
	bpl	.nresdam
	nop
	ibt	r1,#0
	mstorew	r1,WHL_DAMAGE,rwheelptr
	sm	[m_totaldamage],r1
	bra	.ndamshake
	nop
.nresdam
	mloadw	r1,WHL_DAMAGE,rwheelptr

	lm	r0,[m_totaldamage]
	add	r1
	sm	[m_totaldamage],r0

	ibt	r0,#30
	cmp	r1
	bpl	.ndamshake
	nop
	mloadw	r1,OBJ_WORLDZ,rwheelptr
	mloadw	r0,OBJ_WORLDX,rwheelptr
	xor	r1
	swap	
	iwt	r1,#63*256
	and	r1	
	iwt	r1,#31*256
	sub	r1
	mloadw	r1,OBJ_ROTY,rwheelptr
	sub	r1
	div2
	with	r1
	add	r0 
	mstorew	r1,OBJ_ROTY,rwheelptr

	
.ndamshake




;------------------------------------------------------------------
; REPT RELOAD COMMENT
; REPT RELOAD COMMENT
; REPT RELOAD COMMENT
; REPT RELOAD COMMENT
; REPT RELOAD COMMENT
; REPT RELOAD COMMENT
; REPT RELOAD COMMENT
;------------------------------------------------------------------
; copy spring position.

	iwt	r2,#-30<<car_scale
	iwt	r3,#30<<car_scale

	lm	r1,[m_whlspringx]
	REPT	dynshift
	with	r1
	div2
	ENDR
	mrange	r1,r2,r3
	mstorew	r1,WHL_SPRINGX,rwheelptr

	lm	r1,[m_whlspringy]
	REPT	dynshift
	with	r1
	div2
	ENDR
	mrange	r1,r2,r3
	mstorew	r1,WHL_SPRINGY,rwheelptr

	lm	r1,[m_whlspringz]
	REPT	dynshift
	with	r1
	div2
	ENDR
	mrange	r1,r2,r3
	mstorew	r1,WHL_SPRINGZ,rwheelptr

;	lm	r1,[m_wheelgndoff]
;	mstorew	r1,WHL_TEMP1,rwheelptr

.end

;------------------------------------------------
; wheel turn fudging. (make it look like its turning more than it is)
;	mloadw	r2,WHL_FLAGS,rwheelptr
;	iwt	r0,#whlflag_front
;	and	r2
;	beq	.nfr2
;	nop
;	mloadw	r1,OBJ_ROTY,rwheelptr
;	mloadw	r0,CAR_ENGINEROTY,rcarptr
;	with	r1
;	add	r0
;	mstorew	r1,OBJ_ROTY,rwheelptr
;.nfr2
;------------------------------------------------


	mpop	pc
	nop





;************************************************************************
; mset_gndgroup
;
; entry:
;	r2 = offset from ground.



mset_gndgroup

	sub	r0
	mtest	r2
	bpl	.nabove
	nop
	ibt	r0,#1
.nabove
	sm	[m_groupblocks],r0

	sub	r0
	sm	[m_groupblocks+2],r2
	sm	[m_groupblocks+4],r0
	sm	[m_groupblocks+8],r0
	iwt	r0,#(-127*256)
	sm	[m_groupblocks+6],r0
	move	pc,r11
	nop


;************************************************************************
; mdo_wheelcoll - do the actual forces on wheel from groups.
;
; entry:
;	m_wheelgndoff 	= current min group face distance
;	r2		= ptr. to collision object. 0 if ground.
;	r9 		= ptr. to wheel
;	r8		= ptr. to car

rwheelptr	=	r9
rgroupptr	=	r3
rgroupcnt	=	r13

mdo_wheelcoll
	mpush	r11



	iwt	rgroupptr,#(m_groupblocks+10)&WM
	ibt	rgroupcnt,#0

.grouploop
	inc	rgroupcnt
	ibt	r0,#max_groups
	cmp	rgroupcnt
	mlbeq	.groupend

	mcall	mdo_wheelcollforce
	nop


	lm	r0,[m_onroadfriction]
	sm	[m_whlgndfriction],r0

	mlbra	.grouploop

.groupend
	mpop	pc
	nop


;************************************************************************
; mdo_wheelcollforce - do forces on wheel from group.
;
; entry:
;	r3	= ptr. to group	data.
;	r2	= ptr. to collision object. 0 if ground.
;	r8	= ptr. to car
; exit:
;	r3	= ptr. to next group.
;	r8	= ptr. to car


rgroupptr	=	r3
rcollobjptr	=	r2
rD		=	r7
rcarptr		=	r8


mdo_wheelcollforce

	mldwi	rgroupptr
;	mtest	r0
;	mlbne	.nogroup

	mtest	r0
	beq	.groupok
	nop
	mlbpl	.nogroup
.groupok

	mpush	r11
	move	r11,r0


	to	rD
	mldwi	rgroupptr		

	lm	r0,[m_wheelgndoff]
	mabs	r5,r0
	mabs	r4,rD
	with	r5
	cmp	r4
	bmi	.nlow
	nop
	sm	[m_wheelgndoff],rD
.nlow



	iwt	r0,#32000
	cmp	rD
	mlbeq	.nogroup2
	

;	mtest	rD
;	mlbmi	.nogroup2

;---------------------------------------------------
; link collided object with wheel.

	mtest	rcollobjptr
	beq	.isgnd
	nop
	mstorew	rwheelptr,OBJ_COLLOBJ,rcollobjptr
.isgnd


;---------------------------------------------------

	REPT	(dynshift+1)
	with	rD	
	add	rD
	ENDR

;	iwt	r4,#-1		; was -300
;	iwt	r5,#2000
;	mrange	rD,r4,r5
;
;	iwt	r0,#-1
;	cmp	rD
;	mlbeq	.nogroup2	


	mtest	rd
	mlbmi	.nogroup2


; damping.
	ifeq	0
	mloadw	r0,OBJ_VELX,rwheelptr
	add	r0
	to	r6
	mldwi	rgroupptr	; normal X
	sm	[m_normx],r6
	fmult
	move	r1,r0

	mloadw	r0,OBJ_VELY,rwheelptr
	add	r0
	to	r6
	mldwi	rgroupptr	; normal Y
	sm	[m_normy],r6
	fmult
	with	r1
	add	r0

	mloadw	r0,OBJ_VELZ,rwheelptr
	add	r0
	to	r6
	mldwi	rgroupptr	; normal Z
	sm	[m_normz],r6
	fmult
	with	r1
	add	r0
	endc

	lm	r0,[m_normy]
	mtest	r0
	bne	.nwall
	nop
	mtest	r11
	mlbmi	.noforce
	bra	.iswall
	nop
.nwall
	mloadw	r0,WHL_FLAGS,rwheelptr
	iwt	r6,#whlflag_onslope
	to	r6
 	or	r6
	mstorew	r6,WHL_FLAGS,rwheelptr
.iswall



	move	r0,r1
	add	r0
	add	r0

	mneg	r0
	mtest	r0
	bpl	.nne
	nop
	iwt	r0,#0
.nne

	add	rd
	move	r1,r0




	lm	r6,[m_normx]
	move	r0,r1
	fmult
	move	r4,r0

	lm	r6,[m_normy]
	move	r0,r1
	fmult
	move	r5,r0

	lm	r6,[m_normz]
	move	r0,r1
	fmult
	move	r6,r0


	





	mstorew	r4,WHL_TRACKFORCEX,rwheelptr
	mstorew	r5,WHL_TRACKFORCEY,rwheelptr
	mstorew	r6,WHL_TRACKFORCEZ,rwheelptr


	lm	r0,[m_whlspringx]
	add	r4	; x force.
	sm	[m_whlspringx],r0

	lm	r0,[m_whlspringy]
	add	r5	; y force.
	sm	[m_whlspringy],r0

	lm	r0,[m_whlspringz]
	add	r6	; z force.
	sm	[m_whlspringz],r0

	mcall	madd_extforce
	nop

.noforce
	mpop	pc
	nop

.nogroup
	ibt	r0,#(5*2)-2	
	with	rgroupptr
	add	r0
	move	pc,r11
	nop

.nogroup2
	ibt	r0,#(5*2)-4	
	with	rgroupptr
	add	r0
	mpop	pc
	nop


;************************************************************************
; minit_force - init a force.
; trashes: r0
minit_force
	sub	r0
	sm	[m_forceX],r0
	sm	[m_forceY],r0
	sm	[m_forceZ],r0
	move	pc,r11
	nop

;************************************************************************
; madd_extforce - add an external force !
;
; entry:
;	r4 - Fx		; force vector. 
;	r5 - Fy
;	r6 - Fz
; trashes: r0

madd_extforce

	lm	r0,[m_forceX]
	add	r4
	sm	[m_forceX],r0

	lm	r0,[m_forceY]
	add	r5
	sm	[m_forceY],r0

	lm	r0,[m_forceZ]
	add	r6
	sm	[m_forceZ],r0

	move	pc,r11
	nop

;************************************************************************
; madd_intforce - add an internal force !
;
; entry:
;	r4 - Fx		; force vector. 
;	r5 - Fy
;	r6 - Fz
; exit:
;	r2 - Fy		; external force Y.
; trashes: r0-r7

madd_intforce
	

	move	r1,r4
	move	r2,r5
	move	r3,r6

	mdotprod16mq	m_wmat11,m_wmat21,m_wmat31
	lm	r4,[m_forceX]
	add	r4
	sm	[m_forceX],r0
	mdotprod16mq	m_wmat13,m_wmat23,m_wmat33
	lm	r4,[m_forceZ]
	add	r4
	sm	[m_forceZ],r0
	mdotprod16mq	m_wmat12,m_wmat22,m_wmat32
	move	r2,r0
	lm	r4,[m_forceY]
	add	r4
	sm	[m_forceY],r0

	move	pc,r11
	nop


;************************************************************************
mcalc_disprot
	mdotprod16mq	m_wmat11,m_wmat21,m_wmat31
	sm	[m_t1],r0
	mdotprod16mq	m_wmat12,m_wmat22,m_wmat32
	sm	[m_t2],r0
	mdotprod16mq	m_wmat13,m_wmat23,m_wmat33
	sm	[m_t3],r0
	lm	r1,[m_t1]
	lm	r2,[m_t2]
	lm	r3,[m_t3]
	bra	mcalc_disp
	nop

;************************************************************************
; mcalc_disp - calculate displacement from a force.
;
; entry:
;	r1 - PFx	; absolute force position relative to particle.
;	r2 - PFy
;	r3 - PFz
;
; exit: ADDS result to these variables.
;
;	m_dispX		; displacement
;	m_dispY		
;	m_dispZ		
;	r1-r3 		; resultant displacement
;
;
; trashes: probably all.

mcalc_disp

	mpush	r11
	mpush	r9
	mpush	r8


	from	r1
	or	r2
	or	r3
	bne	.nz
	nop
	iwt	r1,#32767
	move	r2,r1
	move	r3,r1
	bra	.skipnorm
	nop
.nz


	mcall	mnormalise16	; normalise r1,r2,r3
	nop


	mtest	r1
	bpl	.nnx
	nop
	mneg	r1
.nnx

	mtest	r2
	bpl	.nny
	nop
	mneg	r2
.nny	

	mtest	r3
	bpl	.nnz
	nop
	mneg	r3
.nnz


.skipnorm

	lm	r6,[m_forceX]	; X displacement.
	with	r6
	div2
	with	r1
	fmult
	lm	r0,[m_dispx]
	add	r1
	sm	[m_dispx],r0
		    

	lm	r6,[m_forceY]	; Y displacement.
	with	r6
	div2
	with	r2
	fmult
	lm	r0,[m_dispy]
	add	r2
	sm	[m_dispy],r0


	lm	r6,[m_forceZ]	; Z displacement.
	with	r6
	div2
	with	r3
	fmult
	lm	r0,[m_dispz]
	add	r3
	sm	[m_dispz],r0


.end
	mpop	r8
	mpop	r9
	mpop	pc
	nop



;************************************************************************
mcalc_torquerot
	mdotprod16mq	m_wmat11,m_wmat21,m_wmat31
	sm	[m_t1],r0
	mdotprod16mq	m_wmat12,m_wmat22,m_wmat32
	sm	[m_t2],r0
	mdotprod16mq	m_wmat13,m_wmat23,m_wmat33
	sm	[m_t3],r0
	lm	r1,[m_t1]
	lm	r2,[m_t2]
	lm	r3,[m_t3]
	bra	mcalc_torque
	nop


mcalc_torquenorm
	mpush	r11
	mpush	r9
	mpush	r8
;	mcall	mnormalise16	; normalise r1,r2,r3
;	nop
	mpop	r8
	mpop	r9
	mpop	r11
	bra	mcalc_torque
	nop


;************************************************************************
; mcalc_torque - calculate torque from a force.
;
; entry:
;	r1 - PFx	; rotated and normalised force position vector relative to particle. (phew!, we know a song about that.)
;	r2 - PFy
;	r3 - PFz
;
; exit: ADDS result to these variables.
;
;	m_torqueX		; displacement
;	m_torqueY		
;	m_torqueZ		
;
; trashes: probably all.

mcalc_torque
	mpush	r11
	mpush	r9
	mpush	r8

	lm	r0,[m_forceX]
	add	r0
	add	r0
	sms	[m_mat11],r0	

	lm	r0,[m_forceY]
	add	r0
	add	r0
	sms	[m_mat22],r0	

	lm	r0,[m_forceZ]
	add	r0
	add	r0
	sms	[m_mat33],r0	

	sub	r0
	sms	[m_mat12],r0

;	mcall	mnormalise16	; normalise r1,r2,r3
;	nop


; REPT RE-LOAD
; REPT RE-LOAD
; REPT RE-LOAD
; REPT RE-LOAD

	REPT	4
	with 	r1
	add	r1
	with 	r2
	add	r2
	with 	r3
	add	r3
	ENDR	

	sm	[m_t1],r1	; save normalised position vector.
	sm	[m_t2],r2
	sm	[m_t3],r3

; rotate force vector.
	lms	r1,[m_mat11]	
	lms	r2,[m_mat22]
	lms	r3,[m_mat33]
	mdotprod16mq	m_wmat11,m_wmat12,m_wmat13
	sms	[m_mat11],r0
	mdotprod16mq	m_wmat21,m_wmat22,m_wmat23
	sms	[m_mat22],r0
	mdotprod16mq	m_wmat31,m_wmat32,m_wmat33
	sms	[m_mat33],r0


	lm	r1,[m_t1]
	lm	r2,[m_t2]
	lm	r3,[m_t3]


	mcrossprod r1,r2,r3,m_mat11,m_mat22,m_mat33,m_x1,m_y1,m_z1

	lm	r4,[m_torqueX]
	lm	r0,[m_x1]
	add	r0
	add	r0
	add	r4
	sm	[m_torqueX],r0
	
	lm	r4,[m_torqueZ]
	lm	r0,[m_z1]
	add	r0
	add	r0
	add	r4
	sm	[m_torqueZ],r0


	lm	r4,[m_torqueY]
	lm	r0,[m_y1]
	add	r0
	add	r0
	add	r4
	sm	[m_torqueY],r0


	mpop	r8
	mpop	r9
	mpop	pc
	nop



;************************************************************************
; mchk_objcoll  - check if object is inside another object.
;
; entry:
;	r7 - another object.
;	r9 - ptr. to object
;
; exit: 
;	r9 - ptr. to object
;	returns valid groups blocks in M_GROUPBLOCKS
;
; trashes: all but r8,r9
;

rotherobjptr	=	r7
robjptr	=	r9

rnormx	=	r1
rnormy	=	r2
rnormz	=	r3
robjpx	=	r4	; CHECK MULT's THAT USE THIS.
robjpy	=	r5
robjpz	=	r8
rdtemp	=	r7
rpntsptr	=	r9
rfacetemp	=	r13
rminD	=	r12
rgroupnum	=	r11


mchk_objcoll
	mpush	r11
	mpush	r8
	mpush	r9


	mloadw	r0,OBJ_FRAME,rotherobjptr
	sms	[m_framenum],r0


	iwt	r0,#1			; default unsed
	iwt	rnormx,#32000

;REPT RE-LOAD COMMENT
;REPT RE-LOAD COMMENT
;REPT RE-LOAD COMMENT
;REPT RE-LOAD COMMENT
;REPT RE-LOAD COMMENT
;REPT RE-LOAD COMMENT
;REPT RE-LOAD COMMENT
;REPT RE-LOAD COMMENT
gcnt	=	10
	REPT	max_groups-1
	sm	[m_groupblocks+gcnt],r0		; group default flags
	sm	[m_groupblocks+gcnt+2],rnormx	; default D
gcnt	=	gcnt+10
	ENDR



	iwt	r0,#shape_headers>>16
	romb

	mloadw	rnormx,OBJ_COLLSHAPE,rotherobjptr
	mtest	rnormx		
	mlbeq	.nocollshape
	move	r14,rnormx	; ptr. to shape.

;------------------------------------------
; get wheel relative to track object.
	mloadw	robjpx,OBJ_WORLDX,robjptr
	mloadw	r0,OBJ_WORLDX,rotherobjptr
	with	robjpx
	sub	r0
;	with	robjpx
;	add	robjpx

	mloadw	robjpy,OBJ_WORLDY,robjptr
	mloadw	r0,OBJ_WORLDY,rotherobjptr
	with	robjpy
	sub	r0
;	with	robjpy
;	add	robjpy

	mloadw	robjpz,OBJ_WORLDZ,robjptr
	mloadw	r0,OBJ_WORLDZ,rotherobjptr
	with	robjpz
	sub	r0
;	with	robjpz
;	add	robjpz
;------------------------------------------

; ptr. to faces.
	iwt	r0,#sh_faces
	with	r14
	add	r0
	mgetw	rnormy

; ptr. to points.
	iwt	r0,#sh_points
	move	r14,rnormx
	with	r14
	add	r0
	mgetw	rpntsptr
	
; shape scale.
	iwt	r0,#sh_shift
	move	r14,rnormx
	with	r14
	add	r0
	getbs	
	move	r12,r0
	ibt	r0,#1
	move	r13,pc
	add	r0
	loop
	nop	
	sm	[m_shapescale],r0


; change to points and faces ROM bank.
	iwt	r0,#sh_bank
	move	r14,rnormx
	with	r14
	add	r0
	getb	
	romb

; if shape and frame num are the same as the last wheel then use old data. 
; copy points data into RAM and do X refl. and animation if needed.
	lm	rnormz,[m_framenum]
	lm	r0,[m_oldshape]
	cmp	rnormx
	bne	.newshape
	nop
	lm	r0,[m_oldframenum]
	cmp	rnormz
	beq	.notnewshape
	nop
.newshape
	sm	[m_oldshape],rnormx
	sm	[m_oldframenum],rnormz
	mcall	mcopy_pnts
	nop
.notnewshape
	iwt	rpntsptr,#m_rotpnts&WM


; skip visiblities
	move	r14,rnormy
	inc	r14
	mgetbi	r0
	umult	#3	
	with	r14		
	add	r0

	mcache

; check if shape uses any BSP.
	getbs
	ibt	rfacetemp,#mval_bspinit	
	cmp	rfacetemp
	bne	.loop
	inc	r14

; skip BSP data.
	ibt	rnormx,#mval_bsp
	ibt	rdtemp,#5	; BSP skip
	ibt	rnormy,#mval_bspe
	ibt	rminD,#3	; BSPE skip
	ibt	rnormz,#mval_bspend
.skipbsp
	getbs	
	cmp	rnormz
	bne	.nbspend
	nop
	bra	.skipbsp
	inc	r14
.nbspend

	cmp	rnormx
	bne	.nbsp
	nop
	with	r14
	bra	.skipbsp
	add	rdtemp
.nbsp
	cmp	rnormy
	bne	.sloop2
	with	r14
	bra	.skipbsp
	add	rminD

; now check all the groups 
.sloop
	getbs    		; Faces or Endshape
.sloop2	
	inc	r14
	mtest	r0
	mlbeq	.end		; Endshape

	mcache

;-------------------------------------------------------
.loop
	to	rfacetemp
	getbs			; FendQ or num pnts in face.
	mtest	rfacetemp		
	bmi	.sloop		; FendQ
	inc	r14	
	


	sub	r0
	mgetbsi	rgroupnum		; get group number.

	mtest	rgroupnum	
	mlbeq	.nextface		; null group.
	move	r0,rgroupnum
	sm	[m_groupPtype],r0
	iwt	rnormx,#groupflag_nocol!groupflag_anim
	with	rgroupnum
	bic	rnormx


	ibt	r0,#10
	to	rgroupnum
	mult	rgroupnum
	iwt	r0,#m_groupblocks&WM
	with	rgroupnum
	add	r0
	ldw	[rgroupnum]
	mtest	r0		; if any face out then all faces in group out.
	mlbmi	.nextface


	inc	r14		; skip vis number.
	inc	r14		; skip colour


; if frame 0 then use ROM normal.
;	lms	r0,[m_framenum]
;	mtest	r0
;	mlbeq	.facenorm

; if face's angle not change then get normal from ROM.
	lm	rdtemp,[m_groupPtype]
	iwt	r0,#groupflag_anim
	and	rdtemp	
	mlbeq	.facenorm

; calculate normal from first 3 points.
	with	r14
	add	#3		; skip normal

	mpush	r14

	move	rminD,rpntsptr

; get point 1	
	mgetbi	r0	
	umult	#6
	to	rpntsptr
	add	rminD

	mldwi	rpntsptr	; X
	sms	[m_x1],r0

	mldwi	rpntsptr	; Y
	sms	[m_y1],r0

	mldwi	rpntsptr	; Z
	sms	[m_z1],r0


; get point 2	
	mgetbi	r0		
	umult	#6
	to	rpntsptr
	add	rminD

	mldwi	rpntsptr	; X
	sms	[m_x2],r0

	mldwi	rpntsptr	; Y
	sms	[m_y2],r0

	mldwi	rpntsptr	; Z
	sms	[m_z2],r0


; get point 3	
	mgetbi	r0	
	umult	#6
	to	rpntsptr
	add	rminD

	to	rnormX
	mldwi	rpntsptr	; X

	to	rnormY
	mldwi	rpntsptr	; Y

	to	rnormZ
	mldwi	rpntsptr	; Z

; V1 = P1-P2
	lms	r0,[m_x1]
	lms	rpntsptr,[m_x2]
	sub	rpntsptr
	sms	[m_x1],r0
	lms	r0,[m_y1]
	lms	rpntsptr,[m_y2]
	sub	rpntsptr
	sms	[m_y1],r0
	lms	r0,[m_z1]
	lms	rpntsptr,[m_z2]
	sub	rpntsptr
	sms	[m_z1],r0

; V2 = P2-P3
	lms	r0,[m_x2]
	sub	rnormx
	sms	[m_x2],r0
	lms	r0,[m_y2]
	sub	rnormy
	sms	[m_y2],r0
	lms	r0,[m_z2]
	sub	rnormz
	sms	[m_z2],r0

	mpush	r4
	mpush	r5
	mpush	r8
	mpush	r12
	mpush	r13
	mpush	r11

; normalise V1
	lms	r1,[m_x1]
	lms	r2,[m_y1]
	lms	r3,[m_z1]
	mcall	mnormalise16
	nop
	sms	[m_x1],r1
	sms	[m_y1],r2
	sms	[m_z1],r3



; normalise V2
	lms	r1,[m_x2]
	lms	r2,[m_y2]
	lms	r3,[m_z2]
	mcall	mnormalise16
	nop

	mcrossprod	r1,r2,r3,m_x1,m_y1,m_z1,m_x2,m_y2,m_z2

	lms	rnormx,[m_x2]
	lms	rnormy,[m_y2]
	lms	rnormz,[m_z2]


	mpop	r11
	mpop	r13
	mpop	r12
	mpop	r8
	mpop	r5
	mpop	r4


	move	rpntsptr,rminD
	
	mpop	r14
	bra	.gotnorm
	nop

		

; get normal from face data if frame = 0
.facenorm


	mgetbi	r0		; get norm X
	to	rnormx
	swap	
	mneg	rnormx

	mgetbi	r0		; get norm Y
	to	rnormy
	swap	
	mneg	rnormy
	
	mgetbi	r0		; get norm Z
	to	rnormz
	swap	
	mneg	rnormz
	

.gotnorm
;	ibt	rdtemp,#1<<(track_scale+1)	; used for pnt. scale up
	lm	rdtemp,[m_shapescale]

; get a point in the face
	getbs	r0		; first point number.

	with	r14
	add	rfacetemp	; ptr. to next face.

	move	rfacetemp,rpntsptr
	umult	#6
	with	rpntsptr
	add	r0		; rpntsptr = start of point

	mldwi	rpntsptr	; X
	mult	rdtemp		; scale up
	sm	[m_facePX],r0

	mldwi	rpntsptr	; Y
;	iwt	rminD,#-90
;	add	rminD
	mult	rdtemp		; scale up
	sm	[m_facePY],r0

	ldw	[rpntsptr]	; Z
	mult	rdtemp		; scale up
	sm	[m_facePZ],r0
     
	move	rpntsptr,rfacetemp


	ldw	[rgroupnum]
	mtest	r0
	bmi	.grouparout
	nop
	sub	r0  		; flags this group as in.
	stw	[rgroupnum]
.grouparout
	move	rfacetemp,r0

	mtest	rfacetemp		; don't do compare if group is already out.
	mlbmi	.loop


	MCALC_D
	bpl	.notout
	nop
	iwt	rdtemp,#-1
	with	rdtemp
	stw	[rgroupnum]		; flags as out.
.notout

	lm	rdtemp,[m_groupPtype]
	iwt	rminD,#groupflag_nocol
	with	rminD
	and	rdtemp	
	mlbne	.loop


	inc	rgroupnum
	inc	rgroupnum

	to	rminD		
	ldw	[rgroupnum]	; get group's current min D
	mabs	rdtemp,rminD	; old
	mabs	rminD,r0	; new
	
	with	rdtemp
	cmp	rminD
	mlbmi	.loop		; if old D is smaller then do next face.


	mstwi	rgroupnum		; save D
	from	rnormx
	mstwi	rgroupnum		; save normal X
	from	rnormy
	mstwi	rgroupnum		; save normal Y
	from	rnormz
	stw	[rgroupnum]		; save normal Z

	mlbra	.loop


.groupout
	with	rgroupnum
	sub	#10-2
.groupout2
	iwt	r0,#-1
	stw	[rgroupnum]		; flags as out.
	mlbra	.loop

.nextface
	with	r14
	add	rfacetemp     	; ptr. to next face
	with	r14	
	add	#1+1+3		; vis+colour+Nx+Ny+Nz
	mlbra	.loop

.end	
	mpop	r9
	mpop	r8
	mpop	pc
	nop

.offroad
	bra	.end
	nop

;	iwt	rnormx,#offroad_friction
;	mstorew	rnormx,WHL_GNDFRICTION,rwheelptr	; offroad ground friction.

; make ground bumpy.
	iwt	rgroupnum,#m_groupblocks&WM
	mloadw	r0,OBJ_WORLDX,rwheelptr
	mloadw	rnormy,OBJ_WORLDZ,rwheelptr
	add	rnormy	
	ibt	rnormy,#127
	and	rnormy
	mneg	r0
	mloadw	rnormy,OBJ_WORLDY,rwheelptr
	add	rnormy
	stw	[rgroupnum]

	bra	.end
	nop

rcarptr	=	r8

.nocollshape
	mpop	r9
	mpop	r8
;	mstorew	rotherobjptr,OBJ_COLLOBJ,rcarptr
;	mstorew	rwheelptr,OBJ_COLLOBJ,rotherobjptr
	mpop	pc
	nop


;************************************************************************
; mcopy_pnts - copy all points including X reflection and animation.
;
; entry:
;	r9 	- ptr. to points
; m_framenum	- frame number.
;
;     ROMB - set to shape bank
;
; exit:
;    m_rotpnts  - list of copied points.
;

rpntsoutptr	=	r9
rmval		=	r3
rt1		=	1
rt2		=	2
rt3		=	3

mcopy_pnts
	mpush	rmval
	mpush	rt1
	mpush	rt2
	move	r14,r9

	iwt	rpntsoutptr,#m_rotpnts&WM
	

	mcache

mcopy_pnts_next

; get shape language code.
	getbs	
	inc	r14

	
; this could be better !
	ibt	rmval,#mval_rotpoints8
	cmp	rmval
	beq	mdo_pntscopy
	nop

	ibt	rmval,#mval_rotpointsx8
	cmp	rmval
	beq	mdo_pntsxcopy
	nop

	ibt	rmval,#mval_frames
	cmp	rmval
	beq	mdo_pntsframes
	nop

	ibt	rmval,#mval_jump
	cmp	rmval
	beq	mdo_pntsjump
	nop

	mpop	rt2
	mpop	rt1
	mpop	rmval
	move	pc,r11
	nop


mdo_pntscopy
	to	r12
	getb
	inc	r14
	move	r13,pc

	mgetbsi	r0	
	mstwi	rpntsoutptr
	mgetbsi	r0	
	mstwi	rpntsoutptr
	mgetbsi	r0	
	stw	[rpntsoutptr]
	inc	rpntsoutptr
	loop
	inc	rpntsoutptr

	bra	mcopy_pnts_next
	nop


mdo_pntsxcopy
	to	r12
	getb
	inc	r14
	move	r13,pc

	mgetbsi	r0	
	mstwi	rpntsoutptr
	mgetbsi	rt1
	from	rt1
	mstwi	rpntsoutptr
	mgetbsi	rt2	
	from	rt2
	mstwi	rpntsoutptr

	mneg	r0
	mstwi	rpntsoutptr
	from	rt1
	mstwi	rpntsoutptr
	from	rt2

	stw	[rpntsoutptr]
	inc	rpntsoutptr
	loop
	inc	rpntsoutptr
	bra	mcopy_pnts_next
	nop

mdo_pntsframes
	inc	r14		; skip number of frames.
	lms	r0,[m_framenum]
	add	r0
	with	r14
	add	r0

mdo_pntsjump
	mgetw	r0	       	; get relative word offset
	with	r14
	add	r0		
	mlbra	mcopy_pnts_next



	
;************************************************************************
; mfind_objcolls	- find collided objects
;
; entry:
;	r9 - ptr. to object.
;	r8 - ptr. to mask object (ignores this object in search)
;
; exit:
;	r9 - ptr. to object.
;	r8 - ptr. to mask object
;
; trashes: r4-r6

robjptr		=	r9
rmaskobjptr	=	r8
robjposx	=	r1
robjposy	=	r2
robjposz	=	r3
rt1		=	r4


mfind_objcolls
	mpush	r11



	mloadw	robjposx,OBJ_WORLDX,robjptr
	mloadw	robjposy,OBJ_WORLDY,robjptr
	mloadw	robjposz,OBJ_WORLDZ,robjptr


	ibt	rt1,#0
	mstorew	rt1,OBJ_COLLOBJ1,robjptr
	mstorew	rt1,OBJ_COLLOBJ2,robjptr


	mcall	mcheck_objscoll
	nop

	mpop	pc
	nop



;************************************************************************
; mcheck_objscoll	- check if obj1ptr position is within objects in list radius
;
; entry:
;	r8	= mask obj ptr.  (ignores this object when scanning list)  
;	r9	= ptr. to obj1
;	r1-r3  	= obj1 position
;
; trashes: r4-r6
;

rmaskptr	=	r8
robj1ptr	=	r9
robj2ptr	=	r7
robjposx	=	r1
robjposy	=	r2
robjposz	=	r3
rt1		=	r4
rt5		=	r5
rt6		=	r6


mcheck_objscoll
;	iwt	r0,#shape_headers>>16
;	romb
	

	mloadw	r6,OBJ_MAPZ,robj1ptr


	mcache

	lm	r0,[m_objects]
.loop
	moves	robj2ptr,r0
	mlbeq	.noobjs
	
	cmp	rmaskptr
	beq	.nextobj
	nop

	mloadw	r0,OBJ_MAPZ,robj2ptr
	sub	rt6
	bpl	.nn1
	nop
	mneg	r0
.nn1	sub	#2
	bpl	.nextobj
	nop		



	mloadw	rt5,OBJ_TYPE,robj2ptr
	iwt	r0,#OBJTYPE_exppiece!OBJTYPE_marker		;!OBJTYPE_car
	and	rt5
	bne	.nextobj
	nop

	mloadw	rt1,OBJ_RADZ,robj2ptr
	mloadw	r0,OBJ_WORLDZ,robj2ptr
	sub	robjposz
	bpl	.nnegz
	nop
	mneg	r0
.nnegz	sub	rt1
	bpl	.nextobj
	nop



	mloadw	rt1,OBJ_RADX,robj2ptr
	mloadw	r0,OBJ_WORLDX,robj2ptr
	sub	robjposx
	bpl	.nnegx
	nop
	mneg	r0
.nnegx	sub	rt1
	bpl	.nextobj
	nop

;	mloadw	rt1,OBJ_RADY,robj2ptr
;	mloadw	r0,OBJ_WORLDY,robj2ptr
;	sub	robjposy
;	bpl	.nnegy
;	nop
;	mneg	r0
;.nnegy	sub	rt1
;	bpl	.nextobj
;	nop


;	mloadw	rt1,OBJ_COLLSHAPE,robj2ptr
;	mtest	rt1
;	beq	.nextobj
;	nop
;	iwt	r0,#sh_ymax
;	to	r14
;	add	rt1
;	mgetw	r0
;	mtest	r0
;	beq	.nextobj
;	nop
	


	iwt	r0,#OBJTYPE_car
	and	rt5
	bne	.coll1full
	nop


	mloadw	r0,OBJ_COLLOBJ1,robj1ptr
	mtest	r0
	bne	.coll1full
	nop
	mstorew	robj2ptr,OBJ_COLLOBJ1,robj1ptr
	bra	.setcoll
	nop
.coll1full


	mloadw	r0,OBJ_COLLOBJ2,robj1ptr
	mtest	r0
	bne	.coll2full
	nop
;	mstorew	robj2ptr,OBJ_COLLOBJ2,robj1ptr
	mstorew	robj1ptr,OBJ_COLLOBJ,robj2ptr
	mstorew	robj2ptr,OBJ_COLLOBJ,robj1ptr
.coll2full

.setcoll
;	ibt	rt1,#0
;	mstorew	rt1,OBJ_COLLOBJ,robj2ptr

.nextobj
	mloadw	r0,OBJ_NEXT,robj2ptr
	mlbra	.loop
.noobjs

	move	pc,r11
	nop

;******************************************************************

mdrawspeed	
	mpush	r11
	ifeq	1
	
	sub	r0
	cmode

	move	r1,#2
	move	r2,#2
	move	r3,#130
	move	r4,#10
	move	r0,#9
	mcall	mdrawbox
	nop

	lm	r1,[m_testcar1]
	mloadw	r0,CAR_gndspeed,r1
	div2
	div2
	iwt	r2,#126
	cmp	r2
	bmi	.less
	nop
	move	r0,r2
.less	
	move	r3,r0

	iwt	r4,#$94
	mloadw	r0,CAR_FLAGS,r1
	iwt	r2,#CARflag_boost
	and	r2
	beq	.norm
	nop
	ibt	r4,#2
.norm	
	move	r0,r4




	move	r1,#4
	move	r2,#4
	move	r4,#6
	mcall	mdrawsolidbox
	nop

	endc
	mpop	pc
	nop    

;******************************************************************
boost_x	equ	192
boost_y	equ	70
boost_width	equ	10
boost_height	equ	52
boost_fcol	equ	$2f
boost_col	equ	$72
boost_col1	equ	$41
boost_colscale	equ	(65536*1000)/((car1_boosttime*1000)/16)


rcarptr	=	r8

mdrawmeters
	mpush	r11

	
	iwt	r0,#boost_fcol
	iwt	r1,#boost_X
	iwt	r2,#boost_Y
	iwt	r3,#boost_width
	iwt	r4,#boost_height
	mcall	mdrawbox
	nop

	lm	rcarptr,[m_testcar1]
	mloadw	r4,CAR_BOOSTTIME,rcarptr

	ibt	r0,#red2green_pal>>16
	romb
	iwt	r14,#red2green_pal&wm
	move	r6,r4
	iwt	r0,#boost_colscale
	fmult	
	with	r14
	add	r0
	getb


	iwt	r1,#boost_x+1
	iwt	r2,#boost_y-1+boost_height
	with	r2
	sub	r4
	iwt	r3,#boost_width-2
	mcall	mdrawsolidbox
	nop

	mpop	pc
	nop


red2green_pal
	db	$41,$41,$41,$41,$41,$54,$53,$52
	db	$51,$50,$63,$62,$61,$71,$72,$73

	db	$43,$42,$41,$54,$53,$52,$51,$50
	db	$63,$62,$61,$61,$71,$71,$72,$73





mdrawdamage
	mpush	r11
	ifeq	1

	lm	r1,[m_testcar1]
	mloadw	r8,CAR_WHEELS,r1

	mloadw	r0,WHL_DAMAGE,r8
	iwt	r1,#10
	iwt	r2,#10
	mcall	mdrawwhldam	
	nop

	mloadw	r0,WHL_NEXT,r8
	move	r8,r0
	mloadw	r0,WHL_DAMAGE,r8
	iwt	r1,#30
	iwt	r2,#10
	mcall	mdrawwhldam	
	nop


	mloadw	r0,WHL_NEXT,r8
	move	r8,r0
	mloadw	r0,WHL_DAMAGE,r8
	iwt	r1,#10
	iwt	r2,#50
	mcall	mdrawwhldam	
	nop

	mloadw	r0,WHL_NEXT,r8
	move	r8,r0
	mloadw	r0,WHL_DAMAGE,r8
	iwt	r1,#30
	iwt	r2,#50
	mcall	mdrawwhldam	
	nop

	endc
	mpop	pc
	nop

	ifeq	1
mdrawwhldam
	mpush	r11
	mpush	r8

	ifeq	1
	mneg	r0
	div2
	bpl	.nneg 	
	nop
	sub	r0
.nneg
	iwt	r3,#32
	cmp	r3
	bmi	.ok
	nop
	move	r0,r3
.ok
	elseif
	div2
	endc


	mpush	r0
	mpush	r1
	mpush	r2
	

;	move	r1,#10
;	move	r2,#10
	move	r3,#10
	move	r4,#34
	move	r0,#60
	mcall	mdrawbox
	nop

	mpop	r2
	mpop	r1

	mpop	r4
	iwt	r0,#33
	with	r2
	add	r0
	with	r2
	sub	r4

	inc	r1

	move	r3,#8
	move	r0,#70
	mcall	mdrawsolidbox
	nop


	mpop	r8
	mpop	pc
	nop	
	endc



;******************************************************************


wheel_defs
	whldef	small,wheel2,5
	whldef	medium,wheel2,10
	whldef	big,wheel2,30




car_defs

	cardef		cartype_blocky
	cardef_shape	car
	cardef_whltype	whltype_medium
	cardef_centg	0,0,0
	cardef_wheel	40,20,55,front_maxgrip,power,front
	cardef_wheel	-40,20,55,front_maxgrip,power,front
	cardef_wheel	-40,20,-55,rear_maxgrip,power,rear
	cardef_wheel	40,20,-55,rear_maxgrip,power,rear

	cardef		cartype_dragster
;	cardef_shape	car2
;	cardef_whltype	whltype_medium
;	cardef_centg	0,0,0
;	cardef_wheel	30,30,70,front_maxgrip,power,front
;	cardef_wheel	-30,30,70,front_maxgrip,power,front
;	cardef_wheel	-45,40,-45,rear_maxgrip,power,rear
;	cardef_wheel	45,40,-45,rear_maxgrip,power,rear

	cardef		cartype_fzero
	cardef_shape	car7
	cardef_whltype	whltype_medium
	cardef_centg	0,-38,0
	cardef_wheel	55,50,-55,(rear_maxgrip*160)/100,power,rear	; 55	; mod
	cardef_wheel	-55,50,-55,(rear_maxgrip*160)/100,power,rear	; 55
	cardef_wheel	50,50,65,front_maxgrip/2,front	; 65
	cardef_wheel	-50,50,65,front_maxgrip/2,front	; 65

	cardef		cartype_pickup1
	cardef_shape	car15
	cardef_whltype	whltype_big
	cardef_centg	0,-60,0
	cardef_wheel	45,70,-55,(rear_maxgrip*160)/100,power,rear	; 55	; mod
	cardef_wheel	-45,70,-55,(rear_maxgrip*160)/100,power,rear	; 55
	cardef_wheel	45,70,65,front_maxgrip/2,front	; 65
	cardef_wheel	-45,70,65,front_maxgrip/2,front	; 65

	cardef		cartype_pickup2
	cardef_shape	car15b
	cardef_whltype	whltype_big
	cardef_centg	0,-28,0
	cardef_wheel	55,50,-55,(rear_maxgrip*160)/100,power,rear	; 55	; mod
	cardef_wheel	-55,50,-55,(rear_maxgrip*160)/100,power,rear	; 55
	cardef_wheel	50,50,65,front_maxgrip/2,front	; 65
	cardef_wheel	-50,50,65,front_maxgrip/2,front	; 65

	cardef		cartype_pickup3
	cardef_shape	car16
	cardef_whltype	whltype_big
	cardef_centg	0,-28,0
	cardef_wheel	55,50,-55,(rear_maxgrip*160)/100,power,rear	; 55	; mod
	cardef_wheel	-55,50,-55,(rear_maxgrip*160)/100,power,rear	; 55
	cardef_wheel	50,50,65,front_maxgrip/2,front	; 65
	cardef_wheel	-50,50,65,front_maxgrip/2,front	; 65

	cardef		cartype_ant
	cardef_shape	rvl_4
	cardef_whltype	whltype_medium
	cardef_centg	0,-28,0
	cardef_wheel	55,50,-55,(rear_maxgrip*160)/100,power,rear	; 55	; mod
	cardef_wheel	-55,50,-55,(rear_maxgrip*160)/100,power,rear	; 55
	cardef_wheel	50,50,65,front_maxgrip/2,front	; 65
	cardef_wheel	-50,50,65,front_maxgrip/2,front	; 65

	cardef		cartype_truck
	cardef_shape	car6
	cardef_whltype	whltype_big
	cardef_centg	0,-50,0
	cardef_wheel	100,100,100,front_maxgrip,front	; 65
	cardef_wheel	-100,100,100,front_maxgrip,front	; 65
	cardef_wheel	-100,100,-100,rear_maxgrip,power,rear	; 55
	cardef_wheel	100,100,-100,rear_maxgrip,power,rear	; 55


;******************************************************************
; gear data


mcar1gears_speeds
	dw	80,160,240,320,500,500,500,500
	dw	60,120,180,240,300

	db	45,95,141,188,235,300

geardata_all	MACRO	
	geardata	\1,\2,\2,\2,\2,\2,\2,\2,\2,\2,\2,\2,\2,\2,\2,\2,\2
	ENDM

geardata_8	MACRO	
	geardata	\1,\2,\2,\2,\2,\2,\2,\2,\2,\3,\3,\3,\3,\3,\3,\3,\3
	ENDM

	geardata	5,-99/2,-97/2,-92/2,-85/2,-74/2,-5/29,-39/2,-13/2,0,0,0,0,0,0,0,0
mcar1gears_data
	geardata	1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	geardata_8	5,20,40
	geardata_8	10,50,70
	geardata_8	15,40,30
	geardata_8	20,15,15
	geardata_8	25,13,13


car1_anims
	db	8,7,7,6,6,5,5,4	; thin - normal
	db	4,3,3,2,2,1,1,0	; normal flat
	db	4,4,9,9,10,10,11,11




