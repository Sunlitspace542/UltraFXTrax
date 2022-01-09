
makereport	macro	[name]
	printf	   "{name}"
	printf	   "%n"
	printf	   "..........................."
	printf	   :${name}
	printf	   "%n"

	endm
makecmd		macro	
	printf	   "YU  " 
	printf	   "\1"
	printf	   "="
	printf	   :$\2
	printf	   "%n"

	endm
makesym	    	macro	
	printf	   "YU  " 
	printf	   "\1"
	printf	   "="
	printf	   "\2"
	printf	   "%n"

	endm
dispram		macro	 [name]
	printf	"{name}"
	printf	"="
	printf	:${name}
	printf	"%n"
	endm



	
	dispram	 m_testcar1
	dispram	 m_dynvar1
	dispram	 obj_worldx
	dispram	 obj_worldy
	dispram	 obj_worldz
	dispram	 obj_rotx
	dispram	 obj_roty
	dispram	 obj_rotz
	dispram	 m_carworldx
	dispram	 m_carworldy
	dispram	 m_carworldz

	fopen	car.cmd

	makecmd	 car,m_testcar1
	makecmd	 obj,m_dynvar1
	makecmd	 xx,obj_worldx
	makecmd	 yy,obj_worldy
	makecmd	 zz,obj_worldz 
	makecmd	 rx,obj_rotx
	makecmd	 ry,obj_roty
	makecmd	 rz,obj_rotz


	makecmd	 xxx,m_carworldx
	makecmd	 yyy,m_carworldy
	makecmd	 zzz,m_carworldz
		

	fclose	!
