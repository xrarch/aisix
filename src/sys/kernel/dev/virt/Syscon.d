(* polled boy *)

var SysconOut 0
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

	auto rs
	InterruptDisable rs!

	if (SysconOut@ 0 ==)
		return
	end

	c@ SysconOut@ Call

	rs@ InterruptRestore
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

procedure SysconInit (* -- *)
	"syscon: init\n" Printf

	auto sca
	"tty0" ArgsValue sca!

	auto contty
	TtyAdd dup contty! SysconTty!

	if (sca@ 0 ==)
		(* defaults *)

		if (VidConPresent@)
			pointerof VConsolePutChar SysconSetOut

			if (KeyboardPresent@)
				contty@ KeyboardTty!
			end
		end else
			pointerof SerialWritePolled SysconSetOut

			contty@ SerialTty!
		end
	end
end