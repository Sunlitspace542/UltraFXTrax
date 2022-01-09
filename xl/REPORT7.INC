


makereport	macro	[name]
	printf	   "{name}"
	printf	   "%n"
	printf	   "..........................."
	printf	   :${name}
	printf	   "%n"

	endm
makecmd		macro	[name]
	printf	   "YU  " 
	printf	   "{name}"
	printf	   "="
	printf	   :${name}
	printf	   "%n"

	endm
makesym	    	macro	
	printf	   "YU  " 
	printf	   "\1"
	printf	   "="
	printf	   "\2"
	printf	   "%n"

	endm

	fopen	report.dat

	makereport irq_index
	makereport irq_flag
	makereport screen_contrast
	makereport player_mode
	makereport trans_level
	makereport bitmap_status
	makereport trans_status
	makereport fade_control
	makereport framecounter
	makereport map_number
	makereport damage_value
	makereport transcole0
	makereport transcole1
	makereport transcole2
	makereport transcole3
	makereport time_flag
	makereport decimaltime
	makereport secondtime
	makereport minutetime
	makereport accel_index
	makereport cursor_posh
	makereport cursor_posv
	makereport color_buffer
	makereport tm_buffer
	makereport mwork
	makereport m_bitmapbase
	makereport sound0buffer
	makereport sound1buffer
	makereport sound0pointer
	makereport sound1pointer
	makereport sound0number
	makereport sound1number
	makereport sound0stock
	makereport sound1stock
	makereport enginesound
	makereport spriteblk
	makereport cont0l
	makereport cont1l
	makereport	posx
	makereport	posy
	makereport	posz
	makereport	font12
	fclose	!


	fopen	sfd.cmd



	makesym	ap0,2140
	makesym	ap1,2141
	makesym	ap2,2142
	makesym	ap3,2143
			 
	makecmd irq_index
	makecmd irq_flag
	makecmd screen_contrast
	makecmd player_mode
	makecmd trans_level
	makecmd bitmap_status
	makecmd trans_status
	makecmd fade_control
	makecmd framecounter
	makecmd map_number
	makecmd damage_value
	makecmd transcole0
	makecmd transcole1
	makecmd transcole2
	makecmd transcole3
	makecmd time_flag
	makecmd decimaltime
	makecmd secondtime
	makecmd minutetime
	makecmd accel_index
	makecmd cursor_posh
	makecmd cursor_posv
	makecmd color_buffer
	makecmd tm_buffer
	makecmd mwork
	makecmd m_bitmapbase
	makecmd sound0buffer
	makecmd sound1buffer
	makecmd sound0pointer
	makecmd sound1pointer
	makecmd sound0number
	makecmd sound1number
	makecmd sound0stock
	makecmd sound1stock
	makecmd enginesound
	makecmd	spriteblk
	makecmd cont0l
	makecmd cont1l
	makecmd	posx
	makecmd	posy
	makecmd	posz
	makecmd	font12

	printf	"bc 1,,,,,,,---x-%n"
	printf	"bc 2,,,,,,,---x-%n"
	printf	"bc 3,,,,,,,---x-%n"
	printf	"bc 4,,,,,,,---x-%n"
	printf	"bc 5,,,,,,,---x-%n"
	printf	"bc 6,,,,,,,---x-%n"
	printf	"bc 7,,,,,,,---x-%n"
	printf	"bc 8,,,,,,,---x-%n"

	printf	"TMS AB%n"

	printf	"er%n"
	printf	"g%n"

	fclose	!
