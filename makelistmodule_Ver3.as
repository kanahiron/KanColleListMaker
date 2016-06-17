#module "mod_vpx"//VRAMのモジュール

#deffunc VRAMset
	dim rgb
	;dim vramA
	mref vramA,66
	winx=ginfo_winx+(ginfo_sx-ginfo_winx)	//サイズ可変ウィンドウに対応
	winym=ginfo_winy-1+(ginfo_sy-ginfo_winy)	//一番上のライン
	winx2=((winx*3+3)&-4)	//VRAM横1ラインのサイズ
	vramptr=varptr(vramA)
return

#define global vpxget(%1=0, %2=0)	p@mod_vpx=(winym@mod_vpx-(%2))*winx2@mod_vpx+(%1)*3
#define global ctype vpxset(%1=0)	peek(vramA@mod_vpx,p@mod_vpx+(%1))

//おまけ
//vpxrgb x,y でvpx_rgbに24ビットで色が返る
//色毎のデータはvpx_r、vpx_g、vpx_bで取得
#define global vpxrgb(%1=0, %2=0) memcpy rgb@mod_vpx,vramA@mod_vpx,3,0,(winym@mod_vpx-(%2))*winx2@mod_vpx+(%1)*3
#define global vpx_rgb (rgb@mod_vpx)
#define global vpx_r ((rgb@mod_vpx>>16))
#define global vpx_g ((rgb@mod_vpx>>8)&$ff)
#define global vpx_b (rgb@mod_vpx&$ff)

#global
#module makelistmodule

#deffunc init_makelist

	dim verticallinedeta,19,3
	verticallinedeta(0,0) = 0xC4B658, 0xC9BD56, 0xC2B546, 0xC3B63E, 0xBBAD2E, 0xB7AA23, 0xBCAE24, 0xB6A91A, 0xBBAE1D, 0xBAA629, 0xB7A326, 0xB6A225, 0xBFAB2E, 0xC7B336, 0xC0AC2F, 0xBAA629, 0xC2AE31, 0xB6A225, 0xC2AE31
	verticallinedeta(0,1) = 0xCABA51, 0xCCBC4A, 0xCFBE47, 0xC6B338, 0xC3B033, 0xB8A429, 0xC3AF34, 0xC4B035, 0xBDA92E, 0xBCA82D, 0xBAA62B, 0xB7A328, 0xB8A429, 0xB6A227, 0xB7A328, 0xB7A328, 0xBAA62B, 0xC3AF34, 0xC8B439
	verticallinedeta(0,2) = 0xE0CA60, 0xCEB949, 0xCCB747, 0xC6B141, 0xC4AF3F, 0xCBB646, 0xCEB949, 0xC8B343, 0xC5B040, 0xCBB646, 0xBFAA3A, 0xC3AE3E, 0xD4BF4F, 0xD4BF4F, 0xC6B141, 0xCBB646, 0xDFCA5A, 0xD8C03F, 0xD1BC3C
	
	dim verticallinexy,2,3
	verticallinexy(0,0) = 109,23
	verticallinexy(0,1) = 110,27
	verticallinexy(0,2) = 111,31
	
	dim tsscap,4
	dim mxy,2
	dim mxy_,2
	dim sti
	dim cliflag
	dim ccolor,3
	
return

#deffunc getkancollewindowposauto int imageid,array sscap

	gsel imageid
	vramset
	 
	sw = ginfo(12)
	sh = ginfo(13)

	sscap(0) = 0,0,0,0
	tsscap(0) = 0,0,0,0
	count = 0
	breakf = 0
	xcnt = 0
	ycnt = 0
	ypos = 0
	linep = 0

	repeat	sw/3
		xcnt = cnt*3
		repeat sh
			ycnt = cnt
			vpxrgb xcnt,ycnt
		;	dialog strf("%06X %06X\n%06X %06X\n%06X %06X",verticallinedeta(0,0),vpx_rgb,verticallinedeta(0,1),vpx_rgb,verticallinedeta(0,2),vpx_rgb),2
			if stat = 7:end
			linep = -1
			if verticallinedeta(0,0) = vpx_rgb:linep = 0
			if verticallinedeta(0,1) = vpx_rgb:linep = 1
			if verticallinedeta(0,2) = vpx_rgb:linep = 2
			if linep = -1:continue
			
			tsscap(0) = xcnt-verticallinexy(0,linep),ycnt-verticallinexy(1,linep)
			;dialog ""+tsscap(0)+" "+tsscap(1)
			color 255,0,0
			repeat 19
				vpxrgb tsscap(0)+verticallinexy(0,0),tsscap(1)+verticallinexy(1,0)+cnt
				;pset tsscap(0)+verticallinexy(0,0),tsscap(1)+verticallinexy(1,0)+cnt
				if verticallinedeta(cnt,0) = vpx_rgb:count++
				vpxrgb tsscap(0)+verticallinexy(0,1),tsscap(1)+verticallinexy(1,1)+cnt
				;pset tsscap(0)+verticallinexy(0,1),tsscap(1)+verticallinexy(1,1)+cnt
				if verticallinedeta(cnt,1) = vpx_rgb:count++
				vpxrgb tsscap(0)+verticallinexy(0,2),tsscap(1)+verticallinexy(1,2)+cnt
				;pset tsscap(0)+verticallinexy(0,2),tsscap(1)+verticallinexy(1,2)+cnt
				if verticallinedeta(cnt,2) = vpx_rgb:count++
				;wait 100
			loop
			;dialog ""+count
	
			if count >= 6:breakf = 1
			count = 0

			if breakf :break
			await
		loop
		if breakf :break
	loop
	
	if breakf {
		sscap(0) = tsscap(0),tsscap(1)
		sscap(2) = sscap(0)+800,sscap(1)+480
	}

return

#deffunc getkancollewindowposmanual int imageid1,array sscap,int imageid2

	
	sscap(0) = 0,0,0,0
	tsscap(0) = 0,0,0,0
	mxy(0) = 0,0
	mxy_(0) = 0,0
	cliflag = 0
	ccolor(0) = 0,0,0

	gsel imageid2,-1
	width ginfo(20),ginfo(21),0,0
	gsel imageid2,2
	
	repeat
		redraw 0
		pos 0,0
		gcopy imageid1,0,0,ginfo(20),ginfo(21)
		color
		boxf 0,0,950,60
		color 255,255,255
		pos 10,10
		mes "艦これの画面を囲うようにドラッグして下さい Escキーでキャンセル"
		color
	
		stick sti,256
		if sti = 256{
			if cliflag = 0{
				cliflag = 1
				mxy(0) = mousex
				mxy(1) = mousey
				pget mxy(0),mxy(1)
				ccolor(0) = ginfo_r ,ginfo_g, ginfo_b
			}
			if cliflag = 1{
				color 0,255,0
				boxf mxy(0),mxy(1),mousex,mousey
				color
			}
		}
			
		if (sti = 0 & cliflag = 1){
			cliflag = 0
			mxy_(0) = mousex
			mxy_(1) = mousey
			dialog "この位置で決定しますか？",2,"確認"
			if stat = 6:break
		}
			
		if (sti = 128){
			break
		}
			
		redraw 1
		await 17
	loop
		
	gsel imageid2,-1
		
	if mxy(0) < mxy_(0) {
		tsscap(0) = mxy(0)
		tsscap(2) = mxy_(0)
	} else {
		tsscap(0) = mxy_(0)
		tsscap(2) = mxy(0)
	}
		
	if mxy(1) < mxy_(1) {
		tsscap(1) = mxy(1)
		tsscap(3) = mxy_(1)
	} else {
		tsscap(1) = mxy_(1)
		tsscap(3) = mxy(1)
	}
	
	;dialog strf("%d %d %d %d",tsscap(0),tsscap(1),tsscap(2),tsscap(3))
		
	gsel imageid1
	
	repeat 300
		pget tsscap(0)+cnt,tsscap(1)+200
		if (ccolor(0) != ginfo_r) | (ccolor(1) != ginfo_g) | (ccolor(2) != ginfo_b) {
			sscap(0) = tsscap(0)+cnt
			break
		}
	loop
		
	repeat 300
		pget tsscap(2)-cnt,tsscap(3)-200
		if (ccolor(0) != ginfo_r) | (ccolor(1) != ginfo_g) | (ccolor(2) != ginfo_b) {
			sscap(2) = tsscap(2)-cnt+1
			break
		}
	loop
		
	repeat 300
		pget tsscap(0)+200,tsscap(1)+cnt
		if (ccolor(0) != ginfo_r) | (ccolor(1) != ginfo_g) | (ccolor(2) != ginfo_b) {
			sscap(1) = tsscap(1)+cnt
			break
		}
	loop
	
	repeat 300
		pget tsscap(2)-200,tsscap(3)-cnt
		if (ccolor(0) != ginfo_r) | (ccolor(1) != ginfo_g) | (ccolor(2) != ginfo_b) {
			sscap(3) = tsscap(3)-cnt+1
			break
		}
	loop
	
	;dialog strf("%d %d %d %d",sscap(0),sscap(1),sscap(2),sscap(3))

return

#global

