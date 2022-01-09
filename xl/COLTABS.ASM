
	incpublics	coltabs.ext


;Colour tables ----------------------------------------------------

HYPER_C
	COLNORM	14,14
	COLNORM	4,4
	COLNORM	7,7
	COLNORM	8,8


WHITE_C
	rept	100
	COLNORM	$20
	endr
	COLANIM	ca_2
	


BLACK_C
	rept	64
	COLNORM	9,9
	endr	
RED_C
	rept	110
	COLNORM	4,4
	endr	
;;

BLUE1_C
;	rept	110
;	COLNORM	7,7
;	endr

BLUE2_C
;	rept	110
;	COLNORM	6,6
;	endr


BLUE3_C
;	rept	110
;	COLNORM	5,5
;	endr

DEFAULT_C
	COLLITE	4,4	;0
	COLLITE	1,1	;1
	COLLITE	2,2	;2
	COLLITE	3,3	;3
	COLLITE	4,4	;4
	COLLITE	5,5	;5
	COLLITE	6,6	;6
	COLLITE	7,7	;7
	COLLITE	8,8	;8
	COLLITE	9,9	;9
	COLLITE	10,10	;10
	COLLITE	11,11	;11
	COLLITE	0,0	;12
	COLLITE	1,1	;13
	COLLITE	2,2	;14
	COLLITE	3,3	;15
	COLLITE	4,4	;16
	COLLITE	5,5	;17
	COLLITE	6,6	;18
	COLLITE	7,7	;19
	COLANIM	DEFAULT_A1	;20
	COLLITE	9,9	;21
	COLLITE	10,10	;22
	COLLITE	11,11	;23
;	COLTEXT	LASER1_SPR	;24
	COLANIM	DEFAULT_A1	;25
DEFAULT_A1
	db	4
	COLNORM	1,1	;1
	COLNORM	2,2	;2
	COLNORM	3,3	;3
	COLNORM	4,4	;4




TEXTURES_C
	IFEQ	1
;	COLTEXT	EXPL1_SPR		; 0
;	COLTEXT	EXPL2_SPR		; 1
;	COLTEXT	EXPL3_SPR		; 2
;	COLTEXT	EXPL4_SPR		; 3
;	COLTEXT	EXPL5_SPR		; 4
;	COLTEXT	EXPL6_SPR		; 5
;	COLTEXT	EXPL7_SPR		; 6
;	COLTEXT	EXPL8_SPR		; 7
;	COLTEXT	EXPL9_SPR		; 8
;	COLTEXT	EXPL10_SPR	; 9

	COLTEXT	SPARK1_SPR	; 10
	COLTEXT	SPARK2_SPR	; 11
	COLTEXT	STARWARS1_SPR	; 12
	COLTEXT	STARWARS2_SPR	; 13
	COLTEXT	STARWARS3_SPR	; 14
	COLTEXT	SPARK3_SPR	; 15

	COLTEXT	STARWARS1_SPR	; 16
	COLTEXT	STARWARS2_SPR	; 17

;	COLTEXT	LASER1_SPR	; 18
;	COLTEXT	LASER2_SPR	; 19

;	COLTEXT	SMOKE1_SPR	; 20
;	COLTEXT	SMOKE2_SPR	; 21
;	COLTEXT	SMOKE3_SPR	; 22

	COLTEXT	ricecrispies1_SPR		; 24

	ENDC

	IFEQ	1

AN_RAD_LAMP
	COLNORM	$1,$A
	COLNORM	$0,$1
	COLNORM	$1,$2
	COLNORM	$2,$2
AN_YELLOW_LAMP
	COLNORM	8,9
	COLNORM	8,$A
	COLNORM	8,$B
	COLNORM	8,$8
AN_BLUE_LAMP
	COLNORM	4,9
	COLNORM	4,$A
	COLNORM	4,4
	COLNORM	5,5
	ENDC

ID_0_FC
	ifeq	1
	COLLITE	$0,$0
	COLLITE	$1,$1
	COLLITE	$2,$2
	COLLITE	$3,$3
	COLLITE	$4,$4
	COLLITE	$5,$5
	COLLITE	$6,$6
	COLLITE	$7,$7
	COLLITE	$8,$8
	COLLITE	$9,$9
	COLNORM	$9,$9
	COLNORM	$9,$a
	COLNORM	$a,$a
	COLNORM	$a,$b
	COLNORM	$b,$b
	COLNORM	$b,$c
	COLNORM	$c,$c
	COLNORM	$c,$d
	COLNORM	$d,$d
	COLNORM	$d,$e
	COLNORM	$e,$e
	COLNORM	$1,$1
	COLNORM	$1,$2
	COLNORM	$2,$2
	COLNORM	$2,$3
	COLNORM	$3,$3
	COLNORM	$3,$4
	COLNORM	$4,$4
	COLNORM	$5,$5
	COLNORM	$5,$6
	COLNORM	$6,$6
	COLNORM	$6,$7
	COLNORM	$7,$7
	COLNORM	$7,$8
	COLNORM	$8,$8
	COLNORM	$1,$6
	COLNORM	$2,$6
	COLNORM	$3,$6
	COLNORM	$4,$6
	COLNORM	$a,$f
	COLNORM	$f,$f
	COLNORM	$d,$f
	COLANIM	CA_0
	COLANIM	CA_1
	COLANIM	CA_2
	COLANIM	CA_3
	COLANIM	CA_4
	COLANIM	CA_5
	COLTEXT	asteroid1_spr
	endc

ID_0_C



	COLNONE 	0		; 00 
	COLLITE		0,0		; 01 
	COLLITE		1,1		; 02 
	COLLITE		2,2		; 03 
	COLLITE		3,3		; 04 
	COLLITE		4,4		; 05 
	COLLITE		5,5		; 06 
	COLLITE		6,6		; 07 
	COLLITE		7,7		; 08 
	COLLITE		8,8		; 09 
	COLLITE		9,9		; 10 
	COLLITE		10,10		; 11 
	COLLITE		11,11		; 12 
	COLLITE		12,12		; 13 
	COLLITE		13,13		; 14 
	COLLITE		14,14		; 15 
	COLNONE 	$00		; 16 
	COLNONE 	$00		; 17 
	COLNONE 	$00		; 18 
	COLNONE 	$00		; 19 
	COLNONE 	$00		; 20 
	COLNONE 	$00		; 21 
	COLNONE 	$00		; 22 
	COLNONE 	$00		; 23 
	COLNONE 	$00		; 24 
	COLNONE 	$00		; 25 
	COLNONE 	$00		; 26 
	COLNONE 	$00		; 27 
	COLNONE 	$00		; 28 
	COLNONE 	$00		; 29 
	COLNONE 	$00		; 30 
	COLNONE 	$00		; 31 

	COLDEPTH	$00		; 32 
	COLDEPTH	$01		; 33 
	COLDEPTH	$02		; 34 
	COLDEPTH	$03		; 35 
	COLDEPTH	$04		; 36 
	COLDEPTH	$05		; 37 
	COLDEPTH	$06		; 38 
	COLDEPTH	$07		; 39 
	COLDEPTH	$08		; 40 
	COLDEPTH	$09		; 41 
	COLDEPTH	$0A		; 42 
	COLDEPTH	$0B		; 43 
	COLDEPTH	$0C		; 44 
	COLDEPTH	$0D		; 45 
	COLDEPTH	$0E		; 46 
	COLDEPTH	$0F		; 47 
	COLDEPTH	$10		; 48 
	COLDEPTH	$11		; 49 
	COLDEPTH	$12		; 50 
	COLDEPTH	$13		; 51 
	COLDEPTH	$14		; 52 
	COLDEPTH	$15		; 53 
	COLDEPTH	$16		; 54 
	COLDEPTH	$17		; 55 
	COLDEPTH	$18		; 56 
	COLDEPTH	$19		; 57 
	COLDEPTH	$1A		; 58 
	COLDEPTH	$1B		; 59 
	COLDEPTH	$1C		; 60 
	COLDEPTH	$1D		; 61 
	COLDEPTH	$1E		; 62 
	COLDEPTH	$1F		; 63 
	COLDEPTH	$20		; 64 
	COLDEPTH	$21		; 65 
	COLDEPTH	$22		; 66 
	COLDEPTH	$23		; 67 
	COLDEPTH	$24		; 68 
	COLDEPTH	$25		; 69 
	COLDEPTH	$26		; 70 
	COLDEPTH	$27		; 71 
	COLDEPTH	$28		; 72 
	COLDEPTH	$29		; 73 
	COLDEPTH	$2A		; 74 
	COLDEPTH	$2B		; 75 
	COLDEPTH	$2C		; 76 
	COLDEPTH	$2D		; 77 
	COLDEPTH	$2E		; 78 
	COLDEPTH	$2F		; 79 
	COLDEPTH	$30		; 80 
	COLDEPTH	$31		; 81 
	COLDEPTH	$32		; 82 
	COLDEPTH	$33		; 83 
	COLDEPTH	$34		; 84 
	COLDEPTH	$35		; 85 
	COLDEPTH	$36		; 86 
	COLDEPTH	$37		; 87 
	COLDEPTH	$38		; 88 
	COLDEPTH	$39		; 89 
	COLDEPTH	$3A		; 90 
	COLDEPTH	$3B		; 91 
	COLDEPTH	$3C		; 92 
	COLDEPTH	$3D		; 93 
	COLDEPTH	$3E		; 94 
	COLDEPTH	$3F		; 95 
	COLDEPTH	$40		; 96 
	COLDEPTH	$41		; 97 
	COLDEPTH	$42		; 98 
	COLDEPTH	$43		; 99 
	COLDEPTH	$44		; 100 
	COLDEPTH	$45		; 101 
	COLDEPTH	$46		; 102 
	COLDEPTH	$47		; 103 
	COLDEPTH	$48		; 104 
	COLDEPTH	$49		; 105 
	COLDEPTH	$4A		; 106 
	COLDEPTH	$4B		; 107 
	COLDEPTH	$4C		; 108 
	COLDEPTH	$4D		; 109 
	COLDEPTH	$4E		; 110 
	COLDEPTH	$4F		; 111 
	COLDEPTH	$50		; 112 
	COLDEPTH	$51		; 113 
	COLDEPTH	$52		; 114 
	COLDEPTH	$53		; 115 
	COLDEPTH	$54		; 116 
	COLDEPTH	$55		; 117 
	COLDEPTH	$56		; 118 
	COLDEPTH	$57		; 119 
	COLDEPTH	$58		; 120 
	COLDEPTH	$59		; 121 
	COLDEPTH	$5A		; 122 
	COLDEPTH	$5B		; 123 
	COLDEPTH	$5C		; 124 
	COLDEPTH	$5D		; 125 
	COLDEPTH	$5E		; 126 
	COLDEPTH	$5F		; 127 
	COLDEPTH	$64		; 128 
	COLDEPTH	$65		; 129 
	COLDEPTH	$66		; 130 
	COLDEPTH	$67		; 131 
	COLDEPTH	$68		; 132 
	COLDEPTH	$69		; 133 
	COLDEPTH	$6A		; 134 
	COLDEPTH	$6B		; 135 
	COLDEPTH	$6C		; 136 
	COLDEPTH	$6D		; 137 
	COLDEPTH	$6E		; 138 
	COLDEPTH	$6F		; 139 
	COLNONE 	$00		; 140 
	COLNONE 	$00		; 141 
	COLNONE 	$00		; 142 
	COLNONE 	$00		; 143 
	COLNONE 	$00		; 144 
	COLNONE 	$00		; 145 
	COLNONE 	$00		; 146 
	COLNONE 	$00		; 147 
	COLNONE 	$00		; 148 
	COLNONE 	$00		; 149 
	COLNONE 	$00		; 150 
	COLNONE 	$00		; 151 
	COLNONE 	$00		; 152 
	COLNONE 	$00		; 153 
	COLNONE 	$00		; 154 
	COLNONE 	$00		; 155 
	COLNONE 	$00		; 156 
	COLNONE 	$00		; 157 
	COLNONE 	$00		; 158 
	COLNONE 	$00		; 159 
	COLANIM 	CA_00		; 160 
	COLANIM 	CA_01		; 161 
	COLANIM 	CA_02		; 162 
	COLANIM 	CA_03		; 163 
	COLANIM 	CA_04		; 164 
	COLANIM 	CA_05		; 165 
	COLANIM 	CA_06		; 166 
	COLANIM 	CA_07		; 167 
	COLDEPTH	$60		; 168 
	COLDEPTH	$62		; 169 
	COLDEPTH	$63		; 170 
	COLDEPTH	$61		; 171 

	COLTEXT		num1_spr,8	; 172
	COLTEXT		num2_spr,8	; 173
	COLTEXT		num3_spr,8	; 174
	COLTEXT		num4_spr,8	; 175
	COLTEXT		stripe_spr	; 176
	COLANIM		numbers_a1	; 177

	COLTEXT		uturn_spr	; 178
	COLTEXT		turnright_spr	; 179
	COLTEXT		superfx_spr,8	; 180
	COLTEXT		turnright_spr,8	; 181
	COLTEXT		uturn_spr,8	; 182
	COLTEXT		sqturn_spr	; 183
	COLTEXT		sqturn_spr,8	; 184
	COLTEXT		rightbend_spr	; 185
	COLTEXT		rightbend_spr,8	; 186
	COLTEXT		bumpy_spr	; 187
	COLTEXT		grill1_spr,8	; 188


	ifeq	1
	COLNONE 	$00		; 00 
	COLLITE		$00,$0		; 01 
	COLLITE		$01,$1		; 02 
	COLLITE		$02,$2		; 03 
	COLLITE		$03,$3		; 04 
	COLLITE		$04,$4		; 05 
	COLLITE		$05,$5		; 06 
	COLLITE		$06,$6		; 07 
	COLLITE		$07,$7		; 08 
	COLLITE		$08,$8		; 09 
	COLLITE		$09,$9		; 10 
	COLLITE		10,10		; 11 
	COLLITE		11,11		; 12 
	COLLITE		12,12		; 13 
	COLLITE		13,13		; 14 
	COLLITE		14,14		; 15 
	COLNONE 	$00		; 16 
	COLNONE 	$00		; 17 
	COLNONE 	$00		; 18 
	COLNONE 	$00		; 19 
	COLNONE 	$00		; 20 
	COLNONE 	$00		; 21 
	COLNONE 	$00		; 22 
	COLNONE 	$00		; 23 
	COLNONE 	$00		; 24 
	COLNONE 	$00		; 25 
	COLNONE 	$00		; 26 
	COLNONE 	$00		; 27 
	COLNONE 	$00		; 28 
	COLNONE 	$00		; 29 
	COLNONE 	$00		; 30 
	COLNONE 	$00		; 31 

	COLDEPTH	$00		; 32 
	COLDEPTH	$01		; 33 
	COLDEPTH	$02		; 34 
	COLDEPTH	$03		; 35 
	COLDEPTH	$04		; 36 
	COLDEPTH	$05		; 37 
	COLDEPTH	$06		; 38 
	COLDEPTH	$07		; 39 
	COLDEPTH	$08		; 40 
	COLDEPTH	$09		; 41 
	COLDEPTH	$0A		; 42 
	COLDEPTH	$0B		; 43 
	COLDEPTH	$0C		; 44 
	COLDEPTH	$0D		; 45 
	COLDEPTH	$0E		; 46 
	COLDEPTH	$0F		; 47 
	COLDEPTH	$10		; 48 
	COLDEPTH	$11		; 49 
	COLDEPTH	$12		; 50 
	COLDEPTH	$13		; 51 
	COLDEPTH	$14		; 52 
	COLDEPTH	$15		; 53 
	COLDEPTH	$16		; 54 
	COLDEPTH	$17		; 55 
	COLDEPTH	$18		; 56 
	COLDEPTH	$19		; 57 
	COLDEPTH	$1A		; 58 
	COLDEPTH	$1B		; 59 
	COLDEPTH	$1C		; 60 
	COLDEPTH	$1D		; 61 
	COLDEPTH	$1E		; 62 
	COLDEPTH	$1F		; 63 
	COLDEPTH	$20		; 64 
	COLDEPTH	$21		; 65 
	COLDEPTH	$22		; 66 
	COLDEPTH	$23		; 67 
	COLDEPTH	$24		; 68 
	COLDEPTH	$25		; 69 
	COLDEPTH	$26		; 70 
	COLDEPTH	$27		; 71 
	COLDEPTH	$28		; 72 
	COLDEPTH	$29		; 73 
	COLDEPTH	$2A		; 74 
	COLDEPTH	$2B		; 75 
	COLDEPTH	$2C		; 76 
	COLDEPTH	$2D		; 77 
	COLDEPTH	$2E		; 78 
	COLDEPTH	$2F		; 79 
	COLDEPTH	$30		; 80 
	COLDEPTH	$31		; 81 
	COLDEPTH	$32		; 82 
	COLDEPTH	$33		; 83 
	COLDEPTH	$34		; 84 
	COLDEPTH	$35		; 85 
	COLDEPTH	$36		; 86 
	COLDEPTH	$37		; 87 
	COLDEPTH	$38		; 88 
	COLDEPTH	$39		; 89 
	COLDEPTH	$3A		; 90 
	COLDEPTH	$3B		; 91 
	COLDEPTH	$3C		; 92 
	COLDEPTH	$3D		; 93 
	COLDEPTH	$3E		; 94 
	COLDEPTH	$3F		; 95 
	COLDEPTH	$40		; 96 
	COLDEPTH	$41		; 97 
	COLDEPTH	$42		; 98 
	COLDEPTH	$43		; 99 
	COLDEPTH	$44		; 100 
	COLDEPTH	$45		; 101 
	COLDEPTH	$46		; 102 
	COLDEPTH	$47		; 103 
	COLDEPTH	$48		; 104 
	COLDEPTH	$49		; 105 
	COLDEPTH	$4A		; 106 
	COLDEPTH	$4B		; 107 
	COLDEPTH	$4C		; 108 
	COLDEPTH	$4D		; 109 
	COLDEPTH	$4E		; 110 
	COLDEPTH	$4F		; 111 
	COLDEPTH	$50		; 112 
	COLDEPTH	$51		; 113 
	COLDEPTH	$52		; 114 
	COLDEPTH	$53		; 115 
	COLDEPTH	$54		; 116 
	COLDEPTH	$55		; 117 
	COLDEPTH	$56		; 118 
	COLDEPTH	$57		; 119 
	COLDEPTH	$58		; 120 
	COLDEPTH	$59		; 121 
	COLDEPTH	$5A		; 122 
	COLDEPTH	$5B		; 123 
	COLDEPTH	$5C		; 124 
	COLDEPTH	$5D		; 125 
	COLDEPTH	$5E		; 126 
	COLDEPTH	$5F		; 127 
	COLNONE 	$00		; 128 
	COLNONE 	$00		; 129 
	COLNONE 	$00		; 130 
	COLNONE 	$00		; 131 
	COLNONE 	$00		; 132 
	COLNONE 	$00		; 133 
	COLNONE 	$00		; 134 
	COLNONE 	$00		; 135 
	COLNONE 	$00		; 136 
	COLNONE 	$00		; 137 
	COLNONE 	$00		; 138 
	COLNONE 	$00		; 139 
	COLNONE 	$00		; 140 
	COLNONE 	$00		; 141 
	COLNONE 	$00		; 142 
	COLNONE 	$00		; 143 
	COLNONE 	$00		; 144 
	COLNONE 	$00		; 145 
	COLNONE 	$00		; 146 
	COLNONE 	$00		; 147 
	COLNONE 	$00		; 148 
	COLNONE 	$00		; 149 
	COLNONE 	$00		; 150 
	COLNONE 	$00		; 151 
	COLNONE 	$00		; 152 
	COLNONE 	$00		; 153 
	COLNONE 	$00		; 154 
	COLNONE 	$00		; 155 
	COLNONE 	$00		; 156 
	COLNONE 	$00		; 157 
	COLNONE 	$00		; 158 
	COLNONE 	$00		; 159 
	COLANIM 	CA_00		; 160 
	COLANIM 	CA_01		; 161 
	COLANIM 	CA_02		; 162 
	COLANIM 	CA_03		; 163 
	COLANIM 	CA_04		; 164 
	COLANIM 	CA_05		; 165 
	COLANIM 	CA_06		; 166 
	COLANIM 	CA_07		; 167 
	COLANIM 	CA_08		; 168 
	COLANIM 	CA_09		; 169 
	COLANIM 	CA_0A		; 170 
	COLANIM 	CA_0B		; 171 
	endc
ID_1_C


	COLNONE 	0		; 00 
	COLLITE		0,0		; 01 
	COLLITE		1,1		; 02 
	COLLITE		2,2		; 03 
	COLLITE		3,3		; 04 
	COLLITE		4,4		; 05 
	COLLITE		5,5		; 06 
	COLLITE		6,6		; 07 
	COLLITE		7,7		; 08 
	COLLITE		8,8		; 09 
	COLLITE		9,9		; 10 
	COLLITE		10,10		; 11 
	COLLITE		11,11		; 12 
	COLLITE		12,12		; 13 
	COLLITE		13,13		; 14 
	COLLITE		14,14		; 15 
	COLNONE 	$00		; 16 
	COLNONE 	$00		; 17 
	COLNONE 	$00		; 18 
	COLNONE 	$00		; 19 
	COLNONE 	$00		; 20 
	COLNONE 	$00		; 21 
	COLNONE 	$00		; 22 
	COLNONE 	$00		; 23 
	COLNONE 	$00		; 24 
	COLNONE 	$00		; 25 
	COLNONE 	$00		; 26 
	COLNONE 	$00		; 27 
	COLNONE 	$00		; 28 
	COLNONE 	$00		; 29 
	COLNONE 	$00		; 30 
	COLNONE 	$00		; 31 

	COLDEPTH	$00		; 32 
	COLDEPTH	$01		; 33 
	COLDEPTH	$02		; 34 
	COLDEPTH	$03		; 35 
	COLDEPTH	$04		; 36 
	COLDEPTH	$05		; 37 
	COLDEPTH	$06		; 38 
	COLDEPTH	$07		; 39 
	COLDEPTH	$08		; 40 
	COLDEPTH	$09		; 41 
	COLDEPTH	$0A		; 42 
	COLDEPTH	$0B		; 43 
	COLDEPTH	$0C		; 44 
	COLDEPTH	$0D		; 45 
	COLDEPTH	$0E		; 46 
	COLDEPTH	$0F		; 47 
	COLDEPTH	$10		; 48 
	COLDEPTH	$11		; 49 
	COLDEPTH	$12		; 50 
	COLDEPTH	$13		; 51 
	COLDEPTH	$14		; 52 
	COLDEPTH	$15		; 53 
	COLDEPTH	$16		; 54 
	COLDEPTH	$17		; 55 
	COLDEPTH	$18		; 56 
	COLDEPTH	$19		; 57 
	COLDEPTH	$1A		; 58 
	COLDEPTH	$1B		; 59 
	COLDEPTH	$1C		; 60 
	COLDEPTH	$1D		; 61 
	COLDEPTH	$1E		; 62 
	COLDEPTH	$1F		; 63 
	COLDEPTH	$20		; 64 
	COLDEPTH	$21		; 65 
	COLDEPTH	$22		; 66 
	COLDEPTH	$23		; 67 
	COLDEPTH	$24		; 68 
	COLDEPTH	$25		; 69 
	COLDEPTH	$26		; 70 
	COLDEPTH	$27		; 71 
	COLDEPTH	$28		; 72 
	COLDEPTH	$29		; 73 
	COLDEPTH	$2A		; 74 
	COLDEPTH	$2B		; 75 
	COLDEPTH	$2C		; 76 
	COLDEPTH	$2D		; 77 
	COLDEPTH	$2E		; 78 
	COLDEPTH	$2F		; 79 
	COLDEPTH	$30		; 80 
	COLDEPTH	$31		; 81 
	COLDEPTH	$32		; 82 
	COLDEPTH	$33		; 83 
	COLDEPTH	$34		; 84 
	COLDEPTH	$35		; 85 
	COLDEPTH	$36		; 86 
	COLDEPTH	$37		; 87 
	COLDEPTH	$38		; 88 
	COLDEPTH	$39		; 89 
	COLDEPTH	$3A		; 90 
	COLDEPTH	$3B		; 91 
	COLDEPTH	$3C		; 92 
	COLDEPTH	$3D		; 93 
	COLDEPTH	$3E		; 94 
	COLDEPTH	$3F		; 95 
	COLDEPTH	$40		; 96 
	COLDEPTH	$41		; 97 
	COLDEPTH	$42		; 98 
	COLDEPTH	$43		; 99 
	COLDEPTH	$44		; 100 
	COLDEPTH	$45		; 101 
	COLDEPTH	$46		; 102 
	COLDEPTH	$47		; 103 
	COLDEPTH	$48		; 104 
	COLDEPTH	$49		; 105 
	COLDEPTH	$4A		; 106 
	COLDEPTH	$4B		; 107 
	COLDEPTH	$4C		; 108 
	COLDEPTH	$4D		; 109 
	COLDEPTH	$4E		; 110 
	COLDEPTH	$4F		; 111 
	COLDEPTH	$50		; 112 
	COLDEPTH	$51		; 113 
	COLDEPTH	$52		; 114 
	COLDEPTH	$53		; 115 
	COLDEPTH	$54		; 116 
	COLDEPTH	$55		; 117 
	COLDEPTH	$56		; 118 
	COLDEPTH	$57		; 119 
	COLDEPTH	$58		; 120 
	COLDEPTH	$59		; 121 
	COLDEPTH	$5A		; 122 
	COLDEPTH	$5B		; 123 
	COLDEPTH	$5C		; 124 
	COLDEPTH	$5D		; 125 
	COLDEPTH	$5E		; 126 
	COLDEPTH	$5F		; 127 
	COLDEPTH	$64		; 128 
	COLDEPTH	$65		; 129 
	COLDEPTH	$66		; 130 
	COLDEPTH	$67		; 131 
	COLDEPTH	$68		; 132 
	COLDEPTH	$69		; 133 
	COLDEPTH	$6A		; 134 
	COLDEPTH	$6B		; 135 
	COLDEPTH	$6C		; 136 
	COLDEPTH	$6D		; 137 
	COLDEPTH	$6E		; 138 
	COLDEPTH	$6F		; 139 
	COLNONE 	$00		; 140 
	COLNONE 	$00		; 141 
	COLNONE 	$00		; 142 
	COLNONE 	$00		; 143 
	COLNONE 	$00		; 144 
	COLNONE 	$00		; 145 
	COLNONE 	$00		; 146 
	COLNONE 	$00		; 147 
	COLNONE 	$00		; 148 
	COLNONE 	$00		; 149 
	COLNONE 	$00		; 150 
	COLNONE 	$00		; 151 
	COLNONE 	$00		; 152 
	COLNONE 	$00		; 153 
	COLNONE 	$00		; 154 
	COLNONE 	$00		; 155 
	COLNONE 	$00		; 156 
	COLNONE 	$00		; 157 
	COLNONE 	$00		; 158 
	COLNONE 	$00		; 159 
	COLANIM 	CA_00		; 160 
	COLANIM 	CA_01		; 161 
	COLANIM 	CA_02		; 162 
	COLANIM 	CA_03		; 163 
	COLANIM 	CA_04		; 164 
	COLANIM 	CA_05		; 165 
	COLANIM 	CA_06		; 166 
	COLANIM 	CA_07		; 167 
	COLDEPTH	$60		; 168 
	COLDEPTH	$63		; 169 
	COLDEPTH	$62		; 170 
	COLDEPTH	$61		; 171 

	COLTEXT		num1_spr,8	; 172
	COLTEXT		num2_spr,8	; 173
	COLTEXT		num3_spr,8	; 174
	COLTEXT		num4_spr,8	; 175
	COLTEXT		stripe_spr	; 176
	
	COLANIM		numbers_a1	; 177


ID_2_C
	COLLITE	$2,2
	COLLITE	$6,6
	COLLITE	$0,0
	COLLITE	$3,3
	COLLITE	$4,4
	COLLITE	$5,5
	COLLITE	$1,1
	COLLITE	$7,7
	COLLITE	$8,8
	COLLITE	$9,9
	COLDEPTH	$0
	COLDEPTH	$1
	COLDEPTH	$b
	COLDEPTH	$c
	COLDEPTH	$d
	COLDEPTH	$e
	COLDEPTH	$f
	COLDEPTH	$10
	COLDEPTH	$11
	COLDEPTH	$9
	COLDEPTH	$a
	COLDEPTH	$2
	COLDEPTH	$3
	COLDEPTH	$4
	COLDEPTH	$5
	COLDEPTH	$6
	COLDEPTH	$7
	COLDEPTH	$8
	COLDEPTH	$12
	COLDEPTH	$13
	COLDEPTH	$14
	COLDEPTH	$15
	COLDEPTH	$16
	COLDEPTH	$17
	COLDEPTH	$18
	COLDEPTH	$19
	COLDEPTH	$1a
	COLDEPTH	$1b
	COLDEPTH	$1c
	COLDEPTH	$1d
	COLDEPTH	$1e
	COLDEPTH	$1f
	COLANIM	CA_0
	COLANIM	CA_1
	COLANIM	CA_2
	COLANIM	CA_3
	COLANIM	CA_4
	COLANIM	CA_5

ID_3_C
	COLLITE	$3,$3
	COLLITE	$7,$7
	COLLITE	$2,$2
	COLLITE	$0,$0
	COLLITE	$4,$4
	COLLITE	$5,$5
	COLLITE	$6,$6
	COLLITE	$1,$1
	COLLITE	$8,$8
	COLLITE	$9,$9
	COLDEPTH	$0
	COLDEPTH	$1
	COLDEPTH	$12
	COLDEPTH	$13
	COLDEPTH	$14
	COLDEPTH	$15
	COLDEPTH	$16
	COLDEPTH	$17
	COLDEPTH	$18
	COLDEPTH	$9
	COLDEPTH	$a
	COLDEPTH	$b
	COLDEPTH	$c
	COLDEPTH	$d
	COLDEPTH	$e
	COLDEPTH	$f
	COLDEPTH	$10
	COLDEPTH	$11
	COLDEPTH	$2
	COLDEPTH	$3
	COLDEPTH	$4
	COLDEPTH	$5
	COLDEPTH	$6
	COLDEPTH	$7
	COLDEPTH	$8
	COLDEPTH	$19
	COLDEPTH	$1a
	COLDEPTH	$1b
	COLDEPTH	$1c
	COLDEPTH	$1d
	COLDEPTH	$1e
	COLDEPTH	$1f
	COLANIM	CA_0
	COLANIM	CA_1
	COLANIM	CA_2
	COLANIM	CA_3
	COLANIM	CA_4
	COLANIM	CA_5

ID_4_C
	ifeq	1
	COLLITE	$0,0
	COLLITE	$1,1
	COLLITE	$0,0
	COLLITE	$3,3
	COLLITE	$4,4
	COLLITE	$5,5
	COLLITE	$1,1
	COLLITE	$7,7
	COLLITE	$8,8
	COLLITE	$9,9
	COLDEPTH	$0
	COLDEPTH	$1
	COLDEPTH	$2
	COLDEPTH	$3
	COLDEPTH	$4
	COLDEPTH	$5
	COLDEPTH	$6
	COLDEPTH	$7
	COLDEPTH	$8
	COLDEPTH	$9
	COLDEPTH	$a
	COLDEPTH	$0
	COLDEPTH	$1
	COLDEPTH	$2
	COLDEPTH	$3
	COLDEPTH	$4
	COLDEPTH	$5
	COLDEPTH	$6
	COLDEPTH	$12
	COLDEPTH	$13
	COLDEPTH	$14
	COLDEPTH	$15
	COLDEPTH	$16
	COLDEPTH	$17
	COLDEPTH	$18
	COLDEPTH	$19
	COLDEPTH	$1a
	COLDEPTH	$1b
	COLDEPTH	$1c
	COLDEPTH	$1d
	COLDEPTH	$1e
	COLDEPTH	$1f
	COLANIM	CA_0
	COLANIM	CA_1
	COLANIM	CA_2
	COLANIM	CA_3
	COLANIM	CA_4
	COLANIM	CA_5
	endc
ID_5_C

	COLLITE	$0,$0
	COLLITE	$1,$1
	COLLITE	$2,$2
	COLLITE	$0,$0
	COLLITE	$4,$4
	COLLITE	$5,$5
	COLLITE	$6,$6
	COLLITE	$1,$1
	COLLITE	$8,$8
	COLLITE	$9,$9
	COLDEPTH	$0
	COLDEPTH	$1
	COLDEPTH	$2
	COLDEPTH	$3
	COLDEPTH	$4
	COLDEPTH	$5
	COLDEPTH	$6
	COLDEPTH	$7
	COLDEPTH	$8
	COLDEPTH	$9
	COLDEPTH	$a
	COLDEPTH	$b
	COLDEPTH	$c
	COLDEPTH	$d
	COLDEPTH	$e
	COLDEPTH	$f
	COLDEPTH	$10
	COLDEPTH	$11
	COLDEPTH	$0
	COLDEPTH	$1
	COLDEPTH	$2
	COLDEPTH	$3
	COLDEPTH	$4
	COLDEPTH	$5
	COLDEPTH	$6
	COLDEPTH	$19
	COLDEPTH	$1a
	COLDEPTH	$1b
	COLDEPTH	$1c
	COLDEPTH	$1d
	COLDEPTH	$1e
	COLDEPTH	$1f
	COLANIM	CA_0
	COLANIM	CA_2
	COLANIM	CA_1
	COLANIM	CA_3
	COLANIM	CA_4
	COLANIM	CA_5


CA_00
	DB	4
	COLNORM	$4,$2
	COLNORM	$4,$3
	COLNORM	$4,$4
	COLNORM	$4,$5
CA_01
   	DB	4
	COLNORM	$5,$2
	COLNORM	$5,$3
	COLNORM	$5,$4
	COLNORM	$5,$5
CA_02
	DB	4
	COLNORM	$6,$2
	COLNORM	$6,$3
	COLNORM	$6,$4
	COLNORM	$6,$5
CA_03
	DB	4
	COLNORM	$7,$2
	COLNORM	$7,$3
	COLNORM	$7,$4
	COLNORM	$7,$5
CA_04
	DB	4
	COLNORM	$8,$2
	COLNORM	$8,$3
	COLNORM	$8,$4
	COLNORM	$8,$5
CA_05
	DB	4
	COLNORM	$9,$2
	COLNORM	$9,$3
	COLNORM	$9,$4
	COLNORM	$9,$5
CA_06
	DB	4
	COLNORM	$2,$0
	COLNORM	$2,$4
	COLNORM	$2,$8
	COLNORM	$2,$c
CA_07
	DB	4
	COLNORM	$4,$3
	COLNORM	$8,$3
	COLNORM	$6,$3
	COLNORM	$7,$3
CA_08
	DB	4
	COLNORM	$5,$0
	COLNORM	$4,$0
	COLNORM	$8,$0
	COLNORM	$7,$0
CA_09
	DB	8
	COLNORM	$47
	COLNORM	$46
	COLNORM	$45
   	COLNORM	$44

   	COLNORM	$43
   	COLNORM	$44
   	COLNORM	$45
   	COLNORM	$46

CA_0A
	DB	4
	COLNORM	$8,$7
	COLNORM	$8,$5
	COLNORM	$8,$4
	COLNORM	$8,$3
CA_0B
	DB	4
	COLNORM	$2,$f
	COLNORM	$6,$7
	COLNORM	$6,$5
	COLNORM	$6,$2





			;old 16 color version
CA_0
	DB	4
	COLNORM	$e,$e
	COLNORM	$7,$7
	COLNORM	$2,$2
	COLNORM	$f,$f
CA_1
	DB	4
	COLNORM	$4,$4
	COLNORM	$3,$3
	COLNORM	$2,$2
	COLNORM	$1,$1

CA_1d
	DB	4
	COLDEPTH	$11
	COLDEPTH	$1b
	COLDEPTH	$11
	COLDEPTH	$1b

CA_2
	DB	4
	COLNORM	$8,$8
	COLNORM	$7,$7
	COLNORM	$6,$6
	COLNORM	$5,$5
CA_3
	DB	4
	COLNORM	$e,$e
	COLNORM	$d,$d
	COLNORM	$c,$c
	COLNORM	$b,$b
CA_4	
	DB	4
	COLNORM	$4,$e
	COLNORM	$6,$8
	COLNORM	$2,$8
	COLNORM	$1,$3
CA_5	
	DB	4
	COLNORM	$0,$e
	COLNORM	$0,$7
	COLNORM	$0,$2
	COLNORM	$0,$f



PEXPLOD2S_C	COLTEXT	LARGEEXPL1_SPR,6
	COLANIM	PEXPLOD2S_A1

PEXPLOD2S_A1
	COLTEXT	LARGEEXPL1_SPR,6
	COLTEXT	LARGEEXPL2_SPR,6
	COLTEXT	LARGEEXPL1_SPR,6
	COLTEXT	LARGEEXPL2_SPR,6

SMOOTH_c
	IFEQ	1
	colsmooth	0,0
	colsmooth	1,1
	colsmooth	2,2
	colsmooth	3,3
	colsmooth	4,4
	colsmooth	5,5
	colsmooth	6,6
	colsmooth	7,7
	colsmooth	8,8
	colsmooth	9,9
	colsmooth	10,10
	colsmooth	11,11
	colsmooth	12,12
	colsmooth	13,13
	colsmooth	14,14
	colsmooth	15,15
	ENDC

cornflakes_c COLTEXT	ricecrispies1_spr
burnmark_c	COLTEXT	ricecrispies1_spr
;smoke_c	COLANIM	smoke_a1
spark_c	COLANIM	spark_a1
bouncyball_c	COLANIM	bouncyball_a1
explode_c	COLANIM	explode_a1
explode2_c	COLANIM	explode_a2
explode3_c	COLANIM	explode_a3
bullet_c	COLANIM	bullet_a1
Ebullet_c	COLANIM	Ebullet_a1
line_c	COLANIM	line_a1
asteroid_c	COLTEXT	asteroid1_spr
asteroid2_c	COLTEXT	asteroid2_spr
exitlight_c	COLANIM	exitlight_a1
splash_c	COLANIM	splash_a1
starwars_c	COLANIM	starwars_a1
egg_c	COLTEXT	egg_Spr
specialweapon_c
	COLANIM	specialweapon_a1
lfdie_c	COLANIM	lfdie_a1
ballandchain_c
	COLTEXT	ball_spr
fire_c	COLANIM	fire_a1
ringlaser_c	COLANIM	ring_a6

ironball_c	COLTEXT	ironball_spr
fireball_c	COLANIM	fireball_a1
ovalbeam_c	COLANIM	ovalbeam_a1
boost_c	COLANIM	boost_a1
teleport_c	COLTEXT	planetc_spr
bonfire_c	COLANIM	bonfire_a1
	COLTEXT	space3_spr

bonfire_a1	db	2
	COLTEXT	largeexpl3_spr,6
	COLTEXT	largeexpl4_spr,6

break_meteor_c
	COLTEXT	asteroid3_spr
scrapmetal_c	COLTEXT	scrapmetal_spr

androssl3_c	
	COLTEXT	bigandross_spr,6
	COLANIM	androssl3c_a1

androssl3c_a1	db	4
	COLLITE	$0,0		; grey
	COLLITE	$7,7		; blue
	COLLITE	$6,6		; red

andross_c	
	COLTEXT	bigandross_spr,6
	COLTEXT	bigandross_spr,6
;	COLANIM	andross_a1
;	COLANIM	andross_a1

finalboss_c	COLANIM	finalbossc0_a1
	COLANIM	finalbossc1_a1
	COLANIM	finalbossc2_a1
	COLANIM	finalbossc3_a1
	COLANIM	finalbossc4_a1
	COLANIM	finalbossc5_a1
	COLANIM	finalbossc6_a1
	COLANIM	finalbossc7_a1


neonsign_a1	db	4
	COLTEXT	starwars1_spr
	COLTEXT	starwars2_spr
	COLTEXT	starwars3_spr
	COLTEXT	starwars3_spr



;andross_a1	db	4
;	COLTEXT	monkey1_spr
;	COLTEXT	monkey2_spr
;	COLTEXT	monkey3_spr
;	COLTEXT	monkey2_spr


playerbeam_a1	db	2
	COLNORM	$e,$e
	COLNORM	$7,$7


boost_a1	db	2

	COLTEXT	boost2_spr
	COLTEXT	laserfire2_spr


playerbeam_c	
	COLTEXT	scrapmetal_spr	; 67
;	COLTEXT	plasma1_spr


finalbossC0_a1	db	32
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$e
	COLNORM	$d,$e
	COLNORM	$d,$e
	COLNORM	$d,$e
	COLNORM	$d,$e
	COLNORM	$e,$e
	COLNORM	$e,$e
	COLNORM	$e,$e

	COLNORM	$e,$e
	COLNORM	$e,$e
	COLNORM	$e,$e
	COLNORM	$e,$e
	COLNORM	$e,$e
	COLNORM	$e,$e
	COLNORM	$e,$e
	COLNORM	$e,$e
	COLNORM	$e,$e
	COLNORM	$e,$e

finalbossC1_a1	db	32
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$d

	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$d

finalbossC2_a1	db	32
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$d,$d
	COLNORM	$c,$d
	COLNORM	$c,$d
	COLNORM	$d,$d
	COLNORM	$c,$d
	COLNORM	$c,$c
	COLNORM	$c,$c
	COLNORM	$c,$c

	COLNORM	$c,$c
	COLNORM	$c,$c
	COLNORM	$c,$c
	COLNORM	$c,$c
	COLNORM	$c,$c
	COLNORM	$c,$c
	COLNORM	$c,$c
	COLNORM	$c,$c
	COLNORM	$c,$c
	COLNORM	$c,$c

finalbossC3_a1	db	32
	COLNORM	$d,$d
	COLNORM	$c,$d
	COLNORM	$c,$d
	COLNORM	$c,$c
	COLNORM	$c,$c
	COLNORM	$b,$c
	COLNORM	$b,$c
	COLNORM	$b,$b
	COLNORM	$b,$b
	COLNORM	$b,$b

	COLNORM	$b,$b
	COLNORM	$b,$b
	COLNORM	$b,$b
	COLNORM	$b,$b
	COLNORM	$b,$b
	COLNORM	$b,$b
	COLNORM	$b,$b
	COLNORM	$b,$b
	COLNORM	$b,$b
	COLNORM	$b,$b

finalbossC4_a1	db	32
	COLNORM	$d,$d
	COLNORM	$c,$d
	COLNORM	$c,$d
	COLNORM	$c,$c
	COLNORM	$b,$c
	COLNORM	$b,$b
	COLNORM	$b,$b
	COLNORM	$a,$b
	COLNORM	$a,$b
	COLNORM	$a,$a

	COLNORM	$a,$a
	COLNORM	$a,$a
	COLNORM	$a,$a
	COLNORM	$a,$a
	COLNORM	$a,$a
	COLNORM	$a,$a
	COLNORM	$a,$a
	COLNORM	$a,$a
	COLNORM	$a,$a
	COLNORM	$a,$a

finalbossC5_a1	db	32
	COLNORM	$d,$d
	COLNORM	$c,$d
	COLNORM	$c,$c
	COLNORM	$b,$c
	COLNORM	$b,$b
	COLNORM	$a,$b
	COLNORM	$a,$a
	COLNORM	$9,$a
	COLNORM	$9,$a
	COLNORM	$9,$9

	COLNORM	$9,$9
	COLNORM	$9,$9
	COLNORM	$9,$9
	COLNORM	$9,$9
	COLNORM	$9,$9
	COLNORM	$9,$9
	COLNORM	$9,$9
	COLNORM	$9,$9
	COLNORM	$9,$9
	COLNORM	$9,$9

finalbossc6_a1			; left eye
	DB	32	
	COLNORM	$8,$8
	COLNORM	$7,$7
	COLNORM	$6,$6
	COLNORM	$5,$5
	COLNORM	$8,$8
	COLNORM	$7,$7
	COLNORM	$6,$6
	COLNORM	$5,$5
	COLNORM	$8,$8
	COLNORM	$7,$7	

	COLNORM	$5,$5	; 10	; both eyes OK
	COLNORM	$8,$8	; 11

	COLNORM	$9,$9	; 12	; left eye dead
	COLNORM	$9,$9	; 13

	COLNORM	$5,$5	; 14	; right eye dead
	COLNORM	$8,$8	; 15

	COLNORM	$9,$9	; 16	; both eyes dead
	COLNORM	$9,$9	; 17	; left red eye dead
	COLNORM	$2,$2	; 18	; right red eye dead 
	COLNORM	$2,$2	; 19	; both eyes red


finalbossc7_a1			; right eye
	DB	32	
	COLNORM	$8,$8
	COLNORM	$7,$7
	COLNORM	$6,$6
	COLNORM	$5,$5
	COLNORM	$8,$8
	COLNORM	$7,$7
	COLNORM	$6,$6
	COLNORM	$5,$5
	COLNORM	$8,$8
	COLNORM	$7,$7	

	COLNORM	$5,$5	; 10	; both eyes OK
	COLNORM	$8,$8	; 11

	COLNORM	$5,$5	; 12	; left eye dead
	COLNORM	$8,$8	; 13

	COLNORM	$9,$9	; 14	; right eye dead
	COLNORM	$9,$9	; 15

	COLNORM	$9,$9	; 16	; both eyes dead
	COLNORM	$2,$2	; 17	; left red eye dead
	COLNORM	$9,$9	; 18	; right red eye dead 
	COLNORM	$2,$2	; 19	; both eyes red





fireball_a1	db	4
	COLTEXT	fireball1_spr
	COLTEXT	fireball2_spr
	COLTEXT	fireball3_spr
	COLTEXT	fireball2_spr

ring_a1	db	4
	COLTEXT	ring2_spr
	COLTEXT	ring1_spr
	COLTEXT	ring1_spr
	COLTEXT	ring1_spr

ring_a2	db	4
	COLTEXT	ring1_spr
	COLTEXT	ring2_spr
	COLTEXT	ring1_spr
	COLTEXT	ring1_spr

ring_a3	db	4
	COLTEXT	ring1_spr
	COLTEXT	ring1_spr
	COLTEXT	ring2_spr
	COLTEXT	ring1_spr


ring_a4	db	4
	COLTEXT	ring1_spr
	COLTEXT	ring1_spr
	COLTEXT	ring1_spr
	COLTEXT	ring2_spr

ring_a5	db	2
	COLTEXT	ring2_spr
	COLTEXT	ring1_spr

ring_a6	db	8
	COLTEXT	ring1_spr
	COLTEXT	ring2_spr
	COLTEXT	ring1_spr
	COLTEXT	ring2_spr
	COLTEXT	ring1_spr
	COLTEXT	ring2_spr
	COLTEXT	ring1_spr
	COLTEXT	ring2_spr

;	COLTEXT	ring1_spr
;	COLTEXT	ring1_spr
;	COLTEXT	ring1_spr
;	COLTEXT	ring1_spr
;	COLTEXT	ring2_spr
;	COLTEXT	ring2_spr
;	COLTEXT	ring2_spr
;	COLTEXT	ring2_spr
fire_a1	db	8
	COLTEXT	largeexpl5_Spr,6
	COLTEXT	largeexpl4_Spr,6
	COLTEXT	largeexpl3_Spr,6
	COLTEXT	largeexpl3_Spr,6
	COLTEXT	largeexpl2_Spr,6
	COLTEXT	largeexpl2_Spr,6
	COLTEXT	largeexpl1_Spr,6
	COLTEXT	largeexpl1_Spr,6


roadflash_a1	db	2
	COLNORM	1,1
	COLNORM	3,3

LFDIE_A1	db	4
	COLTEXT	spark1_spr
	COLTEXT	spark2_spr
	COLTEXT	spark3_spr
	COLTEXT	spark2_spr


specialweapon_a1
	DB	8
	COLTEXT	specialweapon1_spr
	COLTEXT	specialweapon2_spr
	COLTEXT	specialweapon3_spr
	COLTEXT	specialweapon1_spr
	COLTEXT	specialweapon2_spr
	COLTEXT	specialweapon3_spr
	COLTEXT	specialweapon1_spr
	COLTEXT	specialweapon2_spr

gateflash_a1	db	16
	COLNORM	$8,$8
	COLNORM	$7,$7
	COLNORM	$6,$6
	COLNORM	$5,$5
	COLNORM	$4,$4
	COLNORM	$4,$4
	COLNORM	$3,$3
	COLNORM	$3,$3

	COLNORM	$2,$2
	COLNORM	$2,$2
	COLNORM	$1,$1
	COLNORM	$1,$1
	COLNORM	$1,$1
	COLNORM	$2,$2
	COLNORM	$3,$3
	COLNORM	$4,$4

bosshitcol1_a1
	DB	8		; 43
	COLNORM	$4,$4
	COLNORM	$3,$3
	COLNORM	$2,$2
	COLNORM	$1,$1
	COLDEPTH	$0	; 10

bosshitcol2_a1
	DB	8		; 43
	COLNORM	$4,$4
	COLNORM	$3,$3
	COLNORM	$2,$2
	COLNORM	$1,$1
	COLDEPTH	6	; 16

bosshitcol3_a1
	DB	8
	COLNORM	$8,$8
	COLNORM	$7,$7
	COLNORM	$6,$6
	COLNORM	$5,$5
	COLNORM	$4,$4
	COLNORM	$3,$3
	COLNORM	$2,$2
	COLNORM	$1,$1

pwireframe_a1
	DB	8
	COLNORM	$8,$8
	COLNORM	$7,$7
	COLNORM	$6,$6
	COLNORM	$5,$5

	COLDEPTH	29	



exitlight_a1	db	2
	COLNORM	4,4
	COLNORM	1,1

line_a1	db	8
	COLNORM	14,14
	COLNORM	13,13
	COLNORM	12,12
	COLNORM	11,11
	COLNORM	10,10
	COLNORM	9,9
	COLNORM	9,9
	COLNORM	9,9

bullet_a1	db	8
	COLNORM	14,14
	COLNORM	8,8
	COLNORM	14,14
	COLNORM	7,7
	COLNORM	14,14
	COLNORM	8,8
	COLNORM	14,14
	COLNORM	6,6

Ebullet_a1	db	4
	COLNORM	$e,$e
	COLNORM	$3,$3
	COLNORM	$e,$e
	COLNORM	$4,$4

;	COLNORM	14,14
;	COLNORM	8,8
;	COLNORM	14,14
;	COLNORM	7,7
;	COLNORM	14,14
;	COLNORM	8,8
;	COLNORM	14,14
;	COLNORM	6,6

bouncyball_a1
	db	2
	COLTEXT	plasma1_spr
	COLTEXT	plasma2_spr
;	COLTEXT	plasma1_spr
;	COLTEXT	largeexpl1_spr,6

;smoke_a1	db	8
;	COLTEXT	largeexpl1_spr,6
;	COLTEXT	expl9_spr
;	COLTEXT	smoke1_spr
;	COLTEXT	smoke2_spr
;	COLTEXT	smoke3_spr
;	COLTEXT	smoke4_spr
;	COLTEXT	smoke5_spr
;	COLTEXT	smoke6_spr

spark_a1	db	4
	COLTEXT	spark1_spr
	COLTEXT	spark2_spr
	COLTEXT	spark3_spr
	COLTEXT	spark2_spr

starwars_a1	db	4
	COLTEXT	starwars1_spr
	COLTEXT	starwars2_spr
	COLTEXT	starwars3_spr
	COLTEXT	starwars2_spr

explode_a1	db	4
	COLTEXT	largeexpl1_spr,6
	COLTEXT	largeexpl2_spr,6
	COLTEXT	expl9_spr
	COLTEXT	expl10_spr

explode_a2	db	8
	COLTEXT	largeexpl1_spr,6
	COLTEXT	largeexpl2_spr,6
	COLTEXT	largeexpl3_spr,6
	COLTEXT	largeexpl6_spr,6
	COLTEXT	largeexpl7_spr,6
	COLTEXT	largeexpl8_spr,6
	COLTEXT	largeexpl8_spr,6
	COLTEXT	largeexpl8_spr,6

explode_a3	db	8
	COLTEXT	largeexpl1_spr,6
	COLTEXT	largeexpl2_spr,6
	COLTEXT	largeexpl3_spr,6
	COLTEXT	largeexpl4_spr,6
	COLTEXT	largeexpl5_spr,6
	COLTEXT	largeexpl6_spr,6
	COLTEXT	largeexpl7_spr,6
	COLTEXT	largeexpl8_spr,6

arrow_a1	db	8
	COLNORM	6,6
	COLNORM	6,6
	COLNORM	14,14
	COLNORM	14,14
	COLNORM	3,3
	COLNORM	3,3
	COLNORM	1,1
	COLNORM	1,1

normal_c
	COLNORM	0,0
	COLNORM	1,1
	COLNORM	2,2
	COLNORM	3,3
	COLNORM	4,4
	COLNORM	5,5
	COLNORM	6,6
	COLNORM	7,7
	COLNORM	8,8
	COLNORM	9,9
	COLNORM	10,10
	COLNORM	11,11
	COLNORM	12,12
	COLNORM	13,13
	COLNORM	14,14
	COLNORM	15,15
	COLANIM	arrow_a1
	COLTEXT	panel3_spr
	COLTEXT	panel3_spr


britenormal_c
	COLNORM	0,0
	COLNORM	1,1
	COLNORM	2,2
	COLNORM	3,3
	COLNORM	4,4
	COLNORM	5,5
	COLNORM	6,6
	COLNORM	7,7
	COLNORM	8,8
	COLNORM	10,10
	COLNORM	11,11
	COLNORM	12,12
	COLNORM	13,13
	COLNORM	14,14
	COLNORM	14,14
	COLNORM	15,15
	COLANIM	arrow_a1
	COLTEXT	panel3_spr
	COLTEXT	panel3_spr



splash_a1	db	8
	COLTEXT	splash1_spr
	COLTEXT	splash2_spr
	COLTEXT	splash3_spr
	COLTEXT	splash4_spr
	COLTEXT	splash5_spr
	COLTEXT	splash5_spr
	COLTEXT	splash6_spr
	COLTEXT	splash6_spr


flash_c	COLANIM	flash_a1
flash_A1	db	2
	COLTEXT	laserfire1_spr
	COLTEXT	laserfire2_spr



spacemistWhite_a1	db	8
	COLNORM	14,14
	COLNORM	13,13
	COLNORM	12,12
	COLNORM	11,11
	COLNORM	10,10
	COLNORM	9,10
	COLNORM	9,9
	COLNORM	9,9


spacemistRed_a1	db	8
	COLNORM	2,2
	COLNORM	2,2
	COLNORM	1,2
	COLNORM	1,2
	COLNORM	1,1
	COLNORM	1,1
	COLNORM	1,1
	COLNORM	1,1


spacemistLgrey_a1	db	8
	COLNORM	13,13
	COLNORM	12,12
	COLNORM	11,11
	COLNORM	10,10
	COLNORM	9,10
	COLNORM	9,9
	COLNORM	9,9
	COLNORM	9,9

brakelight_a1
	DB	2
	COLNORM	$9,$1
	COLNORM	$2,$2


ovalbeam_a1	db	4
	COLTEXT	oval1_spr
	COLTEXT	oval3_spr
	COLTEXT	oval2_spr
	COLTEXT	oval3_spr
;;;


numbers_a1
	db	4
	COLTEXT	num1_spr,8
	COLTEXT	num2_spr,8
	COLTEXT	num3_spr,8
	COLTEXT	num4_spr,8

treestump_c	
	COLTEXT	treestump_spr
treetop_c	
	COLTEXT	treetop_spr,6


smoke_c	
	COLANIM	smoke_a1

smoke_a1	db	8
	COLTEXT	smoke1_spr
	COLTEXT	smoke2_spr
	COLTEXT	smoke3_spr
	COLTEXT	smoke4_spr
	COLTEXT	smoke5_spr
	COLTEXT	smoke6_spr

eyes1_c
	COLANIM	eyes1_a1

eyes1_a1	db	16
	COLTEXT	eye1_spr,9
	COLTEXT	eye2_spr,9
	COLTEXT	eye3_spr,9
	COLTEXT	eye4_spr,9
	COLTEXT	eye5_spr,9
	COLTEXT	eye6_spr,9
	COLTEXT	eye7_spr,9
	COLTEXT	eye8_spr,9
	COLTEXT	eye9_spr,9
	COLTEXT	eye10_spr,9
	COLTEXT	eye11_spr,9
	COLTEXT	eye12_spr,9
	



whitepuff_c	
	COLANIM	whitepuff_a1

whitepuff_a1	db	4
	COLTEXT	whitepuff1_spr
	COLTEXT	whitepuff2_spr
	COLTEXT	whitepuff3_spr
	COLTEXT	whitepuff4_spr
brownpuff_c	
	COLANIM	brownpuff_a1

brownpuff_a1	db	4
	COLTEXT	brownpuff1_spr
	COLTEXT	brownpuff2_spr
	COLTEXT	brownpuff3_spr
	COLTEXT	brownpuff4_spr



whitetyres_c
	COLTEXT	whitetyres_spr
redtyres_c
	COLTEXT	redtyres_spr
bush1_c
	COLTEXT	bush1_spr


hand_c	
	COLANIM	hand_a1

hand_a1	db	4
	COLTEXT	hand1_spr
	COLTEXT	hand2_spr
	COLTEXT	hand3_spr



wheel1_c	
	COLANIM	wheel1_a1


wheelball_c	COLANIM	wheelball_a1
wheelball_a1	db	64
	REPT	64
;	COLTEXT	l1wheel1_spr
	ENDR

wheel1_a1	db	64
	coltext	wheel0_spr	; left 1
	coltext	wheel0_spr
	coltext	wheel1_spr
	coltext	wheel1_spr
	coltext	wheel2_spr
	coltext	wheel2_spr
	coltext	wheel3_spr
	coltext	wheel3_spr
	coltext	wheel4_spr
	coltext	wheel4_spr
	coltext	wheel5_spr
	coltext	wheel5_spr
	coltext	wheel6_spr
	coltext	wheel6_spr
	coltext	wheel7_spr
	coltext	wheel7_spr


	coltext	wheel7_spr	; right 1
	coltext	wheel7_spr
	coltext	wheel8_spr
	coltext	wheel8_spr
	coltext	wheel9_spr
	coltext	wheel9_spr
	coltext	wheela_spr
	coltext	wheela_spr
	coltext	wheelb_spr
	coltext	wheelb_spr
	coltext	wheelc_spr
	coltext	wheelc_spr
	coltext	wheeld_spr
	coltext	wheeld_spr
	coltext	wheel0_spr
	coltext	wheel0_spr


	coltext	wheele_spr	; left 2
	coltext	wheele_spr
	coltext	wheelf_spr
	coltext	wheelf_spr
	coltext	wheel10_spr
	coltext	wheel10_spr
	coltext	wheel11_spr
	coltext	wheel11_spr
	coltext	wheel12_spr
	coltext	wheel12_spr
	coltext	wheel13_spr
	coltext	wheel13_spr
	coltext	wheel14_spr
	coltext	wheel14_spr
	coltext	wheel15_spr
	coltext	wheel15_spr


	coltext	wheel15_spr	; right 2
	coltext	wheel15_spr
	coltext	wheel16_spr
	coltext	wheel16_spr
	coltext	wheel17_spr
	coltext	wheel17_spr
	coltext	wheel18_spr
	coltext	wheel18_spr
	coltext	wheel19_spr
	coltext	wheel19_spr
	coltext	wheel1a_spr
	coltext	wheel1a_spr
	coltext	wheel1b_spr
	coltext	wheel1b_spr
	coltext	wheele_spr
	coltext	wheele_spr





	incfile	defspr.asm

dbh	macro
	db	$\1,$\2,$\3,$\4,$\5,$\6,$\7,$\8
	endm

defshadestab	macro
	dw	shades\1_0&WM
	dw	shades\1_1&WM
	dw	shades\1_2&WM
	dw	shades\1_3&WM
	dw	shades\1_4&WM
	dw	shades\1_5&WM
	dw	shades\1_6&WM
	dw	shades\1_7&WM
	dw	shades\1_8&WM
	dw	shades\1_9&WM
	dw	shades\1_10&WM
	dw	shades\1_11&WM
	dw	shades\1_12&WM
	dw	shades\1_13&WM
	dw	shades\1_14&WM
	endm

paladdr

palwood
	rgbw	0,0,0
gs	=	1			; wood
	rept	7
	rgbw	gs,gs,0
	rgbw	gs/2,gs/2,0
gs	=	gs+4
	endr
	rgbw	31,31,0

;
;;3D light source dither palette
;;(1)
;	ifeq	0		; THE WINNER
;
;	rgbw	0,0,0
;
;	rgbw	26,3,0		; reds
;	rgbw	16,2,0
;	rgbw	8,1,0
;
;;	rgbw	8,8,0		; yellows
;	rgbw	18,16,0
;	rgbw	26,26,0
;
;	rgbw	6,20,0		; greens
;	rgbw	2,12,0
;;	rgbw	0,8,0
;
;	rgbw	0,10,26		; blues
;	rgbw	0,4,16
;	rgbw	0,0,8
;
;	rgbw	3,3,3		; greys
;	rgbw	6,6,6
;	rgbw	10,10,10
;	rgbw	14,14,14
;	rgbw	20,20,20
;
;	endc

;Nintendo 3d pal  -----------------------------------------------

	IFEQ	1
	rgbw	0,0,0
	rgbw	$14,0,0
	rgbw	$1c,4,4
	rgbw	$1f,$c,$c
	rgbw	$3,$9,$19
 	rgbw	$8,$e,$1e
	rgbw	$d,$13,$1f
	rgbw	$00,$1f,$6
	rgbw	$1f,$1f,$0a
	rgbw	4,4,4
	rgbw	9,9,9
	rgbw	$e,$e,$e
	rgbw	$14,$14,$14
	rgbw	$19,$19,$19
	rgbw	$1f,$1f,$1f
	rgbw	0,0,0
	ENDC

	defgamepal	norm,gfx\night.col
	defgamepal	red,gfx\red.col
	defgamepal	blue,gfx\blue.col


paladdrend

numpals	equ	(paladdrend-paladdr)>>5

shadestab2_0
	defshadestab	0
shadestab2_1
	defshadestab	1
shadestab2_2
	defshadestab	2
shadestab2_3
	defshadestab	3



depthtabs  
; the actual colour values for the depth tabs


	incfile	coltab.asm

	incfile	light.asm

;------------------------------------------------------
def_depthz	macro	[name,1,2,3,4]

	db	-{1}>>8,-{2}>>8,-{3}>>8,0
depth_{name}	=	dn
dn	=	dn+1
	endm

def_depthz_same	macro	[name,1]
	IFEQ	{1}-1
	db	-$40,-$50,-$50,0
	ELSEIF
	IFEQ	{1}-2
	db	0,-$40,-$50,0
	ELSEIF
	IFEQ	{1}-3
	db	0,0,-$40,0
	ELSEIF
	IFEQ	{1}-4
	db	0,0,0,0
	ELSEIF
	progress_off
	printf	"def_depthz_same.... values 1-4 only are accepted%n"
	progress_on
	ENDC
	ENDC
	ENDC
	ENDC

depth_{name}	=	dn
dn	=	dn+1

	endm

dn	=	0
;------------------------------------------------------

depthtables
; the actual z distance values for depths

	def_depthz_same	1,1
	def_depthz_same	2,2
	def_depthz_same	3,3
	def_depthz_same	4,4
	def_depthz	normal,($a00+$e00),($d00+$e00),($f00+$e00)
	def_depthz	tunnel,500,750,1000
	def_depthz	mist,500,750,1000
	def_depthz	stage1,$a00,$d00,$3f00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;









