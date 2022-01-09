;--------------------------------------------------------------------
;
;	Initialize Game Program for XL
;
;				programed by Masato Kimura
;
;				05/02/1993
;--------------------------------------------------------------------
;
;
	incpublics	xlstart.ext
;

;
	shorti
ProgramEntry
	sei				;IRQdisable
	rep	#%00001001		;set binary mode
	xce				;set native mode
;
;--------------------------------------------------------------------
;	Initiarize SFX
;--------------------------------------------------------------------

	ai8
	stz	$4200			;Disable NMI&IRQ
	stz	$420b			;Disable M-DMA
	stz	$420c			;Disable H-DMA
	lda	#%10000000
	sta	$2100			;Screen blanking!!
	stz	$2133			;set PPU mode
	stz	$4016			;for controller auto scan
;--------------------------------------------------------------------
	i16

;clear zero paze
	ldx	#2feh
Clear_zero_loop
	stz	0,x
	dex	
	bpl	Clear_zero_loop

	a16
	lda	#0000
	tcd				;set Direct resister
	lda	#$02ff
	tcs				;set Stack Pointer(2ffh)
	phk
	plb		;set data bank resister
;--------------------------------------------------------------------
;	Clear Work RAM		ZERO CLEAR!!
;--------------------------------------------------------------------
;
	a8i16
	lda	#00h
	ldx	#0300h
	ldy	#1d00h
	jsr	Clear_DRAM	;clear 000000-002000
	lda	#7eh
	ldx	#02000h
	ldy	#0e000h
	jsr	Clear_DRAM	;clear 7e2000-7ee000
	lda	#7fh
	ldx	#0000h
	ldy	#0ffffh
	jsr	Clear_DRAM	;clear 7f0000-7fffff
;
;	phb
;	ai16			;clear 700000-70ffff
;	lda	#00h
;	sta.l	700000h
;	lda	#07ffeh	;ffffh-01h
;	ldx	#00h  	;origin
;	ldy	#01h	;terminal
;;;;	mvn	#70h,#70h	;this assembler does'nt
; 				;support MVN command!!!!
;				
;	db	54h	;mvn opecode
;	db	70h	;terminal data bank resister
;	db	70h	;original data bank resister 
;	
;	plb
;
;
	clearram    700000h,2800h
;
;
;--------------------------------------------------------------------
;	initial APU
;--------------------------------------------------------------------


	jsl	apu_initialize


;--------------------------------------------------------------------
;	copy interrupt Vector to 101h
;--------------------------------------------------------------------
	ai16
 	ldx	#VectorDataEnd-VectorData-1
.SetVectorLoop
	lda.l	VectorData,x
	sta.l	$101,x
	dex
	bpl	.SetVectorLoop
;--------------------------------------------------------------------
;	transfer main program to RAM area 
;--------------------------------------------------------------------

	a8i16

;		ROM 28000h(length 8000h) >>>>>>>7e8000h!!!



Trans_28000_to_7e8000

;

	ldx	#$8000			;set DMA control & B bus addr
	stx	$4300			;4300h=DMA channel 00
;
	ldy	#xroutines&WM
	sty	$2181			;DRAM address	008000
	lda	#xroutines>>16
	sta	$2183			;DRAM bank	70
	
	stx	$4302			;Rom address	008000
	lda	#02
	sta	$4304			;ROM bank	02
;
	ldy	#xlen
	sty	4305h			;Trans 8000h
DMA_switch_ON
	lda	#00000001b
	sta	420bh			;turn on DMA ch.0 switch!!!
	
;--------------------------------------------------------------------


title_start    
	a8	
	phk
	plb
	stz	sound_selecter
	jsl	Title_sequence	;GOTO INITAL PROG!!!


game_start
	i16
	ldx	#2ffh
	txs
	ai8
	
;

	jsl	initialise_l ;(main.asm)

;
	
	jsl	intro_l  ;(endseq.asm)

;--------------------------------------------------------------------
Clear_DRAM
	shorta
	longi
;
;		entry	DRAM bank
;			DRAM Address
;			Trans data length
	stx	$2181
	sta	$2183
	sty	$4305
	
;
	ldx	#(WorkClearData)&WM
	stx	$4302			;set A bus address
	lda	#(WorkClearData)>>16
	sta	$4304			;set A bus bank 
	ldx	#$8008			;set DMA control & B bus addr
	stx	$4300			;4300h=DMA channel 00
	lda	#00000001b
	sta	420bh			;turn on DMA ch.0 switch!!!
	rts
;--------------------------------------------------------------------
VectorData
	nop		;101  brk
	nop		;102
	nop		;103
	nop		;104  cop
	nop		;105
	nop		;106
	nop		;107
	rti		;108 NMI
	nop		;108
	nop		;109
	nop		;10a
	nop		;10b
	jsl	irq_routin  ;10c!!!	
	rti

VectorDataEnd
;--------------------------------------------------------------------
WorkClearData
	dw	0000
;--------------------------------------------------------------------


