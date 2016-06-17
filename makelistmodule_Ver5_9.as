
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


#module
#deffunc chgbm int bpp
	mref bm,67
	if bpp==0{
		GetDC 0
		hdisp=stat
		CreateCompatibleBitmap hdisp, bm.1, bm.2
		hnewbm=stat
		ReleaseDC 0,hdisp
		bm.5=0
	}else{
		dupptr bminfo,bm.6,40
		wpoke bminfo,14,bpp
		bminfo.5=0
		CreateDIBSection 0,bm.6,0,varptr(bm.5),0,0
		hnewbm=stat
	}
	SelectObject hdc,hnewbm
	DeleteObject bm.7
	bm.7=hnewbm
	bm.67=(bm.1*bpp+31)/32*4
	bm.16=bm.67*bm.2
return
#global


#module makelistmodule

#deffunc init_makelist array disinfo_

	dim verticallinedeta,19,3
	verticallinedeta(0,0) = 0xC4B658, 0xC9BD56, 0xC2B546, 0xC3B63E, 0xBBAD2E, 0xB7AA23, 0xBCAE24, 0xB6A91A, 0xBBAE1D, 0xBAA629, 0xB7A326, 0xB6A225, 0xBFAB2E, 0xC7B336, 0xC0AC2F, 0xBAA629, 0xC2AE31, 0xB6A225, 0xC2AE31
	verticallinedeta(0,1) = 0xCABA51, 0xCCBC4A, 0xCFBE47, 0xC6B338, 0xC3B033, 0xB8A429, 0xC3AF34, 0xC4B035, 0xBDA92E, 0xBCA82D, 0xBAA62B, 0xB7A328, 0xB8A429, 0xB6A227, 0xB7A328, 0xB7A328, 0xBAA62B, 0xC3AF34, 0xC8B439
	verticallinedeta(0,2) = 0xE0CA60, 0xCEB949, 0xCCB747, 0xC6B141, 0xC4AF3F, 0xCBB646, 0xCEB949, 0xC8B343, 0xC5B040, 0xCBB646, 0xBFAA3A, 0xC3AE3E, 0xD4BF4F, 0xD4BF4F, 0xC6B141, 0xCBB646, 0xDFCA5A, 0xD8C03F, 0xD1BC3C
	
	dim verticallinexy,2,3
	verticallinexy(0,0) = 109,23
	verticallinexy(0,1) = 110,27
	verticallinexy(0,2) = 111,31

	dim horizontallinedeta,16
	horizontallinedeta(0) = 0x00BFAB4A ,0x00B5A03E ,0x00A48D2A ,0x00A18924 ,0x00A68C28 ,0x009A801C ,0x00AF901F ,0x009A7B0A ,0x00977807 ,0x00947504 ,0x00917201 ,0x009D7E0D ,0x00947603 ,0x009B7D0A ,0x00927401 ,0x009D7F0C
	;horizontallinedeta(0) = 0x00bfab4a
	
	dim tsscap,4
	dim mxy,2
	dim mxy_,2
	dim mwh,2
	dim sti
	dim cliflag
	dim ccolor,3
	dim nid
	dim disinfo,4
	
	repeat 4
		disinfo(cnt) = disinfo_(cnt)
	loop
	
	//4ディスプレイ全体の最左座標
	//5ディスプレイ全体の最上座標
	//6ディスプレイ全体の横幅
	//7ディスプレイ全体の縦幅

	
return

#defcfunc homeport int hmid

	count = 0
	nid = ginfo(3)
	
	gsel hmid
	vramset

	repeat 19
		vpxrgb verticallinexy(0,0),verticallinexy(1,0)+cnt
		if verticallinedeta(cnt,0) = vpx_rgb:count++
	loop
	if count = 19{
		count = 0
		gsel nid
		return 1
	} else {
		gsel nid
		count = 0
	}

return 0

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

	repeat sw/3
		xcnt = cnt*3
		repeat sh
			ycnt = cnt
			vpxrgb xcnt,ycnt

			linep = -1
			if verticallinedeta(0,0) = vpx_rgb:linep = 0
			if verticallinedeta(0,1) = vpx_rgb:linep = 1
			if verticallinedeta(0,2) = vpx_rgb:linep = 2
			if linep = -1:continue
			
			tsscap(0) = xcnt-verticallinexy(0,linep),ycnt-verticallinexy(1,linep)

			color 255,0,0
			repeat 19
				vpxrgb tsscap(0)+verticallinexy(0,0),tsscap(1)+verticallinexy(1,0)+cnt
				if verticallinedeta(cnt,0) = vpx_rgb:count++
				
				vpxrgb tsscap(0)+verticallinexy(0,1),tsscap(1)+verticallinexy(1,1)+cnt
				if verticallinedeta(cnt,1) = vpx_rgb:count++
				
				vpxrgb tsscap(0)+verticallinexy(0,2),tsscap(1)+verticallinexy(1,2)+cnt
				if verticallinedeta(cnt,2) = vpx_rgb:count++
			loop
	
			if count >= 6:breakf = 1
			count = 0

			if breakf :break
			await
		loop
		if breakf :break
	loop
	
	if breakf {
		sscap(0) = tsscap(0)+disinfo(0),tsscap(1)+disinfo(1)
		sscap(2) = sscap(0)+800,sscap(1)+480
	}

return

#deffunc getkancollewindowposauto2 int imageid,array sscap

	gsel imageid
	mref vram,66
	 
	sw = ginfo(12)
	sh = ginfo(13)

	count = 0
	breakf = 0
	xcnt = 0
	ycnt = 0
	ypos = 0
	linep = 0

	repeat sw*sh
		rootcnt = cnt
		if (vram(cnt) == horizontallinedeta(0)){
			
			repeat 7,1
				if (vram(rootcnt+cnt) == horizontallinedeta(cnt)){
					count++
				}
			loop
			;dialog ""+count
			if count = 7{
				xx = (rootcnt\sw)
				yy = ((sh-1)-rootcnt/sw)
				sscap(0) = xx+disinfo(0)-26,yy+disinfo(1)-105
				sscap(2) = sscap(0)+800,sscap(1)+480
				break
			}
			continue rootcnt+count
		}
	loop


return


#deffunc getkancollewindowposmanual int imageid1,array sscap,int imageid3

	sscap(0) = 0,0,0,0
	tsscap(0) = 0,0,0,0
	mxy(0) = 0,0
	mxy_(0) = 0,0
	mwh = 0,0
	cliflag = 0
	ccolor(0) = 0,0,0
	
	gsel imageid3,-1
	imagehwnd3 = hwnd 
	MoveWindow imagehwnd3,0,0,0,0,0
	gsel imageid3,2

	repeat
	
		ginfo0 = ginfo(0)
		ginfo1 = ginfo(1)
		
		stick sti,256,0
		if sti = 256{
			if cliflag = 0{
				cliflag = 1
				mxy_(0) = ginfo0
				mxy_(1) = ginfo1
				
			}
			if cliflag = 1{

				mwh(0) = abs(mxy_(0) - ginfo0)
				mwh(1) = abs(mxy_(1) - ginfo1)
				
				if mxy_(0) < ginfo0 {
					mxy(0) = mxy_(0)
				} else {
					mxy(0) = ginfo0
				}
		
				if mxy_(1) < ginfo1 {
					mxy(1) = mxy_(1)
				} else {
					mxy(1) = ginfo1
				}
	
				MoveWindow imagehwnd3,mxy(0),mxy(1),mwh(0),mwh(1),0
				
			}
		}
			
		if (sti = 0 & cliflag = 1){
			cliflag = 0

			dialog "この位置で決定しますか？",2,"確認"
			if stat = 6:break
			mxy(0) = 0,0
			mxy_(0) = 0,0
			mwh = 0,0
			MoveWindow imagehwnd3,0,0,0,0,0
		}
			
		if (sti = 128){
			break
		}
			
		redraw 1
		await 16
	loop
		
	gsel imageid3,-1
	gsel imageid1

	;/*
	;dialog ""+mxy(0) +"  "+ginfo(0)+"\n"+mxy(1) +"  "+ginfo(1)
	if ginfo(0) > mxy(0) {
		;dialog "真x"
		tsscap(0) = mxy(0) - disinfo(0)
		tsscap(2) = mxy(0) + mwh(0) - disinfo(0)
	} else {
		tsscap(0) = ginfo(0) - disinfo(0)
		tsscap(2) = ginfo(0) + mwh(0) - disinfo(0)
	}
	
	if mxy(1) < ginfo(1){
		;dialog "真y"
		tsscap(1) = mxy(1) - disinfo(1)
		tsscap(3) = mxy(1) + mwh(1) - disinfo(1)
	} else {
		tsscap(1) = ginfo(1) - disinfo(1)
		tsscap(3) = ginfo(1) + mwh(1) - disinfo(1)
	}
	
	;dialog ""+mwh(0)+"  "+mwh(1)+"\n"+""+tsscap(0)+"  "+tsscap(1)+"\n"+tsscap(2) +"  "+tsscap(3)
	;*/
	/*
	
	tsscap(0) = mxy_(0) - disinfo(0)
	tsscap(2) = mxy_(0) + mwh(0) - disinfo(0)
	tsscap(1) = mxy_(1) - disinfo(1)
	tsscap(3) = mxy_(1) + mwh(1) - disinfo(1)
	
	;*/
	
	;dialog ""+tsscap(0)+"  "+tsscap(1)+"\n"+tsscap(2)+"  "+tsscap(3)
	;dialog strf("%d %d %d %d",tsscap(0),tsscap(1),tsscap(2),tsscap(3))
	
	;dialog ""+ccolor(0)+" "+ccolor(1)+" "+ccolor(2)+" "

	pget tsscap(0),tsscap(1)+mwh(1)/2
	ccolor(0) = ginfo_r ,ginfo_g, ginfo_b
	;dialog ""+ccolor(0)+" "+ccolor(1)+" "+ccolor(2)+" "
	repeat mwh(0)/2,1
		ccnt = cnt
		pget tsscap(0)+cnt,tsscap(1)+mwh(1)/2
		;dialog ""+ginfo_r+" "+ginfo_g+" "+ginfo_b
		if (ccolor(0) != ginfo_r) | (ccolor(1) != ginfo_g) | (ccolor(2) != ginfo_b) {
			sscap(0) = tsscap(0)+cnt + disinfo(0)
			break
		}
	loop
	
	;dialog ""+ccnt
	
	pget tsscap(2),tsscap(3)-mwh(1)/2
	ccolor(0) = ginfo_r ,ginfo_g, ginfo_b
	;dialog ""+ccolor(0)+" "+ccolor(1)+" "+ccolor(2)+" "
	repeat mwh(0)/2,1
		ccnt = cnt
		pget tsscap(2)-cnt,tsscap(3)-mwh(1)/2
		;dialog ""+ginfo_r+" "+ginfo_g+" "+ginfo_b
		if (ccolor(0) != ginfo_r) | (ccolor(1) != ginfo_g) | (ccolor(2) != ginfo_b) {
			sscap(2) = tsscap(2)-cnt + disinfo(0)
			break
		}
	loop
	
	;dialog ""+ccnt
	
	pget tsscap(0)+mwh(0)/2,tsscap(1)
	ccolor(0) = ginfo_r ,ginfo_g, ginfo_b
	repeat mwh(1)/2
		ccnt = cnt
		pget tsscap(0)+mwh(0)/2,tsscap(1)+cnt
		if (ccolor(0) != ginfo_r) | (ccolor(1) != ginfo_g) | (ccolor(2) != ginfo_b) {
			sscap(1) = tsscap(1)+cnt + disinfo(1)
			break
		}
	loop
	
	;dialog ""+ccnt
	
	pget tsscap(2)-mwh(0)/2,tsscap(3)
	ccolor(0) = ginfo_r ,ginfo_g, ginfo_b
	repeat mwh(1)/2
		ccnt = cnt
		pget tsscap(2)-mwh(0)/2,tsscap(3)-cnt
		if (ccolor(0) != ginfo_r) | (ccolor(1) != ginfo_g) | (ccolor(2) != ginfo_b) {
			sscap(3) = tsscap(3)-cnt+1 + disinfo(1)
			break
		}
	loop
	
	;dialog ""+ccnt
	
	dialog strf("%d %d %d %d %d %d",sscap(0),sscap(1),sscap(2),sscap(3),sscap(2)-sscap(0),sscap(3)-sscap(1))

return

#defcfunc getbufid

#global

