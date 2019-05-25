#include "dev/chipset/Branch31.d"
#include "dev/chipset/MMU.d"
#include "dev/chipset/Clock.d"

procedure ChipsetInit (* -- *)
	Branch31Init
	MMUInit
	ClockInit
end