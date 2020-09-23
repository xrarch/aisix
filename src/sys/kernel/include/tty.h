struct TTY
	4 IBuffer
	4 OBuffer
	4 Mode
endstruct

extern AllocTTY { ibuf obuf -- tty }

extern TTYRead { pm buf len tty -- bytes }

extern TTYWrite { pm buf len tty -- bytes }