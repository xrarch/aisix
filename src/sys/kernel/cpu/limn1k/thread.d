(* deals with cpu-specific bits of crafting a kernel thread *)
procedure cpu_kernel_thread_create (* func thread -- *)
	auto thread
	thread!

	auto func
	func!

	auto kstack
	thread@ Thread_KernelStack + @ kstack!

	auto ksp
	kstack@ KERNEL_STACK_SIZE + Context_SIZEOF - ksp!

	ksp@ thread@ Thread_Context + !

	ksp@ Context_SIZEOF 0 memset

	func@ ksp@ Context_pc + !

	2 ksp@ Context_rs + !

	(* use half of the stack for the dragonfruit value stack *)
	kstack@ KERNEL_STACK_SIZE 2 / - ksp@ Context_r5 + !
end