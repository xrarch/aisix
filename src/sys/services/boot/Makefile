all:
	for d in */ ; do \
	    make --directory=$$d; \
	done

	gtar --format=ustar --blocking-factor=1 -cf bootimage.tar *.i6s