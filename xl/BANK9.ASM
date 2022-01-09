	include	header.inc
;	include	strathdr.inc
	include	gstrats.ext
	include	pstrats.ext
	include	coltabs.ext
	include	windows.ext
	include	bootnmi.ext

	bank	9
;	incfile	dstrats.asm
;	incfile	ga3strats.asm

	public	bgm11
	public	bgm11len
bgm11	incbinfile	snd\sgbgm11.bin
bgm11len	equ	*-bgm11

	bankend	9

	include	tail.inc


