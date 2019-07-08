procedure superlock (* super -- err *)
	Superblock_Lock + sleeplock
end

procedure superunlock (* super -- *)
	Superblock_Lock + sleepunlock
end

procedure superlocked (* super -- locked? *)
	Superblock_Lock + holdingsleeplock
end

procedure SuperGet (* dev -- superblock or 0 *)
	auto dev
	dev!

	if (dev@ 0 ~=)
		0 return
	end

	auto rs
	InterruptDisable rs!

	auto n
	SuperblockList@ ListHead n!

	while (n@ 0 ~=)
		rs@ InterruptRestore
		InterruptDisable rs!

		auto pnode
		n@ ListNodeValue pnode!

		if (pnode@ Superblock_DevStruct + @ dev@ ==)
			if (pnode@ superlock ~~)
				rs@ InterruptRestore
				-EINTR return
			end
			rs@ InterruptRestore

			pnode@ superunlock
			pnode@ return
		end

		n@ ListNodeNext n!
	end

	rs@ InterruptRestore

	0
end

procedure SuperRead (* data flags name dev -- superblock *)
	auto dev
	dev!

	auto name
	name!

	auto flags
	flags!

	auto data
	data!


	auto s
	dev@ SuperGet s!

	if (s@ 0 ~=)
		s@ return
	end

	auto type
	name@ FSTypeByName type!

	if (type@ -1 ==)
		0 return
	end

	Superblock_SIZEOF Calloc s!

	dev@ s@ Superblock_DevStruct + !
	flags@ s@ Superblock_Flags + !

	auto r
	data@ s@ type@ Filesystem_ReadSuper + @ Call r!

	if (r@ 0 s<=)
		s@ Free
		r@ return
	end

	dev@ s@ Superblock_DevStruct + !
	0 s@ Superblock_Covered + !
	0 s@ Superblock_ReadOnly + !
	0 s@ Superblock_Dirty + !

	s@ SuperblockList@ ListInsert

	s@
end

procedure ResolveRootDev (* name -- dev or -1 *)
	auto rd
	rd!

	auto dev

	rd@ "trying rd = %s... " Printf

	rd@ DeviceByName dev!

	if (dev@ iserr)
		rd@ "%s: couldn't resolve device\n\n" Printf
		-1 return
	end

	if (dev@ Device_Type + @ DRIVER_BLOCK ~=)
		rd@ "%s: not a block device\n\n" Printf
		-1 return
	end

	dev@
end

procedure UserRootDev (* -- dev *)
	auto ubuf
	256 Calloc ubuf!

	auto dev
	-1 dev!

	while (dev@ -1 ==)
		while (ubuf@ strlen 0 ==)
			"rootdev = " Printf

			ubuf@ 255 Gets
		end

		ubuf@ ResolveRootDev dev!

		0 ubuf@ sb
	end

	ubuf@ Free

	dev@
end

procedure MountRoot (* -- *)
	ListCreate SuperblockList!

	auto rd
	"rd" ArgsValue rd!

	auto dev
	-1 dev!

	if (rd@ 0 ==)
		"no root device (rd=%%s) in kernel arguments\n" Printf
	end else
		rd@ ResolveRootDev dev!
		rd@ Free
	end

	if (dev@ -1 ==)
		0 SysconSwitchVC drop
		"couldn't find root device\n" Printf
		UserRootDev dev!
	end

	"as: " Printf

	auto rs
	InterruptDisable rs!

	auto n
	FSList@ ListHead n!

	while (n@ 0 ~=)
		auto pnode
		n@ ListNodeValue pnode!

		rs@ InterruptRestore

		if (pnode@ Filesystem_NeedsDev + @)
			pnode@ Filesystem_Name + @ "%s " Printf

			auto s
			0 0 pnode@ Filesystem_Name + @ dev@ SuperRead s!

			if (s@ 0 s>)
				auto vnode
				s@ Superblock_Mounted + @ vnode!

				4 vnode@ Vnode_Refcount + !
				vnode@ s@ Superblock_Covered + !

				vnode@ TaskCurrent@ Task_PWD + !

				vnode@ RootVnode!

				". SUCCESS\n" Printf

				return
			end
		end

		InterruptDisable rs!

		n@ ListNodeNext n!
	end

	rs@ InterruptRestore

	"mountroot: unable to mount root device\n" Panic
end