;-------------------------------------------------------------
; STRUCTS.INC
;


alcon	=	1
	fopen	alvars.txt

;List structures---------------------------------------
;(first 4 bytes are _next & _prev)
;	structure	4
;	defal	alxblock,2
;	struct	al_start,0
;	struct	al_size,0

;	alc	viewblk,al_size
;	alc	alblks,al_size*number_al


	xalc	alxblkstart,1

	structure	alxblkstart
	struct	alx_start,0
	defalx	next,2
	defalx	prev,2
	defalx	shape,2
	defalx	ptr,2		; ptr to attached alien 
	defalx	flags,1
	defalx	type,1
	defalx	count,1
	defalx	count1,1
	defalx	worldx,2		; world x,y,z
	defalx	worldy,2
	defalx	worldz,2
	defalx	mapz,1
	defalx	worldzh,1
	defalx	rotx,1		; angles x,y,z
	defalx	roty,1
	defalx	rotz,1
	defalx	vel,1

	defalx	colframe,1
	include	GILESalx.inc
	defalx	animframe,1
	defalx	snd1,1
	defalx	snd2,1
	defalx	coltab,2
	defalx	tx,1
	defalx	ty,1
	struct	alx_end,0

alx_size	=	alx_end-alx_start
alxblks	=	1
	xalc	alxblks2,alx_size*number_al
	PRINTF	"alxblkstart =$",:$alxblkstart,"%n"
	PRINTF	"alxblks2 =$",:$alxblks2,"%n"
	

	fclose

;----------------------------------


;Strategy data block
	structure	4
	struct	sb_ptr,2
	struct	sb_x,2
	struct	sb_y,2
	struct	sb_z,2
	struct	sb_size,0

;Zed Sort block
	structure	4
	struct	zb_ptr,2
	struct	zb_x,2
	struct	zb_shadx,2
	struct	zb_y,2
	struct	zb_shady,2
	struct	zb_z,2
	struct	zb_shadz,2
	struct	zb_sz,2
	struct	zb_size,0


;----- structure of drawlist format
	structure	$700000
	struct		dl_next,2
	struct		dl_sortz,2
	struct		dl_rotx,1
	struct		dl_roty,1
	struct		dl_rotz,1
	struct		dl_sflags,1
	struct		dl_shape,2
	struct		dl_shady,2
	struct		dl_shadx,2
	struct		dl_shadz,2
	struct		dl_y,2
	struct		dl_x,2
	struct		dl_z,2
	struct		dl_coltab,2
	struct		dl_expcnt,1
	struct		dl_animframe,1
	struct		dl_colframe,1
	struct		dl_depth,1
	struct		dl_tscrollx,1
	struct		dl_tscrolly,1
	struct		dl_size,0
dl_sizeof	equ		dl_size-$700000


;----- structure of allocation array of colour window
	structure	0
	struct		wm_coldata,1
	struct		wm_coldata_r,1
	struct		wm_coldata_g,1
	struct		wm_coldata_b,1
	struct		wm_ts,1
	struct		wm_cgswsel,1
	struct		wm_cgadsub,1
	struct		wm_val,1
	struct		wm_sizeof,0

wm_wbglog	equ	wm_cgadsub

maxwindows	=	0
; the windows are in priority order - highest is first
	defwindow	wipe
	defwindow	blackfade
	defwindow	whitefade
	defwindow	redfade
	defwindow	halffade
	defwindow	dyingred
	defwindow	hitflash
	defwindow	circle



	xalc	collisttemp,0

;----------------------------------
; collision list structure
	structure	collisttemp
	struct	cl_alien,2
	struct	cl_colbox,2
	struct	cl_xmax,2
	struct	cl_ymax,2
	struct	cl_zmax,2
	struct	cl_size,0

cl_sizeof	=	cl_size-collisttemp


; COLBOXES
	xalc	collist,number_al*cl_sizeof

;----------------------------------

alcon	=	0


