procedure VFSInit (* -- *)
	ListCreate FSList!

	aisixfatInit
end

procedure VFSRegister (* fs -- *)
	auto fs
	fs!

	fs@ Filesystem_Name + @ "registering fs: %s\n" Printf

	auto rs
	InterruptDisable rs!

	fs@ FSList@ ListInsert

	rs@ InterruptRestore
end

procedure FSTypeByName (* name -- type or -1 *)
	auto name
	name!

	auto rs
	InterruptDisable rs!

	auto n
	FSList@ ListHead n!

	while (n@ 0 ~=)
		rs@ InterruptRestore
		InterruptDisable rs!

		auto pnode
		n@ ListNodeValue pnode!

		if (pnode@ Filesystem_Name + @ name@ strcmp)
			rs@ InterruptRestore
			pnode@ return
		end

		n@ ListNodeNext n!
	end

	rs@ InterruptRestore

	-1
end