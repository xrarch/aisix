struct Message
	4 Sender
	4 Type
	64 Body
endstruct

const THREADNUM 1024

struct Thread
	4 Process
	4 StackFrame
	
	4 Flags

	4 StackPhysAddr
	4 StackSize

	4 UserSegPhysAddr
	4 UserSegSize

	4 KernelStackAddr
endstruct

const PROCNAMESIZE 64
const PROCNUM 512

struct Process
	PROCNAMESIZE Name
	4 UserID
	
	4 ProcessID

	4 ImagePhysAddr
	4 ImageSize
	
	4 HeapPhysAddr
	4 HeapSize

	4 ThreadCount

	4 MainThread

	4 Wired

	4 System

	4 FreeSlot
endstruct

const USERSEGMAPADDR 0xC0000000
const HEAPMAPADDR 0x80000000
const STACKMAPADDR 0x40000000
const IMAGEMAPADDR 0x00000000

const SLOT_FREE 0x01
const NO_MAP 0x02
const SENDING 0x04
const RECEIVING 0x08
const SIGNALED 0x10
const SIG_PENDING 0x20
const P_STOP 0x40
const NO_PRIV 0x80

externconst ThreadTable (* pointer to table *)

externconst CurrentThread (* var *)