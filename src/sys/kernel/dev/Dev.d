#include "dev/bus/Bus.d"
#include "dev/MMU.d"
#include "dev/Branch31.d"
#include "dev/Clock.d"
#include "dev/Serial.d"
#include "dev/Keyboard.d"
#include "dev/graphics/Graphics.d"
#include "dev/Syscon.d"

procedure LowlevelInit (* -- *)
	EBusEarlyInit
	AmanatsuEarlyInit
	AmaKeyboardInit
	GraphicsEarlyInit
	Branch31Init
	EarlyClockInit
end

procedure EarlyDeviceInit (* -- *)
	"dev: early init\n" Printf

	LowlevelInit
end

procedure LateDeviceInit (* -- *)
	"dev: late init\n" Printf

	LateClockInit
	SerialInit
	EBusLateInit
	AmanatsuLateInit
	GraphicsLateInit
	SysconLateInit
end