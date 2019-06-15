procedure cpu_dump_tf (* tf -- *)
	auto tf
	tf!

	auto i
	0 i!

	"limn1k trapframe dump\n" Printf

	while (i@ TrapFrameNElem <)
		if (i@ 4 % 0 ==)
			CR
		end

		tf@ i@ 4 * + @ [i@]TrapFrame_Names@ "%s = %x\t" Printf

		i@ 1 + i!
	end

	CR
end