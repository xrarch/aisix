(* stole some concepts from qword, thanks mint *)

(* device-independent part of the tty infrastructure *)

table TtyCDEVSW
	pointerof TtyOpen
	pointerof TtyClose
	pointerof TtyRead
	pointerof TtyWrite
	pointerof TtyIoctl
endtable

procedure TtyInit (* -- *)
	tty_SIZEOF TTY_MAX * Calloc TtyTable!

	pointerof TtyWorker KernelThreadCreate KernelThreadResume

	TtyCDEVSW DRIVER_CHAR "tty" DeviceAddDriver
end

procedure TtyMinorToTty (* minor -- tty *)
	auto minor
	minor!

	if (minor@ TTY_MAX >=)
		-ENODEV return
	end

	auto tty

	TtyTable@ minor@ tty_SIZEOF * + tty!

	if (tty@ tty_Status + @ TTY_EMPTY ==)
		-ENODEV return
	end

	tty@
end

procedure TtyOpen (* proc minor -- ok? *)
	auto minor
	minor!

	auto proc
	proc!

	auto dev
	minor@ TtyMinorToTty dev!

	if (dev@ 0 s<)
		dev@ return
	end

	if (dev@ tty_PGRP + @ 0 ==)
		proc@ Task_PID + @ dev@ tty_PGRP + !
	end

	0
end

procedure TtyClose (* proc minor -- ok? *)
	auto minor
	minor!

	auto proc
	proc!

	auto dev
	minor@ TtyMinorToTty dev!

	if (dev@ 0 s<)
		dev@ return
	end

	0
end

procedure TtyRead (* proc buf offset count minor -- bytes *)
	auto minor
	minor!

	auto count
	count!

	auto offset
	offset!

	auto buf
	buf!

	auto proc
	proc!

	auto dev
	minor@ TtyMinorToTty dev!

	if (dev@ 0 s<)
		dev@ return
	end

	auto wait
	1 wait!

	auto i
	0 i!

	while (i@ count@ <)
		auto c
		dev@ TtyBbufGetc c!
		if (c@ -1 ~=)
			if (c@ 4 ==) (* ^D *)
				i@ return
			end

			i@ 1 + i!

			c@ buf@ sb
			buf@ 1 + buf!

			if (c@ 0xA ==) (* \n *)
				i@ return
			end

			0 wait!
		end else
			if (wait@)
				if (dev@ sleep ~~)
					-EINTR return
				end
			end else
				i@ return
			end
		end
	end

	count@ return
end

procedure TtyWrite (* proc buf offset count minor -- written? *)
	auto minor
	minor!

	auto count
	count!

	auto offset
	offset!

	auto buf
	buf!

	auto proc
	proc!

	auto dev
	minor@ TtyMinorToTty dev!

	if (dev@ 0 s<)
		dev@ return
	end

	auto i
	0 i!

	while (i@ count@ <)
		buf@ i@ + gb dev@ TtyPutc

		i@ 1 + i!
	end

	count@
end

procedure TtyIoctl (* proc cmd data minor -- ok? *)
	auto minor
	minor!

	auto data
	data!

	auto cmd
	cmd!

	auto proc
	proc!

	auto dev
	minor@ TtyMinorToTty dev!

	if (dev@ 0 s<)
		dev@ return
	end

	0
end

procedure TtyAlloc (* -- tty *)
	auto i
	0 i!

	while (i@ TTY_MAX <)
		auto ptr
		i@ tty_SIZEOF * TtyTable@ + ptr!

		if (ptr@ tty_Status + @ TTY_EMPTY ==)
			TTY_USED ptr@ tty_Status + !
			i@ ptr@ tty_Minor + !

			ptr@ return
		end

		i@ 1 + i!
	end

	ERR
end

procedure TtyAdd (* -- tty *)
	auto tty
	TtyAlloc tty!

	if (tty@ ERR ==)
		"couldn't allocate tty\n" Panic
	end

	tty@ tty_Minor + @ "tty: adding tty%d\n" Printf

	auto kbdbuf
	TTY_KBD_BUF_SIZE Calloc kbdbuf!

	kbdbuf@ tty@ tty_KbdBuf + !

	auto bigbuf
	TTY_BIG_BUF_SIZE Calloc bigbuf!

	bigbuf@ tty@ tty_BigBuf + !

	auto devbuf
	TTY_DEV_BUF_SIZE Calloc devbuf!

	devbuf@ tty@ tty_DevBuf + !

	TtyNum@ 1 + TtyNum!

	tty@
end

procedure TtyWorker (* -- *)
	"tty worker thread up\n" Printf

	while (1)
		auto i
		0 i!

		while (i@ TTY_MAX <)
			auto tty
			i@ tty_SIZEOF * TtyTable@ + tty!

			if (tty@ tty_Status + @ TTY_EMPTY ~=)
				auto c
				tty@ TtyDevbufGetc c!
				while (c@ -1 ~=)
					c@ tty@ TtyDoInput
					tty@ TtyDevbufGetc c!
				end
			end

			i@ 1 + i!
		end
	end
end

procedure TtyDevbufPutc (* c tty -- ok? *)
	auto tty
	tty!

	auto c
	c!

	auto rptr

	tty@ tty_DevBufRead + @ rptr!

	auto wptr

	tty@ tty_DevBufWrite + @ wptr!

	if (wptr@ rptr@ - TTY_DEV_BUF_SIZE >=) (* full *)
		0 return
	end

	auto devbuf

	tty@ tty_DevBuf + @ devbuf!

	c@ wptr@ TTY_DEV_BUF_SIZE % devbuf@ + sb

	wptr@ 1 + tty@ tty_DevBufWrite + !

	1
end

procedure TtyDevbufGetc (* tty -- c or -1 *)
	auto tty
	tty!

	auto devbuf

	tty@ tty_DevBuf + @ devbuf!

	auto rptr

	tty@ tty_DevBufRead + @ rptr!

	auto wptr

	tty@ tty_DevBufWrite + @ wptr!

	if (rptr@ wptr@ ==) (* empty *)
		-1 return
	end

	rptr@ 1 + tty@ tty_DevBufRead + !

	rptr@ TTY_DEV_BUF_SIZE % devbuf@ + gb
end

procedure TtyBbufPutc (* c tty -- ok? *)
	auto tty
	tty!

	auto c
	c!

	auto rptr

	tty@ tty_BigBufRead + @ rptr!

	auto wptr

	tty@ tty_BigBufWrite + @ wptr!

	if (wptr@ rptr@ - TTY_BIG_BUF_SIZE >=) (* full *)
		0 return
	end

	auto bigbuf

	tty@ tty_BigBuf + @ bigbuf!

	c@ wptr@ TTY_BIG_BUF_SIZE % bigbuf@ + sb

	wptr@ 1 + tty@ tty_BigBufWrite + !

	1
end

procedure TtyBbufGetc (* tty -- c or -1 *)
	auto tty
	tty!

	auto bigbuf

	tty@ tty_BigBuf + @ bigbuf!

	auto rptr

	tty@ tty_BigBufRead + @ rptr!

	auto wptr

	tty@ tty_BigBufWrite + @ wptr!

	if (rptr@ wptr@ ==) (* empty *)
		-1 return
	end

	rptr@ 1 + tty@ tty_BigBufRead + !

	rptr@ TTY_BIG_BUF_SIZE % bigbuf@ + gb
end

procedure TtyKbufPutc (* c tty -- ok? *)
	auto tty
	tty!

	auto c
	c!

	auto rptr

	tty@ tty_KbdBufRead + @ rptr!

	auto wptr

	tty@ tty_KbdBufWrite + @ wptr!

	if (wptr@ rptr@ - TTY_KBD_BUF_SIZE >=) (* full *)
		0 return
	end

	auto kbdbuf

	tty@ tty_KbdBuf + @ kbdbuf!

	c@ wptr@ TTY_KBD_BUF_SIZE % kbdbuf@ + sb

	wptr@ 1 + tty@ tty_KbdBufWrite + !

	1
end

procedure TtyKbufGetc (* tty -- c or -1 *)
	auto tty
	tty!

	auto kbdbuf

	tty@ tty_KbdBuf + @ kbdbuf!

	auto rptr

	tty@ tty_KbdBufRead + @ rptr!

	auto wptr

	tty@ tty_KbdBufWrite + @ wptr!

	if (rptr@ wptr@ ==) (* empty *)
		-1 return
	end

	rptr@ 1 + tty@ tty_KbdBufRead + !

	rptr@ TTY_KBD_BUF_SIZE % kbdbuf@ + gb
end

procedure TtyKbufRemovec (* tty -- count *)
	auto tty
	tty!

	auto kbdbuf

	tty@ tty_KbdBuf + @ kbdbuf!

	auto rptr

	tty@ tty_KbdBufRead + @ rptr!

	auto wptr

	tty@ tty_KbdBufWrite + @ wptr!

	if (wptr@ rptr@ - 0 ==) (* already empty *)
		0 return
	end

	auto c
	wptr@ 1 - kbdbuf@ + gb c!

	wptr@ 1 - tty@ tty_KbdBufWrite + !

	if (c@ 0x20 <)
		2 return
	end else
		if (c@ TtyPrintable ~~)
			0 return
		end else
			1 return
		end
	end
end

procedure TtyRubout (* tty -- rc *)
	auto tty
	tty!

	auto ao
	tty@ tty_ActualOut + @ ao!

	auto rc
	tty@ TtyKbufRemovec rc!

	auto i
	0 i!
	while (i@ rc@ <)
		if (ao@ 0 ~=)
			'\b' ao@ Call
			' ' ao@ Call
			'\b' ao@ Call
		end

		i@ 1 + i!
	end

	rc@
end

procedure TtySubmit (* tty -- *)
	auto tty
	tty!

	auto c1

	tty@ TtyKbufGetc c1!

	while (c1@ -1 ~=)
		c1@ tty@ TtyBbufPutc drop

		tty@ TtyKbufGetc c1!
	end

	tty@ wakeup
end

(* called by device interrupt to put character on queue *)
procedure TtyInput (* char tty -- *)
	auto tty
	tty!

	auto c
	c!

	c@ tty@ TtyDevbufPutc drop
end

procedure TtyDoInput (* char tty -- *)
	auto tty
	tty!

	auto c
	c!

	if (c@ '\n' ==)
		if ('\n' tty@ TtyKbufPutc)
			'\n' tty@ TtyEchoChar

			tty@ TtySubmit
		end
	end else

	if (c@ '\b' ==)
		tty@ TtyRubout drop
	end else
		if (c@ 26 ==)
			"^Z received, resetting machine" Printf
			cpu_reset
		end

		if (c@ 21 ==) (* ^U *)
			auto rc
			tty@ TtyRubout rc!
			while (rc@ 0 >)
				tty@ TtyRubout rc!
			end

			return
		end

		if (c@ 4 ==) (* ^D *)
			if (4 tty@ TtyKbufPutc)
				4 tty@ TtyEchoChar

				tty@ TtySubmit
			end

			return
		end

		if (c@ 3 ==) (* ^C *)
			3 tty@ TtyEchoChar

			tty@ TtySubmit

			SIGINT tty@ tty_PGRP + @ TaskSignalGroup drop

			return
		end

		if (c@ tty@ TtyKbufPutc)
			c@ tty@ TtyEchoChar
		end
	end

	end
end

procedure TtyPutc (* c tty -- *)
	auto tty
	tty!

	auto c
	c!

	auto ao
	tty@ tty_ActualOut + @ ao!

	if (ao@ 0 ~=)
		c@ ao@ Call
	end
end

table TtyCtrl
	'@'
	'A' 'B' 'C'
	'D' 'E' 'F'
	'G' 'H' 'I'
	'J' 'K' 'L'
	'M' 'N' 'O'
	'P' 'Q' 'R'
	'S' 'T' 'U'
	'V' 'W' 'X'
	'Y' 'Z'
	'['
	'\\'
	']'
	'^'
	'_'
	' '
endtable

procedure TtyEchoChar (* c tty -- *)
	auto tty
	tty!

	auto c
	c!

	if (c@ TtyPrintable ~~)
		return
	end

	auto outf
	tty@ tty_ActualOut + @ outf!

	if (c@ '\n' ==)
		'\n' outf@ Call
		return
	end

	if (c@ 0x20 <)
		'^' outf@ Call
		[c@]TtyCtrl@ outf@ Call
	end else
		c@ outf@ Call
	end
end

procedure TtyPrintable (* c -- printable? *)
	auto c
	c!

	c@ 0x7E <=
end