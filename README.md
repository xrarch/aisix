## Defunct as of December 2020; work has shifted to [MINTIA](http://github.com/limnarch/mintia) except for occasional bugfixes.

# aisix

Major work-in-progress.

Attempt to build an OS for the LIMNstation fantasy computer.

A long-term goal is a tiled GUI, short(er) term goal is to get a half-usable kernel.

![Running](https://i.imgur.com/RGFRGHh.png)

## License

AISIX is licensed under GPLv3. See LICENSE.

## Building

As with all LIMNstation projects, the [sdk](http://github.com/xrarch/sdk) should be in a directory `../sdk` relative to this repository.

Running `make` in this repository should then place an AISIX distribution image at `dist/dist.img`. Windows users should use WSL as Cygwin seems to have problems with the SDK.

## Testing

With the LIMNstation emulator (`./xremu/`) and aisix repository (`./aisix/`) in your current directory, run this command:

`./xremu/graphical.sh -dks ./aisix/dist/dist.img`

If it doesn't boot automatically, type this command at the firmware prompt:

`boot /disks/0/a`

AISIX should boot to the `login:` prompt.

Logging in as `guest` requires no password, and the default password for `root` is `aisix`.
