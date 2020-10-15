#include "<inc>/errno.h"
#include "<inc>/args.h"
#include "<inc>/minfo.h"
#include "<inc>/interrupts.h"
#include "<inc>/atomic.h"
#include "<inc>/thread.h"
#include "<inc>/klog.h"
#include "<inc>/vfs.h"
#include "<inc>/dev.h"
#include "<inc>/timer.h"
#include "<inc>/block.h"
#include "<inc>/char.h"
#include "<inc>/tty.h"
#include "<inc>/gfx.h"
#include "<inc>/exec.h"
#include "<inc>/sys.h"
#include "<inc>/fd.h"
#include "<inc>/seg.h"
#include "<inc>/vm.h"
#include "<inc>/halt.h"
#include "<inc>/weak.h"

extern Panic { ... fmt -- }

extern AskUser { ... fmt anslen -- answer }

externptr ErrorNames

externptr ConsInited

externptr ConsIBuf
externptr ConsOBuf

externptr TriviaSwitch