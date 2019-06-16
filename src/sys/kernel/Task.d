procedure TaskInit (* -- *)
	TASK_MAX Task_SIZEOF * Calloc TaskTable!

	0 "aisix_task" TaskCreateInternal KernelTask!

	KernelTask@ "aisix_task @ 0x%x\n" Printf
end

procedure PIDtoPtr (* pid -- ptr *)
	auto pid
	pid!

	pid@ Task_SIZEOF * TaskTable@ +
end

procedure TaskAddThread (* task -- *)
	auto task
	task!

	task@ Task_Threads + @ 1 + task@ Task_Threads + !
end

procedure TaskRemoveThread (* task -- *)
	auto task
	task!

	task@ Task_Threads + @ 1 - task@ Task_Threads + !

	if (task@ Task_Threads + @ 0 s<=) (* no more threads left in the task, task is a zombie *)
		if (task@ Task_Status + @ TASK_ZOMBIE ~=)
			task@ TaskExit
		end
	end
end

procedure TaskExit (* task -- *)
	auto task
	task!

	if (task@ KernelTask@ ==)
		"kernel task exited\n" Panic
	end

	TASK_ZOMBIE task@ Task_Status + !

	1 task@ Task_Killed + !

	if (task@ Task_Threads + @ 0 >)
		(* find and destroy all of the task's threads *)

		task@ ThreadExitAll
	end

	(* parent could be sleeping in wait *)
	task@ Task_Parent + @ wakeup

	(* pass all children to init *)
	auto i
	0 i!

	while (i@ TASK_MAX <)
		auto ptr
		i@ PIDtoPtr ptr!

		if (ptr@ Task_Status + @ TASK_EMPTY ~=)
			if (ptr@ Task_Parent + @ task@ ==)
				InitTask@ ptr@ Task_Parent + !

				if (ptr@ Task_Status + @ TASK_ZOMBIE ==)
					(* wake up init if child was a zombie *)
					InitTask@ wakeup
				end
			end
		end

		i@ 1 + i!
	end

	task@ Task_Name + @ Free

	task@ Task_SigHandlers + @ Free

	(* TODO: kill all file-descriptors etc etc *)
end

procedure TaskStab (* task -- *)
	auto task
	task!

	if (task@ KernelTask@ ==)
		"can't stab the kernel task!\n" Panic
	end

	1 task@ Task_Killed + !

	task@ ThreadsWakeAll
end

(* more unixy names *)
procedure exit (* -- *)
	TaskCurrent@ TaskExit

	yield
end

(* actually killing the process, apparently *)
procedure kill (* pid -- *)
	auto pid
	pid!

	pid@ PIDtoPtr TaskStab
end

procedure TaskCreateInternal (* parent name -- ptr or ERR *)
	auto name
	name!

	auto parent
	parent!

	auto i
	0 i!

	while (i@ TASK_MAX <)
		auto ptr
		i@ PIDtoPtr ptr!

		if (ptr@ Task_Status + @ TASK_EMPTY ==)
			TASK_USED ptr@ Task_Status + !
			name@ strdup ptr@ Task_Name + !
			i@ ptr@ Task_PID + !
			parent@ ptr@ Task_Parent + !

			0 ptr@ Task_MMUBase + !
			0xFFFFFFFF ptr@ Task_MMUBounds + !

			if (TaskCurrent@ 0 ~=)
				if (TaskCurrent@ Task_PGRP + @ 0 ==)
					(* group leader *)
					i@ ptr@ Task_PGRP + !
				end
			end

			NSIG 4 * Malloc Task_SigHandlers + !

			ptr@ return
		end

		i@ 1 + i!
	end

	ERR
end

procedure TaskDump (* task -- *)
	auto task
	task!

	task@ Task_Name + @ task@ task@ Task_PID + @ "task %d @ 0x%x [%s]\n" Printf
end

procedure TaskDumpAll (* -- *)
	auto i
	0 i!

	while (i@ TASK_MAX <)
		auto ptr
		i@ PIDtoPtr ptr!

		if (ptr@ Task_Status + @ TASK_EMPTY ~=)
			ptr@ TaskDump
			ptr@ ThreadDumpAll
		end

		i@ 1 + i!
	end
end