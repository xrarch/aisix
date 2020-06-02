const DEVNAMELEN 32

struct Driver
	4 Name
	4 Type
	4 Open
	4 Close
	4 Ioctl
	4 Read
	4 Write
	4 Size
endstruct

struct Device
	DEVNAMELEN Name
	4 Driver
	4 Unit
	4 Mount
	4 Next
	4 Prev
endstruct

const DEV_CHAR 1
const DEV_BLOCK 2

extern DevByName (* name -- dev *)

extern DevByIndex (* index -- dev *)

extern DeviceRegister (* name driver type unit -- device *)