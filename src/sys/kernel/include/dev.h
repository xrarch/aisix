const DEVNAMELEN 32

struct Driver
	4 Name
	4 Type
	4 Open
	4 Close
	4 IOCtl
	4 Read
	4 Write
	4 Sysctl
endstruct

fnptr DevOpen { unit -- ok }

fnptr DevClose { unit -- ok }

fnptr DevIOCtl { op1 op2 op3 op4 unit -- ok }

fnptr DevRead { pm buf len unit seek -- bytes }

fnptr BlockDevRead { buf len unit seek -- blocks }

fnptr DevWrite { pm buf len unit seek -- bytes }

fnptr BlockDevWrite { buf len unit seek -- blocks }

fnptr DevSysctl { op1 op2 op3 op4 unit -- ok }

struct Device
	DEVNAMELEN Name
	4 Driver
	4 Unit
	4 Mount
	4 Offset
	4 RawDev
	4 Permissions
	4 IBuffer
	4 OBuffer
	4 TTY
	4 Next
	4 Prev
	4 Size
endstruct

const DEV_CHAR 1
const DEV_BLOCK 2

externptr DevFSTab

extern DeviceSysctl { op1 op2 op3 op4 dev -- ok }

extern DeviceRead { pm buf len seek dev -- bytes }

extern DeviceWrite { pm buf len seek dev -- bytes }

extern DeviceOpen { dev -- ok }

extern DeviceClose { dev -- ok }

extern DeviceIOCtl { op1 op2 op3 op4 dev -- ok }

extern DevByName { name -- dev }

extern DevByIndex { index -- dev }

extern DeviceRegister { permissions ibuffer obuffer name driver unit -- device }

externptr RootDevice