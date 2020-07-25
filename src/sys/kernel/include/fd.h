const MAXFILEP 128

struct FileP
	4 RWX
	4 Count
	4 VNode
	4 Seek
endstruct

extern GetFD { bits -- fd filp }

extern GetFilp { fd -- filp }

extern RefFilp { filp -- }

extern UnrefFilp { filp -- }

extern FDup { filp -- }

extern FilDup { fd1 -- fd2 }

extern Open { path mode -- fd }

extern Close { fd -- ok }

extern Write { buf len fd -- bytes }

extern Read { buf len fd -- bytes }