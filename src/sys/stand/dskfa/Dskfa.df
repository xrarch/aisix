#include "<df>/dragonfruit.h"
#include "<df>/platform/a3x/a3x.h"

extern IDiskInit
extern Prompt
extern PromptYN

var args 0
var BootDevice 0

(* 1: disk. 2: logical. *)
var DeviceType 0
public DeviceType

procedure CheckInvalid { arg -- dn }
	if (arg@ 0 ==)
		"no disk name provided.\n" Printf
		0 dn!
		return
	end

	auto disk
	256 Calloc disk!

	auto nw
	arg@ disk@ ' ' 255 strntok nw!

	disk@ a3xDevTreeWalk dn!

	if (dn@ 0 ==)
		disk@ "%s is an invalid disk path.\n" Printf
		disk@ Free
		0 dn! return
	end

	auto wbm

	dn@ a3xDeviceSelectNode
		"writeBlock" a3xDGetMethod wbm!
	a3xDeviceExit

	if (wbm@ 0 ==)
		disk@ "%s isn't a writable block device.\n" Printf
		disk@ Free
		0 dn! return
	end

	disk@ Free

	auto dpbd
	dn@ a3xDeviceSelectNode
		"bootAlias" a3xDGetProperty dpbd!
	a3xDeviceExit

	if (dpbd@ 0 ~=)
		dpbd@ dn!
	end
end

procedure Main (* fwctx ciptr bootdev args -- *)
	args!

	(* remember the boot device *)
	BootDevice!

	(* initialize the client interface *)
	a3xInit

	auto dpbd
	BootDevice@ a3xDeviceSelectNode
		"bootAlias" a3xDGetProperty dpbd!
	a3xDeviceExit

	if (dpbd@ 0 ~=)
		dpbd@ BootDevice!
	end

	"\n\t=== dskfa ===\nStandalone disk utility.\n" Printf

	auto dn
	args@ CheckInvalid dn!

	if (dn@ 0 ==)
		"no disk path provided, or invalid.\n" Printf

		"\nusage:\n\tdskfa.a3x [diskpath]\n\n" Printf

		return
	end

	dn@ "a3x devnode: %x\n" Printf

	if (dn@ BootDevice@ ==)
		if ("\nwarning, you're attempting to work on the same device that this utility was\nloaded from. are you sure that this is what you want" PromptYN ~~)
			return
		end
	end

	dn@ IDiskInit

	auto dt

	dn@ a3xDeviceSelectNode
		"type" a3xDGetProperty dt!
	a3xDeviceExit

	if (dt@ "disk" strcmp)
		"device type: raw disk\n" Printf
		1 DeviceType!
	end

	if (dt@ "logical" strcmp)
		"device type: logical volume\n" Printf
		2 DeviceType!
	end

	if (DeviceType@ 0 ==)
		"couldn't determine device type.\n" Printf
		return
	end

	Prompt
end





