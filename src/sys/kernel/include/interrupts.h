extern InterruptDisable { -- rs }

extern InterruptRestore { rs -- }

extern InterruptEnable { -- }

extern InterruptRegister { h n -- }

extern InterruptUnregister { n -- }

extern Interrupt { intn -- }

fnptr InterruptGetter { -- intn }

fnptr InterruptAcker { intn -- }

fnptr IntHandler { intn -- }

externptr InterruptGet

externptr InterruptAck