#include "dev/bus/Bus.d"
#include "dev/chipset/Chipset.d"
#include "dev/graphics/Graphics.d"
#include "dev/char/Character.d"
#include "dev/virt/Virt.d"

procedure DeviceInit (* -- *)
	"dev: init\n" Printf

	BusInit
	ChipsetInit
	GraphicsInit
	CharacterInit

	BusProbe

	GraphicsLateInit

	VirtInit
end