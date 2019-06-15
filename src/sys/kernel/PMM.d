var PMMTotalMemory 0
var PMMTotalPages 0
var PMMMemStart 0

procedure PMMInit (* kstart ksize -- *)
	auto ksize
	ksize!

	auto kstart
	kstart!

	platformMemoryParams PMMMemStart! PMMTotalMemory!

	PMMTotalMemory@ 4096 / PMMTotalPages!

	PMMMemStart@ 4096 * PMMTotalMemory@ PMMTotalPages@ "pmm: managing %d pages (%d bytes) of memory starting at 0x%x\n" Printf

	if (PMMTotalMemory@ 2097152 <)
		"refusing to boot with less than 2MB of available RAM\n" Panic
	end

	if (PMMTotalPages@ 65536 >)
		"pmm: can't manage more than 65536 pages (256MB of memory)\n" Panic
	end

	auto ksp
	kstart@ 4096 / 2 - ksp!

	auto kszp
	ksize@ 4096 / 3 + 4096 * kszp!

	ksp@ 4096 * kszp@ dup 4096 / "pmm: reserving %d pages (%d bytes) starting at 0x%x for kernel image\n" Printf
	ksp@ kszp@ 4096 / PMMReserve
end

buffer PMMBitmap 8192 (* we can deal with up to 256MB of physical memory, this is not arbitrarily picked *)

procedure PMMBMSet (* bit v -- *)
	auto v
	v!

	auto bit
	bit!

	auto ent
	auto off

	bit@ 8 / ent!
	bit@ 8 % off!

	auto enta
	ent@ PMMBitmap + enta!

	auto entv
	enta@ gb entv!

	auto log

	if (v@ 1 ==)
		entv@ off@ bitset log!
	end else
		entv@ off@ bitclear log!
	end

	log@ enta@ sb
end

procedure PMMBMGet (* bit -- v *)
	auto bit
	bit!

	auto ent
	auto off

	bit@ 8 / ent!
	bit@ 8 % off!

	auto entv
	ent@ PMMBitmap + gb entv!

	entv@ off@ bitget return
end

procedure PMMFree (* start size -- *)
	auto size
	size!

	auto start
	start!

	auto i
	start@ PMMMemStart@ - i!

	auto max
	start@ PMMMemStart@ - size@ + max!

	while (i@ max@ <)
		i@ 0 PMMBMSet
		i@ 1 + i!
	end
end

procedure PMMReserve (* start size -- *)
	auto size
	size!

	auto start
	start!

	auto i
	start@ PMMMemStart@ - i!

	auto max
	start@ PMMMemStart@ - size@ + max!

	while (i@ max@ <)
		i@ 1 PMMBMSet
		i@ 1 + i!
	end
end

procedure PMMAlloc (* size -- startpage *)
	auto p
	p!

	auto i
	0 i!

	auto q
	0 q!

	auto max
	PMMTotalPages@ max!

	auto strtpage
	while (i@ max@ <)
		if (i@ PMMBMGet 0 ==)
			q@ 1 + q!
		end else
			0 q!
		end
		if (q@ p@ ==)
			i@ p@ 1 - - strtpage!
			auto i2
			strtpage@ i2!

			auto max2
			strtpage@ p@ + max2!
			while (i2@ max2@ <)
				i2@ 1 PMMBMSet
				i2@ 1 + i2!
			end

			strtpage@ PMMMemStart@ + return
		end

		i@ 1 + i!
	end

	"pmmalloc: all pages allocated\n" Panic

	ERR return
end