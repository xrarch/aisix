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

procedure CheckInvalid (* arg -- devnode OR 0 if invalid *)
	auto arg
	arg!

	if (args@ 0 ==)
		"no disk name provided.\n" Printf
		0 return
	end

	auto disk
	256 Calloc disk!

	auto nw
	args@ disk@ ' ' 255 strntok nw!

	auto dn
	disk@ DevTreeWalk dn!

	if (dn@ 0 ==)
		disk@ "%s is an invalid disk path.\n" Printf
		disk@ Free
		0 return
	end

	auto wbm

	dn@ DeviceSelectNode
		"readBlock" DGetMethod wbm!
	DeviceExit

	if (wbm@ 0 ==)
		disk@ "%s isn't a readable block device.\n" Printf
		disk@ Free
		0 return
	end

	disk@ Free

	auto dpbd
	dn@ DeviceSelectNode
		"bootAlias" DGetProperty dpbd!
	DeviceExit

	if (dpbd@ 0 ~=)
		dpbd@ dn!
	end

	dn@
end

procedure Main (* ciptr bootdev args -- *)
	args!

	(* remember the boot device *)
	BootDevice!

	(* initialize the client interface *)
	a3xInit

	auto dpbd
	BootDevice@ DeviceSelectNode
		"bootAlias" DGetProperty dpbd!
	DeviceExit

	if (dpbd@ 0 ~=)
		dpbd@ BootDevice!
	end

	"\n\t=== dskfa ===\nStandalone disk utility.\n" Printf

	auto dn
	args@ CheckInvalid dn!

	if (dn@ 0 ==)
		"no disk path provided, or invalid.\n" Printf

		"\nusage:\n\tdskfa.a3x [diskpath]\n\n" Printf

		return
	end

	dn@ "a3x devnode: %x\n" Printf

	if (dn@ BootDevice@ ==)
		if ("\nwarning, you're attempting to work on the same device that this utility was\nloaded from. are you sure that this is what you want" PromptYN ~~)
			return
		end
	end
end





