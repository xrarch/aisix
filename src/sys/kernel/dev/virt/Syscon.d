(* polled boy *)

var SysconOut 0
var SysconIn 0
var SysconEarly 1

buffer SysconEarlyBuf 1024
const SysconEarlyBufSz 1024
var SysconEarlyBufPtr 0
var SysconEarlyBufSP 0
var SysconEarlyCCount 0

var SysconTty 0

procedure SysconEarlyPut (* c -- *)
	auto c
	c!

	c@ SysconEarlyBuf SysconEarlyBufPtr@ SysconEarlyBufSz % + sb

	SysconEarlyBufPtr@ 1 + SysconEarlyBufPtr!

	if (SysconEarlyBufPtr@ SysconEarlyBufSz >=)
		SysconEarlyBufSP@ 1 + SysconEarlyBufSP!
	end

	SysconEarlyCCount@ 1 + SysconEarlyBufSz min SysconEarlyCCount!
end

procedure SysconDumpEarly (* -- *)
	auto sp
	SysconEarlyBufSP@ sp!

	auto i
	0 i!

	while (i@ SysconEarlyCCount@ <)
		auto c
		SysconEarlyBuf sp@ SysconEarlyBufSz % + gb c!

		if (c@ 0 ~=)
			c@ Putc
		end

		sp@ 1 + sp!
		i@ 1 + i!
	end
end

procedure Putc (* c -- *)
	auto c
	c!

	if (SysconEarly@)
		c@ SysconEarlyPut
	end

	if (SysconOut@ 0 ==)
		c@ platformPutc
		return
	end

	c@ SysconOut@ Call
end

procedure Getc (* -- c *)
	if (SysconIn@ 0 ==)
		platformGetc
		return
	end

	SysconIn@ Call
end

procedure Gets (* s max -- *)
	auto max
	max!

	auto s
	s!

	auto len
	0 len!

	while (1)
		auto c
		ERR c!
		while (c@ ERR ==)
			Getc c!
		end

		if (c@ '\n' ==)
			'\n' Putc
			break
		end

		if (c@ '\b' ==)
			if (len@ 0 >)
				len@ 1 - len!
				0 s@ len@ + sb
				'\b' Putc
				' ' Putc
				'\b' Putc
			end
		end else if (len@ max@ <)
			c@ s@ len@ + sb

			len@ 1 + len!
			c@ Putc
		end end
	end

	0 s@ len@ + sb
end

procedure SysconSetOut (* ptr -- *)
	auto ptr
	ptr!

	auto osc
	SysconOut@ osc!

	ptr@ SysconOut!

	ptr@ SysconTty@ tty_ActualOut + !

	if (SysconEarly@ osc@ ptr@ ~= &&)
		0 SysconEarly!

		if ("-tty0supl" ArgsCheck ~~)
			SysconDumpEarly
		end
	end
end

table SysconNames
	0
	"serial console"
	"a3x boot console"
	"aisix video console"
endtable

procedure SysconDefaults (* -- *)
	if (VidConPresent@)
		pointerof VConsolePutChar SysconSetOut

		if (KeyboardPresent@)
			SysconTty@ KeyboardTty!
		end
	end else
		pointerof SerialWritePolled SysconSetOut

		SysconTty@ SerialTty!
	end
end

procedure SysconInit (* -- *)
	auto sca
	"tty0" ArgsValue sca!

	auto contty
	TtyAdd dup contty! SysconTty!

	if (sca@ 0 ==)
		(* defaults *)

		SysconDefaults

		return
	end

	if (sca@ "serial" strcmp)
		pointerof SerialWritePolled SysconSetOut

		contty@ SerialTty!

		return
	end

	if (sca@ "framebuffer" strcmp)
		if (VidConPresent@)
			pointerof VConsolePutChar SysconSetOut

			if (KeyboardPresent@)
				contty@ KeyboardTty!
			end
		end else
			SysconDefaults
		end

		return
	end

	if (sca@ "a3x" strcmp sca@ "default" strcmp ||)
		SysconDefaults

		return
	end
end