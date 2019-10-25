#include "<df>/dragonfruit.h"
#include "<df>/platform/a3x/a3x.h"

externconst AFSErrors
extern ArgsInit
extern AFSInit
extern IDiskInit
extern ArgsValue
extern ArgsCheck
extern AFSLoadFile
extern AFSPrintList

var args 0
var BootDevice 0

var TotalRAM 0
public TotalRAM

const LoadBase 0x80000

procedure Main (* fwctx ciptr bootdev args -- *)
	args!

	(* remember the boot device *)
	BootDevice!

	(* initialize the client interface *)
	a3xInit

	args@ ArgsInit

	"==============================\n" Printf

	BootDevice@ "aisixboot: boot1 on dev%x\n" Printf

	if (args@ 0 ~=)
		args@ "aisixboot: kernel args: %s\n" Printf
	end

	"/memory" a3xDeviceSelect
		"totalRAM" a3xDGetProperty TotalRAM!
	a3xDeviceExit

	if (TotalRAM@ LoadBase <)
		LoadBase 1024 / "aisixboot: I refuse to run with less than %dKB of RAM.\n" Printf
		-1 a3xReturn
	end

	BootDevice@ IDiskInit
	AFSInit

	auto ab
	"boot:auto" ArgsValue ab!

	if (ab@ 0 ~=)
		ab@ "automatic load: boot:auto=%s\n" Printf

		if ("boot:nodelay" ArgsCheck ~~)
			auto cn
			"/clock" a3xDevTreeWalk cn!

			if (cn@ 0 ~=)
				"press 'p' in the next 2 seconds to cancel.\n" Printf

				cn@ a3xDeviceSelectNode
					2000 "wait" a3xDCallMethod drop
				a3xDeviceExit
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

procedure DoFile { arg buf -- }
	auto sz

	auto r
	buf@ LoadBase AFSLoadFile r! sz!

	if (r@ 1 ~=)
		[r@]AFSErrors@ buf@ "failed to load %s: %s\n" Printf
	end elseif (LoadBase@ 0x58494E56 ~=)
		buf@ "%s is not a standalone program\n" Printf
	end else
		a3xCIPtr@ BootDevice@ arg@ sz@ a3xFwctx@ asm "
			popv r5, r4
			popv r5, r3
			popv r5, r2
			popv r5, r1
			popv r5, r0
			call 0x80004 ;dependent on LoadBase
		"
	end
end

procedure Prompt (* -- *)
	auto Go
	1 Go!

	auto buf
	256 Calloc buf!

	auto word
	256 Calloc word!

	"/" AFSPrintList

	"Type name of standalone program, 'exit' to return, or 'ls' to list files.\nPress return to boot the kernel with normal args.\n" Printf

	while (Go@)
		"\t>> " Printf
		buf@ 255 Gets

		auto nw
		buf@ word@ ' ' 255 strntok nw!

		if (word@ strlen 0 >)
			if (word@ "exit" strcmp)
				0 Go!
			end elseif (word@ "ls" strcmp)
				if (nw@ 0 ~=)
					1 nw +=
				end
				nw@ AFSPrintList
			end else
				if (nw@ 0 ~=)
					1 nw +=
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

	-1 a3xReturn
end