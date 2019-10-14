# aisix

Extreme work-in-progress.

Attempt to build a unix-like OS for the LIMNstation fantasy computer.

A long-term goal is a windowed GUI, short term goals are to finish the standalone disk utilities, and to get a decent kernel.

![Surprisingly decent-looking boot screen](https://i.imgur.com/GFIdtZl.png)

## Building

Run the following command to create a blank disk image. Replace `disk.img` with the desired name of your disk image.

`dd if=/dev/zero of=disk.img bs=4096 count=1024`

Then, run the following commands, with the LIMN sdk folder in your current directory (again, replace `disk.img` with the name of your disk image):

`./sdk/fsutil.sh ./disk.img f`

`./aisix/make-bootable.sh ./disk.img`

`./aisix/build-stand.sh ./disk.img`

`./aisix/build-aisix.sh ./disk.img`

## Booting

Run one of the following commands, with the LIMNstation emulator (`./vm/`) in your current directory.

Again, replace `disk.img` with the name of your aisix disk image.

Graphical boot (recommended, cooler):
`./vm/vm.sh -dks ./disk.img`

Headless (serial port) boot:
`./vm/headless.sh -dks ./disk.img`

If you're doing a graphical boot, press `.` at the graphical box, and then type `2` and press enter to drop into the firmware prompt.

At the a3x firmware prompt, the following command should work to boot the image:

`boot /ebus/platformboard/citron/dks/0`

At the bootloader's `>>` prompt, type `aisix -v`. AISIX should boot! (as far as it can at the moment)

If you want to avoid these long-winded commands, it's possible to make the firmware do it automatically.

At the firmware prompt, type the following sequence of commmands:

```
setenv boot-dev /ebus/platformboard/citron/dks/0
setenv auto-boot? true
```

This sets the NVRAM variable boot-dev to point towards the devicetree path of our boot disk.

It sets the variable auto-boot? to true, to tell the firmware to automatically try to boot from boot-dev.

If you want to automate the bootloader prompt as well, type the following command at the firmware prompt:

```
setenv boot-args boot:auto=aisix -v
```

The bootloader, by default, will have a two second delay to give an opportunity to cancel the boot.

If you're impatient, type this command instead:

```
setenv boot-args boot:auto=aisix -boot:nodelay -v
```

## Boot Options

| Option                                  | Effect                                                       |
|-----------------------------------------|--------------------------------------------------------------|
| -v                                      | Graphical verbose boot                                       |
| -consupl                                | Don't print early messsages after switching to video console |
| console=(video/serial/platform/default) | Use option as system console. Overridden to video by -v.     |
| rd=[dev]                                | Try to use dev (mnemonic) as automatic root device           |
| -nographics                             | Don't initialize graphics subsystem                          |
| -graphics,nobg                          | Don't draw AISIX logo, don't clear screen                    |
| -graphics,noclear                       | Don't clear screen with solid color                          |
