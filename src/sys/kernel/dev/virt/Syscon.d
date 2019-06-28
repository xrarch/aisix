(* polled boy *)

var SysconOut 0
var SysconIn 0
var SysconEarly 1

buffer SysconEarlyBuf 2048
const SysconEarlyBufSz 2048
var SysconEarlyBufPtr 0
var SysconEarlyBufSP 0
var SysconEarlyCCount 0

var SysconTty 0

var SysconVC 0

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
	0 SysconEarly!

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
end

procedure SysconSwitchSerial (* -- ok? *)
	0 SysconVC!

	pointerof SerialWritePolled SysconSetOut

	SysconTty@ SerialTty!

	1
end

procedure SysconSwitchVC (* earlyprint? -- ok? *)
	auto ep
	ep!

	if (SysconVC@)
		1 return
	end

	if (VidConPresent@)
		VConsoleNeedsDraw

		pointerof VConsolePutChar SysconSetOut

		if (SysconEarly@ ep@ &&)
			if ("-tty0supl" ArgsCheck ~~)
				SysconDumpEarly
			end
		end

		if (KeyboardPresent@)
			SysconTty@ KeyboardTty!
		end

		1 SysconVC!

		1 return
	end else
		0 return
	end
end

procedure SysconAttemptVC (* -- *)
	if (1 SysconSwitchVC ~~)
		SysconSwitchSerial drop
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
		SysconSwitchSerial drop
		return
	end

	if (tty0@ "video" strcmp)
		SysconAttemptVC
		tty0@ Free
		return
	end

	if (tty0@ "serial" strcmp tty0@ "default" strcmp ||)
		SysconSwitchSerial drop
		tty0@ Free
		return
	end

	if (tty0@ "platform" strcmp)
		0 SysconEarly!

		pointerof platformPutc SysconSetOut
		tty0@ Free
		return
	end

	SysconSwitchSerial drop

	tty0@ Free
end