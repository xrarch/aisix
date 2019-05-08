#include "EBus.d"
#include "Citron.d"
#include "Amanatsu.d"

procedure PromptYN (* -- *)
	auto r
	2 Calloc r!

	Printf
	" [y/n]? " Printf

	r@ 1 Gets

	if (r@ gb 'y' ==)
		1 return
	end

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