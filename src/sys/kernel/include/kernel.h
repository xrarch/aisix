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

extern Panic (* ... fstr -- *)

extern PMMFree (* pages addr -- *)

extern PMMAlloc (* pages -- addr *)

extern PMMCalloc (* pages -- addr *)

extern AskUser (* question anslen -- answer *)

externconst ErrorNames