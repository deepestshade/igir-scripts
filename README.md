# Igir Scripts

This project contains a set of scripts for managing ROMs across retro gaming devices.  
They use the excellent cross-platform CLI tool [Igir](https://igir.io) to organize ROMs and drastically reduce storage needs.

I’m sharing these scripts as a reference for others to adapt into their own workflows. Feel free to fork and modify.

**Note:** You must supply your own legally obtained ROMs, BIOS, and disc images. This project does not provide them.

---

## Workflow Overview

`External Drive` → `roms-raw` → `roms-filtered` → `roms-for-devices`

Each stage reduces the size of the ROM sets and arranges them into the folder and naming structures expected by different emulators and front-ends.

---

### 1. `roms-raw` (~2TB, mostly unfiltered)

This stage contains symlinks to a 5TB external drive with a mix of downloaded and hand-organized ROMs.  
Sometimes I extract archives directly to `/mnt/archive/roms` and select only the roms/systems that I care about (especially with No-Intro and Redump).

I will not go into sourcing ROMs here, but in general my sources include:

- **BIOS** → A "TOSEC Firmware and Operating Systems Collection"
- **FBNeo** → A FBNeo 1.0.0.3 collection  
- **MAME** → The Pleasuredome ROM sets  
- **No-Intro** → A "PropeR 1G1R Collection"  
- **Redump** → Individually sourced disc images  

Directory structure:

```
roms-raw
├── BIOS -> /mnt/archive/roms/BIOS
├── FBNeo-1.0.0.3 -> /mnt/archive/roms/FBNeo-1.0.0.3
├── MAME
│   ├── chd -> /mnt/archive/roms/MAME/chd
│   ├── rollback -> /mnt/archive/downloads/MAME 0.280 Rollback ROMs
│   ├── roms -> /mnt/archive/roms/MAME/MAME 0.280 ROMs
│   └── samples -> /mnt/archive/downloads/MAME 0.276 EXTRAs/samples
├── No-Intro -> /mnt/archive/roms/No-Intro
└── Redump -> /mnt/archive/roms/Redump
```

---

### 2. `roms-filtered` (~30GB, reduced sets)

This stage filters ROMs down to more manageable sets:

- **Consoles** → 1G1R (1 Game 1 Region)  
- **Arcade (MAME/FBNeo)** → Reduces the roms sets down to top-tier titles only

Tools and DATs used:

1. **BIOS** → DAT from TOSEC BIOS collection  
2. **FBNeo** → [Libretro Arcade DAT](https://github.com/libretro/FBNeo/tree/master/dats)  
3. **MAME** → [Arcade Database](http://adb.arcadeitalia.net) with filters:  
   - MameCab  
   - Latest release  
   - Emulation status: *Working & Imperfect*  
   - Dump status: *Good*  
   - Language: *English*  
   - Best Games: *Very Good (80–90)* + better titles  
4. **No-Intro** → The "PropeR 1G1R Collection" included DATs 
5. **Redump** → [Redump DATs](http://redump.org) 

Example result: MAME reduced from **~50,000 ROMs (~1.2TB)** to **under 500 (~6GB)**. 

Filtering is handled by `filter-raw-roms.sh`, e.g. parsing No-Intro:

```bash
filter_nointro() {
    echo "Filtering No-Intro files..."

    igir copy zip clean test \
        --dat "./dat/proper1g1r-collection.zip" \
        --input "${input_dir}/No-Intro" \
        --output "${output_dir}/No-Intro" \
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
}
```

Example output:

```
roms-filtered
├── BIOS
├── FBNeo-1.0.0.3
│   └── FinalBurn Neo - Arcade Games
├── MAME
│   ├── MAME-0.268
│   ├── MAME-0.280
│   ├── MAME-0.78
│   └── MAME-latest -> MAME-0.280
├── No-Intro
│   ├── Atari - 2600 (Retool)
│   ├── Atari - 5200 (Retool)
│   ├── Atari - 7800 (Retool)
│   ├── Atari - Jaguar (ROM) (Retool)
│   ├── Atari - Lynx (LYX) (Retool)
│   ├── Coleco - ColecoVision (Retool)
│   ├── Mattel - Intellivision (Retool)
│   ├── NEC - PC Engine - TurboGrafx-16 (Retool)
│   ├── Nintendo - Game Boy (Retool)
│   ├── Nintendo - Game Boy Color (Retool)
│   ├── Nintendo - Game Boy Advance (Retool)
│   ├── Nintendo - Nintendo 64 (BigEndian) (Retool)
│   ├── Nintendo - NES (Headered) (Retool)
│   ├── Nintendo - SNES (Retool)
│   ├── Sega - 32X (Retool)
│   ├── Sega - Game Gear (Retool)
│   ├── Sega - Master System - Mark III (Retool)
│   ├── Sega - Genesis (Retool)
│   └── SNK - NeoGeo Pocket Color (Retool)
└── Redump
    ├── Sega - Dreamcast
    ├── Sony - PlayStation
    └── Sony - PlayStation Portable
```

---

### 3. `roms-for-devices` (~25–30GB per device)

Finally, the `roms-filtered` directory is sorted and tailored for each target device.  

I currently use the following devices and front-ends:

1. **Laptop** running [RetroArch](https://www.retroarch.com)  
2. **Raspberry Pi 4** running [Batocera](https://batocera.org)  
3. **Anbernic RG351V** running [AmberElec](https://amberelec.org)  
4. **TRIMUI Brick** running [Knulli](https://knulli.org)  

Each OS uses different emulators and annoyingly slightly different folder names. 

The script `filter-for-devices.sh` handles this by selecting the correct MAME version and structure for each target device:

```bash
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

Output structure:

```
roms-for-devices
├── RetroArch
│   ├── atari2600
│   ├── atari5200
│   ├── atari7800
│   ├── atarijaguar
│   ├── atarilynx
...
├── RG351V
│   ├── atari2600
│   ├── atari5200
│   ├── atari7800
│   ├── atarijaguar
│   ├── atarilynx
...
└── RPi4
    ├── atari2600
    ├── atari5200
    ├── atari7800
    ├── bios
    ├── colecovision
...
```

---

## Summary

- **roms-raw** → Unfiltered collections from external storage  
`filter-raw-roms.sh`
↓
- **roms-filtered** → Reduced using DATs (1G1R, best arcade titles)  
`filter-for-devices.sh`
↓
- **roms-for-devices** → Final device-specific structures, tuned for compatibility  
