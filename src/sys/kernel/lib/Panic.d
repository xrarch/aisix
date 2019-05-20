procedure Panic (* fmt -- *)

	"\n\naisix PANIC: " Printf

	Printf

	CR

	if (CurProc@ -1 ==)
		"hadn't initialized scheduler yet!\n" Printf
	end else
		CurProc@ Proc_Name + @ CurProc@ Proc_PID + @ "was executing pid%d (%s)\n" Printf

		auto chtta
		CurProc@ Proc_cHTTA + @ chtta!

		auto p
		0 p!
		while (p@ HTTA_SIZEOF <)
			chtta@ p@ + @ dup [p@ 4 /]HTTA_Names@ "[%s] = %x (%d)" Printf

			if (p@ 12 % 0 ==)
				CR
			end else
				'\t' Putc
			end

			p@ 4 + p!
		end
	end

	while (1) end
end