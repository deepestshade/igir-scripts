#!/bin/bash

set -euo pipefail

target="$1"
dat_dir="./dat"
input_dir="./intermediate"
output_dir="./output"

# Validate target argument
if [[ -z "$target" ]]; then
    echo "Error: Target not specified"
    echo "Usage: $0 <target>"
    echo "Available targets: brick, retroarch, rg351v, rpi4"
    exit 1
fi

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

echo "Preparing ROMs for target: $target"
echo "Output directory: $output_dir"

igir() {
  npx --yes igir@latest \
    "$@" \
    --input-checksum-max CRC32 \
    --input-checksum-archives never
}

mkdir -p "${output_dir}"

echo "Copying BIOS files..."
igir copy extract clean test \
  --dat "https://raw.githubusercontent.com/libretro/libretro-database/master/dat/System.dat" \
  --input  "${input_dir}/BIOS" \
  --output "${output_dir}/${device}/bios"

echo "Copying No-Intro roms..."
igir copy zip clean test \
  --dat "${dat_dir}/proper1g1r-collection.zip" \
  --input  "${input_dir}/No-Intro" \
  --output "${output_dir}/${device}/${path_token}"

echo "Copying Redump roms..."
igir copy clean test \
  --dat "${dat_dir}/Redump*.zip" \
  --input "${input_dir}/Redump" \
  --output "${output_dir}/${device}/${path_token}"

echo "Copying FBNeo roms..."
igir copy zip clean test \
  --dat "${dat_dir}/FBNeo 1.0.0.3*.zip" \
  --dat-name-regex "/arcade/i" \
  --input  "${input_dir}/FBNeo-1.0.0.3" \
  --output "${output_dir}/${device}/fbneo"

echo "Copying MAME roms..."
igir copy zip clean test \
  --dat "${dat_dir}/MAME ${mame_version}.zip" \
  --input "${input_dir}/MAME-latest" \
  --input "${input_dir}/MAME-rollback" \
  --output "${output_dir}/${device}/mame"

# Rename CHD files that lack extensions
find "${output_dir}/${device}/mame" -mindepth 2 -type f ! -name "*.*" \
  -exec mv "{}" "{}.chd" \;

echo "ROM preparation complete for $target!"