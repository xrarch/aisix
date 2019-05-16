#include "../lib/a3x.d"
#include "../lib/Runtime.d"

var args 0
var BootDevice 0
var TotalRAM 0

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

procedure Main (* ciptr bootdev args -- *)
	args!

	(* remember the boot device *)
	BootDevice!

	(* initialize the client interface *)
	a3xInit

	"==============================\n" Printf

	BootDevice@ "boot1 on dev%x\n" Printf

	if (args@ 0 ~=)
		args@ "kernel args: %s\n" Printf
	end

	"/memory" DeviceSelect
		"totalRAM" DGetProperty TotalRAM!
	DeviceExit

	BootDevice@ IDiskInit
	AFSInit

	Prompt
end

procedure DoFile (* args f -- *)
	auto buf
	buf!

	auto arg
	arg!

	auto r
	buf@ 0x200000 AFSLoadFile r!
	if (r@ 1 ~=)
		[r@]AFSErrors@ buf@ "failed to load %s: %s\n" Printf
	end else
		if (0x200000@ 0x58494E56 ~=)
			buf@ "%s is not a standalone program\n" Printf
		end else
			CIPtr@ BootDevice@ arg@ asm "
				popv r5, r2
				popv r5, r1
				popv r5, r0
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

	auto word
	256 Calloc word!

	AFSPrintList

	"Type name of standalone program, or 'exit' to return.\nPress return to boot the kernel with normal args.\n" Printf

	while (Go@)
		"\t>> " Printf
		buf@ 255 Gets

		auto nw
		buf@ word@ ' ' 255 strntok nw!

		if (word@ strlen 0 >)
			if (word@ "exit" strcmp)
				0 Go!
			end else
				if (nw@ 0 ~=)
					nw@ 1 + nw!
				end
				nw@ word@ DoFile
			end
		end else
			args@ "aisix" DoFile
		end
	end

	word@ Free
	buf@ Free
end

procedure Panic (* errorstr -- *)
	"panic: %s\n" Printf
end



















