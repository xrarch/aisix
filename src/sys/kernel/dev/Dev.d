#include "dev/bus/Bus.d"
#include "dev/MMU.d"
#include "dev/Branch31.d"
#include "dev/Clock.d"
#include "dev/Serial.d"
#include "dev/Keyboard.d"
#include "dev/graphics/Graphics.d"
#include "dev/Syscon.d"

procedure DevEarlyInit (* -- *)
	EBusEarlyInit
	AmanatsuEarlyInit
	AmaKeyboardInit
	GraphicsEarlyInit
	Branch31Init
	EarlyClockInit
end

procedure DevLateInit (* -- *)
	LateClockInit
	SerialInit
	EBusLateInit
	AmanatsuLateInit
	GraphicsLateInit
	SysconLateInit
end

procedure DeviceInit (* -- *)
	"dev: init\n" Printf

	DevEarlyInit
	DevLateInit
end