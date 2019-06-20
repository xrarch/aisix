procedure Shutdown (* -- *)
	"shutting down the system...\n" Goodbye

	platform_shutdown
end

procedure Reboot (* -- *)
	"rebooting the system...\n" Goodbye

	platform_reboot
end

procedure Goodbye (* message -- *)
	CR

	0 SysconSwitchVC drop

	Printf

	InterruptDisable drop

	"syncing...\n" Printf
	sync
end