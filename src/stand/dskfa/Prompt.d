procedure PromptYN (* -- *)
	auto r
	2 Calloc r!

	Printf
	" [y/n]? " Printf

	r@ 1 Gets

	if (r@ gb 'y' ==)
		r@ Free
		1 return
	end

	r@ Free
	0 return
end

var Running 0

buffer PromptLine 128

buffer CommandTable 512

buffer PartitionTable 32

const VDBCache 0x220000

const MiscCache 0x230000

struct VDB
	16 Label
	128 PartitionTable
	4 Magic
endstruct

struct PTE
	8 Label
	4 Blocks
	1 Status
	3 Unused
endstruct

procedure BuildPT (* -- *)
	auto i
	0 i!

	auto ptr
	VDBCache VDB_PartitionTable + ptr!

	auto ps
	0 ps!
	while (i@ 8 <)
		if (ptr@ PTE_Status + gb 0 ~=)
			if (i@ 0 ==)
				ps@ 2 + ps!
			end

			ps@ i@ 4 * PartitionTable + !
			ptr@ PTE_Blocks + @ ps@ + ps!
		end else
			-1 i@ 4 * PartitionTable + !
		end

		ptr@ PTE_SIZEOF + ptr!
		i@ 1 + i!
	end
end

procedure SaveVDB (* -- *)
	"Writing VDB...\n" Printf
	0 VDBCache IWriteBlock
end

procedure CommandLine (* -- *)
	CLInit

	"Type h for a list of commands.\n" Printf

	1 Running!

	while (Running@)
		CLPrompt
	end
end

procedure CLNotACommand (* cstr -- *)
	drop
	"Not a valid command.\n" Printf
end

procedure CLRegisterCommand (* handler char -- *)
	4 * CommandTable + !
end

procedure CLInit (* -- *)
	0 VDBCache IReadBlock

	BuildPT

	auto i
	0 i!
	while (i@ 128 <)
		pointerof CLNotACommand i@ CLRegisterCommand
		i@ 1 + i!
	end

	pointerof CmdHelpText 'h' CLRegisterCommand
	pointerof CmdQuit 'q' CLRegisterCommand
	pointerof CmdSave 's' CLRegisterCommand
	pointerof CmdInfo 'i' CLRegisterCommand
	pointerof CmdFormat 'f' CLRegisterCommand
	pointerof CmdPartition 'p' CLRegisterCommand
end

procedure CLPrompt (* -- *)
	"dskfa> " Printf
	PromptLine 127 Gets

	PromptLine gb dup
	if (0 ==)
		return
	end
	4 * CommandTable + @ PromptLine 1 + swap Call
end

procedure CmdHelpText (* cstr -- *)
	drop
"h - help
q - quit
s - save changes
i - print disk info
p - partition
f<name> - format (will overwrite VDB, partition table wiped out)
c<dev> - change to dev\n" Printf
end

procedure CmdPartition (* cstr -- *)
	drop

	auto pbase

	auto i
	0 i!
	while (i@ 8 <)
		VDBCache VDB_PartitionTable + PTE_SIZEOF i@ * + pbase!

		pbase@ "%x\n" Printf

		i@ "partition %d: \n" Printf
		"\tstatus (0 unused, 1 boot, 2 used): " Printf
		PromptLine 1 Gets
		PromptLine atoi dup pbase@ PTE_Status + sb

		if (0 ~=)
			"\tlabel: " Printf
			PromptLine 7 Gets
			pbase@ PTE_Label + PromptLine strcpy

			"\tblocks: " Printf
			PromptLine 10 Gets
			PromptLine atoi pbase@ PTE_Blocks + !
		end

		i@ 1 + i!
	end

	BuildPT
end

procedure CmdFormat (* cstr -- *)
	auto ptr
	VDBCache ptr!
	auto max
	VDBCache 4096 + max!
	while (ptr@ max@ <)
		0 ptr@ !
		ptr@ 4 + ptr!
	end

	VDBCache swap strcpy

	0x4E4D494C VDBCache VDB_Magic + !
end

procedure CmdQuit (* cstr -- *)
	drop
	"Bye!\n" Printf
	0 Running!
end

procedure CmdSave (* cstr -- *)
	drop
	SaveVDB
end

procedure CmdInfo (* cstr -- *)
	drop

	"Disk Info:\n" Printf
	VDBCache VDB_Magic + dup "\tMagic: %s\n" Printf

	if (@ 0x4E4D494C ~=) (* check for signature *)
		"Invalid volume descriptor. Type 'f<name>' to format.\n" Printf
		return
	end

	VDBCache VDB_Label + "\tDisk Label: %s\n" Printf

	"Partitions:\n" Printf

	auto i
	0 i!
	auto ptr
	VDBCache VDB_PartitionTable + ptr!
	while (i@ 8 <)
		if (ptr@ PTE_Status + gb 0 ~=)
			ptr@ i@ "\t%d: %s\n" Printf
			ptr@ PTE_Status + gb "\t\tStatus: %d\n" Printf
			ptr@ PTE_Blocks + @ "\t\tSize: %d blocks\n" Printf
		end

		ptr@ PTE_SIZEOF + ptr!
		i@ 1 + i!
	end
end