const RAM256DescSpace 0x10000000

procedure RAM256Slots (* -- slots *)
	RAM256DescSpace@
end

procedure RAM256SlotSize (* n -- size *)
	1 + 4 * RAM256DescSpace + @
end

procedure TotalRAM (* -- totalram *)
	auto max
	RAM256Slots max!

	auto i
	0 i!

	auto sz
	0 sz!

	while (i@ max@ <)
		sz@ i@ RAM256SlotSize + sz!

		i@ 1 + i!
	end

	sz@
end