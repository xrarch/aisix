procedure platform_shutdown (* -- *)
	InterruptDisable drop

	"it is now safe to shut down your computer.\n" Printf

	while (1) end
end

procedure platform_reboot (* -- *)
	cpu_reset
end