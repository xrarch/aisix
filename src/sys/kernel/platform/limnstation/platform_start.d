asm "

.include platform/limnstation/platform_start.s

"

procedure platform_start (* node args imagesz -- *)
	auto imagesz
	imagesz!

	auto args
	args!

	a3xBootNode!

	MMUInit

	args@ imagesz@ 0x200000 AisixStart

	cpu_reset
end