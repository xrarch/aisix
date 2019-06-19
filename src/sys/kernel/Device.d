#include "dev/Dev.d"

procedure DeviceInit (* -- *)
	DRIVER_MAX GenericDriver_SIZEOF * Calloc devsw!
	ListCreate DevList!
end

procedure DeviceDriverAlloc (* type -- driver *)
	auto type
	type!

	auto i
	0 i!

	while (i@ DRIVER_MAX <)
		auto ptr
		i@ GenericDriver_SIZEOF * devsw@ + ptr!

		if (ptr@ GenericDriver_Type + @ DRIVER_EMPTY ==)
			type@ ptr@ GenericDriver_Type + !
			i@ ptr@ GenericDriver_Major + !

			ptr@ return
		end

		i@ 1 + i!
	end

	ERR
end

procedure DeviceNumMajor (* dev -- maj *)
	0xFF00 & 8 >>
end

procedure DeviceNumMinor (* dev -- min *)
	0xFF &
end

procedure DeviceAdd (* owner perm name dev -- *)
	auto dev
	dev!

	auto name
	name!

	auto perm
	perm!

	auto owner
	owner!

	auto sdev
	Device_SIZEOF Malloc sdev!

	name@ strdup sdev@ Device_Name + !
	dev@ sdev@ Device_DevNum + !
	perm@ sdev@ Device_Perm + !
	owner@ sdev@ Device_Owner + !

	sdev@ DevList@ ListInsert
end

procedure DeviceByName (* name -- dev or -ENODEV *)
	auto name
	name!

	auto n
	DevList@ ListHead n!

	while (n@ 0 ~=)
		auto pnode
		n@ ListNodeValue pnode!

		if (pnode@ Device_Name + @ name@ strcmp)
			pnode@ return
		end

		n@ ListNodeNext n!
	end

	-ENODEV
end

procedure DeviceNumByName (* name -- num or -ENODEV *)
	auto dev
	DeviceByName dev!

	if (dev@ iserr)
		dev@ return
	end

	dev@ Device_DevNum + @
end

procedure DeviceDriverByMajor (* maj -- driver *)
	auto maj
	maj!

	if (maj@ DRIVER_MAX >=)
		-ENODEV return
	end

	auto drv

	maj@ GenericDriver_SIZEOF * devsw@ + drv!

	if (drv@ GenericDriver_Type + @ DRIVER_EMPTY ==)
		-ENODEV return
	end

	drv@
end

procedure DeviceNumDriver (* dev -- driver *)
	DeviceNumMajor DeviceDriverByMajor
end

procedure DeviceDriverByName (* name -- driver or -ENODEV *)
	auto name
	name!

	auto i
	0 i!

	while (i@ DRIVER_MAX <)
		auto ptr
		i@ GenericDriver_SIZEOF * devsw@ + ptr!

		if (ptr@ GenericDriver_Type + @ DRIVER_EMPTY ~=)
			if (ptr@ GenericDriver_Name + @ name@ strcmp)
				ptr@ return
			end
		end

		i@ 1 + i!
	end

	-ENODEV
end

procedure DeviceMajorByName (* name -- major *)
	auto drv

	DeviceDriverByName drv!

	if (drv@ iserr)
		drv@ return
	end

	drv@ GenericDriver_Major + @
end

procedure DevOpen (* proc num -- err *)
	auto num
	num!

	auto proc
	proc!

	auto drv
	num@ DeviceNumMajor DeviceDriverByMajor drv!
	if (drv@ iserr)
		drv@ return
	end

	auto dsw
	drv@ GenericDriver_devsw + @ dsw!

	proc@ num@ DeviceNumMinor dsw@ sdevsw_Open + @ Call
end

procedure DevClose (* proc num -- err *)
	auto num
	num!

	auto proc
	proc!

	auto drv
	num@ DeviceNumMajor DeviceDriverByMajor drv!
	if (drv@ iserr)
		drv@ return
	end

	auto dsw
	drv@ GenericDriver_devsw + @ dsw!

	proc@ num@ DeviceNumMinor dsw@ sdevsw_Close + @ Call
end

procedure DevIoctl (* proc cmd data num -- err *)
	auto num
	num!

	auto data
	data!

	auto cmd
	cmd!

	auto proc
	proc!

	auto drv
	num@ DeviceNumMajor DeviceDriverByMajor drv!
	if (drv@ iserr)
		drv@ return
	end

	auto dsw
	drv@ GenericDriver_devsw + @ dsw!

	proc@ cmd@ data@ num@ DeviceNumMinor dsw@ sdevsw_Ioctl + @ Call
end

procedure DevStrategy (* proc buf -- err *)
	auto buf
	buf!

	auto proc
	proc!

	auto num
	buf@ Buffer_Dev + @ num!

	auto drv
	num@ DeviceNumMajor DeviceDriverByMajor drv!
	if (drv@ iserr)
		drv@ return
	end

	if (drv@ GenericDriver_Type + @ DRIVER_BLOCK ~=)
		-ENOTBLK return
	end

	(* implemented at bio.d *)
	proc@ buf@ drv@ num@ DeviceNumMinor strategy
end

procedure DevSize (* proc minor -- err *)
	auto num
	num!

	auto proc
	proc!

	auto drv
	num@ DeviceNumMajor DeviceDriverByMajor drv!
	if (drv@ iserr)
		drv@ return
	end

	if (drv@ GenericDriver_Type + @ DRIVER_BLOCK ~=)
		-ENOTBLK return
	end

	auto dsw
	drv@ GenericDriver_devsw + @ dsw!

	proc@ num@ DeviceNumMinor dsw@ bdevsw_Size + @ Call
end

procedure DevRead (* proc buf offset count num -- err *)
	auto num
	num!

	auto count
	count!

	auto offset
	offset!

	auto buf
	buf!

	auto proc
	proc!

	auto drv
	num@ DeviceNumMajor DeviceDriverByMajor drv!
	if (drv@ iserr)
		drv@ return
	end

	if (drv@ GenericDriver_Type + @ DRIVER_CHAR ~=)
		-ENOTBLK return
	end

	auto dsw
	drv@ GenericDriver_devsw + @ dsw!

	proc@ buf@ offset@ count@ num@ DeviceNumMinor dsw@ cdevsw_Read + @ Call
end

procedure DevWrite (* proc buf offset count num -- err *)
	auto num
	num!

	auto count
	count!

	auto offset
	offset!

	auto buf
	buf!

	auto proc
	proc!

	auto drv
	num@ DeviceNumMajor DeviceDriverByMajor drv!
	if (drv@ iserr)
		drv@ return
	end

	if (drv@ GenericDriver_Type + @ DRIVER_CHAR ~=)
		-ENOTBLK return
	end

	auto dsw
	drv@ GenericDriver_devsw + @ dsw!

	proc@ buf@ offset@ count@ num@ DeviceNumMinor dsw@ cdevsw_Write + @ Call
end

procedure DeviceAddDriver (* devsw type name -- driver *)
	auto name
	name!

	auto type
	type!

	auto ddevsw
	ddevsw!

	auto driver
	type@ DeviceDriverAlloc driver!

	if (driver@ ERR ==)
		name@ "couldn't allocate device driver\n" Panic
	end

	name@ strdup driver@ GenericDriver_Name + !
	ddevsw@ driver@ GenericDriver_devsw + !

	driver@ GenericDriver_Major + @
end