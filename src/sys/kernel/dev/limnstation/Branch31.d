const PBBase 0xF8000000
const PBInfo 0xF8000800
const PBInfoIRQ 0xF8000FFC

var PBInterruptsVT 0

procedure Branch31Init (* -- *)
	1024 Calloc PBInterruptsVT!

	pointerof PBInterrupt 0x7 EBusSlotInterruptRegister
end

procedure PBInterruptDitch (* -- *)
	-1 PBInfoIRQ!
end

procedure PBInterrupt (* tf -- *)
	drop

	auto pbi
	PBInfoIRQ@ pbi!

	while (pbi@ -1 ~=)
		auto handler
		pbi@ 4 * PBInterruptsVT@ + @ handler!

		if (handler@ 0 ~=)
			handler@ Call
		end else
			pbi@ "spurious branch31 interrupt %d\n" Panic
		end

		PBInfoIRQ@ pbi!
	end
end

procedure PBInterruptRegister (* handler num -- *)
	4 * PBInterruptsVT@ + !
end