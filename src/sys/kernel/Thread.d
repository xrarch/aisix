procedure StackAlloc (* -- ptr *)
	KERNEL_STACK_SIZE 4096 / PMMAlloc 4096 *
end

procedure StackFree (* ptr -- *)
	4096 / KERNEL_STACK_SIZE 4096 /
end

procedure ThreadInit (* -- *)
	THREAD_MAX Thread_SIZEOF * Calloc ThreadTable!
end

procedure ThreadCreateInternal (* parent -- ptr or ERR *)
	auto task
	task!

	task@ TaskAddThread

	auto i
	0 i!

	while (i@ THREAD_MAX <)
		auto ptr
		i@ Thread_SIZEOF * ThreadTable@ + ptr!

		auto rs
		InterruptDisable rs!

		if (ptr@ Thread_Status + @ THREAD_EMPTY ==)
			THREAD_PAUSED ptr@ Thread_Status + !
			task@ ptr@ Thread_Task + !

			rs@ InterruptRestore
			ptr@ return
		end

		rs@ InterruptRestore

		i@ 1 + i!
	end

	ERR
end

procedure KernelThreadCreate (* func -- thread *)
	auto func
	func!

	auto thread
	KernelTask@ ThreadCreateInternal thread!

	if (thread@ ERR ==)
		thread@ "couldn't create kernel thread @func 0x%x\n" Panic
	end

	auto kstack
	StackAlloc kstack!

	kstack@ thread@ Thread_KernelStack + !

	(* go to machine-dependent bit *)
	func@ thread@ cpu_kernel_thread_create

	thread@
end

procedure ThreadExit (* thread -- *)
	auto thread
	thread!

	thread@ Thread_KernelStack + @ StackFree

	thread@ Thread_Task + @ TaskRemoveThread

	THREAD_EMPTY thread@ Thread_Status + !
end

(* destroy all of a task's threads *)
procedure ThreadExitAll (* task -- *)
	auto task
	task!

	auto i
	0 i!

	while (i@ THREAD_MAX <)
		auto ptr
		i@ Thread_SIZEOF * ThreadTable@ + ptr!

		auto rs
		InterruptDisable rs!

		if (ptr@ Thread_Status + @ THREAD_EMPTY ~=)
			if (ptr@ Thread_Task + @ task@ ==)
				ptr@ ThreadExit
			end
		end

		rs@ InterruptRestore

		i@ 1 + i!
	end
end

(* wake all of a tasks threads *)
procedure ThreadsWakeAll (* task -- *)
	auto task
	task!

	auto i
	0 i!

	while (i@ THREAD_MAX <)
		auto ptr
		i@ Thread_SIZEOF * ThreadTable@ + ptr!

		auto rs
		InterruptDisable rs!

		if (ptr@ Thread_Status + @ THREAD_SLEEPING ==)
			if (ptr@ Thread_Task + @ task@ ==)
				THREAD_RUNNABLE ptr@ Thread_Status + !
				0 ptr@ Thread_WaitChan + !
			end
		end

		rs@ InterruptRestore

		i@ 1 + i!
	end
end

procedure ThreadsWakeup (* wchan -- *)
	auto wchan
	wchan!

	auto i
	0 i!

	while (i@ THREAD_MAX <)
		auto ptr
		i@ Thread_SIZEOF * ThreadTable@ + ptr!

		auto rs
		InterruptDisable rs!

		if (ptr@ Thread_Status + @ THREAD_SLEEPING ==)
			if (ptr@ Thread_WaitChan + @ wchan@ ==)
				THREAD_RUNNABLE ptr@ Thread_Status + !
				0 ptr@ Thread_WaitChan + !
			end
		end

		rs@ InterruptRestore

		i@ 1 + i!
	end
end

(* more unixy names *)
procedure wakeup (* wchan -- *)
	ThreadsWakeup
end

(* sleep until channel is woken, returns whether the resource was really
given up or if something bad happened *)
procedure sleep (* wchan -- actually? *)
	auto wchan
	wchan!

	auto me
	ThreadCurrent@ me!

	auto rs
	InterruptDisable rs!

	wchan@ me@ Thread_WaitChan + !
	THREAD_SLEEPING me@ Thread_Status + !

	sched

	rs@ InterruptRestore

	if (TaskCurrent@ Task_Killed + @)
		0 return
	end

	1
end

procedure sleeplock (* lock -- actually? *)
	auto lock
	lock!

	auto rs
	(* this is ok because interrupt status is per-thread
	and sleep calls yield which restores the psw of the next
	thread via swtch *)
	InterruptDisable rs!

	if (lock@ SleepLock_Thread + @ ThreadCurrent@ ==)
		rs@ InterruptRestore
		lock@ "sleeplock: thread already holding lock @ 0x%x\n" Panic
	end

	while (lock@ SleepLock_Locked + @)
		if (lock@ sleep ~~)
			rs@ InterruptRestore
			0 return
		end
	end

	1 lock@ SleepLock_Locked + !
	ThreadCurrent@ lock@ SleepLock_Thread + !

	rs@ InterruptRestore

	1
end

procedure sleepunlock (* lock -- *)
	auto lock
	lock!

	auto rs
	InterruptDisable rs!

	if (lock@ SleepLock_Thread + @ ThreadCurrent@ ~=)
		rs@ InterruptRestore
		lock@ "sleepunlock: thread wasn't holding lock @ 0x%x\n" Panic
	end

	0 lock@ SleepLock_Locked + !
	0 lock@ SleepLock_Thread + !

	rs@ InterruptRestore

	lock@ wakeup
end

procedure holdingsleeplock (* lock -- holding? *)
	auto lock
	lock!

	auto r

	auto rs
	InterruptDisable rs!

	lock@ SleepLock_Locked + @ lock@ SleepLock_Thread + @ ThreadCurrent@ == && r!

	rs@ InterruptRestore

	r@
end

procedure KernelThreadResume (* thread -- *)
	auto thread
	thread!

	THREAD_RUNNABLE thread@ Thread_Status + !
end

procedure KernelThreadPause (* thread -- *)
	auto thread
	thread!

	THREAD_PAUSED thread@ Thread_Status + !
end

(* scheduler vthread *)
procedure Scheduler (* -- *)
	"scheduler running for the first time\n" Printf

	platform_interrupt_throwaway

	InterruptEnable drop

	while (1)
		auto i
		0 i!

		while (i@ THREAD_MAX <)
			auto ptr
			i@ Thread_SIZEOF * ThreadTable@ + ptr!

			auto rs
			InterruptDisable rs!

			if (ptr@ Thread_Status + @ THREAD_RUNNABLE ==)
				if (TaskCurrent@ 0 ~=)
					TASK_USED TaskCurrent@ Task_Status + !
				end

				ptr@ ThreadCurrent!
				ptr@ Thread_Task + @ TaskCurrent!

				THREAD_RUNNING ptr@ Thread_Status + !

				ptr@ TaskCurrent@ Task_RunningThread + !
				TASK_RUNNING TaskCurrent@ Task_Status + !

				TaskCurrent@ Task_MMUBase + @ MMUSetBase
				TaskCurrent@ Task_MMUBounds + @ MMUSetBounds

				ptr@ Thread_Context + @ SchedulerContext swtch
			end

			rs@ InterruptRestore

			i@ 1 + i!
		end
	end
end

(* hard leap into scheduler context *)
procedure sched (* -- *)
	SchedulerContext@ ThreadCurrent@ Thread_Context + swtch
end

(* more unixy name for the above *)
procedure yield (* -- *)
	auto rs
	InterruptDisable rs!

	THREAD_RUNNABLE ThreadCurrent@ Thread_Status + !
	sched

	rs@ InterruptRestore
end

(* called from clock interrupt *)
procedure ThreadTick (* -- *)
	if (ThreadCurrent@ 0 ~= ThreadCurrent@ Thread_Status + @ THREAD_RUNNING == &&)
		yield
	end
end

(* dump info related to all threads of task *)
procedure ThreadDumpAll (* task -- *)
	auto task
	task!

	auto i
	0 i!

	while (i@ THREAD_MAX <)
		auto ptr
		i@ Thread_SIZEOF * ThreadTable@ + ptr!

		if (ptr@ Thread_Status + @ THREAD_EMPTY ~=)
			if (ptr@ Thread_Task + @ task@ ==)
				ptr@ ThreadDump
			end
		end

		i@ 1 + i!
	end
end

procedure ThreadDump (* thread -- *)
	auto thread
	thread!

	thread@ "thread @ 0x%x\n" Printf
end