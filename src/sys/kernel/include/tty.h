struct TTY
	4 IBuffer
	4 OBuffer
	4 Mode
	4 Device
	4 Width
	4 Height
endstruct

extern AllocTTY { dev ibuf obuf -- tty }

extern TTYRead { pm buf len tty -- bytes }

extern TTYWrite { pm buf len tty -- bytes }

extern TTYIOCtl { pm op1 op2 op3 op4 tty -- ok }

struct TTYInfo
	4 Width
	4 Height
	4 Mode
	48 Reserved
endstruct

const TTY_MODE_RAW 1
const TTY_MODE_NOECHO 2

const TTY_IOCTL_INFO 1
const TTY_IOCTL_SET 2