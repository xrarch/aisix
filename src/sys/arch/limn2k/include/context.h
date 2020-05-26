struct Context
	4 r1    4 r2
	4 r3    4 r4
	4 r5    4 r6
	4 r7    4 r8
	4 r9    4 r10
	4 r11   4 r12
	4 r13   4 r14
	4 r15   4 r16
	4 r17   4 r18
	4 r19   4 r20
	4 r21   4 r22
	4 r23   4 r24
	4 r25   4 tf
	4 vs    4 at

	4 sp
	4 ers
	4 epc
	4 lr
	4 timer
endstruct

externconst ContextNames

const CONTEXTELEM 33

const RS_USER 1
const RS_INTENABLE 2
const RS_MMU 4
const RS_TIMER 8

extern CPUContextPrepare