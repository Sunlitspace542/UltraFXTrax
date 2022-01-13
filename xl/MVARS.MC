CacheOn	equ	1




; Mario register defs

rsp	equr	10
rlink	equr	11



; Mario zero page vars

	zmalc	m_bnorms,16
	zmalc	m_mariomode,2

	zmalc	m_sp,2		; sp temp
	zmalc	m_drawmap,2	; bitmap to draw to

; shape vars
	zmalc	m_pntptr,2	; shape ROM points data ptr
	zmalc	m_faceptr,2	; shape ROM faces data ptr
	zmalc	m_shapeptr,2	; shape ROM data ptr
	zmalc	m_shapebank,2	; shape ROM data bank
	zmalc	m_rotptr,2	; shape rotated points ptr
	zmalc	m_rotx,2	; shape angles
	zmalc	m_roty,2
	zmalc	m_rotz,2
	zmalc	m_bigx,2	; shape rotated relative pos
	zmalc	m_bigy,2
	zmalc	m_bigz,2
;	zmalc	m_x1,2		; shape relative pos
	zmalc	m_y1,2
	zmalc	m_z1,2
	zmalc	m_scale,2	; shape scale	(eg. 4)
	zmalc	m_shift,2	; shape shift	(eg. 2)
	zmalc	m_vanishx,2
	zmalc	m_vanishy,2
	zmalc	m_xleft,2
	zmalc	m_xright,2
	zmalc	m_ytop,2
	zmalc	m_ybot,2
	zmalc	m_cnt,2
	zmalc	m_texturemap,2	; texture mapping off/on (0/1)
	zmalc	m_framenum,2
	zmalc	m_colframe,2
	zmalc	m_expcnt,2
	zmalc	m_colourptr,2
	zmalc	m_shadestab,2
	zmalc	m_depthstab,2
	zmalc	m_depthtable,2
	zmalc	m_depthsptr,2
	zmalc	m_objflags,2
	zmalc	m_bspptr,2
	zmalc	m_tcmodecol,2

; scan converter vars

	zmalc	m_tr1,2		; tracer 1
	zmalc	m_tr2,2		; tracer 2

	zmalc	m_dy1,2		;
	zmalc	m_dy2,2		;

	zmalc	m_x1,2		;
	zmalc	m_x2,2		;
	zmalc	m_x1inc,2	;
	zmalc	m_x2inc,2	;

	zmalc	m_xp1,2		;
	zmalc	m_xp2,2		;
	zmalc	m_dxp1,2	;
	zmalc	m_dxp2,2	;
	zmalc	m_xp1inc,2	;
	zmalc	m_xp2inc,2	;

	zmalc	m_yp1,2		;
	zmalc	m_yp2,2		;
	zmalc	m_dyp1,2	;
	zmalc	m_dyp2,2	;
	zmalc	m_yp1inc,2	;
	zmalc	m_yp2inc,2	;

	zmalc	m_texptr,2	;

; clip vars

	zmalc	m_clipdx,2	;
	zmalc	m_clippnts,2	;
	zmalc	m_clipx,2	;
	zmalc	m_clipy,2	;
	zmalc	m_clipz,2	;
	zmalc	m_clip2drsp,2	; used in clp_poly to store rsp
;	zmalc	m_x2,2		;
	zmalc	m_y2,2		;
	zmalc	m_z2,2		;


; sprite vars
	zmalc	m_sprbank,2	; sprite data bank
	zmalc	m_sprdata,2	; sprite data addr
	zmalc	m_spra,2	; sprite matrix a
	zmalc	m_sprb,2	; sprite matrix b
	zmalc	m_sprc,2	; sprite matrix c
	zmalc	m_sprd,2	; sprite matrix d
	zmalc	m_sprxmin,2	; sprite x min
	zmalc	m_sprxmax,2	; sprite x max
	zmalc	m_sprymin,2	; sprite y min
	zmalc	m_sprymax,2	; sprite y max
	zmalc	m_sprx,2	; sprite x
	zmalc	m_spry,2	; sprite y
	zmalc	m_sprz,2	; sprite z
	zmalc	m_sprxscroll,2	; sprite x scroll
	zmalc	m_spryscroll,2	; sprite y scroll
	zmalc	m_sprx0,2	; sprite x0
	zmalc	m_spry0,2	; sprite y0
	zmalc	m_sprsize,2	; sprite size
	zmalc	m_sprwidth,2	; sprite height
	zmalc	m_sprheight,2	; sprite width
	zmalc	m_sprxscale,2	; sprite xscale
	zmalc	m_spryscale,2	; sprite yscale
	zmalc	m_sprangle,2	; sprite angle
	zmalc	m_sprmask,2	; sprite mask
	zmalc	m_spr0,2	; sprite temp

msprite		equ	m_spra
mspr_pal	equ	m_sprb
m_clipleft	equ	m_sprxmin
m_clipright	equ	m_sprxmax

;	?m_shapeptr

; view vars
     	zmalc	m_viewposx,2	; world pos
	zmalc	m_viewposy,2
	zmalc	m_viewposz,2
	zmalc	m_viewrotx,2	; world angles
	zmalc	m_viewroty,2
	zmalc	m_viewrotz,2
	zmalc	m_wmat11,2	; world matrix, 16 bit
	zmalc	m_wmat12,2
	zmalc	m_wmat13,2
	zmalc	m_wmat21,2
	zmalc	m_wmat22,2
	zmalc	m_wmat23,2
	zmalc	m_wmat31,2
	zmalc	m_wmat32,2
	zmalc	m_wmat33,2
	zmalc	m_wmat1211,2	; world matrix
	zmalc	m_wmat2113,2
	zmalc	m_wmat2322,2
	zmalc	m_wmat3231,2
	zmalc	m_wmat0033,2
	zmalc	m_lightx,2	; world light source vector
	zmalc	m_lighty,2
	zmalc	m_lightz,2
	zmalc	m_rotlightx,2	; rotated light source vector
	zmalc	m_rotlighty,2
	zmalc	m_rotlightz,2


; current shape vars
	zmalc	m_rmat1211,2	; shapes own matrix
	zmalc	m_rmat2113,2
	zmalc	m_rmat2322,2
	zmalc	m_rmat3231,2
	zmalc	m_rmat0033,2
	zmalc	m_rmat11,2	; shapes own matrix, 16 bit
	zmalc	m_rmat12,2
	zmalc	m_rmat13,2
	zmalc	m_rmat21,2
	zmalc	m_rmat22,2
	zmalc	m_rmat23,2
	zmalc	m_rmat31,2
	zmalc	m_rmat32,2
	zmalc	m_rmat33,2
	zmalc	m_mat1211,2	; shape matrix
	zmalc	m_mat2113,2
	zmalc	m_mat2322,2
	zmalc	m_mat3231,2
	zmalc	m_mat0033,2
	zmalc	m_mat11,2	; shape matrix, 16 bit
	zmalc	m_mat12,2
	zmalc	m_mat13,2
	zmalc	m_mat21,2
	zmalc	m_mat22,2
	zmalc	m_mat23,2
	zmalc	m_mat31,2
	zmalc	m_mat32,2
	zmalc	m_mat33,2
	zmalc	m_numpnts,2
	zmalc	m_fnumpnts,2
;	zmalc	m_numfaces,2
	zmalc	m_numgroups,2

	zmalc	m_or_of_outcodes,2
	zmalc	m_inpoints,2
	zmalc	m_groupnum,2
	zmalc	m_grouptab,2
	zmalc	m_rand,2


; ground dots vars
	zmalc	m_pxx,2
	zmalc	m_pxy,2
	zmalc	m_pxz,2
	zmalc	m_pzx,2
	zmalc	m_pzy,2
	zmalc	m_pzz,2
	zmalc	m_gridzsize,2
	zmalc	m_gridx,2
	zmalc	m_gridz,2

; texture map vars

	zmalc	m_fx0,2
	zmalc	m_fy0,2
	zmalc	m_fz0,2

	zmalc	m_fsx,2
	zmalc	m_fsy,2
	zmalc	m_fsz,2
	zmalc	m_ftx,2
	zmalc	m_fty,2
	zmalc	m_ftz,2
	zmalc	m_fpa,2
	zmalc	m_fpb,2
	zmalc	m_fpc,2

	zmalc	m_fpdlo,2
	zmalc	m_fpdhi,2
	zmalc	m_paxlo,2
	zmalc	m_paxhi,2
	zmalc	m_palo,2
	zmalc	m_pahi,2
	zmalc	m_pblo,2
	zmalc	m_pbhi,2
	zmalc	m_pclo,2
	zmalc	m_pchi,2
	zmalc	m_uax,2
	zmalc	m_ua,2
	zmalc	m_ub,2
	zmalc	m_uc,2
	zmalc	m_ud,2
	zmalc	m_vax,2
	zmalc	m_va,2
	zmalc	m_vb,2
	zmalc	m_vc,2
	zmalc	m_vd,2
	zmalc	m_vx,2
	zmalc	m_vy,2
	zmalc	m_xlen,2

	zmalc	m_bossmaxHP,2
	zmalc	m_bossHP,2
	zmalc	m_dotsorstars,2
	zmalc	m_pfm,2
	zmalc	m_shadowpass,2
	zmalc	m_depthoffset,2

; mhofs 
	zmalc	testk,2
	zmalc	testk2,2
	zmalc	testk3,2
	zmalc	testk4,2
	zmalc	m_sineoffset,2
	zmalc	m_scrollxoff,2
;


; Mario RAM vars

	malc	rtest1,2
	
;	malc	py1n,1
;	malc	py2n,1
;	malc	x_data_blk,0


	malc	m_count,2
	malc	m_charset,2	; char set ptr
	malc	m_textpos,0	; text x,y pos
	malc	m_textposx,1
	malc	m_textposy,1
	malc	m_textcolour,0	; text colours c1,c2
	malc	m_textc1,1
	malc	m_textc2,1
	malc	m_textr0,2	; text reg save area
	malc	m_textr1,2
	malc	m_textr2,2
	malc	m_textr3,2
	malc	m_textr4,2
	malc	m_textr5,2
	malc	m_textr11,2
	malc	m_textr12,2
	malc	m_textr13,2
	malc	m_textr14,2



mmaxxpos	=	224
mmaxypos	=	192

mmaxpnts	=	150	; was 80
mmaxpolysize	=	150
mmaxgroups	=	16
mmaxstack	=	256
mmaxbsp		=	40	; was 64
mmaxdust	=	1			120
mmaxdrawlist	=	dl_sizeof*number_drawal
mmaxvistab	=	150	; was 128


	malc	m_meters,2
	malc	m_dlptr,2
	malc	m_shadowheight,2

	malc	rtest2,2

;	malc	bg_scrollbuffer,224*3
	malc	m_stack,mmaxstack
	malc	m_zlist,0
	malc	m_rotpnts,6*mmaxpnts
	malc	m_projpnts,6*mmaxpnts
	malc	m_uvlist,0
	malc	m_polybuf,mmaxpolysize
	malc	m_clippolybuf,mmaxpolysize
	malc	m_cpolybuf,mmaxpolysize
	malc	m_bsplist,mmaxbsp
	malc	m_zbuf,mmaxgroups
	malc	m_uvlist2,0
	malc	m_dustpnts,0
	malc	m_intpnts,0
	malc	m_vistab,mmaxvistab
	malc	m_drawlist,mmaxdrawlist

	malc	rtest3,2


	malc	m_scuptab,0
	malc	m_scdwntab,0

	malc	m_planetstars,2
	malc	m_particlesON,2
	malc	m_defaultID,2

	malc	m_debugchars,0	; always last!

;----------------------------------------------------------
; dynamic allocs.

;-----------------------------------------------	


	malc	m_dynmem,totaldynmem

	malc	m_objects,2

;	malc	m_testmem,1000
	
	malc	m_framec,2

	malc	rtest4,2

;-----------------------------------------------	
; forces
	malc	m_DISPx,2     --	
	malc	m_DISPy,2	|
	malc	m_DISPz,2	|-	; MUST be this order
	malc	m_TORQUEx,2	|
	malc	m_TORQUEy,2	|
	malc	m_TORQUEz,2   --
	malc	m_forceX,2
	malc	m_forceY,2
	malc	m_forceZ,2

	malc	m_whlrotposX,2
	malc	m_whlrotposY,2
	malc	m_whlrotposZ,2

	malc	m_carflags,2
	malc	m_carworldx,2
	malc	m_carworldy,2
	malc	m_carworldz,2
	malc	m_test1,2
	malc	m_test2,2
	
	malc	m_enginex,2
	malc	m_enginey,2
	malc	m_enginez,2
	malc	m_frictdispx,2
	malc	m_frictdispy,2
	malc	m_frictdispz,2

	malc	m_t1,2
	malc	m_t2,2
	malc	m_t3,2
	malc	m_t4,2
	malc	m_t5,2
	malc	m_t6,2
	
	malc	m_normX,2
	malc	m_normY,2
	malc	m_normZ,2

	malc	m_facePX,2
	malc	m_facePY,2
	malc	m_facePZ,2

	malc	m_faceD,2
	malc	m_whlD,2
	malc	m_groupPtype,2

	malc	m_wheelgndoff,2
	malc	m_oldshape,2
	malc	m_oldframenum,2
	malc	m_shapescale,2
	malc	m_whlgndfriction,2

	malc	m_whlspringx,2
	malc	m_whlspringy,2
	malc	m_whlspringz,2
	malc	m_dynvar1,2
	malc	m_dynvar2,2
	malc	m_dynvar3,2
	malc	m_lastroadobj,2
	malc	m_lastmarkobj,2

	malc	m_offroadfriction,2
	malc	m_onroadfriction,2
	malc	m_objspeed,2
	
	malc	m_groupblocks,(2*5)*max_groups

	malc	m_mariokey,2
	malc	m_indynamics,2
	malc	m_dynframe,2

	malc	m_testcar1,2
	malc	m_totaldamage,2

	malc	rtest5,2

;----------------------------------------------------------
maxparticles	=	30		mmaxpnts
part_LIFE	equ	0	; must be 0!
part_FLAGS	equ	1
part_COLOUR	equ	2
part_VX		equ	3
part_VY		equ	4
part_VZ		equ	5
part_POSX	equ	6
part_POSY	equ	8
part_POSZ	equ	10
part_UNIQUE	equ	12
part_len	equ	14

	Zmalc	m_particlerand,2
	malc	m_particles,part_len*(maxparticles+1)
;	malc	m_particlerand2,2
;	malc	m_drawparticles,(8+6)*(maxparticles+1)
		  




; 0000 vars	    512		4
; 0200 stack	    256		2
; 0280 rotpnts	    768		6
; 0280 projpnts    768		6
; 0280 vistab	    128		1
; 0280 zbuf	    128		1
; 0280 bsplist	    128		1
; 0280 polybuf	    128		1
; 0280 clippolybuf 128		1
; 0280 cpolybuf    128		1
; 0280 drawlist    512		4
; 0280 dustpnts    256		2
; 0280 free	    256		2
; 






