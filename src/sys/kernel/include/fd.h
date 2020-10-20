const MAXFILEP 128

struct FileP
	4 RWX
	4 Count
	4 Type
	4 VNode
	4 VDirent
	4 Seek
	4 Flags
endstruct

struct Dirent
	256 Name
	32 Reserved
endstruct

struct Stat
	4 Mode
	4 UID
	4 GID
	4 Size
	4 Type
	4 ATime
	4 MTime
	4 CTime
	32 Reserved
endstruct

const O_READ 1
const O_WRITE 2
const O_RW (O_READ O_WRITE |)

const O_TRUNC 4
const O_CLOEXEC 8
const O_CREATE 16
const O_APPEND 32

const FD_FILE 1
const FD_PIPE 2

const SEEK_SET 1
const SEEK_CUR 2
const SEEK_END 3

extern GetFD { bits -- fd filp }

extern GetFilp { fd -- filp }

extern RefFilp { filp -- }

extern UnrefFilp { filp -- }

extern FDup { filp -- }

extern FilDup { fd1 -- fd2 }

extern Open { path mode pbits -- fd }

extern ReadDir { dirent fd -- ok }

extern CloseP { filp -- ok }

extern Close { fd -- ok }

extern Write { buf len fd -- bytes }

extern Read { buf len fd -- bytes }

extern PStat { stat path -- ok }

extern FStat { stat fd -- ok }

extern Chdir { path -- ok }

extern Unlink { path -- ok }

extern Mkdir { path mode -- ok }

extern Chown { path owner -- ok }

extern FChown { fd owner -- ok }

extern Chmod { path mode -- ok }

extern FChmod { fd mode -- ok }

extern Seek { fd offset whence -- ok }

extern GetDeviceName { fd -- name }