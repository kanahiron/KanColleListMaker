#module
	#uselib "kernel32"
	#func WritePrivateProfileString "WritePrivateProfileStringA" sptr, sptr, sptr, sptr
	#func GetPrivateProfileString "GetPrivateProfileStringA" sptr, sptr, sptr, sptr, sptr, sptr
	
	#deffunc SetIni str path
		inipath = path
		if instr(inipath, 0, ":") = -1 : inipath = "" : return 1
		fname = getpath(path, 8)
		fpath = getpath(path, 32)
		fpath = strmid(fpath, 0, strlen(fpath) - 1)
		opath = dir_cur
		chdir fpath
		inipath = dir_cur + "\\" + fname
		chdir opath
		exist inipath
		if strsize = -1 : return 1
		return 0
		
	#deffunc GetIni str sect, str para, var vari
		if inipath = "" : return 1
		switch vartype(vari)
			case 2
				dupptr size, varptr(vari) - 16, 4
				GetPrivateProfileString sect, para, "", varptr(vari), size, inipath
				return 0
			swbreak
	
			case 3
				sdim dummy
				GetPrivateProfileString sect, para, "", varptr(dummy), 64, inipath
				vari = double(dummy)
				return 0
			swbreak
	
			case 4
				sdim dummy
				GetPrivateProfileString sect, para, "", varptr(dummy), 64, inipath
				vari = int(dummy)
				return 0
			swbreak
		swend
		return 1
		
	#deffunc WriteIni str sect, str para, var vari
		if inipath = "" : return 1
		switch vartype(vari)
			case 2 : case 3 : case 4
				WritePrivateProfileString sect, para, str(vari), inipath
				return 0
		swend
		return 1
#global