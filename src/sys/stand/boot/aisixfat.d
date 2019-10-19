#include "<df>/dragonfruit.h"

externconst TotalRAM
extern IReadBlock
extern Panic

(* extremely simple, read-only implementation of aisixfat *)

const AFSSuperblockNumber 0x0
const AFSSuperblockCache 0x47F00
const AFSFATCache 0x48F00
const AFSRootCache 0x49F00
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
	"not a file"
endtable
public AFSErrors

procedure AFSInit (* -- *)
	"AFS: Mounting filesystem\n" Printf

	AFSSuperblockNumber AFSSuperblockCache IReadBlock

	AFSSuperblockCache AFSSuperblock_Magic + @
	if (AFSSuperblockMagic ~=)
		"AFS: Invalid superblock\n" Panic
	end

	AFSSuperblockCache AFSSuperblock_Version + gb
	if (AFSSuperblockVersion ~=)
		"AFS: Bad version on superblock\n" Panic
	end
end

procedure AFSLoadFile { name destptr } (* -- size ok? *)
	auto entryptr
	name@ AFSFileByName entryptr!
	if (entryptr@ 0 ==)
		0 0 return
	end

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
		1 i +=
	end

	size@ 4096 * 1
end

procedure AFSDirentByName { name -- dirent }
	if (name@ strlen 0 ==)
		0 dirent!
		return
	end

	auto i
	0 i!
	while (i@ 64 <)
		auto off
		i@ 64 * AFSRootCache + off!

		if (off@ AFSDirEnt_name + name@ strcmp)
			off@ dirent!
			return
		end

		1 i +=
	end

	0 dirent!
end

procedure AFSPathSeek { path -- dirent }
	auto pcomp
	256 Calloc pcomp!

	auto last
	2 last!

	-1 dirent!

	AFSReadRoot

	while (path@ 0 ~=)
		path@ pcomp@ '/' 255 strntok path!

		if (pcomp@ strlen 0 ==)
			pcomp@ Free
			if (dirent@ -1 ==) 0 dirent! end
			return
		end

		if (last@ 2 ~=)
			pcomp@ Free
			0 dirent!
			return
		end

		if (dirent@ -1 ~=)
			dirent@ AFSDirEnt_startblock + @ AFSRootCache IReadBlock
		end

		pcomp@ AFSDirentByName dirent!
		if (dirent@ 0 ==)
			pcomp@ Free
			0 dirent!
			return
		end

		dirent@ AFSDirEnt_type + gb last!
	end

	pcomp@ Free
end

procedure AFSPrintList { path -- }
	if (path@ strlen 0 ==)
		AFSReadRoot
	end elseif (path@ "/" strcmp)
		AFSReadRoot
	end else
		auto dirent
		path@ AFSPathSeek dirent!
		if (dirent@ 0 ==)
			path@ "couldn't find %s\n" Printf
			return
		end

		if (dirent@ AFSDirEnt_type + gb 2 ~=)
			path@ "%s isn't a directory\n" Printf
			return
		end

		dirent@ AFSDirEnt_startblock + @ AFSRootCache IReadBlock
	end

	path@ "%s:\n" Printf
	"\tNAME\tBYTES\n" Printf

	auto i
	0 i!
	while (i@ 64 <)
		auto off
		i@ 64 * AFSRootCache + off!

		if (off@ AFSDirEnt_type + gb 0 ~=)
			off@ AFSDirEnt_bytesize + @ off@ AFSDirEnt_name + 

			if (off@ AFSDirEnt_type + gb 1 ==)
				"\t%s\t%d\n"
			end else
				"\t%s/\t%d\n"
			end

			Printf
		end

		1 i +=
	end

	CR
end

procedure AFSFileByName { path -- dirent }
	path@ AFSPathSeek dirent!
	if (dirent@ 0 ==)
		0 dirent!
		return
	end

	if (dirent@ AFSDirEnt_type + gb 1 ~=)
		0 dirent!
		return
	end
end

procedure AFSReadRoot (* -- *)
	AFSSuperblockCache AFSSuperblock_Root + @ AFSRootCache IReadBlock
end

var AFSFatCached -1
procedure AFSReadFATBlock { fatblock -- }
	if (fatblock@ AFSFatCached@ ~=) (* only read in new block if not already in cache *)
		fatblock@ AFSSuperblockCache AFSSuperblock_FATStart + @ +
		AFSFATCache IReadBlock
		fatblock@ AFSFatCached!
	end
end

procedure AFSBlockStatus { bnum -- status }
	auto fatblock
	auto fatoff

	bnum@ 4096 / fatblock!
	bnum@ 4096 % fatoff!

	fatblock@ AFSReadFATBlock
	fatoff@ 4 * AFSFATCache + @ status!
end