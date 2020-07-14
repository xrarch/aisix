const THREADNAMELEN 32

struct Thread
	4 Context
	
	4 KernelStackTop
	
	4 KernelStack
	
	4 Process
	4 TID
	4 Status
	
	4 TrapFrame

	4 WaitChan

	4 Killed

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

externptr CurrentThread

externptr Processes

externptr Threads

const THREADMAX 128

const PROCMAX 64

const KERNELSTACKPAGES 1

const TS_NOTREADY 0
const TS_READY 1
const TS_RUNNING 2
const TS_SLEEPING 3
const TS_TIMER 4

extern JumpIntoScheduler { -- }

extern KernelThreadNew { entry name -- thread }

extern ThreadReady { thread -- }

extern Yield { -- }

extern Sleep { channel -- killed }

extern Wakeup { channel -- }

extern ProcessExit { ret -- }

extern ProcessKill { ret process -- }

extern ThreadExit { -- }

extern ThreadKill { thread -- }

extern SleepFor { ms -- killed }

extern WakeupTimer { uptime -- }

extern ThreadFree { thread -- }

extern cswtch { old new -- }