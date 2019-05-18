var PMMTotalMemory 0
var PMMTotalPages 0

procedure PMMInit (* -- *)
	TotalRAM dup PMMTotalMemory!
	4096 / PMMTotalPages!

	PMMTotalPages@ "pmm: managing %d pages\n" Printf

	if (PMMTotalPages@ 65536 >)
		"pmm: can't manage more than 65536 pages (256MB of memory)\n" Panic
	end
end

buffer PMMBitmap 8192 (* we can deal with up to 256MB of physical memory, this is not arbitrarily picked *)

table PMMBitmasks
	254
	253
	251
	247
	239
	223
	191
	127
endtable

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
		auto sh
		v@ off@ << sh!

		entv@ sh@ | log!
	end else
		[off@]PMMBitmasks@ entv@ & log!
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

	entv@ off@ >> 1 & return
end

procedure PMMFree (* start size -- *)
	auto size
	size!

	auto start
	start!

	auto i
	start@ i!

	auto max
	start@ size@ + max!

	while (i@ max@ <)
		i@ 0 PMMBMSet
		i@ 1 + i!
	end
end

procedure PMMAllocate (* size -- *)
	auto p
	p!

	auto i
	768 i! (* skip first 3mb *)

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

			strtpage@ return
		end

		i@ 1 + i!
	end

	"pmmallocate: all pages allocated\n" Panic

	ERR return
end