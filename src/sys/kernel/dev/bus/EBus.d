const EBusSlotsStart 0xC0000000
const EBusSlots 7
const EBusSlotSpace 0x8000000
const EBusBoardMagic 0x0C007CA1

procedure EBusSlotInterruptRegister (* handler slot -- *)
	0x98 + InterruptRegister
end

procedure EBusBranchInterruptRegister (* handler branch -- *)
	0x80 + InterruptRegister
end