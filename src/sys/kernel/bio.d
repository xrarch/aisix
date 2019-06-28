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
		auto buf

		BufAlloc buf!
		buf@ BufferList@ ListInsert1 buf@ Buffer_Node + !

		i@ 1 + i!
	end
end

procedure BufAlloc (* -- buf *)
	auto buf
	Buffer_SIZEOF Calloc buf!

	BlocksBase@ 4096 * buf@ Buffer_Block + !
	BlocksBase@ 1 + BlocksBase!

	-1 buf@ Buffer_Dev + !
	-1 buf@ Buffer_Blockno + !

	buf@
end

procedure buflock (* buf -- err *)
	Buffer_Lock + sleeplock
end

procedure bufunlock (* buf -- *)
	Buffer_Lock + sleepunlock
end

procedure buflocked (* buf -- locked? *)
	Buffer_Lock + holdingsleeplock
end

procedure strategy (* locked proc buf drv minor -- err *)
	auto minor
	minor!

	auto drv
	drv!

	auto buf
	buf!

	auto proc
	proc!

	auto locked
	locked!

	if (locked@)
		if (buf@ buflocked ~~)
			buf@ "strategy: not holding lock on buf @ 0x%x\n" Panic
		end
	end

	if (buf@ Buffer_Flags + @ BUFFER_VALID BUFFER_DIRTY | & BUFFER_VALID ==)
		buf@ "strategy: nothing to do to buf @ 0x%x\n" Panic
	end

	auto dsw
	drv@ GenericDriver_devsw + @ dsw!

	auto s

	if (buf@ Buffer_Flags + @ BUFFER_DIRTY & BUFFER_DIRTY ==)
		proc@ buf@ minor@ dsw@ bdevsw_Write + @ Call s!
	end else
		proc@ buf@ minor@ dsw@ bdevsw_Read + @ Call s!
	end

	if (s@ iserr)
		s@ return
	end

	while (buf@ Buffer_Flags + @ BUFFER_VALID BUFFER_DIRTY | & BUFFER_VALID ~=)
		if (buf@ sleep ~~)
			-EINTR return
		end
	end

	0
end

procedure bget (* blockno dev -- buf *)
	auto dev
	dev!

	auto blockno
	blockno!

	auto rs
	InterruptDisable rs!

	auto pnode
	auto n
	BufferList@ ListHead n!

	while (n@ 0 ~=)
		rs@ InterruptRestore
		InterruptDisable rs!

		n@ ListNodeValue pnode!

		if (pnode@ Buffer_Dev + @ dev@ ==)
			if (pnode@ Buffer_Blockno + @ blockno@ ==)
				if (pnode@ buflock ~~)
					rs@ InterruptRestore
					-EINTR return
				end

				pnode@ Buffer_Refcount + @ 1 + pnode@ Buffer_Refcount + !

				rs@ InterruptRestore
				pnode@ return
			end
		end

		n@ ListNode_Next + @ n!
	end

	rs@ InterruptRestore
	(* breathing space *)
	InterruptDisable rs!

	BufferList@ ListTail n!

	while (n@ 0 ~=)
		rs@ InterruptRestore
		InterruptDisable rs!

		n@ ListNodeValue pnode!

		if (pnode@ Buffer_Refcount + @ 0 ==)
			if (pnode@ Buffer_Flags + @ BUFFER_DIRTY & 0 ==)
				if (pnode@ buflock ~~)
					rs@ InterruptRestore
					-EINTR return
				end

				dev@ pnode@ Buffer_Dev + !
				blockno@ pnode@ Buffer_Blockno + !
				0 pnode@ Buffer_Flags + !
				1 pnode@ Buffer_Refcount + !

				rs@ InterruptRestore
				pnode@ return
			end
		end

		n@ ListNode_Prev + @ n!
	end

	"bget: no buffers\n" Panic
end

procedure bread (* blockno dev -- buf *)
	auto buf
	bget buf!

	if (buf@ iserr)
		buf@ return
	end

	auto rs
	InterruptDisable rs!

	if (buf@ Buffer_Flags + @ BUFFER_VALID & 0 ==)
		auto r
		1 TaskCurrent@ buf@ DevStrategy r!

		if (r@ iserr)
			rs@ InterruptRestore
			r@ return
		end
	end

	rs@ InterruptRestore
	buf@
end

procedure bwrite (* buf -- *)
	auto buf
	buf!

	if (buf@ Buffer_Lock + holdingsleeplock ~~)
		buf@ "bwrite: not holding lock on buf @ 0x%x\n" Panic
	end

	auto rs
	InterruptDisable rs!

	buf@ Buffer_Flags + @ BUFFER_DIRTY | buf@ Buffer_Flags + !

	rs@ InterruptRestore
end

procedure brelse (* buf -- *)
	auto buf
	buf!

	if (buf@ Buffer_Lock + holdingsleeplock ~~)
		buf@ "brelse: not holding lock on buf @ 0x%x\n" Panic
	end

	auto rs
	InterruptDisable rs!

	auto node
	buf@ Buffer_Node + @ node!

	buf@ Buffer_Refcount + @ 1 - buf@ Buffer_Refcount + !

	if (buf@ Buffer_Refcount + @ 0 ==)
		node@ BufferList@ ListDelete
		node@ BufferList@ ListAppend
	end

	rs@ InterruptRestore

	buf@ bufunlock
end

procedure flushall (* dev -- err *)
	auto dev
	dev!

	auto rs
	InterruptDisable rs!

	auto n
	BufferList@ ListHead n!

	while (n@ 0 ~=)
		rs@ InterruptRestore
		InterruptDisable rs!

		auto pnode
		n@ ListNodeValue pnode!

		if (pnode@ Buffer_Flags + @ BUFFER_DIRTY & BUFFER_DIRTY ==)
			if (pnode@ Buffer_Dev + @ dev@ ==)
				auto r
				0 TaskCurrent@ pnode@ DevStrategy r!

				if (r@ iserr)
					r@ return
				end
			end
		end

		n@ ListNode_Next + @ n!
	end

	rs@ InterruptRestore

	0
end

procedure flushblockdevs (* -- err *)
	auto rs
	InterruptDisable rs!

	auto n
	DevList@ ListHead n!

	while (n@ 0 ~=)
		rs@ InterruptRestore
		InterruptDisable rs!

		auto pnode
		n@ ListNodeValue pnode!

		if (pnode@ Device_Type + @ DRIVER_BLOCK ==)
			auto r
			pnode@ Device_DevNum + @ flushall r!

			if (r@ iserr)
				rs@ InterruptRestore
				r@ return
			end
		end

		n@ ListNodeNext n!
	end

	rs@ InterruptRestore

	0
end