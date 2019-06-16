procedure BufferInit (* -- *)
	ListCreate BufferList!

	BUFFER_PORTION "buffer portion: 1/%d\n" Printf

	PMMTotalMemory@ BUFFER_PORTION / 4096 / 1 + BufferMax!

	auto ih
	BufferMax@ Buffer_SIZEOF * ih!

	ih@ BufferMax@ 4096 * BufferMax@ "using %d buffers (total of %d bytes), %d in heap\n" Printf

	"allocating buffers...\n" Printf

	BufferMax@ PMMAlloc BlocksBase!

	BlocksBase@ "blocksbase @ 0x%x\n" Printf

	auto i
	0 i!

	while (i@ BufferMax@ <)
		BufAlloc BufferList@ ListInsert

		i@ 1 + i!
	end

	"done\n" Printf
end

procedure BufAlloc (* -- buf *)
	auto buf
	Buffer_SIZEOF Malloc buf!

	0 buf@ Buffer_Refcount + !
	-1 buf@ Buffer_Blockno + !
	-1 buf@ Buffer_Dev + !

	BlocksBase@ buf@ Buffer_Block + !
	BlocksBase@ 1 + BlocksBase!
end