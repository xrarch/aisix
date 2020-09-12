struct IOBuffer
	4 Size
	4 Data
	4 ReadP
	4 WriteP
	4 InputF
	4 WriterF
	4 TTY
	4 Overwrite
	EventQueue_SIZEOF ReadQ
	EventQueue_SIZEOF WriteQ
endstruct

fnptr IOBufWriter { c buf -- written }

fnptr IOCharInput { c buf -- }

const IOBUFEMPTY 256 (* biggest char + 1 *)

extern AllocIOBuf { size -- iobuf }

extern FreeIOBuf { iobuf -- }

(* ok is 1 if char put, 0 if buffer full, negative if error *)
extern IOBufPutc { c buf sleeponfull -- ok }

(* c is char if available, IOBUFEMPTY if buf empty, negative if error *)
extern IOBufGetc { buf sleeponempty -- c }

extern IOBufPutBack { c buf -- }

extern IOBufRubout { buf -- c }

extern ChangeIOBufSize { iobuf newsize -- ok }