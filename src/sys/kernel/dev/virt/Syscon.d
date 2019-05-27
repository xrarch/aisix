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

procedure SysconInit (* -- *)
	"syscon: init\n" Printf

	auto sca
	"syscon" ArgsValue sca!

	auto con

	if (VidConPresent@)
		3 con! (* if vidcon present, use it by default *)
	end else
		2 con! (* otherwise use a3x console by default *)
	end

	if (sca@ 0 ~=)
		if (sca@ "serial" strcmp)
			1 con! (* use specifically the serial port *)
		end else

		if (sca@ "a3x" strcmp)
			2 con! (* use specifically a3x console *)
		end

		end
	end

	"setting syscon = " Printf

	if (con@ 1 ==)
		"serial\n" Printf
		pointerof SerialWritePolled SysconSetOut
	end else

	if (con@ 2 ==)
		"a3x boot console\n" Printf
		pointerof a3xPutc SysconSetOut
	end else

	if (con@ 3 ==)
		"kernel video console\n" Printf
		pointerof VConsolePutChar SysconSetOut
	end

	end

	end
end