	include	header.inc
	include	strathdr.inc
	include	pstrats.ext
	include	shmacs.inc
	include	windows.ext
	include	bgmacs.inc
	include	maps\maplist.ext
	include	marioi.inc
	include	gastrats.ext
	

	incpublics	mhofs.ext

;------------------------------------------------------------------
	bank	6
	incfile	gstrats.asm

cacheon	=	1
     	incfile	mmacs.mc
	mario	on
	incfile	mhofs.mc		;Kristers .mc files
	mario	off


	bankend	6

	include	tail.inc



