		 
	include	header.inc
	include	coltabs.ext
	include	mdata.ext
	include	sgdata.ext
	include	marioi.inc
	include	shmacs.inc
	include	gridvars.inc

	include	stratequ.inc
	include	trackdat.ext
	incfile	mdynmacs.mc
	incfile	dynstruc.inc
	incfile	dynparms.inc
	include	shapes.ext

	extern	arctantab
	extern	shape_headers

	include	incbins.ext

	incpublics	mario.ext


;------------------------------------------------------------------
	bank	1
rztab
mariobegin
yyy	mario	on
	incfile	mvars.mc
     	incfile	mmacs.mc
	incfile	mshtab.mc	; must be at start of bank
	incfile	mmaths.mc
	incfile	mwrot.mc
	incfile	mwcrot.mc
	incfile	mobj.mc
	incfile	mclip.mc
	incfile	mdrawc.mc
	incfile	mdrawp.mc
	incfile	msprite.mc
	incfile	mgdots.mc
;	incfile	mcircle.mc
	incfile	mdrawlis.mc
	incfile	mdecru.mc
;	incfile	mtxtprt.mc
;	incfile	mplanet.mc
	incfile	mdsprite.mc
;	incfile	mhofs.mc		;Kristers .mc files
;	incfile	mbumwipe.mc
;	incfile	mhud.mc

	incfile	mpart.mc

	incfile	mdynamic.mc
	incfile	mai.mc

	mario	off


;	incfile	fontdata.asm

mariocodelen	=	*-mariobegin

oopspal	;incbin	data\oops.pal
oopschr	;incbin	data\oops.chr
oopspic	;incbin	data\oops.pic

	bankend	1


	include	tail.inc


