(* signals are sent to tasks as a whole and are handled by whatever thread is currently running *)

procedure TaskCanSignal (* signaler signalee -- allowed? *)
	auto signalee
	signalee!

	auto signaler
	signaler!

	if (signalee@ KernelTask@ ==)
		0 return
	end

	if (signaler@ Task_EUID + @ 0 ==)
		1 return
	end

	if (signaler@ Task_EUID + @ signalee@ Task_UID + @ ==)
		1 return
	end

	0 return
end

procedure TaskSignalInternal (* sig task -- *)
	auto task
	task!

	auto sig
	sig!

	task@ Task_Signals + 1 sig@ << | task@ Task_Signals + !

	(* just kill it for now who cares *)
	task@ TaskStab
end

(* uses current task implicitly for privilege checking *)
procedure TaskSignal (* sig task -- sent? *)
	auto task
	task!

	auto sig
	sig!

	if (sig@ NSIG >)
		"TaskSignal: sig > nsig" Panic
	end

	if (TaskCurrent@ task@ TaskCanSignal ~~)
		-EPERM return
	end

	if (task@ Task_Killed + @ 1 ==)
		1 return
	end

	if (task@ Task_Status + @ TASK_ZOMBIE ==)
		1 return
	end

	sig@ task@ TaskSignalInternal

	1
end

procedure TaskSignalGroup (* sig pgrp -- sent? *)
	auto pgrp
	pgrp!

	auto sig
	sig!

	auto sent
	0 sent!

	auto i
	0 i!

	while (i@ TASK_MAX <)
		auto ptr
		i@ PIDtoPtr ptr!

		if (ptr@ Task_Status + @ TASK_EMPTY ~=)
			if (ptr@ Task_PGRP + @ pgrp@ ==)
				if (sig@ ptr@ TaskSignal 0 s>)
					1 sent!
				end 
			end
		end

		i@ 1 + i!
	end

	sent@
end