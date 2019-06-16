procedure BufferInit (* -- *)
	ListCreate BufferList!

	PMMTotalMemory@ BUFFER_PORTION / 4096 / 1 + BufferMax!

	auto ih
	BufferMax@ Buffer_SIZEOF * ih!

	BUFFER_PORTION ih@ BufferMax@ 4096 * BufferMax@ "allocating %d i/o buffers (%d bytes pmm, %d bytes heap, 1/%d)\n" Printf

	BufferMax@ PMMAlloc BlocksBase!

	auto i
	0 i!

	while (i@ BufferMax@ <)
		BufAlloc BufferList@ ListInsert

		i@ 1 + i!
	end
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

procedure bget (* -- *)

end

procedure bread (* -- *)

end