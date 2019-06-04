table SysTab
	0
	0
	pointerof SysYieldK
	pointerof SysYield
endtable

const SysCount 4

procedure Syscall (* -- *)
	auto htta
	asm "
		pushv r5, htta
	" htta!

	auto sysn
	htta@ HTTA_r0 + @ sysn!

	if (sysn@ SysCount >=)
		(* not a syscall, just return but later we'll do a SIGSYS *)
		return
	end

	auto sysf
	[sysn@]SysTab@ sysf!

	if (sysf@ 0 ~=)
		htta@ sysf@ Call
	end
end

procedure SysYieldK (* htta -- *)
	auto htta
	htta!

	if (htta@ HTTA_rs + @ 1 & 0 ~=)
		return
	end

	htta@ HTTA_r1 + @ CurProc@ Proc_Status + !

	Schedule
end

procedure SysYield (* htta -- *)
	drop

	PRUNNABLE CurProc@ Proc_Status + !

	Schedule
end