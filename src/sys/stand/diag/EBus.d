#include "<df>/dragonfruit.h"

const EBusSlotsStart 0xC0000000
const EBusSlots 7
const EBusSlotSpace 0x8000000
const EBusBoardMagic 0x0C007CA1

procedure EBusDump (* -- *)
	"== ebus dump ==\n\tSLOT\tADDR\t\tID\t\tNAME\n" Printf

	auto i
	0 i!

	auto p
	EBusSlotsStart p!

	while (i@ EBusSlots <)
		auto bp
		i@ EBusSlotSpace * p@ + bp!

		if (bp@@ EBusBoardMagic ==)
			bp@ 8 + bp@ 4 + @ bp@ i@ "\t%d\t%x\t%x\t%s\n" Printf
		end else
			bp@ i@ "\t%d\t%x\tN/A\t\tNo board installed\n" Printf		
		end

		i@ 1 + i!
	end

	"\t7\tf8000000\tN/A\t\tPBOARD\n\n" Printf
end