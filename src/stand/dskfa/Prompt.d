procedure PromptYN (* -- *)
	auto r
	2 Calloc r!

	Printf
	" [y/n]? " Printf

	r@ 1 Gets

	if (r@ gb 'y' ==)
		r@ Free
		1 return
	end

	r@ Free
	0 return
end