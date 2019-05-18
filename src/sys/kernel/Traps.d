procedure UserTrap (* r4 r3 r2 r1 r0 -- *)
	auto htta
	asm "pushv r5, htta" htta!

	if (htta@ HTTA_r0 + @ 0xF ==)
		htta@ HTTA_r1 + "%x\n" Printf
	end
end