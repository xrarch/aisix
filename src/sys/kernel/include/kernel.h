#include "<inc>/atomic.h"
#include "<inc>/errno.h"
#include "<inc>/args.h"
#include "<inc>/minfo.h"
#include "<inc>/interrupts.h"
#include "<inc>/thread.h"
#include "<inc>/klog.h"
#include "<inc>/vfs.h"
#include "<inc>/dev.h"
#include "<inc>/timer.h"
#include "<inc>/block.h"
#include "<inc>/char.h"

extern Panic { ... fmt -- }

externptr Pages

extern PMMFree { pages addr -- }

extern PMMAlloc { pages -- addr }

extern PMMCalloc { pages -- addr }

extern AskUser { ... fmt anslen -- answer }

externptr ErrorNames