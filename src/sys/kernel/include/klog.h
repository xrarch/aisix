extern KLogAttach { read write -- }

fnptr KLogWriter { c -- }

fnptr KLogReader { -- c }

extern LogPump { -- }

externptr KLogWrite

externptr KLogRead

extern BootPrintf { ... fmt -- }