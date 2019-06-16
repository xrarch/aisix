#include "dev/Dev.d"

procedure DeviceInit (* -- *)
	DRIVER_MAX GenericDriver_SIZEOF * Calloc devsw!

	devsw@ "devsw @ 0x%x\n" Printf
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

procedure DeviceMajorToDriver (* maj -- driver *)
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

procedure DeviceNumMajor (* dev -- maj *)
	0xFF00 & 8 >>
end

procedure DeviceNumMinor (* dev -- min *)
	0xFF &
end

procedure DeviceNumDriver (* dev -- driver *)
	DeviceNumMajor DeviceMajorToDriver
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

	if (drv@ 0 s<)
		drv@ return
	end

	drv@ GenericDriver_Major + @
end

procedure DeviceAddDriver (* devsw type name -- *)
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

	driver@ GenericDriver_Major + @ name@ "dev: adding driver '%s' at major %d\n" Printf

	name@ strdup driver@ GenericDriver_Name + !
	ddevsw@ driver@ GenericDriver_devsw + !
end

















