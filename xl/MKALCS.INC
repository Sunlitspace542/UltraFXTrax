;--------------------------------------------------------------------
;	Alocation file for XL
;
;				programed by Masato Kimura
;
;				04/02/1993
;--------------------------------------------------------------------
;
;		VARS!!!!
;
;
;sprite main address (on spriteblk)
;
startaddress	equ	00
endaddress	equ	128*04
timeaddress	equ	((00*00)+00)*04
vspriteaddress	equ	((25*04)+01)*04
paneladdress	equ	((02*04)+00)*04		      
timelength	equ	paneladdress-timeaddress-02*04
panellength	equ	vspriteaddress-paneladdress
vspritelength	equ	endaddress-vspriteaddress

;
;
;
	alc	debug_count,1
	alc	fx_status,1		;(mario_chip_status)
	alc	irq_index,1	    
	alc	irq_flag,1
	alc	race_index,1			 
	alc	control_flag,1
	alc	start_count,1
	alc	screen_contrast,2	
	alc	player_mode,1		;00=1player,02=2player
	alc	trans_level,2	
	alc	bitmap_status,2
	alc	trans_status,2



	alc	upper_screen,2
	alc	lower_screen,2
	alc	upper_scrollh,2	
	alc	upper_scrollv,2	
	alc	lower_scroolh,2
	alc	lower_scroolv,2
	
	alc	fade_control,1 
	alc	framecounter,1
	alc	game_counter,1
	alc	flashdamagecounter,1
	alc	map_number,1
	alc	lapstock,1
	alc	lapdispcnt,1
	alc	laptimedispcnt,1
	alc	damage_value,2
	alc	transcole0,1
	alc	transcole1,1 
	alc	transcole2,1 
	alc	transcole3,1
	alc	transcolfont,1
;sound
	alc	soundgate,2 
	alc	sound_selecter,1
	alc	engine_lebel,1
	alc	skid_lebel,1
	alc	dart_flag,1
	alc	brake_flag,1
	
	alc	fade_cnt,1
	alc	demo_cnt,1
	alc	gameover_flag,1
	alc	gameover_cnt,2
	alc	goalin_flag,1
	alc	goalin_cnt,2
	alc	timeup_cnt,1
	alc	time_flag,1  		;00=stop ff=go!!!  
	
	alc	decimaltime,2
	alc	secondtime,2
	alc	minutetime,2
	alc	decimalcounter,2
	alc	secondcounter,2
	alc	minutecounter,2
	alc	minutecountold,2
;
	alc	jewel_number,1
	alc	jewel_pattern,1		;0,1,2,3
	alc	jewel_color,1		;00=RED
					;01=BLUE
					;02=YELLOW
	alc	hand_new,1
	alc	hand_old,1
	alc	handh,1
	alc	handv,1
;
	alc	accel_index,1		;00=last on !!

	alc	cursor_posh,1
	alc	cursor_posv,1
	alc	tempolary,2
	alc	posx,2
	alc	posy,2
	alc	posz,2
	alc	addx,2
	alc	addy,2
	alc	addz,2
;
	alc	cont0d,2
	alc	cont1d,2
	alc	trig0d,2
	alc	trig1d,2
;

	xalc	timebuffer,8*6  
	xalc	laptimebuffer,8*6	

	
;
	xalc	color_buffer,512
	xalc	tm_buffer,9		;through main buffer
	 
	malc	mdecimallap,2
	malc	msecondlap,2
	malc	mminutelap,2
	malc	mminutecounter,2


	malc	mwork,2		;FOR TESTING
	malc	messageh,2
	malc	messagev,2
	malc	messagezoomh,2
	malc	messagezoomv,2
	malc	messagemoozh,2
	malc	messagemoozv,2
	malc	messageaddress,2
;
	malc	messagelength,2
	malc	messagepallet,2
;---------------------------------------------------------
	malc	m_bitmapbase,2

	xalc	sound0buffer,16		;for set sounds!!
	xalc	sound1buffer,16
	xalc	sound0pointer,2
	xalc	sound1pointer,2
	xalc	sound0number,2
	xalc	sound1number,2
	xalc	sound0stock,2
	xalc	sound1stock,2

	xalc	enginesound,2
;
;---------------------------------------------------------
; equate to define size of depth cue table

depthcuesize	equ	$70

;---------------------------------------------------------
;		use 7F BANK !!!!
;---------------------------------------------------------

handsprite	equ	7f2000h
handspritelength	equ	1c00h
jewelstart	equ	handsprite+6ch*20h
nextaddress	equ	7f3c00h
	







	

