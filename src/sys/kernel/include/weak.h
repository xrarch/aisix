struct WeakObject
	4 Callback
	4 Private0
	4 Private1
	4 Prev
	4 Next
endstruct

fnptr WeakObjectCallback { obj bytespreferred rs -- bytesactual destroyed }

extern WeakReclaim { bytespreferred -- bytesactual }

extern RemoveWeakObject { obj -- }

extern TouchWeakObject { obj -- }

extern NewWeakObject { priv0 priv1 callback -- obj }