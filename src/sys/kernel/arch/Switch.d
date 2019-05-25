procedure HTTANew (* rs usp ksp pc -- htta *)
	auto pc
	pc!

	auto ksp
	ksp!

	auto usp
	usp!

	auto rs
	rs!

	auto nhtta
	HTTA_SIZEOF Calloc nhtta!

	nhtta@ nhtta@ HTTA_htta + !
	pc@ nhtta@ HTTA_pc + !
	ksp@ nhtta@ HTTA_sp + !
	usp@ nhtta@ HTTA_usp + !
	rs@ nhtta@ HTTA_rs + !

	asm "
		pushv r5, ivt
	" nhtta@ HTTA_ivt + !

	nhtta@
end

(* for when we want to switch processes outright *)
procedure uswtch (* newproc -- *)
	auto newproc
	newproc!

	if (CurProc@ -1 ~=)
		asm "pushv r5, htta" CurProc@ Proc_cHTTA + !
	end

	newproc@ CurProc!

	PRUNNING newproc@ Proc_Status + !

	newproc@ Proc_kr5 + @ ProcCurrentkr5!

	auto nppb
	newproc@ Proc_Page + @ nppb!

	if (nppb@ -1 ~=)
		nppb@ 4096 * newproc@ Proc_Base + !
		nppb@ newproc@ Proc_Extent + @ + 4096 * newproc@ Proc_Bounds + !
	end

	auto mb
	newproc@ Proc_Base + @ mb!

	auto bounds
	newproc@ Proc_Bounds + @ bounds!

	mb@ MMUSetBase
	bounds@ MMUSetBounds

	newproc@ Proc_cHTTA + @

	asm "

	popv r5, htta
	httl

	"
end

(* for when we want to return to somewhere in kernelspace later *)
procedure kswtch (* newproc -- *)
	auto newproc
	newproc!
end