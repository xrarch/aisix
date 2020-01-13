#include "<inc>/args.h"
#include "<inc>/minfo.h"
#include "<inc>/proc.h"
#include "<inc>/aixo.h"
#include "<inc>/clock.h"

#include "<inc>/limnstation/limn.h"

extern Shutdown (* -- *)

extern Reboot (* -- *)

extern Panic (* ... fstr -- *)

extern PMMFree (* pages addr -- *)

extern PMMAlloc (* pages -- addr *)

extern ServiceAdd (* name pid -- ok *)

extern ServiceByName (* name -- pid *)

extern Getc (* -- c *)