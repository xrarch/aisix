# aisix

Major work-in-progress.

Attempt to build a unix-like OS for the LIMNstation fantasy computer.

A long-term goal is a tiled GUI, short(er) term goal is to get a half-usable kernel.

## Building

As with all of our LIMNstation projects, the [sdk](http://github.com/limnarch/sdk) should be in a directory `../sdk` relative to this repository.

Running `make` in this repository should then place an AISIX distribution image at `dist/dist.img`. Windows users should use WSL as Cygwin seems to have problems with the SDK.

## Testing

With the LIMNstation emulator (`./vm/`) and aisix repository (`./aisix/`) in your current directory, run this command:

`./vm/vm.sh -dks ./aisix/dist/dist.img`

If it doesn't boot automatically, type this command at the firmware prompt:

`boot /disks/0/a`

AISIX should boot! (as far as it can at the moment)
