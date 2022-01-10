	include	header.inc
	include	shmacs.inc


	incfile	mdynmacs.mc
	incfile	dynstruct.inc	

	include	stratmac.inc
	include	stratlib.inc

	include	stratrou.ext
	include	game.ext
	include	world.ext
	include	draw.ext
	include	mario.ext
	include	mother.ext
	include	xltrans.ext
	include	windows.ext


	include	gstrats.ext
	include	pstrats.ext

	include	coltabs.ext
	include	colboxes.ext
	include	mem.ext
	include	endseq.ext
	include xlstart.ext

	public	shape_headers

;------------------------------------
	bank	0		;Bank 0

	db	0,0,0,0,0,0

	incfile	blink.asm

	incfile	sgtabs.asm
	incfile	sgdata.asm

	incfile	data\arctan.asm


	incfile	istrats.asm

Do_HDR	=	1
shape_headers	
	fopen	tshapes.log
default_group_num	=	0
	incfile	shapes.asm
	incfile	shapes2.asm
	incfile	ashapes.asm
	incfile	a2shapes.asm
	incfile	afshapes.asm
	incfile	af2shapes.asm
	incfile	a1shapes.asm
	incfile	ajshapes.asm
	incfile	aushapes.asm
	incfile	acshapes.asm
	incfile	rshapes.asm
	incfile	rshapes2.asm
	incfile	awshapes.asm
	printf	"shapes_end%n"
	fclose	


Do_HDR	=	0


;	incfile	d3strats.asm

	public	bgandpcr
	inccru	bgandpcr,data\and.pcr

ResetEntry
	jmp.l	ProgramEntry

cop_ve
abort_ve
nmi_ve
irq_ve
cop_vn
reset_vn
break_vn
abort_vn
	rti

	bankend	0

	org	$00ffc0,$7fc0

	IFEQ	JANGLISH

	db	"FX TRAX              "
	db	$20,$15,$a,$0,$1,$1,$0,$ff,$ff,$0,$0

	ELSEIF

	db	"FX TRAX              "
	db	$20,$15,$a,$0,$0,$1,$0,$ff,$ff,$0,$0

	ENDC

;------------------------------------

;Hardware Vectors	-------------------------
	org	$00ffe4,$7fe4
	dw	cop_vn
	dw	break_vn
	dw	abort_vn
	dw	$0108
	dw	$0000
	dw	$010c

	org	$00fff4,$7ff4
	dw	cop_ve
	dw	0
	dw	abort_ve
	dw	nmi_ve
	dw	ResetEntry
	dw	irq_ve




;------------------------------------


	include	tail.inc


