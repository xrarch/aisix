#include "dev/virt/VidConsole.d"
#include "dev/virt/Syscon.d"

procedure VirtInit (* -- *)
	VidConInit
	SysconInit
end