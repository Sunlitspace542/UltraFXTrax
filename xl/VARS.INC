fast21mhz	equ	1	;21mhz mode off/on (0/1)

cesdemo	equ	0	; 0 is normal, 1/2
debuginfo	equ	1	; full strategy debugging
debuginfo2	equ	1	; stage selection/ speed up mode
janglish	equ	0	; 0 = english, 1 = japanese
cestime	equ	5	; ces countdown (in minutes)


; angles
deg360	equ	256
deg180	equ	deg360/2
deg90	equ	deg360/4
deg45	equ	deg360/8
deg22	equ	deg360/16
deg11	equ	deg360/32
deg5	equ	deg360/64
deg270	equ	deg180+deg90
deg0	equ	0
deg120	equ	deg360/3
deg60	equ	deg120/2
deg240	equ	deg120*2
deg300	equ	deg240+deg60

deg135	equ	deg90+deg45
deg225	equ	deg180+deg45
deg315	equ	deg180+deg90+deg45

deg72	equ	deg360/5
deg144	equ	(deg360*2)/5
deg216	equ	(deg360*3)/5
deg288	equ	(deg360*4)/5


p_n	equ	10000000b
p_v	equ	01000000b
p_a	equ	00100000b
p_x	equ	00010000b
p_d	equ	00001000b
p_int	equ	00000100b
p_z	equ	00000010b
p_c	equ	00000001b

wallhgt	equ	120
walldist	equ	60+10

;ebugp	equ	0	; 0/1 off/on debug print carl 
;debugpete	equ	0	; 0/1 off/on debug print pete
;itlines	equ	0	; 0/1 off/on line bit flags
dma_clr_screen equ	1	; 0/1 off/on
mario_test	equ	0
mario_test1	equ	0
mario_board	equ	1
FastTrans	equ	0	; 0/1 0ff/on Fast transfer
;colours4	equ	1

mario_stats3d	equ	0

realchip	equ	1
mario_showobj equ	1
mario_spr_demo equ	1
easytext	equ	0

min_lockon	equ	8


disableobj	equ	0

soundon	equ	1

mario_sph_demo	equ	0

;Key pad Codes		(ends in l = in contl0)
Key_al	equ	$80
Key_b	equ	$80
key_xl	equ	$40
key_y	equ	$40
key_start	equ	$10
key_select	equ	$20
key_leftl	equ	$20
key_rightl	equ	$10
key_jup	equ	$08
key_jdown	equ	$04
key_jleft	equ	$02
key_jright	equ	$01

pad_B	equ	1<<15
pad_Y	equ	1<<14
pad_SELECT	equ	1<<13
pad_START	equ	1<<12
pad_JUP	equ	1<<11
pad_JDOWN	equ	1<<10
pad_JLEFT	equ	1<<9
pad_JRIGHT	equ	1<<8
pad_A	equ	1<<7
pad_X	equ	1<<6
pad_LEFT	equ	1<<5
pad_RIGHT	equ	1<<4

padl_B	equ	pad_B>>8
padl_Y	equ	pad_Y>>8
padl_SELECT	equ	pad_SELECT>>8
padl_START	equ	pad_START>>8
padl_JUP	equ	pad_JUP>>8
padl_JDOWN	equ	pad_JDOWN>>8
padl_JLEFT	equ	pad_JLEFT>>8
padl_JRIGHT	equ	pad_JRIGHT>>8
padl_A	equ	pad_A
padl_X	equ	pad_X
padl_LEFT	equ	pad_LEFT
padl_RIGHT	equ	pad_RIGHT



NULL	equ	0

;Game limit vars --------------------------------------
number_al	equ	70	;Max aliens
number_drawal	equ	70
number_zb	equ	70	;Max z srot blocks

;Base addresses for RAM alocation -----------------
zmempt	=	0	;zero page
wmempt	=	$300	;work space
xmempt	=	$7e2000	;extended RAM
xxmempt	=	$7f0000	;extended RAM
zmmempt	=	$700000
mmempt	=	$700200
mrambank	=	$700000



bitmap1	equ	$2800
bitmap2	equ	$9000
bitmapbase	equ	$700000

WM	equ	$ffff
BM	equ	$ff
K	equ	1024


gameNum_col		equ	26
gameNum_row		equ	16
gameNum_col2		equ	22
gameNum_row2		equ	12

vchr_base1		equ	0
vsc_base1		equ	22*k/2
vchr_base2		equ	24*k/2
vchr_physback	equ	40*k/2
vchr_logback	equ	46*k/2
vobj_base		equ	52*k/2
vsc_base2		equ	56*k/2
bg2offsets		equ	vsc_base1+32*28

num_col	equ	26
num_row	equ	16
num_col2	equ	22
num_row2	equ	12

char_size	equ	64
col_size	equ	char_size*num_row
usedchar	equ	col_size*num_col
pal3d	equ	7



;alien flags (al_flags) -------
afexp	equ	1	;Exploding
afInRngPl	equ	2	;In Range of player
afLeftPl	equ	4	;Left of player
afFrontPl	equ	8	;Infront of Player
afInviewPl	equ	16	;Inview of player
afhit	equ	32	;was hit/ shot/blasted/bumped
afonfire	equ	64	;on fire

;alien type flags (al_type) ---
atgnd	equ	1	;ground object
atmissile	equ	2	;Is misslie
atlaser	equ	4	;Is laser bolt
atzremove	equ	8	;remove when behind
atnuked	equ	16	;if hit by nuke explosion.

;player machine flags (macflags 16 bit)
MACFEXISTS	equ	1
MACFRELAXIS	equ	2


; planets.asm
num_routes	equ	4


; main
SPACE_MODE	equ	1
WATER_MODE	equ	2

xhdma_max	equ	5*K

mapbase	=	$58000
mapbase2	=	$d8000


HF1	equ	1<<0
HF2	equ	1<<1
HF3	equ	1<<2
HF4	equ	1<<3
HF5	equ	1<<4
HF6	equ	1<<5
HF7	equ	1<<6
HF8	equ	1<<7

; continue.asm

friend_fox	equ	0
friend_rabbit equ	1
friend_falcon equ	2
friend_frog	equ	3
friend_pepper equ	4
friend_andross equ	5
friend_anyone equ	6

friend_fox3	equ	0+128
friend_rabbit3 equ	1+128
friend_falcon3 equ	2+128
friend_frog3	equ	3+128
friend_pepper3 equ	4+128
friend_andross3 equ	5+128
friend_anyone3 equ	6+128


; sprites.asm
spradd	equ	128	;((24*28)-512+2)

; trans
gamechar_size	equ	64
gamemdm		equ	1+32
gameStRow		equ	2
gameVW_Pos		equ	(8*gameStRow+8*gameNum_row)-1
gamemtrans		equ	((262-gameVW_Pos+8*gameStRow)*170)&(-30)
gameBMPSZ		equ	gameNum_col*gameNum_row*gamechar_size
;		ifge	gamemtrans-gameBMPSZ
gamemaxtrans	equ	gameBMPSZ/2
;		elseif
;gamemaxtrans	equ	gamemtrans
;		endc
gametranlen1	equ	gamemaxtrans
gametranlen2	equ	gamemaxtrans
paltranlen1	equ	(gamemaxtrans*3)/4
paltranlen2	equ	gamemaxtrans-paltranlen1

; irq vars
tm_planets	equ	8
tm_fox	equ	10
tm_fox2	equ	12
tm_fox3	equ	14
tm_planets2	equ	34

dec_base	equ	2800h





