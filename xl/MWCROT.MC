



rcosx	equr	8
rsinx	equr	12
rcosy	equr	3
rsiny	equr	4
rcosz	equr	5
rsinz	equr	7
rmatptr	equr	9
rt1	equr	1
rt2	equr	2
rt3	equr	13
rt4	equr	14

; t1= cz*sy 		 yz
; t2= cz*cy 		 yz
; t3= sz*sy		 yz
; t4= sz*cy		 yz
; m11= t3*sx + t2	xyz
; m12= t1*sx - t4	xyz
;>m13= cx*sy		xy
; m21= cx*sz		x z
; m22= cx*cz		x z
;>m23= -sx		x
; m31= t4*sx - t1	xyz
; m32= t2*sx + t3	xyz
;>m33= cx*cy		xy


; create full 16 bit world zxy matrix
; in:	m_rotx,y,z	(16 bit angles)
; out:	m_wmat

mcrotwmatzxy16
	miwt	r9,m_wmat11
	mcall	mcrotmatzxy16
	nop

	stop
	nop


; create full 16 bit world zxy matrix
; in:	m_rotx,y,z	(16 bit angles)
;	r9 = matrix ptr
; out:	
	
mcrotmatzxy16
	sub	r0
	ramb
	romb

	lms	r1,[m_rotx]
	mgetsin16	rsinx,r1,r2
	mgetcos16	rcosx,r1,r2

	lms	r1,[m_roty]
	mgetsin16	rsiny,r1,r2
	mgetcos16	rcosy,r1,r2

	lms	r1,[m_rotz]
	mgetsin16	rsinz,r1,r2
	mgetcos16	rcosz,r1,r2

; calc temps
; t1= cz*sy 		 yz
; t2= cz*cy 		 yz
; t3= sz*sy		 yz
; t4= sz*cy		 yz

	move	r6,rcosz

	from	rsiny
	fmult
	to	rt1
	rol

	from	rcosy
	fmult
	to	rt2
	rol

	move	r6,rsinz

	from	rsiny
	fmult
	to	rt3
	rol

	from	rcosy
	fmult
	to	rt4
	rol

; m11= t3*sx + t2	xyz
; m12= t1*sx - t4	xyz
;>m13= cx*sy		xy

	move	r6,rsinx

	from	rt3
	fmult
	rol
	add	rt2

	mstwi	rmatptr	; mat11

	from	rt1
	fmult
	rol
	sub	rt4

	mstwi	rmatptr	; mat12

	move	r6,rcosx

	from	rsiny
	fmult
	rol

	mstwi	rmatptr	; mat13

; m21= cx*sz		x z
; m22= cx*cz		x z
;>m23= -sx		x

	from	rsinz
	fmult
	rol

	mstwi	rmatptr	; mat21

	from	rcosz
	fmult
	rol

	mstwi	rmatptr	; mat22

	from	rsinx
	not
	inc	r0

	mstwi	rmatptr	; mat23

; m31= t4*sx - t1	xyz
; m32= t2*sx + t3	xyz
;>m33= cx*cy		xy

	move	r6,rsinx

	from	rt4
	fmult
	rol
	sub	rt1

	mstwi	rmatptr	; mat31

	from	rt2
	fmult
	rol
	add	rt3

	mstwi	rmatptr	; mat32

	move	r6,rcosx

	from	rcosy
	fmult
	rol

	stw	[rmatptr]	; mat33

	jmp	r11
	nop



;***********************************************************************
; mcrotmatzxy8 -
;
; creates 8 bit object matrix.

rmatx	equr	1
rmaty	equr	2
rmatz	equr	3
rcosx	equr	4
rsinx	equr	5
rcosy	equr	6
rsiny	equr	7
rcosz	equr	8
rmatptr	equr	9
rsinz	equr	3
rt1	equr	1
rt2	equr	2
rt3	equr	12
rt4	equr	13

; t1= cz*sy 		 yz
; t2= cz*cy 		 yz
; t3= sz*sy		 yz
; t4= sz*cy		 yz
; m11= t3*sx + t2	xyz
; m12= t1*sx - t4	xyz
;>m13= cx*sy		xy
; m21= cx*sz		x z
; m22= cx*cz		x z
;>m23= -sx		x
; m31= t4*sx - t1	xyz
; m32= t2*sx + t3	xyz
;>m33= cx*cy		xy


mcrotmatzxy8
;	mpush	r11
;	sms	[m_sp],rsp

	miwt	rt1,costab
	from	rt1
	to	r14
	add	rmatx
	to	rcosx
	getb

	from	rt1
	to	r14
	add	rmaty
	to	rcosy
	getb

	from	rt1
	to	r14
	add	rmatz
	to	rcosz
	getb

	miwt	rt1,sintab
	from	rt1
	to	r14
	add	rmatx
	to	rsinx
	getb

	from	rt1
	to	r14
	add	rmaty
	to	rsiny
	getb

	from	rt1
	to	r14
	add	rmatz
	to	rsinz
	getb

; calc temps
; t1= cz*sy 		 yz
; t2= cz*cy 		 yz
; t3= sz*sy		 yz
; t4= sz*cy		 yz

	from	rcosz
	mult	rsiny
	to	rt1
	add	r0

	from	rcosz
	mult	rcosy
	to	rt2
	add	r0

	from	rsinz
	mult	rsiny
	to	rt3
	add	r0

	from	rsinz
	mult	rcosy
	to	rt4
	add	r0

; m11= t3*sx + t2	xyz
; m12= t1*sx - t4	xyz
;>m13= cx*sy		xy

	from	rt3
	hib
	mult	rsinx
	add	r0
	add	rt2
	hib
	mstbi	rmatptr	; mat11

	from	rt1
	hib
	mult	rsinx
	add	r0
	sub	rt4
	hib
	mstbi	rmatptr	; mat12

	from	rsiny
	mult	rcosx
	add	r0
	hib
	mstbi	rmatptr	; mat13

; m21= cx*sz		x z
; m22= cx*cz		x z
;>m23= -sx		x

	from	rcosx
	mult	rsinz
	add	r0
	hib
	mstbi	rmatptr	; mat21

	from	rcosx
	mult	rcosz
	add	r0
	hib
	mstbi	rmatptr	; mat22

	from	rsinx
	not
	inc	r0
	mstbi	rmatptr	; mat23

; m31= t4*sx - t1	xyz
; m32= t2*sx + t3	xyz
;>m33= cx*cy		xy

	from	rt4
	hib
	mult	rsinx
	add	r0
	sub	rt1
	hib
	mstbi	rmatptr	; mat31

	from	rt2
	hib
	mult	rsinx
	add	r0
	add	rt3
	hib
	mstbi	rmatptr	; mat32

	from	rcosy
	mult	rcosx
	add	r0
	hib
	stb	[rmatptr]	; mat33

;	lms	rsp,[m_sp]
;	mpop	pc

	jmp	r11
	nop







