#include "dev/bus/Bus.d"
#include "dev/MMU.d"
#include "dev/Branch31.d"
#include "dev/Clock.d"
#include "dev/Serial.d"
#include "dev/Syscon.d"

procedure LowlevelInit (* -- *)
	Branch31Init
	EarlyClockInit
end

procedure EarlyDeviceInit (* -- *)
	LowlevelInit
end

procedure LateDeviceInit (* -- *)
	LateClockInit
	SerialInit
end