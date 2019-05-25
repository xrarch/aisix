#include "dev/virt/VidConsole.d"
#include "dev/virt/Syscon.d"

procedure VirtInit (* -- *)
	"pseudodevs: init\n" Printf

	VidConInit
	SysconInit
end