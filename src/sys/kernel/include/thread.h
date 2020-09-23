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

	4 EvQ
	4 PrevWaiter
	4 NextWaiter

	4 InKernel

	4 Killed

	THREADNAMELEN Name
endstruct

const OFILEMAX 64

const OSEGMAX 32

const PROCNAMELEN 32

const CWDPATHLEN 384

struct OSeg
	4 Segment
	4 Flags
	4 VAddr
endstruct

const OSEG_MAPPED 1
const OSEG_WRITABLE 2

struct Process
	4 Threads
	4 Parent
	4 UID
	4 EUID

	4 MainThread

	4 PQ

	4 Pagemap

	4 CWDVNode

	4 Exited

	4 Zombie

	4 TTY
	4 IgnoreTTY

	4 Index
	4 PID

	4 ReturnValue

	4 UMask

	Mutex_SIZEOF Mutex

	Mutex_SIZEOF ParentLock

	EventQueue_SIZEOF WaitQ

	256 OFiles (* dragonfruit is dumb so we can't use a nice constant here, but this is OFILEMAX=64 * 4 *)

	384 OSegs (* OSEGMAX=32 * 12 *)

	CWDPATHLEN CWDPathString

	PROCNAMELEN Name
endstruct

externptr CurrentThread

externptr Processes

externptr Threads

externptr KernelProcess

externptr InitProcess

const THREADMAX 128

const PROCMAX 64

const KERNELSTACKPAGES 1

const TS_NOTREADY 0
const TS_READY 1
const TS_RUNNING 2
const TS_TIMER 4
const TS_EVENT 5
const TS_EVENT_UNINTERRUPTIBLE 6
const TS_SUSPEND 7

extern PlatformSwitchSeg { proc -- }

extern PlatformUserToPhys { len user wr -- phys valid }

extern JumpIntoScheduler { -- }

extern KernelThreadNew { entry name -- thread }

extern ThreadReady { thread -- }

extern Yield { -- }

extern WaitQueue { evq -- killed }

extern WaitQueueUninterruptible { evq -- }

extern WakeQueue { evq -- }

extern ProcessExit { ret -- }

extern ProcessKill { ret process -- }

extern ThreadExit { -- }

extern ThreadKill { thread -- }

extern SleepFor { ms -- killed }

extern WakeupTimer { uptime -- }

extern ThreadFree { thread -- }

extern cswtch { old new -- }

extern ProcessNew { name -- process }

extern ProcessAddMainThread { entry udata udatasz process kernel -- ok }

extern ProcessFreeSlot { process -- }

extern ProcLock { proc -- killed }

extern ProcUnlock { proc -- }

extern LockMe { -- killed }

extern UnlockMe { -- }

extern KillTTY { tty -- }

extern Wait { -- pid ret }