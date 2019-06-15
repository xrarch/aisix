procedure StackAlloc (* -- ptr *)
	KERNEL_STACK_SIZE Malloc
end

procedure StackFree (* ptr -- *)
	Free
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

		if (ptr@ Thread_Status + @ THREAD_EMPTY ==)
			THREAD_PAUSED ptr@ Thread_Status + !
			task@ ptr@ Thread_Task + !

			ptr@ return
		end

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

		if (ptr@ Thread_Status + @ THREAD_EMPTY ~=)
			if (ptr@ Thread_Task + @ task@ ==)
				ptr@ ThreadExit
			end
		end

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

		if (ptr@ Thread_Status + @ THREAD_SLEEPING ==)
			if (ptr@ Thread_Task + @ task@ ==)
				THREAD_RUNNABLE ptr@ Thread_Status + !
				0 ptr@ Thread_WaitChan + !
			end
		end

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

		if (ptr@ Thread_Status + @ THREAD_SLEEPING ==)
			if (ptr@ Thread_WaitChan + @ wchan@ ==)
				THREAD_RUNNABLE ptr@ Thread_Status + !
				0 ptr@ Thread_WaitChan + !
			end
		end

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

	wchan@ me@ Thread_WaitChan + !
	THREAD_SLEEPING me@ Thread_Status + !

	yield

	if (TaskCurrent@ Task_Killed + @)
		0 return
	end

	1
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

	while (1)
		InterruptEnable drop

		auto i
		0 i!

		while (i@ THREAD_MAX <)
			auto ptr
			i@ Thread_SIZEOF * ThreadTable@ + ptr!

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

			i@ 1 + i!
		end
	end
end

(* hard leap into scheduler context *)
procedure SchedLeap (* -- *)
	SchedulerContext@ ThreadCurrent@ Thread_Context + swtch
end

(* more unixy name for the above *)
procedure yield (* -- *)
	SchedLeap
end

(* called from clock interrupt *)
procedure ThreadTick (* -- *)
	if (ThreadCurrent@ 0 ~= ThreadCurrent@ Thread_Status + @ THREAD_RUNNING == &&)
		THREAD_RUNNABLE ThreadCurrent@ Thread_Status + !
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