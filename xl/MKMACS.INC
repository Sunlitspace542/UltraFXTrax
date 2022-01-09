;------------------------------------------------------------------------
;
;	Macros !Peesented by Masato Kimura !!!!
;				
;			05/02/1993
;
;------------------------------------------------------------------------


dl	macro
	dw	(\1)&WM
	db	(\1)>>16
	endm

ldax	macro
	db	$bd
	dw	(\1)&WM
	endm

lday	macro
	db	$b9
	dw	(\1)&WM
	endm

waitloop macro
	bra	*
	endm	


;---------------------------------------------------------------
executemario	MACRO
	a8i16
	ldx	#\1&WM
	lda	#\1>>16
	jsl	runmario_l
		ENDM
;---------------------------------------------------------------

recordlaptime		MACRO

	a16i8
	ldx  	#\1*6
	jsr	set_record
			ENDM

;---------------------------------------------------------------

Execute_DMA		MACRO	
	php
	a16i8
	ldx	\1
	stx	$4300	;DMA control parametar
	ldx	\2
	stx	$4301	;B buss address(21XXh)
	ldx	(\3>>16)
	stx	$4304	;data bank
	lda	(\3&$ffff)
	sta	+02	;data address 
	lda	\4
	sta	$4305	;data length
	ldx	#01
	stx	$420b		:set DMA switch
	plp
		ENDM


Trans_DRAM	MACRO
	a16
	php
	lda	#(\5>>8)		;set DRAM BANK
	sta	$2182
	lda	#(\5&$ffff)
	sta	$2181		;set DRAM ADDRESS
	ExecuteDMA \1,\2,\3,\4
	plp
		ENDM

;---------------------------------------------------------------
;entry			from ???,to ???,amount ???

blocktransfer	macro
	db	$08b		;phb
	db	$008		;php
	db	$0c2		;rep
	db	%00110000	;#00110000b
	db	$0a9		;lda
	dw	(\3)&WM-1	;#amount(\3)-1
	db	$0a2		;ldx
	dw	(\1)&WM		;#original
	db	$0a0		;ldy
	dw	(\2)&WM		;#terminal	
	db	54h		;mvn opecode
	db	(\2)>>16	;terminal data bank resister
	db	(\1)>>16	;original data bank resister
	db 	$28	      	;plp
	db	$0ab		;plb
	endm



;---------------------------------------------------------------
;entry		      start address ???,amount ????

clearram	macro

	db	$08b		;phb
	db	$08		;php
	db	$0c2		;rep
	db	%00110000	;#00110000b
	db	$0a9		;lda
	dw	0000		;#00
	db	$08f		;sta(long!!!)
	dl	\1		;address
	db	$0a9		;lda
	dw	(\2)&WM-1	;#amount(\3)-1
	db	$0a2		;ldx
	dw	(\1)&WM		;#original
	db	$0a0		;ldy
	dw	(\1)&WM+1	;#terminal	
	db	54h		;mvn opecode
	db	(\1)>>16	;terminal data bank resister
	db	(\1)>>16	;original data bank resister
	db 	$28	      	;plp
	db	$0ab		;plb
	endm
;
;**************************************************************


;		INTERRUPT SOUND EFFECT


;**************************************************************


se_cutall		macro
	lda	#1fh
	jsl	call_sound1
		endm

se_cut0		macro
	lda	#0eh
	jsl	call_sound1
		endm
se_cut1		macro
	lda	#0dh
	jsl	call_sound1
		endm
se_cut2		macro
	lda	#0ch
	jsl	call_sound1
		endm
se_cut3		macro
	lda	#0bh
	jsl	call_sound1
		endm
se_cut4		macro
	lda	#0ah
	jsl	call_sound1
		endm
se_cut5		macro
	lda	#09h
	jsl	call_sound1
		endm
se_cut6		macro
	lda	#08h
	jsl	call_sound1
		endm
se_cut7		macro
	lda	#07h
	jsl	call_sound1
		endm

;---------------------------------------------------------------
se_null0	macro
	lda	#00
	jsl	call_sound0
		endm
se_null1	macro
	lda	#00
	jsl	call_sound1
		endm

;**************************************************************


;		BACK GROUND MUSIC


;**************************************************************


se_starttitle	macro
	lda	#01h
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_startrace	macro
	lda	#02h
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_gameoverbgm	macro
	lda	#04h
	jsl	call_sound0
		endm
;---------------------------------------------------------------

se_stopbgm	macro
	lda	#01h
	jsl	call_sound1
		endm
;---------------------------------------------------------------
se_interruptbgm	macro
	lda	#02h
	jsl	call_sound1
		endm
;---------------------------------------------------------------
se_restartbgm	macro
	lda	#03h
	jsl	call_sound1
		endm
;---------------------------------------------------------------
se_fadeoutbgm	macro
	lda	#04h
	jsl	call_sound1
	endm
;---------------------------------------------------------------
se_startingbgm	macro
	lda	#05h
	jsl	call_sound0
	endm
;---------------------------------------------------------------
se_resetsound	macro
	lda	#06h
	jsl	call_sound1
	endm
;---------------------------------------------------------------
se_goalinbgm	macro
	lda	#03h
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_gameoverbgm	macro
	lda	#04h
	jsl	call_sound0
		endm

;**************************************************************


;		ENGINE SOUND EFFECTS	


;**************************************************************	


nomalengine	equ	16h
coreengine	equ	18h
tunnelengine	equ	17h



se_startengine	macro
	lda	#16h
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_normalengine	macro
	jsl	nomal_engine_call
		endm
;---------------------------------------------------------------
se_tunnelengine	macro
	jsl	tunnel_engine_call
		endm
;---------------------------------------------------------------
se_coreengine	macro
	jsl	core_engine_call
		endm
;---------------------------------------------------------------
se_endengine	macro
	lda	#07h
	jsl	call_sound1
	lda	#08h
	jsl	call_sound1
		endm
;---------------------------------------------------------------
se_accelon	macro
	lda	#0fh
	jsl	call_sound1
		endm
;---------------------------------------------------------------
se_acceloff	macro
	lda	#10h
	jsl	call_sound1
		endm
;---------------------------------------------------------------
se_enemyengine	macro
	lda	#19h
	jsl	call_sound0
		endm
;**************************************************************


;	TRIGGER SOUND EFFECTS


;**************************************************************

se_hanging	macro
	lda	#06h
	jsl	call_sound0
		endm
se_endhanging	macro
		se_cut4
		endm
;---------------------------------------------------------------
se_opening	macro
	lda	#07h
	jsl	call_sound0
		endm
;---------------------------------------------------------------

brake_sound	equ	08h

se_brake	macro
	jsl	brake_on
		endm
se_endbrake	macro
		brake_off
		endm
;---------------------------------------------------------------
se_landing	macro
	lda	#0ah
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_explosion 	macro
	lda	#0ch
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_bump	 	macro
	lda	#0bh
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_backturn	macro
	lda	#15h
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_shout	macro
	lda	#17h
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_goalin	MACRO
	lda	#1ah
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_checkline	macro
	lda	#1bh
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_redsignal	macro
	lda	#1ch
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_greensignal	macro
	lda	#1dh
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_laptimedisp	macro
	lda	#1eh
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_gameoverdisp	macro
	lda	#1fh
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_lastexplosion	macro
	lda	#20h
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_gateopen	macro
	lda	#21h
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_bumpwood	macro
	lda	#22h
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_outofroadcount	macro
	lda	#23h
	jsl	call_sound0
		endm
;---------------------------------------------------------------
se_liftcar	macro
	lda	#24h
	jsl	call_sound0
	     	endm
;---------------------------------------------------------------
se_threecount	macro
	lda	#25h
	jsl	call_sound0
	     	endm
;---------------------------------------------------------------
se_mimijump	macro
	lda	#28h	
	jsl	call_sound0
		endm
;---------------------------------------------------------------

dart_sound	equ	29h


se_dartstart	macro
	jsl	dart_on
		endm
se_dartend	macro
	lda	#09h
	jsl	call_sound1
		endm
;---------------------------------------------------------------
se_rebirth 	macro
	lda	#2ch
	jsl	call_sound0
		endm
se_rebirth1 	macro
	lda	#2ch
	jsl	call_sound0
		endm
se_rebirth2 	macro
	lda	#2dh
	jsl	call_sound0
		endm
se_stick1	macro
	lda	#2eh
	jsl	call_sound0
		endm
se_stick2	macro
	lda	#2fh
	jsl	call_sound0
		endm
;---------------------------------------------------------------

skid0		equ	00
skid1		equ	33h
skid2		equ	32h
skid3		equ	31h
skid4		equ	30h


se_skidlevel1	macro
	jsl	call_skid01
		endm
se_skidlevel2	macro
	jsl	call_skid02
		endm
se_skidlevel3	macro
	jsl	call_skid03
		endm
se_skidlevel4	macro
	jsl	call_skid04
		endm
se_skidend	macro
	jsl	call_skidend
		endm
;---------------------------------------------------------------
se_whistle	macro
	lda	#34h
	jsl	call_sound0
		endm
