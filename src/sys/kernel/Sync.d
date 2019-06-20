(* sync all caches *)
procedure sync (* -- err *)
	auto r
	flushblockdevs r!

	if (r@ iserr)
		r@ return
	end

	0
end

procedure SyncWorker (* -- *)
	while (1)
		8000 ClockWait

		auto r
		sync r!

		if (r@ iserr)
			[r@]aisix_errno@ "syncworker: %s\n" Printf
		end
	end
end

procedure SyncInit (* -- *)
	pointerof SyncWorker KernelThreadCreate KernelThreadResume
end