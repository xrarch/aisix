externptr Pages

externptr Alloced

extern PMMFree { pages addr -- }

extern PMMAlloc { pages -- addr }

extern PMMCalloc { pages -- addr }

extern PMMPowerOfTwoAlloc { power -- addr }

extern PMMPowerOfTwoCalloc { power -- addr }

extern PMMPowerOfTwoFree { power addr -- }

extern PMMFasterSinglePageAlloc { -- addr }

extern PMMFasterSinglePageCalloc { -- addr }

extern PMMFasterSinglePageFree { addr -- }

struct Pagemap
	4 Data
	4 Process
endstruct

extern VMPagemapAlloc { proc -- pm }

extern VMMap { pm virt phys flags -- ok }

extern VMUnmap { pm virt free -- }

extern VMNewSegment { -- seg }

extern VMMapSegment { seg pm pva flags must -- ok ava }

extern VMUnmapSegment { seg pm virt -- }

extern VMRefSegment { seg -- }

extern VMCloseSegment { seg -- ok }

extern VMAllocSegment1 { bytes clear -- seg }

extern VMAllocSegment { bytes -- seg }

extern VMCallocSegment { bytes -- seg }

extern VMSallocSegment { bytes -- seg }

extern VMWalk { pm va -- ok pa }

extern VMMemset { pm va size word -- ok }

extern VMCopyout { pm va src len -- ok }

extern VMCopyin { pm dest va len -- ok }

extern VMStrlen { pm va -- len }

extern VMStrnCopyin { pm dest va max -- ok }

extern VMMemcpy { destpm dest srcpm src len -- ok }

extern VMSegDestruct { segment -- ok }

extern VMPagemapFree { pm -- }

extern VMDumpWalk { pm -- }