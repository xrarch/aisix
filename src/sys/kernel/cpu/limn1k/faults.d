table CPUFaultsNames
	"Division by zero"
	"Invalid opcode"
	"Page fault"
	"Privilege violation"
	"General fault"
	"Breakpoint"
	"Unknown1"
	"Bus error"
	"Unknown2"
	"Spurious interrupt"
endtable

procedure CPUFaultHandler (* tf -- *)
	auto tf
	tf!

	auto pc
	tf@ TrapFrame_pc + @ pc!

	auto r0
	tf@ TrapFrame_r0 + @ r0!

	auto rs
	tf@ TrapFrame_rs + @ rs!

	auto fault
	tf@ TrapFrame_icause + @ fault!

	if (rs@ 1 & 0 ==) (* fault occurred in kernel mode! *)
		if (fault@ 5 ==)
			"\nbreakpoint: jumping to debugger\n" Printf

			tf@ Debugger

			return
		end

		pc@ [fault@]CPUFaultsNames@ "kernel mode fault: %s at 0x%x\n" Panic
	end

	(* kill currently executing process and schedule a new one *)

	exit
end

procedure FaultsInit (* -- *)
	auto i
	0 i!
	while (i@ 10 <)
		pointerof CPUFaultHandler i@ TrapRegister
		i@ 1 + i!
	end
end