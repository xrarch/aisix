#include "Runtime.d"
#include "lib/List.d"
#include "lib/Tree.d"
#include "Console.d"
#include "DeviceTree.d"
#include "IDisk.d"
#include "aisixfat.d"

asm preamble "

.org 0x100000

.ds ANTE
.dl Entry

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
	CIPtr!

	"==============================\n" Printf

	BootDevice@ "boot1 on dev%x\n" Printf

	if (args@ 0 ~=)
		args@ "kernel args: %s\n" Printf
	end

	APIDevTree DeviceInit

	BootDevice@ IDiskInit
	AFSInit

	Prompt

	DevStack@ Free
end

procedure DoFile (* f -- *)
	auto buf
	buf!

	buf@ 0x200000 AFSLoadFile
	if (0 ==)
		buf@ "failed to load %s\n" Printf
	end else
		if (0x200000@ 0x58494E56 ~=)
			buf@ "%s is not a standalone program\n" Printf
		end else
			CIPtr@ BootDevice@ args@ asm "
				pushv r5, r2
				pushv r5, r1
				pushv r5, r0
				call 0x200004
			"
		end
	end
end

procedure Prompt (* -- *)
	auto Go
	1 Go!

	auto buf
	256 Calloc buf!

	AFSPrintList

	"Type name of standalone program in root directory, or 'exit' to return.\n" Printf

	while (Go@)
		"\t# " Printf
		buf@ 255 Gets

		if (buf@ strlen 0 >)
			if (buf@ "exit" strcmp)
				0 Go!
			end else
				buf@ DoFile
			end
		end
	end

	buf@ Free
end

procedure Panic (* errorstr -- *)
	"panic: %s\n" Printf
end



















