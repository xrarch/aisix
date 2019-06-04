(* these functions DO implicitly use the current process *)

procedure Schedule (* -- *)

	if (InterruptGet)
		"scheduler expects interrupts to be disabled\n" Panic
	end

	auto np
	ERR np!

	auto i
	0 i!

	while (i@ PROC_MAX <)
		auto p
		i@ ProcNext@ + PROC_MAX % Proc_SIZEOF * ProcTab@ + p!

		if (p@ Proc_Status + @ PRUNNABLE ==)
			p@ np!
			i@ 1 + ProcNext!
			if (ProcNext@ PROC_MAX >=)
				0 ProcNext!
			end
			break
		end

		i@ 1 + i!
	end

	if (np@ ERR ==)
		"nothing to schedule: the idle thread should NOT be blocked\n" Panic
	end

	np@ swtch
end

(* these things have lowercase names because tradition *)

procedure yield (* waitstatus -- *)
	auto wstat
	wstat!

	(* performs a yieldk syscall and briefly enables interrupts in order to process it *)
	wstat@ asm "
		popv r5, r1

		mov r2, rs
		bseti rs, rs, 1

		li r0, 2 ;SYSYIELDK
		sys 0

		mov rs, r2
	"
end

procedure sleep (* channel -- *)
	auto chan
	chan!

	auto p
	CurProc@ p!

	chan@ p@ Proc_WChan + !

	PSLEEPING yield

	0 p@ Proc_WChan + !
end

procedure wakeup (* channel -- *)
	auto chan
	chan!

	auto i
	0 i!

	while (i@ PROC_MAX <)
		auto p
		i@ Proc_SIZEOF * ProcTab@ + p!

		if (p@ Proc_Status + @ PSLEEPING ==)
			if (p@ Proc_WChan + @ chan@ ==)
				PRUNNABLE p@ Proc_Status + !
			end
		end

		i@ 1 + i!
	end
end

procedure allocproc (* -- proc *)
	auto i
	0 i!

	while (i@ PROC_MAX <)
		auto p
		i@ Proc_SIZEOF * ProcTab@ + p!

		if (p@ Proc_Status + @ PEMPTY ==)
			p@ Proc_SIZEOF 0 memset

			CurProc@ p@ Proc_Parent + !

			PFORKING p@ Proc_Status + !

			p@ return
		end

		i@ 1 + i!
	end

	-ENOMEM
end

(* special-case initialization functions *)

procedure MakeProcZero (* func -- proc *)
	auto func
	func!

	func@ "hand-crafting idle process (pid 0) @ 0x%x\n" Printf

	auto proc
	allocproc proc!

	if (proc@ iserr)
		"couldn't allocate idle process\n" Panic
	end

	auto kstack
	1024 Malloc kstack!

	auto httatab
	auto myhtta
	(* psw of 3: usermode and interrupts enabled, but mmu disabled *)
	3 0 kstack@ 1024 + func@ HTTANew httatab! myhtta!

	auto kr5
	1024 Malloc kr5!

	"idle" strdup proc@ Proc_Name + !
	myhtta@ proc@ Proc_cHTTA + !
	httatab@ proc@ Proc_HTTATable + !
	kr5@ proc@ Proc_kr5 + !
	kstack@ proc@ Proc_kstack + !

	PRUNNABLE proc@ Proc_Status + !

	proc@
end

procedure ProcInit (* idleproc -- proc0 *)
	auto iproc
	iproc!

	"proc: init\n" Printf

	PROC_MAX Proc_SIZEOF * Calloc ProcTab!

	ProcTab@ "proctab @ 0x%x\n" Printf

	iproc@ MakeProcZero
end