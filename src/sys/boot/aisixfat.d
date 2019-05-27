(* extremely simple, read-only implementation of aisixfat, only reads root directory *)

const AFSSuperblockNumber 0x0
const AFSSuperblockCache 0x110000
const AFSFATCache 0x120000
const AFSRootCache 0x130000
const AFSSuperblockMagic 0xAFBBAFBB
const AFSSuperblockVersion 0x4

struct AFSSuperblock
	1 Version
	4 Magic
	4 VolSize
	4 NumFiles
	1 Dirty
	4 BlocksUsed
	4 NumDirs
	4 NumReservedBlocks
	4 FATStart
	4 FATSize
	4 Root
	4 DataStart
endstruct

struct AFSDirEnt
	1 type
	1 permissions
	4 uid
	4 reserved
	4 timestamp
	4 startblock
	4 size
	4 bytesize
	37 name
	1 nullterm
endstruct

table AFSErrors
	"not found"
	"ok"
	"not enough memory"
endtable

procedure AFSInit (* -- *)
	"AFS: Mounting filesystem\n" Printf

	AFSSuperblockNumber AFSSuperblockCache IReadBlock

	AFSSuperblockCache AFSSuperblock_Magic + @
	if (AFSSuperblockMagic ~=)
		"AFS: Invalid superblock\n" Panic
		while (1) end
	end

	AFSSuperblockCache AFSSuperblock_Version + gb
	if (AFSSuperblockVersion ~=)
		"AFS: Bad version on superblock\n" Panic
		while (1) end
	end

	AFSSuperblockCache AFSSuperblock_Root + @ AFSRootCache IReadBlock
end

procedure AFSLoadFile (* name destptr -- ok? size *)
	auto destptr
	destptr!

	AFSFileByName
	if (dup 0 ==)
		0 return
	end

	auto entryptr
	entryptr!

	auto cblock
	auto size

	entryptr@ AFSDirEnt_startblock + @ cblock!
	entryptr@ AFSDirEnt_size + @ size!

	auto nmem
	destptr@ size@ 4096 * + nmem!

	if (nmem@ TotalRAM@ >=)
		0 2 return (* not enough memory *)
	end

	auto i
	0 i!
	while (i@ size@ <)
		cblock@ destptr@ IReadBlock

		cblock@ AFSBlockStatus cblock!

		destptr@ 4096 + destptr!
		i@ 1 + i!
	end

	size@ 4096 * 1
end

procedure AFSPrintList (* -- *)
	"volume root listing:\n" Printf
	"\tNAME\tBYTES\n" Printf

	auto i
	0 i!
	while (i@ 64 <)
		auto off
		i@ 64 * AFSRootCache + off!

		if (off@ AFSDirEnt_type + gb 1 ==)
			off@ AFSDirEnt_bytesize + @ off@ AFSDirEnt_name + "\t/%s\t%d\n" Printf
		end

		i@ 1 + i!
	end

	"done.\n" Printf
end

procedure AFSFileByName (* name -- entrypointer *)
	auto name
	name!

	if (name@ strlen 0 ==)
		0 return
	end

	auto i
	0 i!
	while (i@ 64 <)
		auto off
		i@ 64 * AFSRootCache + off!

		if (off@ AFSDirEnt_type + gb 1 ==)
			if (off@ AFSDirEnt_name + name@ strcmp)
				off@ return
			end
		end

		i@ 1 + i!
	end

	0
end

var AFSFatCached 0xFFFFFFFF
procedure AFSReadFATBlock (* fatblock -- *)
	auto fatblock
	fatblock!

	if (fatblock@ AFSFatCached@ ~=) (* only read in new block if not already in cache *)
		fatblock@ AFSSuperblockCache AFSSuperblock_FATStart + @ +
		AFSFATCache IReadBlock
		fatblock@ AFSFatCached!
	end
end

procedure AFSBlockStatus (* blocknum -- status *)
	auto bnum
	bnum!

	auto fatblock
	auto fatoff

	bnum@ 4096 / fatblock!
	bnum@ 4096 % fatoff!

	fatblock@ AFSReadFATBlock
	fatoff@ 4 * AFSFATCache + @
end