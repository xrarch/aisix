const SerialCmdPort 0x10
const SerialDataPort 0x11

const SerialCmdWrite 1
const SerialCmdRead 2
const SerialCmdEnableInt 3

const SerialInterruptNum 0x2B

var SerialTty 0
var SerialIgnore 0

procedure SerialInit (* -- *)
	pointerof SerialInterrupt 0x2B PBInterruptRegister

	auto rs
	InterruptDisable rs!

	SerialCmdEnableInt SerialCmdPort DCitronCommand

	rs@ InterruptRestore
end

procedure SerialInterrupt (* -- *)
	if (SerialIgnore@)
		return
	end

	auto c

	if (SerialTty@ 0 ==) (* serial isnt attached to any tty *)
		0 c!

		while (c@ ERR ~=) (* so just loop reading off the buffer until its empty, to be safe *)
			SerialReadPolled c!
		end

		return
	end

	SerialReadPolled c!
	
	while (c@ ERR ~=)
		c@ SerialTty@ TtyInput
		SerialReadPolled c!
	end
end

procedure SerialWritePolled (* c -- *)
	auto rs
	InterruptDisable rs!

	SerialDataPort DCitronOutb
	SerialCmdWrite SerialCmdPort DCitronCommand

	rs@ InterruptRestore
end

procedure SerialReadPolled (* -- c *)
	auto rs
	InterruptDisable rs!

	auto c
	SerialCmdRead SerialCmdPort DCitronCommand
	SerialDataPort DCitronIni c!

	rs@ InterruptRestore

	if (c@ 0xFFFF ==)
		ERR return
	end

	c@
end