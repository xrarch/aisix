procedure PromptYN (* prompt -- *)
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

procedure PromptON (* ... numopt prompt -- *)
	CR

	Printf

	auto no
	no!

	auto i
	1 i!
	while (i@ no@ <=)
		i@ "\t%d. %s\n" Printf
		i@ 1 + i!
	end

	CR

	auto r
	12 Calloc r!

	"option #: " Printf

	r@ 11 Gets

	r@ atoi

	r@ Free
end

procedure FormatDisk (* -- *)

end

procedure Prompt (* -- *)
	auto r

	0 r!

	while (r@ 3 > r@ 0 == ||)
		"partition the disk"
		"format the disk with a new filesystem"
		"exit"
		3
		"which would you like to do? keep in mind that either are very likely to destroy\nany data currently existing on the volume.\n"
		PromptON r!
	end

	if (r@ 1 ==)
		return
	end

	if (r@ 3 ==)
		if (DeviceType@ 1 ~=)
			"\ncan only partition a raw disk. run this utility again, but supply the raw disk\npath. you are attempting to partition a partition.\n" Printf
			return
		end

		PartitionDisk
	end else
		if (r@ 2 ==)
			if (DeviceType@ 1 ==)
				"\nyou are trying to put a filesystem on a raw disk. this will destroy\nany existing partition table. you probably want to put this filesystem\non a partition instead.\n" Printf

				if ("\nare you sure that this is what you want" PromptYN ~~)
					return
				end 
			end

			FormatDisk
		end
	end
end