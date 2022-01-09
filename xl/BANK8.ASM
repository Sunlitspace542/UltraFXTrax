	include	header.inc
	include	strathdr.inc
	include	gstrats.ext
	include	pstrats.ext
	include	bootnmi.ext
	include	ramstuff.ext
	include	coltabs.ext
	include	mkmacs.inc
	include	xlsound.ext

	
	bank	8
	incfile	gastrats.asm
;	incfile	gbstrats.asm

	

	public	bgmd
	public	bgmdlen
bgmd	incbinfile	snd\sgbgmd.bin
bgmdlen	equ	*-bgmd

	bankend	8

	include	tail.inc


