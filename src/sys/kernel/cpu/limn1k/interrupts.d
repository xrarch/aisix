var InterruptsVT 0
var TrapsVT 0

procedure InterruptsInit (* -- *)
	1024 Calloc InterruptsVT!
	1024 Calloc TrapsVT!

	(* set IVT *)
	InterruptsVT@
	asm "popv r5, ivt"

	FaultsInit

	auto i

	"setting up syscall vectors: " Printf
	0xA i!
	while (i@ 0x10 <)
		i@ "%d " Printf

		pointerof Syscall i@ TrapRegister
		i@ 1 + i!
	end

	CR

	TrapsVT@ InterruptsVT@ "ivt @ 0x%x\ttvt @ 0x%x\n" Printf
end

procedure IVTRegister (* handler num -- *)
	4 * InterruptsVT@ + !
end

procedure TrapRegister (* handler num -- *)
	auto num
	num!

	auto handler
	handler!

	pointerof kernel_entry num@ IVTRegister
	handler@ num@ 4 * TrapsVT@ + !
end

procedure cpu_trap (* tf -- *)
	auto tf
	tf!

	auto trap
	tf@ TrapFrame_icause + @ trap!

	auto th
	trap@ 4 * TrapsVT@ + @ th!

	if (th@ 0 ==)
		trap@ "non-existent trap %d" Panic
	end

	if (TaskCurrent@ 0 ~=)
		if (TaskCurrent@ Task_Killed + @ 1 ==)
			if (tf@ TrapFrame_rs + @ 1 & 0 ~=)
				exit
			end
		end
	end

	tf@ th@ Call

	if (TaskCurrent@ 0 ~=)
		if (TaskCurrent@ Task_Killed + @ 1 ==)
			if (tf@ TrapFrame_rs + @ 1 & 0 ~=)
				exit
			end
		end
	end
end