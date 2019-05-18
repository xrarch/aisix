procedure UserTrap (* -- *)
	auto htta
	asm "pushv r5, htta" htta!

	(* dummy test syscall *)
	if (htta@ HTTA_r0 + @ 0xF ==)
		htta@ HTTA_r1 + "%x\n" Printf
	end
end