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

var VDB 0

procedure LoadVDB (* -- *)
	4096 Malloc VDB!

	0 VDB@ IReadBlock
end

procedure FreeVDB (* -- *)
	VDB@ Free
end

procedure VDBValid (* -- valid? *)
	VDB@ VDB_Magic + @ 0x4E4D494C ==
end

procedure VDBLabel (* -- label *)
	VDB@ VDB_Label +
end

procedure VDBFix (* -- ok? *)
	if (VDBValid) 1 return end

	auto ynr

	"this disk's vol. descriptor block is corrupt or empty.\nwrite new one" PromptYN ynr!

	if (ynr@ ~~) 0 return end

	auto nbuf
	16 Calloc nbuf!

	"disk label: " Printf

	nbuf@ 15 Gets

	auto buf
	4096 Calloc buf!

	0x4E4D494C buf@ VDB_Magic + !

	buf@ VDB_Label + nbuf@ strcpy

	"writing new vdb...\n" Printf

	0 buf@ IWriteBlock

	buf@ Free
	nbuf@ Free

	FreeVDB
	LoadVDB

	"fixed vdb successfully.\n\n" Printf

	1 return
end

procedure PTESet (* label blocks status ent -- *)
	auto ent
	ent!

	auto status
	status!

	auto blocks
	blocks!

	auto label
	label!

	auto ptb
	VDB@ VDB_PartitionTable + ptb!
	ptb@ ent@ PTE_SIZEOF * + ptb!

	ptb@ PTE_Label + label@ strcpy
	blocks@ ptb@ PTE_Blocks + !
	status@ ptb@ PTE_Status + sb
end

procedure PartitionDisk (* -- *)
	LoadVDB

	if (VDBFix ~~)
		"vdb invalid. cannot continue.\n" Printf
		return
	end

	FreeVDB
end