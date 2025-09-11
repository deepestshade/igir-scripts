# Igir Scripts  

This is a set of scripts used to manage ROMS for use on retro gaming devices. These scripts leverage the excellent cross-platform CLI tool [Igir](https://igir.io) to organize and greatly reduce the number of ROMs stored on devices.

I am sharing these scripts as a reference for others to adopt to their individual workflows. Feel free to fork and modify.

## Workflow

`External Drive` -> `roms-raw` -> `roms-filtered` -> `roms-per-device`

Each step of the workflow reduces the size of each ROM set and sorts the ROMs in a folder and naming structure that each device expects.

### 1. Mostly unfiltered ROMs: roms-raw (~2TB)

These are symlinks to a 5TB external drive, with a mix of downloaded hand-organized ROMs. In some cases I extract downloads to the `/mnt/archive/roms` directory and hand pick the systems I want to use This is especially the case around No-Intro and Redump, where I only care about a handful of systems or discs.

I won't get into specifics on sourcing ROMS, but in general I leverage:

1. **BIOS**: A "TOSEC Firmware and Operating Systems Collection".
2. **FBNeo**: A "FBNeo 1.0.0.3" collection.
3. **MAME**: Pleasuredome ROMS.
4. **No-Intro:** A "PropeR 1g1r Collection".
5. **Redump**: Individually sourced disc images.

```
roms-raw
├── BIOS -> /mnt/archive/roms/BIOS
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

This is a first-pass at filtering ROMs down to 1G1R (1 Game 1 Region) for consoles, and for arcades filtering out the majority of roms. This is accomplished by using various pared-down DAT files for each system.

1. **BIOS**: The DAT that came with the TOSEC BIOS collection. 
2. **FBNeo**: The [Libretro Arcade DAT](https://github.com/libretro/FBNeo/tree/master/dats).
3. **MAME**: [Arcade Database](http://adb.arcadeitalia.net) filtered DAT using the following options:
   1. MameCab. 
   2. Latest Release.
   3. Additional Filters -> General -> Emulation -> Working and Imperfect.
   4. Additional Filters -> Driver -> Dump Status -> Good.
   5. Additional Filters -> General -> Categories -> Language -> English.
   6. Additional Filters -> General -> Categories -> Language -> Best Games -> 80 - 90 (Very Good) + Include better titles also.
4. **No-Intro:**: The PropeR 1g1r Collection" set. 
5. **Redump**: 

MAME in particular is reduced from ~50K ROMS down to under 500 (1.2TB down to 6GB)! 

THe `filter-*.sh` scripts do the filtering for each system. e.g. filter-nointro.sh,

```bash
input_dir="./roms-raw/No-Intro"
output_dir="./roms-filtered/No-Intro"
dat_file="./dat/proper1g1r-collection.zip"

npx --yes igir@latest copy zip clean test \
  --dat "${dat_file}" \
  --input "${input_dir}" \
  --output "${output_dir}" \
  --dir-dat-name \
  --input-checksum-max CRC32 \
  --input-checksum-archives never \
  --no-bios \
  --single \
  --only-retail \
  --filter-region USA,WORLD \
  --prefer-language EN \
  --prefer-region USA,WORLD,EUR \
  --prefer-revision newer \
  --zip-exclude "*.{chd,iso}"
```

Output structure:

```
roms-filtered
├── BIOS
├── FBNeo-1.0.0.3
│   └── FinalBurn Neo - Arcade Games
├── MAME
│   ├── MAME-0.268
│   ├── MAME-0.280
│   ├── MAME-0.78
│   └── MAME-latest -> MAME-0.280
├── No-Intro
│   ├── Atari - 2600 (Retool)
│   ├── Atari - 5200 (Retool)
│   ├── Atari - 7800 (Retool)
│   ├── Atari - Jaguar (ROM) (Retool)
│   ├── Atari - Lynx (LYX) (Retool)
│   ├── Coleco - ColecoVision (Retool)
│   ├── Mattel - Intellivision (Retool)
│   ├── NEC - PC Engine - TurboGrafx-16 (Retool)
│   ├── Nintendo - Game Boy Advance (Retool)
│   ├── Nintendo - Game Boy Color (Retool)
│   ├── Nintendo - Game Boy (Retool)
│   ├── Nintendo - Nintendo 64 (BigEndian) (Retool)
│   ├── Nintendo - Nintendo Entertainment System (Headered) (Retool)
│   ├── Nintendo - Super Nintendo Entertainment System (Retool)
│   ├── Sega - 32X (Retool)
│   ├── Sega - Game Gear (Retool)
│   ├── Sega - Master System - Mark III (Retool)
│   ├── Sega - Mega Drive - Genesis (Retool)
│   └── SNK - NeoGeo Pocket Color (Retool)
└── Redump
    ├── Sega - Dreamcast
    ├── Sony - PlayStation
    └── Sony - PlayStation Portable
```

### 3. (ROMs sorted per-device) roms-per-device (~25 - 30GB per device)

Finally, the `roms-filtered` directory is sorted per-device. Currently I have:

1. A laptop running [RetroArch](https://www.retroarch.com) directly.
2. A Raspberry Pi 4 running [Batocera](https://batocera.org).
3. An Anbernic RG351V running [AmberElec](https://amberelec.org).
4. A TRIMUI Brick running [Knulli](https://knulli.org).

Each OS uses different emulators and annoyingly slightly different folder names, so I need to target each device specifically using the `target-device.sh` script.

```bash
# Set target-specific configuration
case "$target" in
    # TRIMUI Brick Hammer (MAME 2003-Plus, Batocera)
    "brick")
        device="Brick"
        mame_version="0.78"
        path_token="{batocera}"
        ;;
    # RetroArch (MAME-Latest, EmulationStation)
    "retroarch")
        device="RetroArch"
        mame_version="0.280"
        path_token="{es}"
        ;;
    # Anbernic RG351V (MAME 2003-Plus, EmulationStation)
    "rg351v")
        device="RG351V"
        mame_version="0.78"
        path_token="{es}"
        ;;
    # Raspberry Pi 4 (MAME 0.268, Batocera)
    "rpi4")
        device="RPi4"
        mame_version="0.268"
        path_token="{batocera}"
        ;;
    *)
        echo "Error: Unknown target '$target'"
        echo "Available targets: brick, retroarch, rg351v, rpi4"
        exit 1
        ;;
esac
```
 
The output goes to the `roms-per-device` directory, with the right roms (mainly around MAME versions) and folder strucure per OS:

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