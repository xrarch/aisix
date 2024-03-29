const NBUF 320

const BLOCKSZ 512

struct Buffer
	4 Valid
	4 Device
	4 RawDev
	4 BlockNum
	4 RawBlockNum
	Mutex_SIZEOF Mutex
	4 Refs
	4 Prev
	4 Next
	4 QNext
	4 Data
	4 Dirty
endstruct

extern bget { blockno dev -- buf }

extern bread { blockno dev -- buf }

extern bwrite { buf -- }

extern brelse { buf -- }

extern bupdate { buf -- ok }

extern bsync { -- ok }