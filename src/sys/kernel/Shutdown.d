procedure Shutdown (* -- *)
	CR

	0 SysconSwitchVC drop

	"shutting down the system.\n" Printf

	(* todo: sync all filesystems and block devices, kill all processes *)

	platform_shutdown
end