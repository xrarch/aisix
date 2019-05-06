struct DeviceNode
	4 Name
	4 Methods
	4 Properties
endstruct

(* device methods are called like [ ... node -- ... ] *)
struct DeviceMethod
	4 Name
	4 Func
endstruct

struct DeviceProperty
	4 Name
	4 Value
endstruct

var DevTree 0
var DevCurrent 0

var DevStack 0 (* we can go 64 layers deep *)
var DevStackPtr 0

procedure DevStackPUSH (* v -- *)
	DevStack@ DevStackPtr@ + !
	DevStackPtr@ 4 + DevStackPtr!
end

procedure DevStackPOP (* -- v *)
	DevStackPtr@ 4 - dup DevStackPtr!
	DevStack@ + @
end

procedure DevTreeWalk (* path -- node or 0 *)
	auto path
	path!

	auto cnode
	DevTree@ TreeRoot cnode!

	auto pcomp
	256 Calloc pcomp!

	while (path@ 0 ~=)
		path@ pcomp@ '/' 255 strntok path!

		if (pcomp@ strlen 0 ==)
			cnode@ pcomp@ Free return
		end

		auto tnc
		cnode@ TreeNodeChildren tnc!

		auto n
		tnc@ ListHead n!

		auto nnode
		0 nnode!

		while (n@ 0 ~=)
			auto pnode
			n@ ListNodeValue pnode!

			if (pnode@ TreeNodeValue DeviceNode_Name + @ pcomp@ strcmp)
				pnode@ nnode! break
			end

			n@ ListNode_Next + @ n!
		end

		if (nnode@ 0 ==)
			pcomp@ Free
			0 return
		end

		nnode@ cnode!
	end

	pcomp@ Free

	cnode@
end

procedure DeviceParent (* -- *)
	DevCurrent@@ DevStackPUSH
	DevCurrent@@ TreeNodeParent DevCurrent@!
end

procedure DeviceSelectNode (* node -- *)
	DevCurrent@@ DevStackPUSH
	DevCurrent@!
end

procedure DeviceSelect (* path -- *)
	auto path
	path!

	DevCurrent@@ DevStackPUSH

	path@ DevTreeWalk DevCurrent@!
end

procedure DeviceNNew (* -- node *)
	auto dnode
	DeviceNode_SIZEOF Calloc
	dnode!

	ListCreate dnode@ DeviceNode_Methods + !
	ListCreate dnode@ DeviceNode_Properties + !

	dnode@
end

(* creates a new unnamed device node, adds it to the
device tree as a child of the current device, sets
itself as the new current device *)
procedure DeviceNew (* -- *)
	DevCurrent@@ DevStackPUSH

	DeviceNNew DevCurrent@@ DevTree@ TreeInsertChild DevCurrent@!
end

procedure DSetName (* name -- *)
	DevCurrent@@ TreeNodeValue DeviceNode_Name + !
end

procedure DAddMethod (* method name -- *)
	auto name
	name!

	auto method
	method!

	auto mnode
	DeviceMethod_SIZEOF Calloc mnode!

	name@ mnode@ DeviceMethod_Name + !
	method@ mnode@ DeviceMethod_Func + !

	mnode@ DGetMethods ListInsert
end

procedure DAddProperty (* string name -- *)
	auto name
	name!

	auto prop
	prop!

	auto mnode
	DeviceProperty_SIZEOF Calloc mnode!

	name@ mnode@ DeviceProperty_Name + !
	prop@ mnode@ DeviceProperty_Value + !

	mnode@ DGetProperties ListInsert 
end

procedure DGetProperty (* name -- string or 0 *)
	auto name
	name!

	auto plist
	DGetProperties plist!

	auto n
	plist@ ListHead n!

	while (n@ 0 ~=)
		auto pnode
		n@ ListNodeValue
		pnode!

		if (pnode@ DeviceProperty_Name + @ name@ strcmp)
			pnode@ DeviceProperty_Value + @ return
		end

		n@ ListNodeNext n!
	end

	0 return
end

procedure DCallMethod (* ... name -- ... ok? *)
	auto name
	name!

	auto plist
	DGetMethods plist!

	auto n
	plist@ List_Head + @ n!

	while (n@ 0 ~=)
		auto pnode
		n@ ListNodeValue
		pnode!

		if (pnode@ DeviceMethod_Name + @ name@ strcmp)
			pnode@ DeviceMethod_Func + @ Call 1 return
		end

		n@ ListNodeNext n!
	end

	0
end

procedure DeviceExit (* -- *)
	DevStackPOP DevCurrent@!
end

procedure DGetName (* -- name *)
	DevCurrent@@ TreeNodeValue DeviceNode_Name + @
end

procedure DGetMethods (* -- methods *)
	DevCurrent@@ TreeNodeValue DeviceNode_Methods + @
end

procedure DGetProperties (* -- properties *)
	DevCurrent@@ TreeNodeValue DeviceNode_Properties + @
end

procedure DeviceInit (* root dcp -- *)
	DevCurrent! DevTree!

	256 Calloc DevStack!
end