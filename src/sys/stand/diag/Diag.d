#include "<df>/dragonfruit.h"
#include "<df>/platform/a3x/a3x.h"

var args 0
var BootDevice 0

extern PromptYN
extern Prompt

procedure Main (* fwctx ciptr bootdev args -- *)
	args!

	(* remember the boot device *)
	BootDevice!

	(* initialize the client interface *)
	a3xInit

	"\n\t=== diag ===\nStandalone diagnostics utility for LIMNstation,1.\n" Printf

	auto pf

	"/platform" a3xDeviceSelect
		"platform" a3xDGetProperty pf!
	a3xDeviceExit

	if (pf@ 0 ==) return end

	if ("LIMNstation,1" pf@ strcmp ~~)
		pf@ "\nwarning, platform mismatch:\n\tthis utility: LIMNstation,1\n\tfirmware reports: %s\n\ncontinue anyway"

		if (PromptYN ~~)
			return
		end
	end

	Prompt
end