default_group_num	=	0
go_scale	=	2

;--Shape file ----- C:\NSHED\XLSHAPES\GO_0.TXT ----
	ifne	DO_HDR

GO_0
	ShapeHdr	GO_0_P,0,GO_0_F,0,0,0,0,go_scale,0,30,30,10,44,id_0_c,0,0,0,0,<GO_0>
	elseif
GO_0_P
	Pointsb	8
	pb	4,0,-10	;0
	pb	30,0,-10	;1
	pb	-14,-30,-10	;2
	pb	30,-30,-10	;3
	pb	4,0,10	;4
	pb	30,0,10	;5
	pb	-14,-30,10	;6
	pb	30,-30,10	;7
	PointsXb	10
	pb	-4,30,-10	;8
	pb	-14,30,-10	;10
	pb	-30,10,-10	;12
	pb	-30,-10,-10	;14
	pb	-4,-30,-10	;16
	pb	-4,30,10	;18
	pb	-14,30,10	;20
	pb	-30,10,10	;22
	pb	-30,-10,10	;24
	pb	-4,-30,10	;26

	EndPoints
GO_0_F
	Vizis	20
	Viz	24,6,26,0,0,127	;0
	Viz	27,7,25,0,0,127	;1
	Viz	19,4,5,0,0,127	;2
	Viz	12,10,8,0,0,-127	;3
	Viz	15,3,17,0,0,-127	;4
	Viz	11,13,1,0,0,-127	;5
	Viz	3,15,25,-127,0,0	;6
	Viz	17,3,7,0,127,0	;7
	Viz	17,27,25,77,-101,0	;8
	Viz	0,1,5,0,127,0	;9
	Viz	1,13,23,-127,0,0	;10
	Viz	13,11,21,-99,-79,0	;11
	Viz	19,21,11,0,-127,0	;12
	Viz	9,0,4,127,0,0	;13
	Viz	8,18,26,-127,0,0	;14
	Viz	2,16,26,0,127,0	;15
	Viz	14,2,6,99,79,0	;16
	Viz	24,22,12,127,0,0	;17
	Viz	10,12,22,99,-79,0	;18
	Viz	8,10,20,0,-127,0	;19
	BSPInit	GO_0_EBSP
	BSP	13,GO_0_f1,.bsp2
	BSPE	GO_0_f3
.bsp2	BSPE	GO_0_f4

GO_0_f1	Faces
	Face4	4,13,127,0,0,9,0,4,19
	FendQ
GO_0_f3	Faces
	Face4	4,8,77,-101,0,17,27,25,15
	Face4	4,9,0,127,0,0,1,5,4
	Face3	6,1,0,0,127,27,7,25
	Face5	6,2,0,0,127,19,4,5,23,21
	Face3	6,4,0,0,-127,15,3,17
	Face5	6,5,0,0,-127,11,13,1,0,9
	Face4	4,6,-127,0,0,3,15,25,7
	Face4	4,7,0,127,0,17,3,7,27
	Face4	4,10,-127,0,0,1,13,23,5
	Face4	4,11,-99,-79,0,13,11,21,23
	Face4	4,12,0,-127,0,19,21,11,9
	FendQ
GO_0_f4	Faces
	Face6	6,0,0,0,127,24,6,26,18,20,22
	Face6	6,3,0,0,-127,12,10,8,16,2,14
	Face4	4,14,-127,0,0,8,18,26,16
	Face4	4,15,0,127,0,2,16,26,6
	Face4	4,16,99,79,0,14,2,6,24
	Face4	4,17,127,0,0,24,22,12,14
	Face4	4,18,99,-79,0,10,12,22,20
	Face4	4,19,0,-127,0,8,10,20,18
	FendQ
GO_0_EBSP
	EndShape

	endc
;--Shape file ----- C:\NSHED\XLSHAPES\GO_1.TXT ----
	ifne	DO_HDR

GO_1
	ShapeHdr	GO_1_P,0,GO_1_F,0,0,0,0,go_scale,0,30,30,10,44,id_0_c,0,0,0,0,<GO_1>
	elseif
GO_1_P
	Pointsb	6
	pb	2,30,-10	;0
	pb	10,30,-10	;1
	pb	-14,-18,-10	;2
	pb	2,30,10	;3
	pb	10,30,10	;4
	pb	-14,-18,10	;5
	PointsXb	4
	pb	-30,30,-10	;6
	pb	-10,-30,-10	;8
	pb	-30,30,10	;10
	pb	10,-30,10	;12

	EndPoints
GO_1_F
	Vizis	11
	Viz	0,2,6,0,0,-127	;0
	Viz	9,8,1,0,0,-127	;1
	Viz	10,5,3,0,0,127	;2
	Viz	11,4,13,0,0,127	;3
	Viz	6,10,3,0,-127,0	;4
	Viz	2,5,10,120,40,0	;5
	Viz	0,3,5,-120,40,0	;6
	Viz	8,13,4,120,-40,0	;7
	Viz	7,1,4,0,-127,0	;8
	Viz	7,11,12,-120,40,0	;9
	Viz	8,9,12,0,127,0	;10

GO_1_f1	Faces
	Face4	4,6,-120,40,0,0,3,5,2
	Face4	4,7,120,-40,0,8,13,4,1
	Face3	6,0,0,0,-127,0,2,6
	Face4	6,1,0,0,-127,9,8,1,7
	Face3	6,2,0,0,127,10,5,3
	Face4	6,3,0,0,127,11,4,13,12
	Face4	4,4,0,-127,0,6,10,3,0
	Face4	4,5,120,40,0,2,5,10,6
	Face4	4,8,0,-127,0,7,1,4,11
	Face4	4,9,-120,40,0,7,11,12,9
	Face4	4,10,0,127,0,8,9,12,13
	Fend
	EndShape

	endc
;--Shape file ----- C:\NSHED\XLSHAPES\GO_2.TXT ----
	ifne	DO_HDR

GO_2
	ShapeHdr	GO_2_P,0,GO_2_F,0,0,0,0,go_scale,0,34,30,10,46,id_0_c,0,0,0,0,<GO_2>
	elseif
GO_2_P
	Pointsb	6
	pb	6,30,-10	;0
	pb	-22,30,-10	;1
	pb	-28,-6,-10	;2
	pb	6,30,10	;3
	pb	-22,30,10	;4
	pb	-28,-6,10	;5
	PointsXb	8
	pb	-14,30,-10	;6
	pb	-34,30,-10	;8
	pb	-4,-30,-10	;10
	pb	-24,-30,-10	;12
	pb	-14,30,10	;14
	pb	-34,30,10	;16
	pb	-4,-30,10	;18
	pb	-24,-30,10	;20

	EndPoints
GO_2_F
	Vizis	17
	Viz	1,2,8,0,0,-127	;0
	Viz	10,12,6,0,0,-127	;1
	Viz	13,11,7,0,0,-127	;2
	Viz	16,5,4,0,0,127	;3
	Viz	3,14,20,0,0,127	;4
	Viz	17,15,19,0,0,127	;5
	Viz	16,4,1,0,-127,0	;6
	Viz	1,4,5,-125,21,0	;7
	Viz	2,5,16,125,21,0	;8
	Viz	12,20,14,125,-21,0	;9
	Viz	0,6,14,0,-127,0	;10
	Viz	0,3,18,-125,21,0	;11
	Viz	12,10,18,0,127,0	;12
	Viz	11,13,21,0,127,0	;13
	Viz	11,19,15,125,-21,0	;14
	Viz	9,17,21,-125,21,0	;15
	Viz	9,7,15,0,-127,0	;16
	BSPInit	GO_2_EBSP
	BSP	9,GO_2_f1,.bsp2
	BSPE	GO_2_f3
.bsp2	BSPE	GO_2_f4

GO_2_f1	Faces
	Face4	4,9,125,-21,0,12,20,14,6
	FendQ
GO_2_f3	Faces
	Face4	4,11,-125,21,0,0,3,18,10
	Face4	4,14,125,-21,0,11,19,15,7
	Face4	6,1,0,0,-127,10,12,6,0
	Face4	6,2,0,0,-127,13,11,7,9
	Face4	6,4,0,0,127,3,14,20,18
	Face4	6,5,0,0,127,17,15,19,21
	Face4	4,10,0,-127,0,0,6,14,3
	Face4	4,12,0,127,0,12,10,18,20
	Face4	4,13,0,127,0,11,13,21,19
	Face4	4,15,-125,21,0,9,17,21,13
	Face4	4,16,0,-127,0,9,7,15,17
	FendQ
GO_2_f4	Faces
	Face3	6,0,0,0,-127,1,2,8
	Face3	6,3,0,0,127,16,5,4
	Face4	4,6,0,-127,0,16,4,1,8
	Face4	4,7,-125,21,0,1,4,5,2
	Face4	4,8,125,21,0,2,5,16,8
	FendQ
GO_2_EBSP
	EndShape

	endc
;--Shape file ----- C:\NSHED\XLSHAPES\GO_3.TXT ----
	ifne	DO_HDR

GO_3
	ShapeHdr	GO_3_P,0,GO_3_F,0,0,0,0,go_scale,0,30,30,10,44,id_0_c,0,0,0,0,<GO_3>
	elseif
GO_3_P
	Pointsb	18
	pb	-2,30,-10	;0
	pb	-10,30,-10	;1
	pb	14,10,-10	;2
	pb	30,10,-10	;3
	pb	-2,0,-10	;4
	pb	14,-10,-10	;5
	pb	30,-10,-10	;6
	pb	-2,-30,-10	;7
	pb	-10,-30,-10	;8
	pb	-2,30,10	;9
	pb	-10,30,10	;10
	pb	14,10,10	;11
	pb	30,10,10	;12
	pb	-2,0,10	;13
	pb	14,-10,10	;14
	pb	30,-10,10	;15
	pb	-2,-30,10	;16
	pb	-10,-30,10	;17
	PointsXb	4
	pb	-30,30,-10	;18
	pb	-30,-30,-10	;20
	pb	-30,30,10	;22
	pb	-30,-30,10	;24

	EndPoints
GO_3_F
	Vizis	21
	Viz	18,1,8,0,0,-127	;0
	Viz	6,21,7,0,0,-127	;1
	Viz	0,19,3,0,0,-127	;2
	Viz	2,5,4,0,0,-127	;3
	Viz	24,17,10,0,0,127	;4
	Viz	16,25,15,0,0,127	;5
	Viz	12,23,9,0,0,127	;6
	Viz	13,14,11,0,0,127	;7
	Viz	20,8,17,0,127,0	;8
	Viz	1,10,17,-127,0,0	;9
	Viz	1,18,22,0,-127,0	;10
	Viz	20,24,22,127,0,0	;11
	Viz	21,25,16,0,127,0	;12
	Viz	21,6,15,-127,0,0	;13
	Viz	7,16,15,67,-108,0	;14
	Viz	0,9,23,0,-127,0	;15
	Viz	23,12,3,-127,0,0	;16
	Viz	3,12,9,67,108,0	;17
	Viz	4,5,14,67,108,0	;18
	Viz	13,11,2,67,-108,0	;19
	Viz	5,2,11,-127,0,0	;20

GO_3_f1	Faces
	Face4	4,9,-127,0,0,1,10,17,8
	Face4	4,14,67,-108,0,7,16,15,6
	Face4	4,17,67,108,0,3,12,9,0
	Face4	4,18,67,108,0,4,5,14,13
	Face4	4,19,67,-108,0,13,11,2,4
	Face4	4,20,-127,0,0,5,2,11,14
	Face4	6,0,0,0,-127,18,1,8,20
	Face3	6,1,0,0,-127,6,21,7
	Face3	6,2,0,0,-127,0,19,3
	Face3	6,3,0,0,-127,2,5,4
	Face4	6,4,0,0,127,24,17,10,22
	Face3	6,5,0,0,127,16,25,15
	Face3	6,6,0,0,127,12,23,9
	Face3	6,7,0,0,127,13,14,11
	Face4	4,8,0,127,0,20,8,17,24
	Face4	4,10,0,-127,0,1,18,22,10
	Face4	4,11,127,0,0,20,24,22,18
	Face4	4,12,0,127,0,21,25,16,7
	Face4	4,13,-127,0,0,21,6,15,25
	Face4	4,15,0,-127,0,0,9,23,19
	Face4	4,16,-127,0,0,23,12,3,19
	Fend
	EndShape

	endc
;--Shape file ----- C:\NSHED\XLSHAPES\GO_4.TXT ----
	ifne	DO_HDR

GO_4
	ShapeHdr	GO_4_P,0,GO_4_F,0,0,0,0,go_scale,0,30,30,10,35,id_0_c,0,0,0,0,<GO_4>
	elseif
GO_4_P
	PointsXb	12
	pb	-4,30,-10	;0
	pb	-14,30,-10	;2
	pb	-30,10,-10	;4
	pb	-30,-10,-10	;6
	pb	-4,-30,-10	;8
	pb	-14,-30,-10	;10
	pb	-4,30,10	;12
	pb	-14,30,10	;14
	pb	-30,10,10	;16
	pb	-30,-10,10	;18
	pb	-4,-30,10	;20
	pb	-14,-30,10	;22

	EndPoints
GO_4_F
	Vizis	16
	Viz	4,2,0,0,0,-127	;0
	Viz	7,11,9,0,0,-127	;1
	Viz	18,22,20,0,0,127	;2
	Viz	17,15,13,0,0,127	;3
	Viz	0,12,20,-127,0,0	;4
	Viz	0,2,14,0,-127,0	;5
	Viz	4,16,14,99,-79,0	;6
	Viz	18,16,4,127,0,0	;7
	Viz	10,22,18,99,79,0	;8
	Viz	10,8,20,0,127,0	;9
	Viz	9,21,13,127,0,0	;10
	Viz	13,15,3,0,-127,0	;11
	Viz	3,15,17,-99,-79,0	;12
	Viz	7,5,17,-127,0,0	;13
	Viz	7,19,23,-99,79,0	;14
	Viz	23,21,9,0,127,0	;15

GO_4_f1	Faces
	Face4	4,4,-127,0,0,0,12,20,8
	Face4	4,10,127,0,0,9,21,13,1
	Face6	6,0,0,0,-127,4,2,0,8,10,6
	Face6	6,1,0,0,-127,7,11,9,1,3,5
	Face6	6,2,0,0,127,18,22,20,12,14,16
	Face6	6,3,0,0,127,17,15,13,21,23,19
	Face4	4,5,0,-127,0,0,2,14,12
	Face4	4,6,99,-79,0,4,16,14,2
	Face4	4,7,127,0,0,18,16,4,6
	Face4	4,8,99,79,0,10,22,18,6
	Face4	4,9,0,127,0,10,8,20,22
	Face4	4,11,0,-127,0,13,15,3,1
	Face4	4,12,-99,-79,0,3,15,17,5
	Face4	4,13,-127,0,0,7,5,17,19
	Face4	4,14,-99,79,0,7,19,23,11
	Face4	4,15,0,127,0,23,21,9,11
	Fend
	EndShape

	endc
;--Shape file ----- C:\NSHED\XLSHAPES\GO_5.TXT ----
	ifne	DO_HDR

GO_5
	ShapeHdr	GO_5_P,0,GO_5_F,0,0,0,0,go_scale,0,30,30,10,44,id_0_c,0,0,0,0,<GO_5>
	elseif
GO_5_P
	Pointsb	6
	pb	14,18,-10	;0
	pb	-2,-30,-10	;1
	pb	-10,-30,-10	;2
	pb	14,18,10	;3
	pb	-2,-30,10	;4
	pb	-10,-30,10	;5
	PointsXb	4
	pb	10,30,-10	;6
	pb	-30,-30,-10	;8
	pb	-10,30,10	;10
	pb	-30,-30,10	;12

	EndPoints
GO_5_F
	Vizis	11
	Viz	1,0,9,0,0,-127	;0
	Viz	7,6,2,0,0,-127	;1
	Viz	13,3,4,0,0,127	;2
	Viz	12,5,11,0,0,127	;3
	Viz	9,13,4,0,127,0	;4
	Viz	0,3,13,-120,-40,0	;5
	Viz	1,4,3,120,-40,0	;6
	Viz	6,11,5,-120,40,0	;7
	Viz	8,2,5,0,127,0	;8
	Viz	8,12,10,120,-40,0	;9
	Viz	6,7,10,0,-127,0	;10

GO_5_f1	Faces
	Face4	4,6,120,-40,0,1,4,3,0
	Face4	4,7,-120,40,0,6,11,5,2
	Face3	6,0,0,0,-127,1,0,9
	Face4	6,1,0,0,-127,7,6,2,8
	Face3	6,2,0,0,127,13,3,4
	Face4	6,3,0,0,127,12,5,11,10
	Face4	4,4,0,127,0,9,13,4,1
	Face4	4,5,-120,-40,0,0,3,13,9
	Face4	4,8,0,127,0,8,2,5,12
	Face4	4,9,120,-40,0,8,12,10,7
	Face4	4,10,0,-127,0,6,7,10,11
	Fend
	EndShape

	endc
;--Shape file ----- C:\NSHED\XLSHAPES\GO_6.TXT ----
	ifne	DO_HDR

GO_6
	ShapeHdr	GO_6_P,0,GO_6_F,0,0,0,0,go_scale,0,30,30,10,44,id_0_c,0,0,0,0,<GO_6>
	elseif
GO_6_P
	Pointsb	24
	pb	-2,30,-10	;0
	pb	-10,30,-10	;1
	pb	-2,10,-10	;2
	pb	14,10,-10	;3
	pb	-2,2,-10	;4
	pb	14,2,-10	;5
	pb	30,-8,-10	;6
	pb	30,-20,-10	;7
	pb	-2,-30,-10	;8
	pb	-10,-30,-10	;9
	pb	14,-30,-10	;10
	pb	-30,-30,-10	;11
	pb	-2,30,10	;12
	pb	-10,30,10	;13
	pb	-2,10,10	;14
	pb	14,10,10	;15
	pb	-2,2,10	;16
	pb	14,2,10	;17
	pb	30,-8,10	;18
	pb	30,-20,10	;19
	pb	-2,-30,10	;20
	pb	-10,-30,10	;21
	pb	14,-30,10	;22
	pb	-30,-30,10	;23
	PointsXb	2
	pb	-30,30,-10	;24
	pb	-30,30,10	;26

	EndPoints
GO_6_F
	Vizis	20
	Viz	24,1,9,0,0,-127	;0
	Viz	7,10,8,0,0,-127	;1
	Viz	0,25,3,0,0,-127	;2
	Viz	23,21,13,0,0,127	;3
	Viz	18,17,16,0,0,127	;4
	Viz	14,15,27,0,0,127	;5
	Viz	1,24,26,0,-127,0	;6
	Viz	11,23,26,127,0,0	;7
	Viz	11,9,21,0,127,0	;8
	Viz	1,13,21,-127,0,0	;9
	Viz	8,20,16,127,0,0	;10
	Viz	8,10,22,0,127,0	;11
	Viz	10,7,19,-67,108,0	;12
	Viz	18,19,7,-127,0,0	;13
	Viz	6,5,17,-67,-108,0	;14
	Viz	5,4,16,0,-127,0	;15
	Viz	2,3,15,0,127,0	;16
	Viz	25,27,15,-99,79,0	;17
	Viz	0,12,27,0,-127,0	;18
	Viz	14,12,0,127,0,0	;19
	BSPInit	GO_6_EBSP
	BSP	10,GO_6_f1,.bsp2
	BSPE	GO_6_f3
.bsp2	BSPE	GO_6_f4

GO_6_f1	Faces
	Face4	4,10,127,0,0,8,20,16,4
	FendQ
GO_6_f3	Faces
	Face4	4,15,0,-127,0,5,4,16,17
	Face4	4,16,0,127,0,2,3,15,14
	Face4	4,14,-67,-108,0,6,5,17,18
	Face4	4,17,-99,79,0,25,27,15,3
	Face6	6,1,0,0,-127,7,10,8,4,5,6
	Face4	6,2,0,0,-127,0,25,3,2
	Face6	6,4,0,0,127,18,17,16,20,22,19
	Face4	6,5,0,0,127,14,15,27,12
	Face4	4,11,0,127,0,8,10,22,20
	Face4	4,12,-67,108,0,10,7,19,22
	Face4	4,13,-127,0,0,18,19,7,6
	Face4	4,18,0,-127,0,0,12,27,25
	Face4	4,19,127,0,0,14,12,0,2
	FendQ
GO_6_f4	Faces
	Face4	6,0,0,0,-127,24,1,9,11
	Face4	6,3,0,0,127,23,21,13,26
	Face4	4,6,0,-127,0,1,24,26,13
	Face4	4,7,127,0,0,11,23,26,24
	Face4	4,8,0,127,0,11,9,21,23
	Face4	4,9,-127,0,0,1,13,21,9
	FendQ
GO_6_EBSP
	EndShape

	endc


;--Shape file ----- C:\NSHED\XLSHAPES\maptest.txt ----
	ifne	DO_HDR

maptest
	trackHdr	maptest_P,0,maptest_F,0,0,0,0,0,0,60,0,63,87,default_c,0,0,0,0,<maptest>
	elseif
maptest_P
	PointsXb	2
	pb	-60,0,-60	;0
	pb	-60,0,63	;2

	EndPoints
maptest_F
	Vizis	1
	Viz	2,0,1,0,127,0	;0

maptest_f1	Faces
	Face4	178,0,0,127,0,3,2,0,1
	Fend
	EndShape

	endc

;--Shape file ----- C:\NSHED\XLSHAPES\TRK_1_1.TXT ----
	ifne	DO_HDR

TRK_1_1
	ShapeHdr	TRK_1_1_P,0,TRK_1_1_F,0,0,0,0,2,0,32,60,50,80,id_0_c,0,0,0,0,<TRK_1_1>
	elseif
TRK_1_1_P
	PointsXb	13
	pb	32,-6,-50	;0
	pb	32,-30,-50	;2
	pb	29,-40,-50	;4
	pb	19,-60,-50	;6
	pb	13,-60,-20	;8
	pb	21,-40,-10	;10
	pb	32,-6,0	;12
	pb	32,6,8	;14
	pb	32,6,20	;16
	pb	32,-6,20	;18
	pb	32,-20,20	;20
	pb	-16,-30,30	;22
	pb	8,6,35	;24

	EndPoints
TRK_1_1_F
	Vizis	20
	Viz	11,10,23,0,123,31	;0
	Viz	23,10,4,-119,36,24	;1
	Viz	2,20,23,-73,103,15	;2
	Viz	2,0,12,-127,0,0	;3
	Viz	9,8,10,0,57,114	;4
	Viz	8,6,4,-112,56,22	;5
	Viz	22,21,3,73,103,15	;6
	Viz	21,19,13,127,0,0	;7
	Viz	3,5,11,119,36,24	;8
	Viz	11,5,7,112,56,22	;9
	Viz	7,6,8,0,127,0	;10
	Viz	2,4,6,0,0,-127	;11
	Viz	1,13,12,0,-127,0	;12
	Viz	23,20,18,-67,0,108	;13
	Viz	16,18,12,-127,0,0	;14
	Viz	25,17,19,67,0,108	;15
	Viz	15,13,19,127,0,0	;16
	Viz	16,14,15,0,-127,0	;17
	Viz	13,15,14,0,-70,-106	;18
	Viz	22,23,24,0,17,126	;19

TRK_1_1_f1	Faces
	Face4	10,0,0,123,31,11,10,23,22
	Face4	10,1,-119,36,24,23,10,4,2
	Face3	10,2,-73,103,15,2,20,23
	Face4	13,4,0,57,114,9,8,10,11
	Face4	13,5,-112,56,22,8,6,4,10
	Face3	10,6,73,103,15,22,21,3
	Face4	10,8,119,36,24,3,5,11,22
	Face4	13,9,112,56,22,11,5,7,9
	Face4	4,12,0,-127,0,1,13,12,0
	Face4	4,18,0,-70,-106,13,15,14,12
	Face5	10,3,-127,0,0,2,0,12,18,20
	Face5	10,7,127,0,0,21,19,13,1,3
	Face4	10,10,0,127,0,7,6,8,9
	Face8	10,11,0,0,-127,2,4,6,7,5,3,1,0
	Face5	10,13,-67,0,108,23,20,18,16,24
	Face4	10,14,-127,0,0,16,18,12,14
	Face5	10,15,67,0,108,25,17,19,21,22
	Face4	10,16,127,0,0,15,13,19,17
	Face6	4,17,0,-127,0,16,14,15,17,25,24
	Face4	10,19,0,17,126,22,23,24,25
	Fend
	EndShape

	endc
;--Shape file ----- C:\NSHED\XLSHAPES\TRK_1_2.TXT ----
	ifne	DO_HDR

TRK_1_2
	ShapeHdr	TRK_1_2_P,0,TRK_1_2_F,0,0,0,0,2,0,32,80,105,136,id_0_c,0,0,0,0,<TRK_1_2>
	elseif
TRK_1_2_P
	PointsXb	12
	pb	32,-6,-105	;0
	pb	10,-10,-105	;2
	pb	32,-10,-105	;4
	pb	15,-15,-105	;6
	pb	32,-15,-105	;8
	pb	32,-80,-105	;10
	pb	32,-6,-75	;12
	pb	32,6,-67	;14
	pb	32,6,62	;16
	pb	32,-6,70	;18
	pb	32,-6,105	;20
	pb	32,-80,105	;22

	EndPoints
TRK_1_2_F
	Vizis	14
	Viz	18,12,14,-127,0,0	;0
	Viz	10,0,12,-127,0,0	;1
	Viz	17,15,13,127,0,0	;2
	Viz	23,21,19,127,0,0	;3
	Viz	18,16,17,0,-70,106	;4
	Viz	20,21,23,0,0,127	;5
	Viz	22,23,11,0,127,0	;6
	Viz	11,1,0,0,0,-127	;7
	Viz	8,6,2,0,0,-127	;8
	Viz	5,3,7,0,0,-127	;9
	Viz	12,0,1,0,-127,0	;10
	Viz	13,15,14,0,-70,-106	;11
	Viz	14,15,17,0,-127,0	;12
	Viz	20,18,19,0,-127,0	;13

TRK_1_2_f1	Faces
	Face4	4,10,0,-127,0,12,0,1,13
	Face4	4,13,0,-127,0,20,18,19,21
	Face4	4,4,0,-70,106,18,16,17,19
	Face4	4,11,0,-70,-106,13,15,14,12
	Face4	1,6,0,127,0,22,23,11,10
	Face4	10,0,-127,0,0,18,12,14,16
	Face6	1,1,-127,0,0,10,0,12,18,20,22
	Face4	10,2,127,0,0,17,15,13,19
	Face6	1,3,127,0,0,23,21,19,13,1,11
	Face4	1,5,0,0,127,20,21,23,22
	Face4	1,7,0,0,-127,11,1,0,10
	Face4	50,8,0,0,-127,8,6,2,4
	Face4	50,9,0,0,-127,5,3,7,9
	Face4	4,12,0,-127,0,14,15,17,16
	Fend
	EndShape

	endc


