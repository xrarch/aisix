#include "../../lib/a3x.d"
#include "../../lib/Runtime.d"

#include "Prompt.d"

asm preamble "

.org 0x200000

.ds VNIX

Entry:

;r0 contains pointer to API
pushv r5, r0

;r1 contains devnode
pushv r5, r1

;r2 contains args
pushv r5, r2

b Main

"

var args 0
var BootDevice 0

procedure Main (* ciptr bootdev args -- *)
	args!

	(* remember the boot device *)
	BootDevice!

	(* initialize the client interface *)
	a3xInit

	"\n\t=== diag ===\nStandalone diagnostics utility for LIMNstation,1.\n" Printf

	auto pf

	"/" DeviceSelect
		"platform" DGetProperty pf!
	DeviceExit

	if (pf@ 0 ==) return end

	if ("LIMNstation,1" pf@ strcmp ~~)
		pf@ "\nwarning, platform mismatch:\n\tthis utility: LIMNstation,1\n\tfirmware reports: %s\n\ncontinue anyway"

		if (PromptYN ~~)
			return
		end
	end

	Prompt
end