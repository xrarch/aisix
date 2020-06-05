extern LockMutex (* mutex -- killed *)

extern UnlockMutex (* mutex -- *)

extern InitMutex (* name mutex -- *)

struct Mutex
	4 Locked
	4 OwnerThread
	4 Name
endstruct