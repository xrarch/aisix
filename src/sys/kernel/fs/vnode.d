procedure VnodeWrite1 (* vno -- err *)
	auto vno
	vno!

	if (vno@ Vnode_Dirty + @ 0 ==)
		0 return
	end

	auto super
	vno@ Vnode_Superblock + @ super!

	if (super@ 0 ~=)
		auto sops
		super@ Superblock_SuperOps + @ sops!

		if (sops@ 0 ~=)
			auto wvn
			sops@ SuperOps_WriteVnode + @ wvn!

			if (wvn@ 0 ~=)
				vno@ wvn@ Call return
			end
		end
	end

	0 vno@ Vnode_Dirty + !

	0
end

procedure VnodeWrite (* vno -- err *)
	auto vno
	vno!

	if (vno@ Vnode_Dirty + @ 0 ==)
		0 return
	end

	if (vno@ ilock ~~)
		-EINTR return
	end

	vno@ VnodeWrite1

	vno@ iunlock
end

procedure ilock (* vno -- locked? *)
	auto vno
	vno!

	if (vno@ 0 ==)
		"ilock\n" Panic
	end

	if (vno@ Vnode_Refcount + @ 1 <)
		"ilock: locking free vnode\n" Panic
	end

	vno@ Vnode_Lock + sleeplock
end

procedure iunlock (* vno -- *)
	Vnode_Lock + sleepunlock
end

procedure iput (* vno -- err *)
	auto vno
	vno!

	if (vno@ 0 ==)
		"iput\n" Panic
	end

	if (vno@ ilock ~~)
		-EINTR return
	end

	if (vno@ Vnode_Refcount + @ 0 ==)
		"iput: already put\n" Panic
	end

	if (vno@ Vnode_Pipe + @ 0 ~=)
		vno@ Vnode_Pipe + wakeup
	end

	while (1)
		if (vno@ Vnode_Refcount + @ 1 >)
			vno@ Vnode_Refcount + @ 1 - vno@ Vnode_Refcount + !
			vno@ iunlock
			0 return
		end

		auto super
		vno@ Vnode_Superblock + @ super!

		if (super@ 0 ~=)
			auto sops
			super@ Superblock_SuperOps + @ sops!

			if (sops@ 0 ~=)
				auto pvn
				sops@ SuperOps_PutVnode + @ pvn!

				if (pvn@ 0 ~=)
					vno@ pvn@ Call

					if (vno@ Vnode_NLink + @ 0 ==)
						vno@ iunlock
						0 return
					end
				end
			end
		end

		if (vno@ Vnode_Dirty + @)
			auto r
			vno@ VnodeWrite1 r!

			if (r@ iserr)
				vno@ iunlock
				r@ return
			end
		end else
			break
		end
	end

	vno@ Vnode_Refcount + @ 1 - vno@ Vnode_Refcount + !

	vno@ iunlock

	0
end

procedure iget (* nr super -- vno *)
	1 iget1
end

procedure iget1 (* nr super crossmnt -- vno *)
	auto crossmnt
	crossmnt!

	auto super
	super!

	auto nr
	nr!

	auto dev
	super@ Superblock_DevStruct + @ dev!

	-1
end