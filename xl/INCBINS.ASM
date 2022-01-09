
	include	header.inc

	incpublics	incbins.ext


	bank	18
msprites1	incbinfile	msprites\sprites1.dat
mworldspr	equ	msprites1
	bankend	18

	bank	19
msprites2	incbinfile	msprites\sprites2.dat
	bankend	19

	bank	20
	incfile	mdata.mc
msprites3
	ifeq	1
	inccru	bgdemoccr,data\demo.ccr
	inccru	bgdemopcr,data\demo.pcr
	inccru	bgholeaccr,data\hole-a.ccr
	inccru	bgbccr,data\b.ccr
	inccru	bgbpcr,data\b.pcr
	inccru	sprites,data\obj-1.ccr
	inccru	bgetestccr,data\e-test.ccr
	inccru	bgetestpcr,data\e-test.pcr
	inccru	bgetest2ccr,data\e-test2.ccr
	inccru	bgetest2pcr,data\e-test2.pcr
	inccru	bgfoxccr,data\fox.ccr
	inccru	bgfoxpcr,data\fox.pcr
	inccru	bgbmccr,data\b-m.ccr
	inccru	bgstpccr,data\st-p.ccr
	inccru	bg23hpcr,data\2-3h.pcr
	endc
	bankend	20

	bank	21
	inccru	bgstppcr,data\st-p.pcr
	inccru	bg22ccr,data\2-2.ccr
	inccru	bg23ccr,data\2-3.ccr
	inccru	bg23bccr,data\2-3b.ccr
	inccru	bgstarsccr,data\stars.ccr
	inccru	bg13bccr,data\1-3-b.ccr
	inccru	bgspaceccr,data\space.ccr
	inccru	bglastpcr,data\last.pcr
	inccru	bg32ccr,data\3-2.ccr
	inccru	bgfsbg3ccr,data\fs-bg3.ccr
	inccru	bg33ccr,data\3-3.ccr
	inccru	mapccr,data\map.ccr
	inccru	bgfsnipcr,data\fs-ni.pcr
	inccru	bgtsspcr,data\t-ss.pcr
	inccru	bg34ccr,data\3-4.ccr
	bankend	21




	ifeq	1
	bank	22
	inccru	bg22pcr,data\2-2.pcr
	inccru	bglsbccr,data\lsb.ccr
	inccru	bgf1ccr,data\f-1.ccr
	inccru	bgbholeccr,data\b-hole.ccr
	inccru	bgtfspcr,data\t-f-s.pcr
	inccru	bg23pcr,data\2-3.pcr
	inccru	bg23bpcr,data\2-3b.pcr
	inccru	mappcr,data\map.pcr
	inccru	bgstarspcr,data\stars.pcr
	inccru	bg32pcr,data\3-2.pcr
	inccru	bg13bpcr,data\1-3-b.pcr
	inccru	bg13pcr,data\1-3.pcr
	inccru	bg14pcr,data\1-4.pcr
	inccru	bg14ccr,data\1-4.ccr
	inccru	bg33pcr,data\3-3.pcr
	inccru	bg34pcr,data\3-4.pcr
	inccru	bglsbpcr,data\lsb.pcr
	inccru	fobjccr,data\f-obj.ccr
	inccru	bgbholepcr,data\b-hole.pcr
	inccru	bgholeapcr,data\hole-a.pcr
	inccru	bgtsppcr,data\t-sp.pcr
	inccru	bg24pcr,data\2-4.pcr
	inccru	bgtstpcr,data\t-st.pcr
	bankend	22
	endc

	bank	23
	inccru	dogpcr,data\dog.pcr
	inccru	bgcppcr,data\cp.pcr
	inccru	bgtstccr,data\t-st.ccr
	inccru	bgtspccr,data\t-sp.ccr
	inccru	bgcmccr,data\c-m.ccr
	ifne	janglish
	inccru	bgti3ccr,data\ti-3.ccr
	inccru	bgti3pcr,data\ti-3.pcr
	inccru	bgcontccr,data\cont.ccr
	inccru	bgcontpcr,data\cont.pcr
	fileslog	data\cont-2.ccr
	fileslog	data\cont-2.pcr
	fileslog	data\ti-3-us.pcr
	fileslog	data\ti-3-us.ccr
	elseif
	inccru	bgcontccr,data\cont-2.ccr
	inccru	bgcontpcr,data\cont-2.pcr
	inccru	bgti3ccr,data\ti-3-us.ccr
	inccru	bgti3pcr,data\ti-3-us.pcr
	fileslog	data\cont.ccr
	fileslog	data\cont.pcr
	fileslog	data\ti-3.pcr
	fileslog	data\ti-3.ccr
	endc
	inccru	bg24ccr,data\2-4.ccr
	inccru	bgcpccr,data\cp.ccr
facedata	inccolfile	data\face.cgx,0,360
	inccru	allcolscru,data\gfx\allcols.pac

	inccru	bgmccr,data\m.ccr

	bankend	23

;------------------------------------------------------------------

firstsndbnk	=	24
musicsize	=	0
	incsnd	xlsnd0,xlsnd\xlsnd0.bin
	incsnd	sound0,snd\sgsound6.bin
	incsnd	sound1,snd\sgsound6.bin
	incsnd	sound2,snd\sgsound6.bin
	incsnd	sound3,snd\sgsound6.bin
	incsnd	sound4,snd\sgsound6.bin
	incsnd	sound5,snd\sgsound6.bin
	incsnd	sound6,snd\sgsound6.bin
	incsnd	sound7,snd\sgsound6.bin
	incsnd	sound8,snd\sgsound6.bin
	incsnd	sound9,snd\sgsound6.bin
	incsnd	sounda,snd\sgsound6.bin
	incsnd	bgma,snd\sgbgma.bin
	incsnd	bgmb,snd\sgbgmb.bin
	incsnd	bgmc,snd\sgbgmc.bin
	incsnd	bgmo,snd\sgbgmo.bin
	incsnd	bgme,snd\sgbgme.bin
	incsnd	bgmf,snd\sgbgmf.bin
	incsnd	bgmg,snd\sgbgmg.bin
	incsnd	bgmh,snd\sgbgmh.bin
	incsnd	bgmi,snd\sgbgmi.bin
	incsnd	bgmk,snd\sgbgmk.bin
	incsnd	bgmp,snd\sgbgmp.bin
	incsnd	bgm1,snd\sgbgm1.bin
	incsnd	bgm4,snd\sgbgm4.bin
	incsnd	bgm5,snd\sgbgm5.bin
	incsnd	bgm6,snd\sgbgm6.bin
	incsnd	bgm8,snd\sgbgm8.bin
	incsnd	bgm9,snd\sgbgm9.bin
	incsnd	bgm10,snd\sgbgm10.bin

	ifne	janglish
	inccru	obj2ccr,data\obj-2.ccr
	fileslog data\obj-3.ccr
	elseif
	inccru	obj2ccr,data\obj-3.ccr
	fileslog data\obj-2.ccr
	endc

	printf	:$*,"%n"

	ifgt	@-$100000
	PRINTF	"%N%N  MORE THAN 8 MEGA-BITS OF ROM USED!! %N%N"
	FAIL
	endc


	fileslog	data\gfx\bg2-a.col
	fileslog	data\gfx\bg2-b.col
	fileslog	data\gfx\bg2-c.col
	fileslog	data\gfx\bg2-d.col
	fileslog	data\gfx\bg2-e.col
	fileslog	data\gfx\bg2-f.col
	fileslog	data\gfx\bg2-g.col
	fileslog	data\gfx\t-m.col
	fileslog	data\gfx\t-m-2.col
	fileslog	data\gfx\t-m-3.col
	fileslog	data\gfx\t-m-4.col
	fileslog	data\gfx\b-m.col
	fileslog	data\gfx\light.col
	fileslog	data\gfx\space.col
	fileslog	data\gfx\stars.col
	fileslog	data\gfx\cp.col
	fileslog	data\gfx\cp-us.col
	fileslog	data\gfx\hole.col
	fileslog	data\gfx\l.col
	fileslog	data\gfx\e-test0.col
	fileslog	data\gfx\e-test.col
	fileslog	data\gfx\obj-1.col



bg22pcr
bglsbccr
bgf1ccr
bgbholeccr
bgtfspcr
bg23pcr
bg23bpcr
mappcr
bgstarspcr
bg32pcr
bg13bpcr
bg13pcr
bg14pcr
bg14ccr
bg33pcr
bg34pcr
bglsbpcr
fobjccr
bgbholepcr
bgholeapcr
bgtsppcr
bg24pcr
bgtstpcr
