#include "<df>/dragonfruit.h"

extern EBusDump
extern AmanatsuDump

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

procedure Prompt (* -- *)
	if ("dump ebus info" PromptYN)
		EBusDump
	end

	if ("dump amanatsu info" PromptYN)
		AmanatsuDump
	end
end