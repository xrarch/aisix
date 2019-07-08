table aisixfatFS
	pointerof aisixfatReadSuper
	"aisixfat"
	1
endtable

table aisixfatSuperOps
	pointerof aisixfatReadVnode
	pointerof aisixfatWriteVnode
	pointerof aisixfatPutVnode
	pointerof aisixfatPutSuper
	0
	pointerof aisixfatStatFS
	pointerof aisixfatRemountFS
endtable

struct aisixfatSuper
	1 Version
	4 Magic
	4 Size
	4 Numfiles
	1 Dirty
	4 Blocksused
	4 Numdirs
	4 Reservedblocks
	4 Fatstart
	4 Fatsize
	4 Rootstart
	4 Datastart
endstruct

const aisixfatSuperMagic 0xAFBBAFBB
const aisixfatSuperVersion 0x4

procedure aisixfatInit (* -- *)
	aisixfatFS VFSRegister
end

procedure aisixfatReadSuper (* data super -- success? *)
	auto super
	super!

	auto data
	data!

	if (super@ superlock ~~)
		-EINTR return
	end

	auto bh

	0 super@ Superblock_DevStruct + @ Device_DevNum + @ bread bh!

	super@ superunlock

	if (bh@ iserr)
		bh@ return
	end

	auto fss
	aisixfatSuper_SIZEOF Malloc fss!

	fss@ bh@ Buffer_Block + @ aisixfatSuper_SIZEOF memcpy

	bh@ brelse

	if (fss@ aisixfatSuper_Magic + @ aisixfatSuperMagic ~=)
		fss@ Free
		0 return
	end

	if (fss@ aisixfatSuper_Version + gb aisixfatSuperVersion ~=)
		fss@ Free
		0 return
	end

	fss@ super@ Superblock_FSData + !

	aisixfatSuperOps super@ Superblock_SuperOps + !

	aisixfatSuperMagic super@ Superblock_Magic + !

	auto ri
	AISIXFAT_ROOT_INO super@ iget ri!

	if (ri@ iserr)
		ri@ return
	end

	ri@ super@ Superblock_Mounted + !

	0
end

procedure aisixfatPutSuper (* super -- err *)
	auto super
	super!

	0
end

procedure aisixfatStatFS (* -- *)

end

procedure aisixfatRemountFS (* -- *)

end