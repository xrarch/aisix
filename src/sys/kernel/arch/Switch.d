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

	auto mb
	newproc@ Proc_Page + @ 4096 * mb!

	auto bounds
	mb@ newproc@ Proc_Extent + @ 4096 * + bounds!

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