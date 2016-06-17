#ifndef xdim
#uselib "kernel32.dll"
#func global VirtualProtect@_xdim "VirtualProtect" var,int,int,var
#define global xdim(%1,%2) dim %1,%2: VirtualProtect@_xdim %1,%2*4,$40,x@_xdim
#endif

#module

#uselib "comdlg32"
#func GetOpenFileName "GetOpenFileNameA" int
#func GetSaveFileName "GetSaveFileNameA" int
#cfunc CommDlgExtendedError "CommDlgExtendedError"
#uselib "user32.dll"
#func SendMessage "SendMessageA" int,int,int,int
#uselib "ole32.dll"
#func CoTaskMemFree "CoTaskMemFree" int
#uselib "shell32.dll"
#cfunc SHBrowseForFolder "SHBrowseForFolderA" int
#cfunc SHGetPathFromIDList "SHGetPathFromIDListA" int,int

#deffunc BrowseFolder str _szTitle, str _defaultfolder
	szTitle = _szTitle : inifldr = _defaultfolder : sdim retfldr, 260 : xdim fncode, 8
	fncode = $08247c83,$8b147501,$ff102444,$68016a30,$00000466,$102474ff,$330450ff,$0010c2c0
	hbdata = varptr(inifldr), varptr(SendMessage)
	BROWSEINFO = hwnd, 0, varptr(retfldr), varptr(szTitle), 67, varptr(fncode), varptr(hbdata), 0
	pidl = SHBrowseForFolder(varptr(BROWSEINFO))
	fret = SHGetPathFromIDList(pidl,varptr(retfldr))
	CoTaskMemFree pidl
	mref stt,64 : stt = fret
return retfldr

#deffunc BrowseFolder2 str _szTitle, str _defaultfolder
	szTitle = _szTitle : inifldr = _defaultfolder : sdim retfldr, 260 : xdim fncode, 8
	fncode = $08247c83,$8b147501,$ff102444,$68016a30,$00000466,$102474ff,$330450ff,$0010c2c0
	hbdata = varptr(inifldr), varptr(SendMessage)
	BROWSEINFO = hwnd, 0, varptr(retfldr), varptr(szTitle), 0x1 & 0x0040 & 0x0200, varptr(fncode), varptr(hbdata), 0
	pidl = SHBrowseForFolder(varptr(BROWSEINFO))
	fret = SHGetPathFromIDList(pidl,varptr(retfldr))
	CoTaskMemFree pidl
	mref stt,64 : stt = fret
return retfldr

#global