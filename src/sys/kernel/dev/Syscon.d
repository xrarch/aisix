var SysconOut 0

procedure Putc (* c -- *)
	if (SysconOut@ 0 ==)
		asm "

		popv r5, r0
		.db 0xF1

		"

		return
	end

	SysconOut@ Call
end

procedure Getc (* -- c *)
	ERR return
end