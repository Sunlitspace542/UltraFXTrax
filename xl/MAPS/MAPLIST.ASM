
	INCPUBLICS	maps\maplist.ext

incmap	MACRO
	incfile	maps\\\1.asm
	ENDM

	mapdef	mapp	; player's map address

courses

course3
course2
course1	


testmap1	incmap	test1
testmap2	incmap	test2
testmap3	incmap	test3
testmap4	incmap	test4

maps	=	*-mapbase
	?maps



