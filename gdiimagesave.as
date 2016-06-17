#module

#uselib "gdiplus"
#func GdiplusStartup        "GdiplusStartup"        var, var, nullptr
#func GdiplusShutdown       "GdiplusShutdown"       int
#func GdipSaveImageToFile   "GdipSaveImageToFile"   int, wstr, var, var ;‰æ‘œ‚ðƒtƒ@ƒCƒ‹‚Æ‚µ‚Ä•Û‘¶
#func GdipDisposeImage      "GdipDisposeImage"      int
#func GdipCreateBitmapFromGdiDib "GdipCreateBitmapFromGdiDib" int, int, var

#deffunc gdipngsave str s,int imageID,local h
    dim h, 15
    h  = 0, 0, $557CF406, $11D31A04, $0000739A, $2EF31EF8, 100, 1, $1D5BE4B5, $452DFA4A, $B35DDD9C, $EBE70551, 1, 4, varptr(h) + 24
    ib = 1, 0, 0, 0
    sdim bmscr
    mref bmscr,(imageID+96)
    GdiplusStartup h(0), ib
    GdipCreateBitmapFromGdiDib bmscr(6), bmscr(5), h(1)
    GdipSaveImageToFile h(1), s, h(2), h(7)
    GdipDisposeImage   h(1) ;Image
    GdiplusShutdown    h(0) ;Gdip
return

#deffunc gdijpgsave str s,int p,int imageID,local h
    dim h, 15
    h  = 0, 0, $557CF401, $11D31A04, $0000739A, $2EF31EF8, p, 1, $1D5BE4B5, $452DFA4A, $B35DDD9C, $EBE70551, 1, 4, varptr(h) + 24
    ib = 1, 0, 0, 0
    sdim bmscr
    mref bmscr,(imageID+96)
    GdiplusStartup h(0), ib
    GdipCreateBitmapFromGdiDib bmscr(6), bmscr(5), h(1)
    GdipSaveImageToFile h(1), s, h(2), h(7)
    GdipDisposeImage   h(1) ;Image
    GdiplusShutdown    h(0) ;Gdip
return
#global