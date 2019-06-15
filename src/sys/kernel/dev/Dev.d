#include "dev/limnstation/limnstation.d"
#include "dev/graphics/Graphics.d"
#include "dev/virt/Virt.d"
#include "dev/tty.d"

procedure DevInit (* -- *)
	PlatformDevInit
	TtyInit
	VirtInit
end