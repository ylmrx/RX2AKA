# Rex2 and AKAI decoder tool (importer) for Renoise 3.x

## Credits

The RX2 import is a port from Esaruoho' Paketti (<https://github.com/esaruoho/paketti>)

The change I made is that it behaves closer to Renoise original import behavior: aka if
you double-click an importable file, it'll overwrite current instrument, and won't load any
macro or default.

If you use/like it a lot, you owe him money : <patreon.com/esaruoho> (if you can)

The Akai import iterates from legacy (and kinda broken) Mxb tool
<https://www.renoise.com/tools/additional-file-format-import-support>

I changed few things so it can deal with stereo files, and behaves better with program

## AKAI

- If you're dealing with programs spanning drum-loop (or non-tonal stuffs, noise, spoken voice...)
across keys, you'll want to disable the `"Key->Pitch"` setting at the bottom of the "Keyzone" tab.
- The whole things expect upper-case file names

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
   C    HD   0x3c00    0x1e00     60.0     0x00d2     1.6    2.7
   D    HD   0x5a00    0x1e00     60.0     0x0268     4.8    8.0
   E    HD   0x7800    0x1e00     60.0     0x016a     2.8    4.7
   F    HD   0x9600    0x1e00     60.0     0x003c     0.5    0.8
   G    HD   0xb400    0x1e00     60.0     0x0073     0.9    1.5
   H    HD   0xd200    0x1e00     60.0     0x0133     2.4    4.0
   I    HD   0xf000    0x0fff     32.0     0x003a     0.5    1.4
----------------------------------------------------------------
total:   9 partition(s)


> /disk0 > cd A    # cd to some partition

> /disk0/A > dir   # list a partition/volume content

/disk0/A
vnr   vname         lnum  startblk  osver  type
---------------------------------------------------
  1   VOLUME 001     -      0x0003   4.40  S1000
  2   VOLUME 002     -      0x006a   4.40  S1000
  3   VOLUME 003     -      0x038a   4.40  S1000
  4   VOLUME 004     -      0x055a   4.40  S1000
  5   VOLUME 005     -      0x072a   4.40  S1000
  6   VOLUME 006     -      0x08a6   4.40  S1000
  7   VOLUME 007     -      0x0a38   4.40  S1000
  8   VOLUME 008     -      0x0b8a   4.40  S1000
  9   VOLUME 009     -      0x0c88   4.40  S1000
 10   VOLUME 010     -      0x0e04   4.40  S1000
 11   VOLUME 011     -      0x0faa   4.40  S1000
 12   VOLUME 012     -      0x10fc   4.40  S1000
 13   VOLUME 013     -      0x1320   4.40  S1000
 14   VOLUME 014     -      0x14c6   4.40  S1000
 15   VOLUME 015     -      0x15c4   4.40  S1000
 16   VOLUME 016     -      0x18ba   4.40  S1000
 17   VOLUME 017     -      0x1b0c   4.40  S1000
---------------------------------------------------
total:  17 volume(s) (max. 100)


> /disk0/A > cdi 1          # cd to a volume (the i is not a typo)

> /disk0/A/VOLUME 001 > dir # list its content

/disk0/A/VOLUME 001
fnr  fname               size/B  startblk  osver  tags
--------------------------------------------------------------
  1  HOUSEWORX.P1           600    0x0004   9.30
  2  POWERED BY.P1          600    0x0005   9.30
  3  MOUSSE T..P1           600    0x0006   9.30
  4  C.S1                 88350    0x0007   9.30
  5  99.S1                88350    0x0012   9.30
  6  BY.S1                88350    0x001d   9.30
  7  UEBERSCHALL.S1       88350    0x0028   9.30
  8  GERMANY.S1           88350    0x0033   9.30
  9  CD ROM.S1            88350    0x003e   9.30
 10  AKAI FORMAT.S1       88350    0x0049   9.30
 11  .S1                  88350    0x0054   9.30
 12  510MB.S1             88350    0x005f   9.30
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


