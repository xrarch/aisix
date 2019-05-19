var InterruptsVT 0
var TrapsVT 0

procedure InterruptsInit (* -- *)
	"interrupts: init\n" Printf

	1024 Calloc InterruptsVT!
	1024 Calloc TrapsVT!

	(* set IVT *)
	InterruptsVT@
	asm "

	popv r5, ivt

	"

	"setting up fault handlers: " Printf

	auto i
	0 i!
	while (i@ 10 <)
		i@ "%d " Printf

		pointerof CPUFaultASM i@ IVTRegister
		i@ 1 + i!
	end

	CR

	InterruptsVT@ "ivt at 0x%x\n" Printf

	"setting up syscall vector: " Printf
	0xA i!
	while (i@ 0x10 <)
		i@ "%d " Printf

		pointerof UserTrap i@ InterruptRegister
		i@ 1 + i!
	end

	CR

	TrapsVT@ InterruptsVT@ "\tivt: 0x%x\n\ttvt: 0x%x\n" Printf
end

asm "

KEntryASM:
	htts
	
	lri.l r5, ProcCurrentkr5

	lri.l r1, TrapsVT
	muli r2, r0, 4
	add r1, r1, r2
	lrr.l r1, r1
	cmpi r1, 0
	be .panic

	call .wt

	httl

.wt:
	br r1
	ret

.panic:
	pushvi r5, .pstr
	call Panic

.pstr:
	.ds trap handler was set for nonexistent trap
	.db 0xA, 0x0

CPUFaultASM:
	pop r1 ; rs
	pop r2 ; r0
	pop r3 ; pc

	andi r4, r4, 1
	cmpi r4, 0
	be .kfault

	lri.l r5, ProcCurrentkr5

	pushv r5, r0
	pushv r5, r1
	pushv r5, r2
	pushv r5, r3

	call CPUFaultHandler

.kfault:
	
	li r5, 0x200000
	li sp, 0x202000

	pushv r5, r0
	pushv r5, r1
	pushv r5, r2
	pushv r5, r3

	call CPUFaultHandler

"

table CPUFaultsNames
	"Division by zero"
	"Invalid opcode"
	"Page fault"
	"Privilege violation"
	"General fault"
	"Fatal fault"
	"Double fault"
	"Bus error"
	"I/O error"
	"Spurious interrupt"
endtable

procedure CPUFaultHandler (* fault rs r0 pc -- *)
	auto pc
	pc!

	auto r0
	r0!

	auto rs
	rs!

	auto fault
	fault!

	if (rs@ 1 & 0 ==) (* fault occurred in kernel mode! *)
		pc@ [fault@]CPUFaultsNames@ "kernel mode fault: %s at 0x%x\n" Panic
	end

	(* kill currently executing process and schedule a new one *)

	(* but for now just a placeholder *)
	pc@ [fault@]CPUFaultsNames@ "usermode fault: %s at 0x%x\n" Panic
end

procedure IVTRegister (* handler num -- *)
	4 * InterruptsVT@ + !
end

procedure InterruptRegister (* handler num -- *)
	auto num
	num!

	auto handler
	handler!

	pointerof KEntryASM num@ IVTRegister
	handler@ num@ 4 * TrapsVT@ + !
end

procedure InterruptEnable (* -- *)
	asm "

	bseti rs, rs, 1

	"
end

procedure InterruptDisable (* -- rs *)
	asm "

	pushv r5, rs
	bclri rs, rs, 1

	"
end

procedure InterruptRestore (* rs -- *)
	asm "

	popv r5, rs

	"
end