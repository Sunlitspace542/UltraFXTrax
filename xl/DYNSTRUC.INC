;*******************************************************************
track_scale	=	5
car_scale	=	1		(track_scale*25)/100
framespersec	=	15
ametre		=	100
dynshift	=	3		
car1_collsize	=	45

;--------------------------------------------
; max speed at accel=40 and wheel_friction=256 is about 4352


;--------------------------------------------

max_groups	=	20	; maximum amount of polygon groups for face testing (including 0 for ground).

groupflag_nocol	equ	128
groupflag_anim		equ	64

whitelinecol	=	32



;*******************************************************************

totaldynmem	=	0


;*******************************************************************
; STANDARD OBJECT STRUCTURE.


OBJTYPE_road		equ	1
OBJTYPE_marker		equ	2
OBJTYPE_exppiece	equ	4
OBJTYPE_car		equ	8
OBJTYPE_wheel		equ	16


	structure	4

	struct		OBJ_NEXT,2
	struct		OBJ_PREV,2

	struct		OBJ_STRATPTR,2

	struct		OBJ_RADX,2
	struct		OBJ_RADY,2
	struct		OBJ_RADZ,2
	struct		OBJ_FRAME,2
	struct		OBJ_COLLSHAPE,2
	struct		OBJ_COLLOBJ,2
	struct		OBJ_LASTCOLLOBJ,2
	struct		OBJ_TYPE,2
	
	struct		OBJ_COLLOBJ1,2
	struct		OBJ_COLLOBJ2,2

	struct		OBJ_MAPZ,2
	struct		OBJ_WORLDX,2
	struct		OBJ_WORLDY,2 
	struct		OBJ_WORLDZ,2 
	struct		OBJ_LEN,0	

	struct		OBJ_ROTX,2
	struct		OBJ_ROTY,2
	struct		OBJ_ROTZ,2
	struct		OBJ_VELX,2
	struct		OBJ_VELY,2
	struct		OBJ_VELZ,2
	struct		OBJ1_LEN,0	

	PRINTF	"OBJ struct size = ",OBJ_LEN,"%n"


;*******************************************************************
; ADDITIONAL BLOCK STRUCTURES.


;*******************************************************************
; CARS
max_CARS	EQU	4
	
CARflag_hitflash	equ	0

CARflag_steerLeft	equ	1
CARflag_steerRight	equ	2
CARflag_steerHardLeft	equ	4
CARflag_steerHardRight	equ	8
CARflag_Accel		equ	16
CARflag_Deccel		equ	32
CARflag_Brake		equ	64
CARflag_collide		equ	128
CARflag_boost		equ	256
CARflag_jump		equ	512
CARflag_dynoff		equ	1024
CARflag_squish		equ	2048
CARflag_suck		equ	4096
CARflag_wheely		equ	8192
CARflag_computer	equ	16384
CARflag_makestop	equ	32768

	structure	OBJ1_LEN

	struct		CAR_TORQUEX,2
	struct		CAR_TORQUEY,2
	struct		CAR_TORQUEZ,2

	struct		CAR_ENGINEROTY,2
	struct		CAR_ACCEL,2

	struct		CAR_WHEELS,2	
	struct		CAR_FLAGS,2

	struct		CAR_OFFGND,2
	struct		CAR_OFFROAD,2
	struct		CAR_WHLFRICTION,2

	struct		CAR_GNDSPEED,2
	struct		CAR_WHLTURNSPEED,2
	struct		CAR_GEAR,2
	struct		CAR_REVS,2
	struct		CAR_REVSND,2

	struct		CAR_HANDOBJ,2
	struct		CAR_SKID,2
	struct		CAR_LASTSKID,2

	struct		CAR_TEST1,2

	struct		CAR_NEARMARKER,2

	struct		CAR_CENTGY,2
;	struct		CAR_CENTGZ,2

	struct		CAR_JUMP,2
	struct		CAR_SHADOWY,2
	struct		CAR_OFFROADTIME,2

	struct		CAR_ACCELY,2
	struct		CAR_SQUISHY,2
	struct		CAR_SUCK,2
	struct		CAR_SIZEANIM,2
	struct		CAR_ZIMPACT,2

	struct		CAR_OFFROADFRICTION,2
	struct		CAR_ROADFRICTION,2

	struct		CAR_DAMTIME,2
	struct		CAR_TOTALDAMAGE,2
	struct		CAR_TWISTTIME,2
	
	struct		CAR_BOOSTTIME,2

 	
	struct		CAR_LEN,0	

	mmax_structs	CAR_LEN,max_cars


	PRINTF	"CAR struct size = ",CAR_LEN,"%n"


;*******************************************************************
; Wheel blocks

WHLflag_rear		EQU	1
WHLflag_front		EQU	2
WHLflag_test1		EQU	4
WHLflag_offroad		EQU	8	; if wheel is NOT inside shape radius.
WHLflag_power		EQU	16
WHLflag_ongnd		EQU	32	; if wheel IS on a ground polygon.
WHLflag_skid		EQU	64
WHLflag_onslope		EQU	128


	structure	OBJ1_LEN

	struct		WHL_NEXT,2  
	
	struct		WHL_ROTOFFX,2	
	struct		WHL_ROTOFFY,2	
	struct		WHL_ROTOFFZ,2	

	struct		WHL_OFFSETX,2	
	struct		WHL_OFFSETY,2	
	struct		WHL_OFFSETZ,2

	struct		WHL_NOFFSETX,2
	struct		WHL_NOFFSETY,2
	struct		WHL_NOFFSETZ,2

	struct		WHL_ROTXSPEED,2

	struct		WHL_TEMP1,2
	struct		WHL_FLAGS,2

	struct		WHL_GNDFRICTION,2

	struct		WHL_SPRINGX,2
	struct		WHL_SPRINGY,2
	struct		WHL_SPRINGZ,2


	struct		WHL_MAXGRIP,2

	struct		WHL_TRACKFORCEX,2
	struct		WHL_TRACKFORCEY,2
	struct		WHL_TRACKFORCEZ,2

	struct		WHL_DAMAGE,2

	struct		WHL_LEN,0


	mmax_structs	WHL_LEN,4*max_cars


	PRINTF	"WHL struct size = ",WHL_LEN,"%n"


;*******************************************************************
; track objects


TOBJflag_hitflash	equ	1
TOBJflag_stratflag1	equ	2

	
	structure	OBJ_LEN
	struct		TOBJ_NEXT,2
	struct		TOBJ_FLAGS,2
	struct		TOBJ_LEN,0

	mmax_structs	TOBJ_LEN,30


	PRINTF	"track obj struct size = ",tobj_LEN,"%n"



;*******************************************************************
; explosion objects

	structure	OBJ1_LEN
;	struct		EXPOBJ_FLAGS,2
	struct		EXPOBJ_OBJECT,2
;	struct		EXPOBJ_COUNT,2
;	struct		EXPOBJ_SHAPE,2

	struct		EXPOBJ_LEN,0

	mmax_structs	EXPOBJ_LEN,15


	PRINTF	"explosion obj struct size = ",EXPOBJ_LEN,"%n"

;*******************************************************************
; hand job-ects (ho ho very droll)

	structure	OBJ_LEN
	struct		HANDOBJ_OBJECT,2

	struct		HANDOBJ_LEN,0

	mmax_structs	HANDOBJ_LEN,2


	PRINTF	"hand obj struct size = ",HANDOBJ_LEN,"%n"


;******************************************************************************************
deftrack	MACRO
	global	\1
\1_xlen	=	\2<<track_scale
\1_zlen	=	\3<<track_scale
	IFEQ	NARG-4
\1_frames	=	\4
	ENDC
	ENDM
;******************************************************************************************



