
sprbank	macro
	defs	$1,"\1"
cpa	=	0
	endm

cps	=	0

defspr	macro
\1_spr	=	cps
	dw	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))&$ffff
	db	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))>>16
cps	=	cps+1
cpa	=	cpa+1
	endm

defspr16	macro
\1_spr	=	cps
	dw	(\$1+((cpa&7)*16)+(256*16*((cpa&31)/8)))&$ffff
	db	(\$1+((cpa&7)*16)+(256*16*((cpa&31)/8)))>>16
cps	=	cps+1
cpa	=	cpa+1
	endm

defspr_hi	macro
\1_spr	=	cps!(1<<7)
	dw	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))&$ffff
	db	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))>>16
cps	=	cps+1
cpa	=	cpa+1
	endm



defsprabs	macro	[name,x,y]
{name}_spr	=	cps
	dw	(\$1+(({x})*8)+(256*8*({y})))&$ffff
	db	(\$1+(({x})*8)+(256*8*({y})))>>16
cps	=	cps+1
	endm

defsprabs_hi	macro	[name,x,y]
{name}_spr	=	cps!(1<<7)
	dw	(\$1+(({x})*8)+(256*8*({y})))&$ffff
	db	(\$1+(({x})*8)+(256*8*({y})))>>16
cps	=	cps+1
	endm

defsprdoub	macro
\1_spr	=	cps
	dw	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))&$ffff
	db	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))>>16
cps	=	cps+1
cpa	=	cpa+2
	endm

defspr64	macro
\1_spr	=	cps
	dw	(\$1+((cpa&3)*64)+(256*64*((cpa&15)/4)))&$ffff
	db	(\$1+((cpa&3)*64)+(256*64*((cpa&15)/4)))>>16
cpa	=	cpa+1
cps	=	cps+1
	endm

defspr64_hi	macro
\1_spr	=	cps!(1<<7)
	dw	(\$1+((cpa&3)*64)+(256*64*((cpa&15)/4)))&$ffff
	db	(\$1+((cpa&3)*64)+(256*64*((cpa&15)/4)))>>16
cpa	=	cpa+1
cps	=	cps+1
	endm

defsprdoub_hi	macro
\1_spr	=	cps!(1<<7)
	dw	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))&$ffff
	db	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))>>16
cps	=	cps+1
cpa	=	cpa+2
	endm


defsprcopy_hi	MACRO	\1
\1_spr	=	cps!(1<<7)
cpa	=	cpa-1
	dw	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))&$ffff
	db	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))>>16
cps	=	cps+1
cpa	=	cpa+1
	ENDM

defdummy	MACRO	
cpa	=	cpa+\1
	ENDM



;textureaddrtab
	sprbank	msprites1

	ifeq	0
	defspr	ironball
	defspr	cockpit1
	defspr	cockpit2
	defspr	asteroid3
	defspr	tunnelwall
	defspr	scrapmetal
	defspr	chicken
	defspr	space3

	defspr	expl9
	defspr	expl10
	defspr	spark1
	defspr	spark2
	defspr	starwars1
	defspr	starwars2
	defspr	starwars3
	defspr	spark3

	defspr	plasma1
	defspr	plasma2
	defspr	laserfire1
	defspr	laserfire2
	defspr	space4
	defspr	fireball1
	defspr	fireball2
	defspr	fireball3

	defspr	ricecrispies1
	defspr	specialweapon1
	defspr	specialweapon2
	defspr	asteroid1
	defspr	specialweapon3
	defspr	ring1
	defspr	ring2
	defspr	asteroid2

	defspr_hi	splash1
	defspr_hi	splash2
	defspr_hi	splash3
	defspr_hi	splash4
	defspr_hi	splash5
	defspr_hi	splash6
	defsprdoub_hi	bigandross

	defspr_hi	rock1
	defspr_hi	panel3
	defspr_hi	ball
	defspr_hi	egg
	defspr_hi	rock2
	defspr_hi	face1
	defsprdoub_hi	nowt
;	defspr_hi	biker1
;	defspr_hi	rock3

	defspr_hi	bigmeteo
	defspr_hi	space1
	defspr_hi	space2
	defspr_hi	cluster
	defspr_hi	blackhole
	defspr_hi	bigships

	defsprdoub_hi	planetc
	defsprdoub_hi	playerplanet
	defsprdoub_hi	planeta
	defsprdoub_hi	planetb
	defsprdoub_hi	enemyplanet

	sprbank	msprites2

	defspr64	largeexpl1
	defspr64	largeexpl2
	defspr64	largeexpl3
	defspr64	largeexpl4
	defspr64	largeexpl5
	defspr64	largeexpl6
	defspr64	largeexpl7
	defspr64	largeexpl8

;	defsprabs_hi	smoke1,0,0
;	defsprabs_hi	smoke2,4,0
;	defsprabs_hi	smoke3,8,0
;	defsprabs_hi	smoke4,12,0
;	defsprabs_hi	smoke5,16,0
;	defsprabs_hi	smoke6,20,0

	defsprabs_hi	oval1,24,0
	defsprabs_hi	oval2,28,0
	defsprabs_hi	oval3,0,4

	defsprabs_hi	boost1,4,4
	defsprabs_hi	boost2,28,4
	endc	


	sprbank	msprites3

	defsprabs	scrollee,0,0

	sprbank	msprites3

	defsprabs_hi	nintendo,0,0

textureaddrtab
cps	=	0
	sprbank	msprites1

	defspr	wheel0
	defspr	wheel1
	defspr	wheel2
	defspr	wheel3
	defspr	wheel4
	defspr	wheel5
	defspr	wheel6
	defspr	wheel7
	defspr	wheel8
	defspr	wheel9
	defspr	wheela
	defspr	wheelb
	defspr	wheelc
	defspr	wheeld
	defspr	wheele
	defspr	wheelf
	defspr	wheel10
	defspr	wheel11
	defspr	wheel12
	defspr	wheel13
	defspr	wheel14
	defspr	wheel15
	defspr	wheel16
	defspr	wheel17
	defspr	wheel18
	defspr	wheel19
	defspr	wheel1a
	defspr	wheel1b

	defspr	wheeld1
	defspr	wheeld2
	defspr	wheeld3
	defspr	wheeld4


	defspr_hi	smoke1
	defspr_hi	smoke2
	defspr_hi	smoke3
	defspr_hi	smoke4
	defspr_hi	smoke5
	defspr_hi	smoke6

	defspr_hi	num1
	defspr_hi	num2
	defspr_hi	num3
	defspr_hi	num4
	defspr_hi	stripe

	defspr_hi	treestump

	defspr_hi	hand1
	defspr_hi	hand2
	defspr_hi	hand3
	defspr_hi	brownpuff1
	defsprcopy_hi	whitepuff1

	defsprabs_hi	treetop,0,8
	defdummy	2

	defspr_hi	brownpuff2
	defsprcopy_hi	whitepuff2
	defspr_hi	brownpuff3
	defsprcopy_hi	whitepuff3

	defspr_hi	redtyres
	defsprcopy_hi	whitetyres

	defspr_hi	uturn
	defspr_hi	sqturn
	defspr_hi	rightbend

	defdummy	2
	defspr_hi	turnright
	defspr_hi	superfx
	defspr_hi	brownpuff4
	defsprcopy_hi	whitepuff4

	defspr_hi	bush1
	defspr_hi	bumpy

	defspr_hi	grill1


	sprbank	msprites2
	defspr16	eye1
	defspr16	eye2
	defspr16	eye3
	defspr16	eye4
	defspr16	eye5
	defspr16	eye6
	defspr16	eye7
	defspr16	eye8
	defspr16	eye9
	defspr16	eye10
	defspr16	eye11
	defspr16	eye12



texturepaltab
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20	; wheels

	db	$20
	db	$20
	db	$20
	db	$20	; wheel dummy


	db	$20
	db	$20
	db	$20
	db	$20
	db	$20
	db	$20	; smoke

	db	$e0	; num 1
	db	$e0	; num 2
	db	$e0	; num 3
	db	$e0 	; num 4
	db	$e0	; stripe

	db	$a0	; tree stump

	db	$b0	; hand 1
	db	$b0	; hand 2
	db	$b0	; hand 3
	db	$d0	; br. puff 1
	db	$20	; wh. puff 1

	db	$70	; tree top
	db	$d0	; br. puff 2
	db	$20	; wh. puff 2
	db	$d0	; br. puff 3
	db	$20	; wh. puff 3
	db	$40	; red tyres
	db	$20	; white tyres

	db	$e0	; uturn
	db	$e0	; sqturn
	db	$e0	; rightbend

	db	$e0	; turnright
	db	$e0	; superfx
	db	$d0	; br. puff 4
	db	$20	; wh. puff 4

	db	$70	; bush1
	db	$a0	; bumpy
	db	$e0	; grill1

; bank 2
	db	$e0	; eye1
	db	$e0	; eye2
	db	$e0	; eye3
	db	$e0	; eye4
	db	$e0	; eye5
	db	$e0	; eye6
	db	$e0	; eye7
	db	$e0	; eye8
	db	$e0	; eye9
	db	$e0	; eye10
	db	$e0	; eye11
	db	$e0	; eye12





texturexytab
	dw	texturexy0&WM
	dw	texturexy1&WM
	dw	texturexy2&WM
	dw	texturexy3&WM
	dw	texturexy4&WM
	dw	texturexy5&WM
	dw	texturexy6&WM
	dw	texturexy7&WM
	dw	texturexy8&WM
	dw	texturexy9&WM


texturexy0
	dw	$1f1f
	db	0,0
	db	31,0
	db	31,31
	db	0,31

;	db	0,30
;	db	0,25
;	db	0,20
;	db	0,15
;	db	0,10
;	db	0,5

texturexy1
	dw	$3f3f
	db	63,0
	db	0,0
	db	0,63
	db	63,63

texturexy2
	db	127,15
	db	0,0
	db	0,15
	db	15,15
	db	15,0

texturexy3
	dw	$1f1f
	db	0,0
	db	127,0
	db	127,31
	db	0,31

texturexy4
	dw	$f3f
	db	0,0
	db	63,0
	db	63,15
	db	0,15

texturexy5
	dw	$f3f
	db	63,0
	db	0,0
	db	0,15
	db	63,15

texturexy6
	dw	$3f3f
	db	0,0
	db	63,0
	db	63,63
	db	0,63

texturexy7
	dw	$077f
	db	31,0
	db	0,0
	db	0,7
	db	31,7

texturexy8	dw	$1f1f
	db	31,0
	db	0,0
	db	0,31
	db	31,31

texturexy9
	dw	$0f0f
	db	0,0
	db	15,0
	db	15,15
	db	0,15



