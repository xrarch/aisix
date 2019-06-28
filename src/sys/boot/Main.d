#include "../lib/a3x.d"
#include "../lib/a3x_names.d"
#include "../../lib/Runtime.d"

var args 0
var BootDevice 0
var TotalRAM 0

#include "IDisk.d"
#include "aisixfat.d"
#include "Args.d"

asm preamble "

.org 0x100000

.ds ANTE
.dl Entry

Entry:

push ivt

;push firmware context
pushv r5, sp

;r0 contains pointer to API
pushv r5, r0

;r1 contains devnode
pushv r5, r1

;r2 contains args
pushv r5, r2

b Main

"

procedure Main (* fwctx ciptr bootdev args -- *)
	args!

	(* remember the boot device *)
	BootDevice!

	(* initialize the client interface *)
	a3xInit

	args@ ArgsInit

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

	auto ab
	"boot:auto" ArgsValue ab!

	if (ab@ 0 ~=)
		ab@ "automatic load: boot:auto=%s\n" Printf

		if ("-boot:nodelay" ArgsCheck ~~)
			auto cn
			"/clock" DevTreeWalk cn!

			if (cn@ 0 ~=)
				"press 'p' in the next 2 seconds to cancel.\n" Printf

				cn@ DeviceSelectNode
					2000 "wait" DCallMethod drop
				DeviceExit
			end
		end

		auto cl
		0 cl!
		auto c
		Getc c!
		while (c@ -1 ~=)
			if (c@ 'p' ==)
				1 cl!
				break
			end
			Getc c!
		end

		if (cl@ ~~)
			args@ ab@ DoFile
		end else
			"automatic load cancelled\n" Printf
		end
	end

	Prompt

	0 a3xReturn
end

procedure DoFile (* args f -- *)
	auto buf
	buf!

	auto arg
	arg!

	auto sz

	auto r
	buf@ 0x200000 AFSLoadFile r! sz!
	if (r@ 1 ~=)
		[r@]AFSErrors@ buf@ "failed to load %s: %s\n" Printf
	end else
		if (0x200000@ 0x58494E56 ~=)
			buf@ "%s is not a standalone program\n" Printf
		end else
			CR CR

			a3xCIPtr@ BootDevice@ arg@ sz@ a3xFwctx@ asm "
				popv r5, r4
				popv r5, r3
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



















