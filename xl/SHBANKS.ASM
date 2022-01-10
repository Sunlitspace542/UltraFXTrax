	include	header.inc
	include	stratequ.inc
	incfile	mdynmacs.mc
	incfile	dynstructs.inc
	
	
	include	shmacs.inc

	include	colboxes.ext
	include	coltabs.ext

	INCPUBLICS shbanks.ext

default_group_num	=	0
do_hdr	=	0

;------------------------------------------------------------------
	bank	12
	incshapes	shapes.asm	
default_group_num	=	1
	incshapes	rshapes.asm
	incshapes	ashapes.asm

	bankend	12

;------------------------------------------------------------------
	bank	14
default_group_num	=	1
	incshapes	a2shapes.asm
	incshapes	rshapes2.asm
	inccru	bgmpcr,data\m.pcr
	bankend	14

;------------------------------------------------------------------
	bank	15
	incshapes	afshapes.asm
	bankend	15

;------------------------------------------------------------------
	bank	16
default_group_num	=	1
	incshapes	a1shapes.asm
	incshapes	awshapes.asm
	incshapes	shapes2.asm
	bankend	16

;------------------------------------------------------------------
	bank	17
default_group_num	=	1
	incshapes	ajshapes.asm
	incshapes	aushapes.asm
	incshapes	af2shapes.asm
	
	bankend	17




;------------------------------------------------------------------
	bank	22
default_group_num	=	1
	incshapes	acshapes.asm
	
	bankend	22



	include	tail.inc


