table AmaKeyboardDev
	0x8FC48FC4
	"AISA Keyboard"
	pointerof AmaKeyboardDevice
endtable

var AmaKeyboardID 0

var KeyboardPresent 0
var KeyboardTty 0

var KeyboardCapsLock 0

procedure AmaKeyboardDevice (* id -- *)
	auto id
	id!

	if (AmaKeyboardID@ 0 ~=)
		return
	end

	id@ AmaKeyboardID!

	pointerof AmaKeyboardInt id@ AmanatsuSetInterrupt

	AKeyboardReset

	1 KeyboardPresent!
end

procedure KeyboardInit (* -- *)
	AmaKeyboardDev AmanatsuDevRegister
end

procedure AmaKeyboardInt (* -- *)
	auto code

	if (KeyboardTty@ 0 ==)
		0 code!
		while (code@ 0xFFFF ~=)
			AKeyboardPopCode code!
		end
		return
	end

	AKeyboardPopCode code!
	while (code@ 0xFFFF ~=)
		auto c

		code@ AKeyboardProcessKey c!

		if (c@ -1 ==)
			return
		end

		c@ KeyboardTty@ TtyPutc

		AKeyboardPopCode code!
	end
end

procedure AKeyboardProcessKey (* code -- char *)
	auto code
	code!

	auto c

	if (code@ 0xF0 ==) (* shift *)

		AKeyboardPopCode code!

		if (code@ 50 >=) code@ AKeyboardSpecial return end

		[code@]AKeyboardLayoutShift@ c!

	end else if (code@ 0xF1 ==) (* ctrl *)

		AKeyboardPopCode code!

		if (code@ 50 >=) code@ AKeyboardSpecial return end

		[code@]AKeyboardLayoutCtrl@ c!

	end else

		if (KeyboardCapsLock@)

			if (code@ 50 >=) code@ AKeyboardSpecial return end

			[code@]AKeyboardLayoutShift@ c!

		end else

			if (code@ 50 >=) code@ AKeyboardSpecial return end

			[code@]AKeyboardLayout@ c!
			
		end

	end
	end

	c@
end

procedure AKeyboardPopCode (* -- code *)
	auto id
	AmaKeyboardID@ id!

	auto rs
	InterruptDisable rs!

	auto code

	id@ AmanatsuSelectDev
	1 AmanatsuCommand
	AmanatsuReadA code!

	rs@ InterruptRestore

	code@
end

procedure AKeyboardReset (* -- *)
	auto id
	AmaKeyboardID@ id!

	auto rs
	InterruptDisable rs!

	id@ AmanatsuSelectDev
	2 AmanatsuCommand

	rs@ InterruptRestore
end

procedure AKeyboardSpecial (* code -- *)
	auto code
	code!

	if (code@ 50 ==)
		'\n' return
	end
	if (code@ 51 ==)
		'\b' return
	end
	if (code@ 52 ==)
		KeyboardCapsLock@ ~~ KeyboardCapsLock!
		-1 return
	end

	ERR return
end

table AKeyboardLayout
	'a'
	'b' 'c' 'd'
	'e' 'f' 'g'
	'h' 'i' 'j'
	'k' 'l' 'm'
	'n' 'o' 'p'
	'q' 'r' 's'
	't' 'u' 'v'
	'w' 'x' 'y'
	'z'
	'0' '1' '2'
	'3' '4' '5'
	'6' '7' '8'
	'9'
	';'
	' '
	' '
	'-'
	'='
	'['
	']'
	'\\'
	-1
	'/'
	'.'
	'\''
	','
	'`'
endtable

table AKeyboardLayoutCtrl
	1
	2 3 4
	5 6 7
	8 9 10
	11 12 13
	14 15 16
	17 18 19
	20 21 22
	23 24 25
	26
	-1 -1 0
	-1 -1 -1
	30 -1 -1
	-1
	-1
	-1
	-1
	31
	-1
	27
	29
	28
	-1
	-1
	-1
	-1
	-1
	-1
endtable

table AKeyboardLayoutShift
	'A'
	'B' 'C' 'D'
	'E' 'F' 'G'
	'H' 'I' 'J'
	'K' 'L' 'M'
	'N' 'O' 'P'
	'Q' 'R' 'S'
	'T' 'U' 'V'
	'W' 'X' 'Y'
	'Z'
	')' '!' '@'
	'#' '$' '%'
	'^' '&' '*'
	'('
	':'
	' '
	' '
	'_'
	'+'
	'{'
	'}'
	'|'
	-1
	'?'
	'>'
	'"'
	'<'
	'~'
endtable