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

bgmm	incbinfile	snd\sgbgmm.bin
bgmmlen	equ	*-bgmm
	bankend	12

;------------------------------------------------------------------
	bank	14
default_group_num	=	1
	incshapes	a2shapes.asm
	incshapes	rshapes2.asm
	inccru	bgmpcr,data\m.pcr
bgm2	incbinfile	snd\sgbgm2.bin
bgm2len	equ	*-bgm2
	bankend	14

;------------------------------------------------------------------
	bank	15
	incshapes	afshapes.asm

bgmn	incbinfile	snd\sgbgmn.bin
bgmnlen	equ	*-bgmn
	bankend	15

;------------------------------------------------------------------
	bank	16
default_group_num	=	1
	incshapes	a1shapes.asm
	incshapes	awshapes.asm
	incshapes	shapes2.asm
bgmj	incbinfile	snd\sgbgmj.bin
bgmjlen	equ	*-bgmj
	bankend	16

;------------------------------------------------------------------
	bank	17
default_group_num	=	1
	incshapes	ajshapes.asm
	incshapes	aushapes.asm
	incshapes	af2shapes.asm
	
	public	dogccr
	inccru	dogccr,data\dog.ccr

bgm7	incbinfile	snd\sgbgm7.bin
bgm7len	equ	*-bgm7
bgm3	incbinfile	snd\sgbgm3.bin
bgm3len	equ	*-bgm3

	bankend	17




;------------------------------------------------------------------
	bank	22
default_group_num	=	1
	incshapes	acshapes.asm
	
	bankend	22



	include	tail.inc


