#include "dev/char/tty.d"
#include "dev/char/Serial.d"
#include "dev/char/Keyboard.d"

procedure CharacterInit (* -- *)
	"chardevs: init\n" Printf

	TtyInit

	SerialInit
	KeyboardInit
end