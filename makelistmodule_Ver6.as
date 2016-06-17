
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


//////
#ifndef getkancollewindowposauto_C
#module N891N5
#uselib "kernel32.dll"
#func VirtualAllocN891N5 "VirtualAlloc" int, int, int, int
#func VirtualFreeN891N5 "VirtualFree" int, int, int
#define NULL                   0x00000000
#define PAGE_EXECUTE_READWRITE 0x00000040
#define MEM_COMMIT             0x00001000
#define MEM_RESERVE            0x00002000
#define MEM_DECOMMIT           0x00004000
#define MEM_RELEASE            0x00008000
#deffunc N891N5_destructor onexit
	if(NULL != getkancollewindowposauto_C_ptr) {
		VirtualFreeN891N5 getkancollewindowposauto_C_ptr, 188, MEM_DECOMMIT
		VirtualFreeN891N5 getkancollewindowposauto_C_ptr, 0, MEM_RELEASE
		getkancollewindowposauto_C_ptr = NULL
	}
	return
#deffunc N891N5_constructor
	N891N5_destructor
	VirtualAllocN891N5 NULL, 188, MEM_RESERVE, PAGE_EXECUTE_READWRITE
	VirtualAllocN891N5 stat, 188, MEM_COMMIT, PAGE_EXECUTE_READWRITE
	getkancollewindowposauto_C_ptr    = stat
	dupptr getkancollewindowposauto_C_bin, stat, 188, vartype("int")
	getkancollewindowposauto_C_bin.0  = $6C8B5553, $C0331024, $57D23356, $8E0FED85, $00000097, $14247C8B
	getkancollewindowposauto_C_bin.6  = $1C24748B, $90045F8D, $81FC4B8B, $FFFFFFE1, $750E3B00, $810B8B72
	getkancollewindowposauto_C_bin.12 = $FFFFFFE1, $044E3B00, $8B400175, $E181044B, $00FFFFFF, $75084E3B
	getkancollewindowposauto_C_bin.18 = $4C8B4001, $E1810C97, $00FFFFFF, $750C4E3B, $4C8B4001, $E1811097
	getkancollewindowposauto_C_bin.24 = $00FFFFFF, $75104E3B, $4C8B4001, $E1811497, $00FFFFFF, $75144E3B
	getkancollewindowposauto_C_bin.30 = $4C8B4001, $E1811897, $00FFFFFF, $75184E3B, $4C8B4001, $E1811C97
	getkancollewindowposauto_C_bin.36 = $00FFFFFF, $751C4E3B, $F8834001, $42147407, $3B04C383, $758C0FD5
	getkancollewindowposauto_C_bin.42 = $5FFFFFFF, $C8835D5E, $5FC35BFF, $C28B5D5E, $0000C35B
	return
#define global getkancollewindowposauto_C(%1, %2, %3) \
	prm@N891N5 = varptr(%1), %2, varptr(%3):\
	mref value@N891N5, 64:\
	value@N891N5 = callfunc(prm@N891N5, getkancollewindowposauto_C_ptr@N891N5, 3)
#global
N891N5_constructor
#endif
/////////////////


#module makelistmodule


#deffunc init_makelist array disinfo_


	horizontallinedata(0) = 0x00947504 ,0x00917201 ,0x009D7E0D ,0x00947603 ,0x009B7D0A ,0x00927401 ,0x009D7F0C ,0x00947601
	
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
	VRAMset
	
	repeat 8
		vpxrgb 35+cnt,105
		if horizontallinedata(cnt) = vpx_rgb:count++
	loop
	gsel nid
	
	if count = 8{
		return 1
	}
return 0



#deffunc getkancollewindowposauto2 int imageid,array sscap

	gsel imageid
	mref vram,66
	 
	sw = ginfo(12)
	sh = ginfo(13)

	getkancollewindowposauto_C vram,sw*sh,horizontallinedata
	if stat = -1{
		return -1
	}

	sscap(0) = (stat\sw)+disinfo(0)-35,((sh-1)-stat/sw)+disinfo(1)-105
	sscap(2) = sscap(0)+800,sscap(1)+480	
	
return 0

#deffunc getkancollewindowposmanual int imageid1,array sscap,int imageid3

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
	
	;dialog strf("%d %d %d %d %d %d",sscap(0),sscap(1),sscap(2),sscap(3),sscap(2)-sscap(0),sscap(3)-sscap(1))

return

#defcfunc getbufid

#global

