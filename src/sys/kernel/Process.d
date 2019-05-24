procedure ProcInit (* -- *)
	"proc: init\n" Printf

	ListCreate ProcList!
end

var SN 1

procedure Schedule (* status return? -- *)
	auto ret
	ret!

	auto status
	status!

	auto rs
	asm "
		pushv r5, rs
	" rs!

	if (rs@ 2 & 2 ==)
		"scheduler expects interrupts to be disabled\n" Panic
	end

	SN@ 1 + SN!

	auto pln
	ProcList@ ListLength pln!

	if (pln@ 0 ==)
		"nothing to schedule\n" Panic
	end

	250 pln@ / 10 max ClockSetInterval

	auto np
	ERR np!

	auto n
	ProcList@ ListHead n!

	while (n@ 0 ~=)
		auto pnode
		n@ ListNodeValue pnode!

		if (pnode@ Proc_Status + @ PRUNNABLE ==)
			pnode@ np!
			n@ ProcList@ ListDelete
			n@ ProcList@ ListAppend
			break
		end

		n@ ListNode_Next + @ n!
	end

	if (np@ ERR ==)
		(* "nothing to schedule!\n" Panic *)
		return
	end

	status@ CurProc@ Proc_Status + !

	if (ret@)
		np@ kswtch
		return
	end else
		np@ uswtch
	end
end

procedure MakeProcZero (* func -- proc *)
	"hand-crafting pid 0\n" Printf

	auto func
	func!

	auto myhtta
	3 0 0x1FE000 func@ HTTANew myhtta!

	0x200000 myhtta@ HTTA_r5 + !

	auto kr5
	1024 Malloc kr5!

	auto myproc

	0x1FE000 kr5@ -1 PMMTotalPages@ 0 myhtta@ 0 "init" ProcBuildStruct myproc!

	PRUNNABLE myproc@ Proc_Status + !

	myproc@ ProcList@ ListInsert

	myproc@
end

procedure ProcExit (* -- *)
	
end

procedure ProcSkeleton (* rs entry extent page name -- proc *)
	auto name
	name!

	auto page
	page!

	auto extent
	extent!

	auto entry
	entry!

	auto rs
	rs!

	auto pid
	LastPID@ pid!

	LastPID@ 1 + LastPID!

	auto kr5
	1024 Malloc kr5!

	auto kstack
	1024 Malloc kstack!

	auto htta
	rs@ 0 kstack@ entry@ HTTANew htta!

	auto proc
	kstack@ kr5@ CurProc@ extent@ page@ htta@ pid@ name@ ProcBuildStruct proc!

	PRUNNABLE proc@ Proc_Status + !

	proc@ ProcList@ ListInsert

	proc@
end

procedure ProcDestroy (* proc -- *)
	auto proc
	proc!

	proc@ Proc_cHTTA + @ Free
	proc@ Proc_kr5 + @ Free
	proc@ Proc_kstack + @ Free

	proc@ Proc_Page + @
	proc@ Proc_Extent + @
	PMMFree

	proc@ ProcList@ ListFind ProcList@ ListRemove

	proc@ ProcDestroyStruct
end

procedure ProcDestroyStruct (* proc -- *)
	auto proc
	proc!

	proc@ Proc_Name + @ Free

	proc@ Free
end

procedure ProcBuildStruct (* kstack kr5 parent extent page chtta pid name -- proc *)
	auto name
	name!

	auto pid
	pid!

	auto chtta
	chtta!

	auto page
	page!

	auto extent
	extent!

	auto parent
	parent!

	auto kr5
	kr5!

	auto kstack
	kstack!

	auto proc
	Proc_SIZEOF Malloc proc!

	name@ strdup proc@ Proc_Name + !
	pid@ proc@ Proc_PID + !
	chtta@ proc@ Proc_cHTTA + !
	page@ proc@ Proc_Page + !
	extent@ proc@ Proc_Extent + !
	parent@ proc@ Proc_Parent + !
	PNONE proc@ Proc_Status + !
	kr5@ proc@ Proc_kr5 + !
	kstack@ proc@ Proc_kstack + !

	proc@
end