const EBusSlotsStart 0xC0000000
const EBusSlots 7
const EBusSlotSpace 0x8000000
const EBusMax 0xF8000000
const EBusBoardMagic 0x0C007CA1

var EBusBoards 0

procedure EBusSlotInterruptRegister (* handler slot -- *)
	0x98 + TrapRegister
end

procedure EBusBranchInterruptRegister (* handler branch -- *)
	0x80 + TrapRegister
end

procedure EBusBoardRegister (* board -- *)
	EBusBoards@ ListInsert
end

procedure EBusInit (* -- *)
	ListCreate EBusBoards!
end

procedure EBusDoBoard (* slot slotspace id -- *)
	auto id
	id!

	auto slotspace
	slotspace!

	auto slot
	slot!

	auto n
	EBusBoards@ ListHead n!

	while (n@ 0 ~=)
		auto pnode
		n@ ListNodeValue pnode!

		if (pnode@ EBusBoard_ID + @ id@ ==)
			slotspace@ pnode@ EBusBoard_Name + @ "%s @ 0x%x" Printf

			slot@ slotspace@ pnode@ EBusBoard_Constructor + @ Call

			return
		end

		n@ ListNode_Next + @ n!
	end

	id@ "Unknown board (ID %x)" Printf
end

procedure EBusProbe (* -- *)
	auto i
	EBusSlotsStart i!

	auto a
	0 a!

	"ebus: enumerating boards\n" Printf

	while (i@ EBusMax <)
		auto magic
		i@ EBusDecl_Magic + @ magic!

		auto tid
		i@ EBusDecl_ID + @ tid!

		auto name
		i@ EBusDecl_Name + name!

		if (magic@ EBusBoardMagic ==)
			a@ "\tebus%d: " Printf

			a@ i@ tid@ EBusDoBoard

			CR
		end

		i@ EBusSlotSpace + i!
		a@ 1 + a!
	end
end