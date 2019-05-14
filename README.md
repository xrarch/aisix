# aisix

Extreme work-in-progress.

Attempt to build a unix-like OS for the LIMN fantasy computer.

A long-term goal is a windowed GUI, short term goals are a bootloader, filesystem utilities, and a stub of a kernel.

## Building

Create a blank disk image.

Replace `disk.img` with the desired name of your disk image.

`dd if=/dev/zero of=disk.img bs=4096 count=1024`

Then, run the following commands with the LIMN sdk folder in your current directory:

Again, replace `disk.img` with the name of your disk image.

`./aisix/build-boot.sh ./disk.img`

`./aisix/build-stand.sh ./disk.img`