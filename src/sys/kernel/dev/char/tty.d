(* stole some concepts from qword, thanks mint *)

(* device-independent part of the tty infrastructure *)

var TtyList 0

var TtyNum 0

procedure TtyInit (* -- *)
	"tty: init\n" Printf

	ListCreate TtyList!
end

procedure TtyAdd (* -- tty *)
	TtyNum@ "tty: adding tty%d\n" Printf

	auto tty
	tty_SIZEOF Calloc tty!

	auto kbdbuf
	TTY_KBD_BUF_SIZE Calloc kbdbuf!

	kbdbuf@ tty@ tty_KbdBuf + !

	auto bigbuf
	TTY_BIG_BUF_SIZE Calloc bigbuf!

	bigbuf@ tty@ tty_BigBuf + !

	tty@ TtyList@ ListInsert

	TtyNum@ 1 + TtyNum!

	tty@
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
end

procedure TtyPutc (* char tty -- *)
	auto tty
	tty!

	auto c
	c!

	auto ao
	tty@ tty_ActualOut + @ ao!

	if (c@ '\n' ==)
		if ('\n' tty@ TtyKbufPutc)
			if (ao@ 0 ~=)
				ao@ '\n' TtyEchoChar
			end

			tty@ TtySubmit
		end
	end else

	if (c@ '\b' ==)
		tty@ TtyRubout drop
	end else
		if (c@ 26 ==)
			"^Z received, resetting machine\n" Printf
			ResetSystem
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
				if (ao@ 0 ~=)
					ao@ 4 TtyEchoChar
				end

				tty@ TtySubmit
			end
			
			return
		end

		if (c@ tty@ TtyKbufPutc)
			if (ao@ 0 ~=)
				ao@ c@ TtyEchoChar
			end
		end
	end

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

procedure TtyEchoChar (* outf c -- *)
	auto c
	c!

	auto outf
	outf!

	if (c@ TtyPrintable ~~)
		return
	end

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