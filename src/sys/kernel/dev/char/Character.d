#include "dev/char/Serial.d"
#include "dev/char/Keyboard.d"

procedure CharacterInit (* -- *)
	"chardevs: init\n" Printf

	SerialInit
	KeyboardInit
end