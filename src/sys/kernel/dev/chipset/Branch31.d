const PBBase 0xF8000000
const PBInfo 0xF8000800
const PBInfoIRQ 0xF8000FFC

var PBInterruptsVT 0

procedure Branch31Init (* -- *)
	"branch31: init\n" Printf

	1024 Calloc PBInterruptsVT!

	pointerof PBInterrupt 0x7 EBusSlotInterruptRegister
end

procedure PBInterrupt (* -- *)
	auto handler
	PBInfoIRQ@ 4 * PBInterruptsVT@ + @ handler!

	if (handler@ 0 ~=)
		handler@ Call
	end
end

procedure PBInterruptRegister (* handler num -- *)
	4 * PBInterruptsVT@ + !
end