## Igir Scripts  

This is a set of scripts used to manage ROMS for use on retro gaming devices. These scripts leverge the excellent cross-platform CLI tool [Igir](https://igir.io) to organize and greatly reduce the number of ROMs stored on devices.

### Workflow

`External Drive` -> `roms-raw` -> `roms-filtered` -> `roms-per-device`

Each step of the workflow reduces the size of each ROM set, and sorts the ROMs in a directory and naming structure that each discreet device expects.

#### Workflow Components

### 1. (Mostly unfiltered ROMs) roms-raw (~2TB)

These are symlinks to a 5TB external drive, with a mix of semi-hand-curated ROMs. In some cases I extract downloads to the `/mnt/archive/roms` directory and hand pick the systems I want to use, especially around No-Intro and Redump, where I only care about a handful of systems or discs.

I won't get into specifics on sourcing ROMS, but in general I leverage:

1. **BIOS**: A "TOSEC Firmware and Operating Systems Collection".
2. **FBNeo**: A "FBNeo 1.0.0.3" collection.
3. **MAME**: Pleasuredome ROMS.
4. **No-Intro:** A "PropeR 1g1r Collection".
5. **Redump**: Individually sourced disc images.

```
roms-raw
├── BIOS -> /mnt/archive/roms/BIOS
├── FBNeo-1.0.0.2 -> /mnt/archive/downloads/FBNeo 1.0.0.2 ROMs (split)/arcade
├── FBNeo-1.0.0.3 -> /mnt/archive/roms/FBNeo-1.0.0.3
├── MAME
│   ├── chd -> /mnt/archive/roms/MAME/chd
│   ├── rollback -> /mnt/archive/downloads/MAME 0.280 Rollback ROMs
│   ├── roms -> /mnt/archive/roms/MAME/MAME 0.280 ROMs
│   └── samples -> /mnt/archive/downloads/MAME 0.276 EXTRAs/samples
├── No-Intro -> /mnt/archive/roms/No-Intro
└── Redump -> /mnt/archive/roms/Redump
```

### 2. (Filtered ROMs) roms-filtered (~70GB)

This is a first-pass at filtering ROMs down to 1G1R and sorting out games I may not want. This is accomplished but using filtered DAT files for each system.

1. **BIOS**: The DAT that came with the collection. 
2. **FBNeo**: The [Libretro Arcade DAT](https://github.com/libretro/FBNeo/tree/master/dats).
3. **MAME**: [Arcade Database](http://adb.arcadeitalia.net) filtered DAT:
   1. MameCab. 
   2. Latest Release.
   3. Additional Filters -> General -> Emulation -> Working and Imperfect.
   4. Additional Filters -> Driver -> Dump Status -> Good.
   5. Additional Filters -> General -> Categories -> Language -> English.
   6. Additional Filters -> General -> Categories -> Language -> Best Games -> 80 - 90 (Very Good) + Include better titles also.
4. **No-Intro:**: The PropeR 1g1r Collection" set. 
5. **Redump**: 

MAME in particular is reduced from ~50K ROMS down to ~500!

```
roms-filtered
├── BIOS
├── FBNeo-1.0.0.2
├── FBNeo-1.0.0.3
├── FBNeo-latest -> FBNeo-1.0.0.3
├── MAME-0.280
├── MAME-latest -> MAME-0.280
├── No-Intro
└── Redump
```

### 3. (ROMs sorted per-device) roms-per-device (~25 - 30GB per device)

```
roms-per-device
├── RetroArch
│   ├── atari2600
│   ├── atari5200
│   ├── atari7800
│   ├── atarijaguar
│   ├── atarilynx
...
├── RG351V
│   ├── atari2600
│   ├── atari5200
│   ├── atari7800
│   ├── atarijaguar
│   ├── atarilynx
...
└── RPi4
    ├── atari2600
    ├── atari5200
    ├── atari7800
    ├── bios
    ├── colecovision
...
```