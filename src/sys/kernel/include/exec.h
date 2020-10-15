extern VNewProcess { vnode name filp0 filp1 filp2 mode udvec udcnt -- process }

const TEXT 0x00000000
const DATA 0x40000000

const NP_INHERIT 0
const NP_SPECIFY 1

const TTYI_ALL 0
const TTYI_IGN 1
const TTYI_CHILD_ALL 0x100
const TTYI_CHILD_IGN 0x200

struct UDVec
	4 Ptr
	4 Size
endstruct