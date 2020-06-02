const MOUNTNAMELEN 32

const Filesystems 1

const VNCACHESIZE 128

struct Filesystem
	4 Name
	4 Mount
	4 GetNode
	4 PutNode
	4 Sync
	4 RewindDir
	4 ReadDir
endstruct

struct Mount
	MOUNTNAMELEN Name
	4 Next
	4 Prev
	4 Device
	4 ReadOnly
	4 Filesystem
	4 FSData
	4 Root
endstruct

struct VNode
	4 VNID
	4 Refs
	4 Mount
	4 FSData
	4 Locked
	4 Type
endstruct

const VNODE_FILE 1
const VNODE_DIR 2
const VNODE_CHAR 3
const VNODE_BLOCK 4

struct VDirent
	4 Mount
	4 DirVNode
	4 VNID
	4 Name
	4 Index
endstruct

extern VFSPath  (* path -- vnode *)

extern VNodeNew (* vnid mount -- vnode *)

extern VNodePut (* vnode -- *)

extern VNodeGet (* vnid mount -- vnode *)

extern VNodeRef (* vnode -- *)