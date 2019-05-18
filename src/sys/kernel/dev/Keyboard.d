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
	AmaKeyboardID@ AKeyboardPopCode "%d\n" Printf
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

asm "

AKeyboardLayout:
	.db \"a\"
	.db \"b\", \"c\", \"d\"
	.db \"e\", \"f\", \"g\"
	.db \"h\", \"i\", \"j\"
	.db \"k\", \"l\", \"m\"
	.db \"n\", \"o\", \"p\"
	.db \"q\", \"r\", \"s\"
	.db \"t\", \"u\", \"v\"
	.db \"w\", \"x\", \"y\"
	.db \"z\"
	.db \"0\", \"1\", \"2\"
	.db \"3\", \"4\", \"5\"
	.db \"6\", \"7\", \"8\"
	.db \"9\"
	.db \";\"
	.db 0x20
	.db 0x20
	.db \"-\"
	.db \"=\"
	.db \"[\"
	.db \"]\"
	.db \"\\\"
	.db \";\"
	.db \"/\"
	.db \".\"
	.db \"'\"
	.db \",\"

AKeyboardLayoutCtrl:
	.db \"t\"
	.db \"h\", \"i\", \"s\"
	.db \"f\", \"i\", \"r\"
	.db \"m\", \"w\", \"a\"
	.db \"r\", \"e\", \"s\"
	.db \"u\", \"c\", \"k\"
	.db \"s\", \"r\", \"s\"
	.db \"t\", \"u\", \"v\"
	.db \"w\", \"x\", \"y\"
	.db \"z\"
	.db \"0\", \"1\", \"2\"
	.db \"3\", \"4\", \"5\"
	.db \"6\", \"7\", \"8\"
	.db \"9\"
	.db \";\"
	.db 0x20
	.db 0x20
	.db \"-\"
	.db \"=\"
	.db \"[\"
	.db \"]\"
	.db \"\\\"
	.db \";\"
	.db \"/\"
	.db \".\"
	.db \"'\"
	.db \",\"

AKeyboardLayoutShift:
	.db \"A\"
	.db \"B\", \"C\", \"D\"
	.db \"E\", \"F\", \"G\"
	.db \"H\", \"I\", \"J\"
	.db \"K\", \"L\", \"M\"
	.db \"N\", \"O\", \"P\"
	.db \"Q\", \"R\", \"S\"
	.db \"T\", \"U\", \"V\"
	.db \"W\", \"X\", \"Y\"
	.db \"Z\"
	.db \")\", \"!\", \"@\"
	.db \"#\", \"$\", \"%\"
	.db \"^\", \"&\", \"*\"
	.db \"(\"
	.db \":\"
	.db 0x20
	.db 0x20
	.db \"_\"
	.db \"+\"
	.db \"{\"
	.db \"}\"
	.db \"|\"
	.db \":\"
	.db \"?\"
	.db \">\"
	.db \"\"\"
	.db \"<\"

"