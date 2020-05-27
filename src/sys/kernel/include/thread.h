const THREADNAMELEN 32

struct Thread
	4 Context
	
	4 KernelStackTop
	4 ValueStackTop
	
	4 KernelStack
	4 ValueStack
	
	4 Process
	4 TID
	4 Status
	
	4 TrapFrame

	THREADNAMELEN Name
endstruct

const PROCNAMELEN 32

struct Process
	4 Threads
	4 Mapped
	4 Parent
	4 UserID
	4 EUserID

	4 MainThread

	4 TextVirtual
	4 TextPhysical
	4 TextPages

	4 DataVirtual
	4 DataPhysical
	4 DataPages

	4 BSSVirtual
	4 BSSPhysical
	4 BSSPages

	4 Index
	4 PID

	4 ReturnValue
	PROCNAMELEN Name
endstruct

externconst CurrentThread

const THREADMAX 256

const PROCMAX 256

const KERNELSTACKPAGES 1

const VALUESTACKPAGES 1

const TS_READY 1
const TS_RUNNING 2

extern JumpIntoScheduler (* -- *)

extern KernelThreadNew (* funcptr -- *)

extern ThreadReady (* thread -- *)

extern Yield (* -- *)