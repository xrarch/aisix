#include "dev/limnstation/bus/Bus.d"
#include "dev/limnstation/Branch31.d"
#include "dev/limnstation/Clock.d"
#include "dev/limnstation/Serial.d"
#include "dev/limnstation/Keyboard.d"

#include "dev/limnstation/FwBlock.d"

(* graphics devices dont get initialized here *)
#include "dev/limnstation/Kinnow3.d"

procedure PlatformDevInit (* -- *)
	BusInit
	GraphicsInit
	Branch31Init
	ClockInit
	SerialInit
	KeyboardInit

	BusProbe

	GraphicsLateInit

	FwBlockInit
end