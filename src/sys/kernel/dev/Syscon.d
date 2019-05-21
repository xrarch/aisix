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

procedure SysconSetOut (* ptr -- *)
	SysconOut!
end

procedure SysconLateInit (* -- *)
	auto sca
	"syscon" ArgsValue sca!

	auto con
	0 con!

	if (sca@ 0 ~=)
		if (sca@ "serial" strcmp)
			1 con!
		end
	end

	if (con@ 0 ==)
		if (VidConPresent@)
			pointerof VConsolePutChar SysconOut!
		end
	end
end