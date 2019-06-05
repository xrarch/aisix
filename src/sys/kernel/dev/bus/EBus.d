const EBusSlotsStart 0xC0000000
const EBusSlots 7
const EBusSlotSpace 0x8000000
const EBusMax 0xF8000000
const EBusBoardMagic 0x0C007CA1

var EBusBoards 0

procedure EBusSlotInterruptRegister (* handler slot -- *)
	0x98 + InterruptRegister
end

procedure EBusBranchInterruptRegister (* handler branch -- *)
	0x80 + InterruptRegister
end

procedure EBusBoardRegister (* board -- *)
	EBusBoards@ ListInsert
end

procedure EBusInit (* -- *)
	"ebus: init\n" Printf

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

			break
		end

		n@ ListNode_Next + @ n!
	end
end

procedure EBusProbe (* -- *)
	"ebus: probing\n" Printf

	auto i
	EBusSlotsStart i!

	auto a
	0 a!

	"enumerating boards:\n" Printf

	while (i@ EBusMax <)
		auto magic
		i@ EBusDecl_Magic + @ magic!

		auto tid
		i@ EBusDecl_ID + @ tid!

		auto name
		i@ EBusDecl_Name + name!

		a@ "\tebus%d: " Printf

		if (magic@ EBusBoardMagic ==)
			a@ i@ tid@ EBusDoBoard
		end

		CR

		i@ EBusSlotSpace + i!
		a@ 1 + a!
	end
end