struct Message
	4 Sender
	4 Type
	40 Body
endstruct

const THREADNUM 256

struct Thread
	4 Process
	4 StackFrame
	
	4 Status

	4 StackPhysAddr
	4 StackSize

	4 UserSegPhysAddr
	4 UserSegSize

	4 KernelStackAddr
endstruct

const PROCNAMESIZE 64
const PROCNUM 128

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

	4 Timeslice

	4 KernelMode

	4 Status

	4 Return

	4 WaitedBy

	4 Parent

	4 EUserID

	4 Service
endstruct

const PFREE 0x1
const PZOMBIE 0x2

const USERSEGMAPADDR 0xC0000000
const HEAPMAPADDR 0x80000000
const STACKMAPADDR 0x40000000
const IMAGEMAPADDR 0x00000000

const SLOT_FREE 0x01
const SENDING 0x02
const RECEIVING 0x03
const NOSCHED 0x04
const WAITING 0x05
const WAITINGANY 0x06

const DEFAULTTIMESLICEMS 10

externconst ThreadTable (* pointer to table *)

externconst CurrentThread (* var *)