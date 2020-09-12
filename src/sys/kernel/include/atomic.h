struct EventQueue
	4 Mutex (* if applicable *)
	4 FirstWaiter
	4 LastWaiter
endstruct

extern LockMutex { mutex -- killed }

extern LockMutexUninterruptible { mutex -- }

extern UnlockMutex { mutex -- }

extern InitMutex { name mutex -- }

extern MutexOwned { mutex -- owned }

struct Mutex
	4 Locked
	4 OwnerThread
	4 Name
	4 Caller
	EventQueue_SIZEOF LockQ
endstruct