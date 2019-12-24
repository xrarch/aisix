_aisix_start:
.global _aisix_start

.yield:
	li r0, 2
	sys 0
	b .yield