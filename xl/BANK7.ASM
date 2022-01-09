	include	header.inc 
	include	bgmacs.inc   
	include	strathdr.inc
	include	gstrats.ext
	include	pstrats.ext
	include	shmacs.inc
	include	xlirq.ext
	include	planets.ext
	include	ramstuff.ext
	include incbins.ext
	include	endseq.ext
	include	bgs.ext
	include	coltabs.ext
	include	marioi.inc
	include	mkmacs.inc
	incpublics mmessage.ext	
	include	mdynmacs.mc
	include	dynparms.inc


	bank	7
font12	incbinfile	xldata\font.bmp	  ;must fastplace on this bank
	incfile	xlstart.asm
	incfile	xltitle.asm
	incfile xlinit.asm
	incfile	xlsound.asm
	incfile	xlmes.asm

	mario	on
	incfile	mmacs.mc
	incfile	mmessage.mc
	mario	off

	public	titlecgx
	public	titlescr
	public	titlecol
	public	racecol0
	public	racecol1
	public	racecol2
	public	racecol3
	public	objcgx
	public	bgpanel
	public	backcgx0
	public	backscr0
	public	font12
	public	hand

	minfo
hand	equ	0
;;;	inccru	  hand,xldata\hand.pcg
;;;	minfo	  xldata\hand.pcg
	inccru	  titlecgx,xldata\title.pcg
	minfo	  xldata\title.pcg
	inccru	  titlecol,xldata\title.pco
	minfo	  xldata\title.pco
	inccru	  titlescr,xldata\title.psc
	minfo	  xldata\title.psc
	inccru	  racecol0,xldata\game.pco
	minfo	  xldata\game.pco
	inccru	  racecol1,xldata\game2.pco
	minfo	  xldata\geme2.pco
	inccru	  racecol2,xldata\game3.pco
	minfo	  xldata\geme3.pco
	inccru	  racecol3,xldata\game4.pco
	minfo	  xldata\geme4.pco
	inccru	  objcgx,xldata\obj.pcg
	minfo	  xldata\obj.pcg
	inccru	  bgpanel,xldata\bgpanel.pcg
	minfo	  xldata\bgpanel.pcg
	inccru	  backcgx0,xldata\back1.pcg
	minfo	  xkdata\back1.pcg
	inccru	  backscr0,xldata\back1.psc
	minfo	  xldata\back1.psc
		
	bankend	7



	include	tail.inc
   	include	report7.inc

