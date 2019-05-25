procedure UserTrap (* -- *)
	auto htta
	CurProc@ Proc_cHTTA + @ htta!

	(* dummy test syscall *)
	if (htta@ HTTA_r0 + @ 0xF ==)
		htta@ HTTA_r1 + @ "this is a test syscall! 0xF in r0. contents of r1: %x\n" Printf
		htta@ HTTA_r1 + @ bswap htta@ HTTA_r1 + !
	end
end