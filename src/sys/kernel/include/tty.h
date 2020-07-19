struct TTY
	4 IBuffer
	4 OBuffer
	4 Mode
endstruct

extern AllocTTY { ibuf obuf -- tty }

extern TTYRead { buf len tty -- bytes }

extern TTYWrite { buf len tty -- bytes }