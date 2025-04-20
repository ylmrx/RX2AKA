# Rex2 and AKAI decoder tool (importer) for Renoise 3.x

## Credits

The RX2 import is a port from Esaruoho' Paketti (<https://github.com/esaruoho/paketti>)

The change the behavior so it behaves closer to Renoise original import : ie. if
you double-click an importable file, it'll overwrite current instrument, and won't load any
macro or default.

If you use/like it a lot, you owe him money : <https://patreon.com/esaruoho> (if you can)

The AKAI import iterates from legacy (and kinda broken) Mxb tool
<https://www.renoise.com/tools/additional-file-format-import-support>

I changed few things so it can deal with stereo files, and behaves better with program

## AKAI

- If you're dealing with programs spanning drum-loop (or non-tonal stuffs, noise, spoken voice...)
across keys:
   - select all sample (square selection in the `keyzone` tab)
   - click: `"Key->Pitch"` setting at the bottom.
   - maybe tweak the bass note
- The whole things expect upper-case file names
- Many programs are kinda broken (ie. reference files that don't exist... if you report issues share the faulty file)

## AKAI Ripping

You'll find `.iso` files on `archive.org` I use `akaiutil` to extract files. It's a CLI tool. It goes like
(commands you'll enter are prefixed with a `>`)

```text
> C:\PATHTO\akaiutil.exe -f "D:\PATH\TO\SOME\FILE.iso"

****************************************************
*                                                  *
*  AKAI S900/S1000/S3000 File Manager, Rev. 4.6.8  *
*                                                  *
****************************************************

[...]

opening disks
disk0: "D:\PATH\TO\SOME\FILE.iso"
done

scanning disks
done

/
disk  type parts  blksize tot/blks  tot/MB  free/blks free/MB free/%
--------------------------------------------------------------------
   0    HD     9   0x2000   0xffff   512.0     0x08b2    17.4    3.4
--------------------------------------------------------------------
total:   1 disk(s)


--- read/write mode ---

try "help" for infos

> /disk0 > dir

/disk0
part  type startblk size/blks  size/MB  free/blks free/MB free/%
----------------------------------------------------------------
   A    HD   0x0000    0x1e00     60.0     0x00d0     1.6    2.7
   B    HD   0x1e00    0x1e00     60.0     0x0122     2.3    3.8
[...]
----------------------------------------------------------------
total:   9 partition(s)


> /disk0 > cd A    # cd to some partition

> /disk0/A > dir   # list a partition/volume content

/disk0/A
vnr   vname         lnum  startblk  osver  type
---------------------------------------------------
  1   VOLUME 001     -      0x0003   4.40  S1000
[...]
 17   VOLUME 017     -      0x1b0c   4.40  S1000
---------------------------------------------------
total:  17 volume(s) (max. 100)


> /disk0/A > cdi 1          # cd to a volume (the i is not a typo)

> /disk0/A/VOLUME 001 > dir # list its content

/disk0/A/VOLUME 001
fnr  fname               size/B  startblk  osver  tags
--------------------------------------------------------------
[...]
  9  CD ROM.S1            88350    0x003e   9.30
[...]
--------------------------------------------------------------
total:  12 file(s) (max. 126),    796950 bytes

> /disk0/A/VOLUME 001 > getall   # copy all files in volume to current directory
exporting "PROGRAM.P1"
exporting "C.S1"
exporting "99.S1"
[...]
> /disk0/A/VOLUME 001 > cd ..    # go back to parent folder (partition)
> /disk0/A > cdi 2               # go to next volume
```


