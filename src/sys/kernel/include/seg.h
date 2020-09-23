fnptr SegmentDestructor { segment -- ok }

struct Segment
	4 Destructor
	4 Refs
	4 PageCount
	4 PageList
	4 VNode
	4 Prev
	4 Next
endstruct

extern RefSegment { seg -- }

extern UnrefSegment { seg -- }

extern ClosePSegment { oseg -- ok }

extern CloseSegment { proc sd -- ok }

extern OpenSegment { proc seg flags -- sd }

extern MapSegment { proc sd pva must -- ok ava }

extern UnmapSegment { proc sd -- ok }