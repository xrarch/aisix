const MOUNTNAMELEN 256

const VNCACHESIZE 128

struct Filesystem
	4 Name
	4 Mount
	4 GetNode
	4 PutNode
	4 Sync
	4 RewindDir
	4 ReadDir
	4 Unmount
	4 Read
	4 Write
	4 Create
	4 Rename
	4 Unlink
	4 Trunc
	4 Delete
endstruct

fnptr FSMount { mount -- root }

fnptr FSGetNode { vnode -- ok }

fnptr FSPutNode { vnode -- ok }

fnptr FSSync { vnode -- ok }

fnptr FSRewindDir { dirent -- ok }

fnptr FSReadDir { dirent -- ok }

fnptr FSUnmount { mount -- ok }

fnptr FSRead { pm buf len seek vnode -- bytes }

fnptr FSWrite { pm buf len seek vnode -- bytes }

fnptr FSCreate { dirvnode name type uid permissions -- vnid }

fnptr FSRename { srcdirvnode srcname destdirvnode destname -- ok }

fnptr FSUnlink { dirvnode vnode name -- ok }

fnptr FSTrunc { vnode -- ok }

fnptr FSDelete { vnode -- ok }

const FS_READONLY 1
const FS_NOUID 2

struct Mount
	MOUNTNAMELEN Path
	MOUNTNAMELEN DevPath
	4 Next
	4 Prev
	4 Device
	4 Flags
	4 Filesystem
	4 FSData
	4 Root
	4 Busy
	4 VRefs
	4 MRefs
	4 Covering
endstruct

struct VNode
	4 VNID
	4 Refs
	4 Mount
	4 FSData
	Mutex_SIZEOF Mutex
	4 Index
	4 Type
	4 UID
	4 GID
	4 Timestamp
	4 Permissions
	4 Size
	4 CoveredBy
	4 DeleteLastRef
	4 Dirty
	4 DirParentVNID

	4 Writers

	4 CachedTextSegmentWMO
	4 UsingWMO
endstruct

const VNODE_FILE 1
const VNODE_DIR 2
const VNODE_CHAR 3
const VNODE_BLOCK 4

const WORLD_X 1
const WORLD_W 2
const WORLD_R 4

const GROUP_X 8
const GROUP_W 16
const GROUP_R 32

const OWNER_X 64
const OWNER_W 128
const OWNER_R 256

const SUID 512

const XMASK 73

struct VDirent
	4 DirVNode
	4 VNID
	4 Name
	4 Index
	4 Cookie
endstruct

externptr RootVNode

extern VRead { pm buf len seek vnode -- bytes }

extern VWrite { pm buf len seek vnode -- bytes }

extern VTrunc { vnode -- ok }

extern VFSPath  { path -- vnode }

extern VFSPathX { path -- sook dirvnode vnode name }

extern VNodeRemoveCachedText { vnode -- }

extern VNodeNew { vnid mount -- vnode }

extern VNodePut { vnode -- }

extern VNodeGet { vnid mount -- vnode }

extern VNodeOwned { vnode -- owned }

extern VNodeLock { vnode -- killed }

extern VNodeUnlock { vnode -- }

extern VNodeLocked { vnode -- locked }

extern VNodeRef { vnode -- }

extern VNodeUnref { vnode -- }

extern MountRef { mount -- }

extern MountUnref { mount -- }

extern SyncVNodes { mount remove -- res }

extern VFSMount { flags path fs dev devpath -- mount }

extern VFSUnmount { mount -- ok }

extern VForbidden { vnode rwx uid -- ok }

extern SMount { type dir pdev flags -- ok }

extern UMount { path -- ok }

extern VFSUnmountAll { -- ok }

extern VFSSync { -- ok }

extern VFSCanonicalizePath { path -- canon }

extern VNodeUpdateSize { newsize vnode -- }