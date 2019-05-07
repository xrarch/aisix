#include "../../lib/a3x.d"
#include "../../lib/Runtime.d"

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

	if (args@ 0 ==)
		"no args\n" Printf
	end else
		args@ "args: %s\n" Printf
	end
end