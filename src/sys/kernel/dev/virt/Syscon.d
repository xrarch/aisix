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

procedure PolledGets (* s max -- *)
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

procedure Readline (* s max -- *)
	auto max
	max!

	auto s
	s!

	auto bytes
	TaskCurrent@ s@ 0 max@ 0 TtyRead bytes!

	if (bytes@ 0 ==)
		0 s@ sb
		return
	end

	if (s@ bytes@ 1 - + gb '\n' ~=)
		0 s@ sb
		return
	end

	0 s@ bytes@ 1 - + sb
end

procedure Gets (* s max -- *)
	if (SysconTty@ 0 ==)
		PolledGets
	end else
		Readline
	end
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

procedure SysconDefaults (* -- *)
	pointerof SerialWritePolled SysconSetOut

	SysconTty@ SerialTty!
end

procedure SysconAttemptVC (* -- *)
	if (VidConPresent@)
		pointerof VConsolePutChar SysconSetOut

		if (KeyboardPresent@)
			SysconTty@ KeyboardTty!
		end
	end else
		SysconDefaults
	end
end

procedure SysconInit (* -- *)
	TtyAdd SysconTty!

	if (SysVerbose@)
		SysconAttemptVC
		return
	end

	auto tty0
	"tty0" ArgsValue tty0!

	if (tty0@ 0 ==)
		SysconDefaults
		return
	end

	if (tty0@ "video" strcmp)
		1 SysVerbose!
		SysconAttemptVC
		return
	end

	if (tty0@ "serial" strcmp tty0@ "default" strcmp ||)
		SysconDefaults
		return
	end

	if (tty0@ "platform" strcmp)
		0 SysconEarly!

		pointerof platformPutc SysconSetOut
		return
	end

	SysconDefaults
end