struct XLOFFHeader
	4 Magic
	4 SymbolTableOffset
	4 SymbolCount
	4 StringTableOffset
	4 StringTableSize
	4 TargetArchitecture
	4 EntrySymbol
	4 Flags
	4 Timestamp
	4 SectionTableOffset
	4 SectionCount
	4 ImportTableOffset
	4 ImportCount
	4 HeadLength
endstruct

struct XLOFFSectionHeader
	4 NameOffset
	4 DataOffset
	4 DataSize
	4 VirtualAddress
	4 RelocTableOffset
	4 RelocCount
	4 Flags
endstruct

struct XLOFFSymbol
	4 NameOffset
	4 Value
	2 SectionIndexI
	1 TypeB
	1 FlagsB
endstruct

const XLOFFMagic 0x99584F46
const XLOFFArch 1

const XLOFFGLOBAL 1

const XLOFFTEXT 0