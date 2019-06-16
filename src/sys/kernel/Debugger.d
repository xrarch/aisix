(* debugger stub *)

procedure Debugger (* tf -- *)
	auto tf
	tf!

	auto line
	256 Malloc line!

	"\n!! AISIX DEBUGGER TRIGGERED !!\n" Printf

	"type 'exit' to resume normal operation\n" Printf

	"was running: " Printf

	if (TaskCurrent@ 0 ~=)
		TaskCurrent@ TaskDump
		'\t' Putc
		if (ThreadCurrent@ 0 ~=)
			ThreadCurrent@ ThreadDump
		end else
			"no thread!\n" Printf
		end
	end else
		"no task!\n" Printf
	end

	if (tf@ 0 ~=)
		tf@ cpu_dump_tf
		CR
	end

	auto run
	1 run!

	while (run@)
		"> " Printf
		line@ 255 PolledGets

		if (line@ "exit" strcmp)
			0 run!
		end
	end
end