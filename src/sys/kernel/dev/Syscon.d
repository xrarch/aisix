var SysconOut 0

procedure Putc (* c -- *)
	auto rs
	InterruptDisable rs!

	if (SysconOut@ 0 ==)
		asm "

		popv r5, r0
		.db 0xF1

		"

		return
	end

	SysconOut@ Call

	rs@ InterruptRestore
end

procedure Getc (* -- c *)
	ERR return
end

procedure SysconLateInit (* -- *)
	if (VidConPresent@)
		pointerof GConsolePutChar SysconOut!
	end
end