struct LOFFHeader
	4 Magic
	4 SymbolTableOffset
	4 SymbolCount
	4 StringTableOffset
	4 StringTableSize
	4 TargetArchitecture
	4 EntrySymbol
	4 Stripped
	4 ImportTableOffset
	4 ImportCount
	20 Reserved
	4 TextHeader
	4 DataHeader
	4 BSSHeader
endstruct

struct LOFFSectionHeader
	4 FixupTableOffset
	4 FixupCount
	4 SectionOffset
	4 SectionSize
	4 LinkedAddress
endstruct

struct LOFFSymbol
	4 NameOffset
	4 Section
	4 Type
	4 Value
	4 ImportIndex
endstruct

const LOFFMagic 0x4C4F4635
const LOFFArch 5

const LOFFGLOBAL 1

const LOFFTEXT 1