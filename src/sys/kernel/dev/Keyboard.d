table AmaKeyboardDev
	0x8FC48FC4
	"AISA Keyboard"
	pointerof AmaKeyboardDevice
endtable

var AmaKeyboardID 0

procedure AmaKeyboardDevice (* id -- *)
	auto id
	id!

	if (AmaKeyboardID@ 0 ~=)
		return
	end

	id@ AmaKeyboardID!

	pointerof AmaKeyboardInt id@ AmanatsuSetInterrupt
end

procedure AmaKeyboardInit (* -- *)
	AmaKeyboardDev AmanatsuDevRegister
end

procedure AmaKeyboardInt (* -- *)
	auto pc
	AmaKeyboardID@ AKeyboardPopCode pc!
	while (pc@ 0xFFFF ~=)
		pc@ "%d " Printf
		AmaKeyboardID@ AKeyboardPopCode pc!
	end
end

procedure AKeyboardPopCode (* id -- code *)
	auto id
	id!

	auto rs
	InterruptDisable rs!

	auto code

	id@ AmanatsuSelectDev
	1 AmanatsuCommand
	AmanatsuReadA code!

	rs@ InterruptRestore

	code@
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
	0
	'/'
	'.'
	'\''
	','
	'`'
endtable

table AKeyboardLayoutCtrl
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
	0
	'/'
	'.'
	'\''
	','
	'`'
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
	0
	'?'
	'>'
	'"'
	'<'
	'~'
endtable