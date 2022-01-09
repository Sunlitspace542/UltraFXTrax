	include	header.inc
	include	marioi.inc
	include	stratmac.inc
	include	stratlib.inc
	include	bgmacs.inc
	include	blink.ext

	include	mapstructs.inc
	incfile	mdynmacs.mc
	incfile	dynstruct.inc
	include	mapmacs.inc
	include	shmacs.inc
	include mkmacs.inc

	include	mario.ext


	include	incbins.ext
	include	mdata.ext

	include	sgdata.ext
	include	pstrats.ext
	include	gstrats.ext
	include	gastrats.ext
;	include	shapes.ext
;	include	stratrou.ext
	include	sgtabs.ext
	include	maps\maplist.ext
	include	shbanks.ext
;	include	mem.ext
	include	istrats.inc
	include	xlmes.ext
	include	mmessage.ext

	include	mhofs.ext

	include	xlstart.ext
	include	xltitle.ext
	include	xlinit.ext
	include	xlsound.ext

scr_offset	equ	(vchr_logback-vchr_physback)/16

	extern	bgandpcr
	extern	bgandccr
	extern	dogccr
	extern	bgml	
	extern	bgmllen	
	extern	bgmd	
	extern	bgmdlen	
	extern	bgm11	
	extern	bgm11len

;-------------------------------------------------------
	bank	2
	ifne	*-$28000
	error	<X Routines bank must be start of bank 2>
	endc

	org	xroutines,$8000*2
ramstart	incfile	ramstuff.asm
xoffset	equ	*-ramstart

	ifle	xlen-xoffset
	error	<Extended code more than xlen>
	endc

	org	$28000+xoffset,$8000*2+xoffset
	minfo
	incfile	xlmain.asm
	minfo	xlmain
	incfile	xltrans.asm
 	minfo	xltrans

	incfile	game.asm
	minfo	game
	incfile	windows.asm
	minfo	windows
	bankend	2



;------------------------------------------------------------------
	bank	3
planetdmapos1	dw	228
planetdmapos2	dw	100
	minfo
	incfile	coltabs.asm
	minfo	coltabs
;	incfile	bgs.asm
;	minfo	bgs
;	incfile	sound.asm
;	minfo	sound
	incfile	obj.asm
 	minfo	obj
;	incfile	planets.asm
;	minfo	planets
;	incfile	sprites.asm
;	minfo	sprites
	incfile	world.asm
	minfo	world
	bankend	3

	org	$1f8000+$3db0,$8000*$1f+$3db0
	minfo
	incfile	debug.asm
	minfo	<debug>
;	incfile	bootnmi.asm
;	minfo	bootnmi
	incfile	stratrou.asm
	minfo	<stratrou>
;	incfile	nmi.asm
;	minfo	nmi
	incfile	draw.asm
	minfo	draw
	incfile	endseq.asm
	inccru	bgf1pcr,data\f-1.pcr
;	incfile	cont.asm
;	minfo	cont
	bankend	31
;------------------------------------------------------------------


	include	tail.inc




