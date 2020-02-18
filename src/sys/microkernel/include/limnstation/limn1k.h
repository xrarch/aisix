struct TrapFrame
	4 rf
	4 r30	4 r29
	4 r28	4 r27
	4 r26	4 r25
	4 r24	4 r23
	4 r22	4 r21
	4 r20	4 r19
	4 r18	4 r17
	4 r16	4 r15
	4 r14	4 r13
	4 r12	4 r11
	4 r10	4 r9
	4 r8	4 r7
	4 r6	4 r5
	4 r4	4 r3
	4 r2	4 r1
	4 icause
	4 usp
	4 rs
	4 r0
	4 pc
endstruct

table TrapFrame_Names
	"rf"
	"r30"	"r29"
	"r28"	"r27"
	"r26"	"r25"
	"r24"	"r23"
	"r22"	"r21"
	"r20"	"r19"
	"r18"	"r17"
	"r16"	"r15"
	"r14"	"r13"
	"r12"	"r11"
	"r10"	"r9"
	"r8"	"r7"
	"r6"	"r5"
	"r4"	"r3"
	"r2"	"r1"
	"icause"
	"usp"
	"rs"
	"r0"
	"pc"
endtable

const TrapFrameNElem 36