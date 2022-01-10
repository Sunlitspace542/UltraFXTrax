
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
	inccru	sprites,data\obj-1.ccr
	inccru	bgetestccr,data\e-test.ccr
	inccru	bgetestpcr,data\e-test.pcr
	inccru	bgetest2ccr,data\e-test2.ccr
	inccru	bgetest2pcr,data\e-test2.pcr
	inccru	bgfoxccr,data\fox.ccr
	inccru	bgfoxpcr,data\fox.pcr
	inccru	bgbmccr,data\b-m.ccr

	endc
	bankend	20

	bank	21
	inccru	bgspaceccr,data\space.ccr
	inccru	bglastpcr,data\last.pcr
	inccru	bgfsbg3ccr,data\fs-bg3.ccr
	inccru	bgfsnipcr,data\fs-ni.pcr
	inccru	bgtsspcr,data\t-ss.pcr
	bankend	21




	ifeq	1
	bank	22
	inccru	bglsbccr,data\lsb.ccr
	inccru	bgf1ccr,data\f-1.ccr
	inccru	bgbholeccr,data\b-hole.ccr
	inccru	bgtfspcr,data\t-f-s.pcr
	inccru	bglsbpcr,data\lsb.pcr
	inccru	fobjccr,data\f-obj.ccr
	inccru	bgbholepcr,data\b-hole.pcr
	inccru	bgholeapcr,data\hole-a.pcr
	inccru	bgtsppcr,data\t-sp.pcr
	inccru	bgtstpcr,data\t-st.pcr
	bankend	22
	endc

	bank	23
	inccru	bgcppcr,data\cp.pcr
	inccru	bgtstccr,data\t-st.ccr
	inccru	bgtspccr,data\t-sp.ccr
	inccru	bgcmccr,data\c-m.ccr
	ifne	janglish
	inccru	bgcontccr,data\cont.ccr
	inccru	bgcontpcr,data\cont.pcr
	fileslog	data\cont-2.ccr
	fileslog	data\cont-2.pcr
	elseif
	inccru	bgcontccr,data\cont-2.ccr
	inccru	bgcontpcr,data\cont-2.pcr
	fileslog	data\cont.ccr
	fileslog	data\cont.pcr
	endc
	inccru	bgcpccr,data\cp.ccr
facedata	inccolfile	data\face.cgx,0,360
	inccru	allcolscru,data\gfx\allcols.pac

	inccru	bgmccr,data\m.ccr

	bankend	23


;------------------------------------------------------------------

firstsndbnk	=	24
musicsize	=	0
	incsnd	xlsnd0,xlsnd\xlsnd0.bin

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