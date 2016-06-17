
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

#uselib "gdi32.dll"
#func GetDC "GetDC" int
#func ReleaseDC "ReleaseDC" int,int
#func CreateDIBSection "CreateDIBSection" int,int,int,int,int,int
#func CreateCompatibleBitmap "CreateCompatibleBitmap" int,int,int
#func SelectObject "SelectObject" int,int
#func DeleteObject "DeleteObject" int 

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

#ifndef getkancollewindowposauto_C
#module R4HBGC
#uselib "kernel32.dll"
#func VirtualAllocR4HBGC "VirtualAlloc" int, int, int, int
#func VirtualFreeR4HBGC "VirtualFree" int, int, int
#define NULL                   0x00000000
#define PAGE_EXECUTE_READWRITE 0x00000040
#define MEM_COMMIT             0x00001000
#define MEM_RESERVE            0x00002000
#define MEM_DECOMMIT           0x00004000
#define MEM_RELEASE            0x00008000
#deffunc R4HBGC_destructor onexit
	if(NULL != getkancollewindowposauto_C_ptr) {
		VirtualFreeR4HBGC getkancollewindowposauto_C_ptr, 184, MEM_DECOMMIT
		VirtualFreeR4HBGC getkancollewindowposauto_C_ptr, 0, MEM_RELEASE
		getkancollewindowposauto_C_ptr = NULL
	}
	return
#deffunc R4HBGC_constructor
	R4HBGC_destructor
	VirtualAllocR4HBGC NULL, 184, MEM_RESERVE, PAGE_EXECUTE_READWRITE
	VirtualAllocR4HBGC stat, 184, MEM_COMMIT, PAGE_EXECUTE_READWRITE
	getkancollewindowposauto_C_ptr    = stat
	dupptr getkancollewindowposauto_C_bin, stat, 184, vartype("int")
	getkancollewindowposauto_C_bin.0  = $6C8B5553, $C0331024, $57DB3356, $840FED85, $00000094, $1424748B
	getkancollewindowposauto_C_bin.6  = $1C24548B, $0024648D, $819E0C8B, $FFFFFFE1, $750A3B00, $9E348D72
	getkancollewindowposauto_C_bin.12 = $830CC283, $03BF04C6, $EB000000, $00498D03, $E1810E8B, $00FFFFFF
	getkancollewindowposauto_C_bin.18 = $75F84A3B, $4E8B4001, $FFE18104, $3B00FFFF, $0175FC4A, $084E8B40
	getkancollewindowposauto_C_bin.24 = $FFFFE181, $0A3B00FF, $8B400175, $E1810C4E, $00FFFFFF, $75044A3B
	getkancollewindowposauto_C_bin.30 = $4E8B4001, $FFE18110, $3B00FFFF, $0175084A, $14C68340, $4F14C283
	getkancollewindowposauto_C_bin.36 = $F883AE75, $8B19740F, $8B142474, $431C2454, $820FDD3B, $FFFFFF78
	getkancollewindowposauto_C_bin.42 = $835D5E5F, $C35BFFC8, $8B5D5E5F, $00C35BC3
	return
#define global getkancollewindowposauto_C(%1, %2, %3) \
	prm@R4HBGC = varptr(%1), %2, varptr(%3):\
	mref value@R4HBGC, 64:\
	value@R4HBGC = callfunc(prm@R4HBGC, getkancollewindowposauto_C_ptr@R4HBGC, 3)
#global
R4HBGC_constructor
#endif



#module makelistmodule


#deffunc init_makelist array disinfo_


	dim resultdata,16
	resultdata = 0x0029556B ,0x00174357 ,0x000C384C ,0x000E384B ,0x001A4256 ,0x001E4557 ,0x001A3E51 ,0x00395D6E ,0x00294B5D ,0x0016384A ,0x0017394B ,0x0017394B ,0x0016384C ,0x0017394D ,0x0017394D ,0x0017394D
	//0,122
	
	dim mapmovedata,16
	mapmovedata = 0x00ABAB92 ,0x00ABA991 ,0x006D7560 ,0x003B4430 ,0x002C3220 ,0x00474B37 ,0x005F614C ,0x006C715F ,0x00777B71 ,0x0076736E ,0x007E7B54 ,0x009EA041 ,0x00AEB037 ,0x008F8E37 ,0x004A6C4D ,0x00409897
	//167,479
	
	dim homeportdata,16
	homeportdata = 0x00C9AC3B ,0x00AC901D ,0x00B69A27 ,0x00B69A25 ,0x00A88D15 ,0x00A1860C ,0x00A2880A ,0x00947A00 ,0x00A28806 ,0x00977E00 ,0x00B19812 ,0x00917800 ,0x00A28A00 ,0x00A78F04 ,0x00988000 ,0x009A7100
	// 33,106
	
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

#defcfunc homeport int imageid,int bufid

	nid = ginfo(3)
	
	gsel imageid
	sw = ginfo(12)
	sh = ginfo(13)
	
	buffer bufid,sw,sh
	chgbm 32
	gcopy imageid,0,0,sw,sh
	mref vram,66
	
	gsel nid

	getkancollewindowposauto_C vram,sw*sh,homeportdata
	if stat = -1{
		return 0
	}
	
return 1

#deffunc getkancollewindowposauto2 int imageid,array sscap,int bufid

	nid = ginfo(3)

	gsel imageid
	sw = ginfo(12)
	sh = ginfo(13)
	;logmes ""+sw+" "+sh
	
	buffer bufid,sw,sh;:title "a"
	
	chgbm 32
	
	gcopy imageid,0,0,sw,sh
	mref vram,66
	
	
	gsel nid
	
	getkancollewindowposauto_C vram,sw*sh,homeportdata
	if stat != -1{
		//homeportdata 33,106
		sscap(0) = (stat\sw)+disinfo(0)-33,((sh-1)-stat/sw)+disinfo(1)-106
		sscap(2) = sscap(0)+800,sscap(1)+480	
		return 0
	}

	getkancollewindowposauto_C vram,sw*sh,resultdata
	if stat != -1{
		//resultdata 0,122
		sscap(0) = (stat\sw)+disinfo(0)-0,((sh-1)-stat/sw)+disinfo(1)-122
		sscap(2) = sscap(0)+800,sscap(1)+480
		return 0
	}
	
	getkancollewindowposauto_C vram,sw*sh,mapmovedata
	if stat != -1{
		//mapmovedata 167,479
		sscap(0) = (stat\sw)+disinfo(0)-167,((sh-1)-stat/sw)+disinfo(1)-479
		sscap(2) = sscap(0)+800,sscap(1)+480	
		return 0
	}



return -1

	
#deffunc getkancollewindowposmanual int imageid1,array sscap,int imageid3,int imageid4,int imageid5

	nid = ginfo(3)
	tsscap(0) = 0,0,0,0
	sscap(0) = 0,0,0,0
	mxy(0) = 0,0
	mxy_(0) = 0,0
	mwh = 0,0
	cliflag = 0
	ccolor(0) = 0,0,0

	screen imageid5,,,2
	
	gsel imageid4,2 //背景
	imagehwnd4 = hwnd
	MoveWindow imagehwnd4,disinfo(0),disinfo(1),disinfo(2),disinfo(3),1
	LoadCursor 0, 32515
	SetClassLong imagehwnd4, -12, stat

	gsel imageid3,-1
	imagehwnd3 = hwnd 
	MoveWindow imagehwnd3,0,0,0,0,0

	repeat
	
		ginfo0 = int(ginfo(0))
		ginfo1 = int(ginfo(1))
		
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
				gsel imageid3,2
				MoveWindow imagehwnd3,mxy(0),mxy(1),mwh(0),mwh(1),1
				
			}
		}
			
		if (sti = 0 & cliflag = 1){
			cliflag = 0
	
			//
			gsel imageid3,-1
			gsel imageid4
			LoadCursor 0, 32512
			SetClassLong imagehwnd4, -12, stat
			gsel imageid4,-1
	
			////////////////////////////////////////
			gsel imageid1
		
			tsscap(0) = mxy(0) - disinfo(0)
			tsscap(1) = mxy(1) - disinfo(1)
			tsscap(2) = mxy(0) + mwh(0) - disinfo(0)
			tsscap(3) = mxy(1) + mwh(1) - disinfo(1)

			pget tsscap(0),tsscap(1)+mwh(1)/2
			ccolor(0) = ginfo_r ,ginfo_g, ginfo_b
			repeat mwh(0)/2,1
				ccnt = cnt
				pget tsscap(0)+cnt,tsscap(1)+mwh(1)/2
				if (ccolor(0) != ginfo_r) | (ccolor(1) != ginfo_g) | (ccolor(2) != ginfo_b) {
					sscap(0) = tsscap(0)+cnt + disinfo(0)
					break
				}
			loop

			pget tsscap(2),tsscap(3)-mwh(1)/2
			ccolor(0) = ginfo_r ,ginfo_g, ginfo_b
			repeat mwh(0)/2,1
				ccnt = cnt
				pget tsscap(2)-cnt,tsscap(3)-mwh(1)/2
				if (ccolor(0) != ginfo_r) | (ccolor(1) != ginfo_g) | (ccolor(2) != ginfo_b) {
					sscap(2) = tsscap(2)-cnt + disinfo(0)+1
					break
				}
			loop

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
			/////////////////////
	
			sscapwh(0) = sscap(2)-sscap(0),sscap(3)-sscap(1)
			if sscapwh(0) >= 99 & sscapwh(1) >= 59{
				screen  imageid5,sscapwh(0),sscapwh(1),,(ginfo(20)-sscapwh(0))/2,(ginfo(21)-sscapwh(1))/2
				gsel imageid5,1
				title "抽出結果"
				gcopy imageid1,sscap(0)-disinfo(0),sscap(1)-disinfo(1),sscapwh(0),sscapwh(1)
				
				dialog "正しく取得できていますか？",2,"確認"
				if stat = 6{
					gsel imageid3,-1
					break
				}
			} else {
				dialog "取得に失敗しました\n再度選択しますか？",2,"確認"
				if stat = 7{
					gsel imageid3,-1
					break
				}
			}
	
			gsel imageid4,2
			MoveWindow imagehwnd4,disinfo(0),disinfo(1),disinfo(2),disinfo(3),1
			LoadCursor 0, 32515
			SetClassLong imagehwnd4, -12, stat
			gsel imageid5,-1
			
			tsscap(0) = 0,0,0,0
			sscap(0) = 0,0,0,0
			mxy(0) = 0,0
			mxy_(0) = 0,0
			mwh = 0,0
			MoveWindow imagehwnd3,0,0,0,0,1
		}
			
		if (sti = 128){
			gsel imageid3,-1
			gsel imageid4
			LoadCursor 0, 32512
			SetClassLong imagehwnd4, -12, stat
			gsel imageid4,-1
			break
		}
			
		redraw 1
		await 16
	loop

	gsel imageid5,-1
	gsel nid
	
return

	
;#defcfunc getbufid

#global

