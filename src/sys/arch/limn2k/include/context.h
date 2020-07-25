struct Context
	4 t0    4 t1
	4 t2    4 t3
	4 t4    4 a0
	4 a1    4 a2
	4 a3    4 v0
	4 v1    4 s0
	4 s1    4 s2
	4 s3    4 s4
	4 s5    4 s6
	4 s7    4 s8
	4 s9    4 s10
	4 s11   4 r12
	4 s13   4 s14
	4 at    4 tf

	4 sp
	4 ers
	4 epc
	4 lr
	4 timer
endstruct

externptr ContextNames

const CONTEXTELEM 33

const RS_USER 1
const RS_INT 2
const RS_MMU 4
const RS_TIMER 8

extern CPUContextPrepare { a0 a1 entry stack kern -- ctx }