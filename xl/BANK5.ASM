

	include	header.inc
	incfile	mdynmacs.mc
	incfile	dynstruct.inc
	include	mapmacs.inc

	include	stratequ.inc
	include	mapstructs.inc

	include	mario.ext
	include	pstrats.ext
	include	gstrats.ext
	include	gastrats.ext
	include	shapes.ext
	include	stratrou.ext
	include	sgtabs.ext
	include	bgs.ext
	include	paths.ext
	include	blink.ext
	include	sound.ext
	include	mdata.ext
	include	endseq.ext
	include	windows.ext
	include	continue.ext
	include	trans.ext
	include	bgmacs.inc
	include	trackdat.ext


real_istrats =	0
	include	istrats.asm


;------------------------------------------------------------------
	bank	5
	incfile	maps\maplist.asm

	public	bgandccr
	inccru	bgandccr,data\and.ccr


	bankend	5
;------------------------------------------------------------------
	bank	13
	incfile	maps\maplist2.asm

	bankend	13
;------------------------------------------------------------------



	include	tail.inc


