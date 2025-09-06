#!/bin/bash

set -euo pipefail

target="$1"
input_dir="./intermediate"

# Validate target argument
if [[ -z "$target" ]]; then
    echo "Error: Target not specified"
    echo "Usage: $0 <target>"
    echo "Available targets: retroarch, rg351v, brick"
    exit 1
fi

# Set target-specific configuration
case "$target" in
    "retroarch")
        mame_dat="./dat/MAME 0.280.zip"
        mame_input="${input_dir}/MAME-latest"
        output_dir="./output/RetroArch"
        path_token="{es}"
        ;;
    "rg351v")
        mame_dat="./dat/MAME 0.78.zip"
        mame_input="${input_dir}/MAME-2003-Plus"
        output_dir="./output/RG351V"
        path_token="{es}"
        ;;
   "brick")
        mame_dat="./dat/MAME 0.78.zip"
        mame_input="${input_dir}/MAME-2003-Plus"
        output_dir="./output/Brick"
        path_token="{batocera}"
        ;;
    *)
        echo "Error: Unknown target '$target'"
        echo "Available targets: retroarch, rg351v, brick"
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
  --output "${output_dir}/bios"

echo "Copying No-Intro roms..."
igir copy zip clean test \
  --dat "./dat/proper1g1r-collection.zip" \
  --input  "${input_dir}/No-Intro" \
  --output "${output_dir}/${path_token}"

echo "Copying Redump roms..."
igir copy clean test \
  --dat "./dat/Redump*.zip" \
  --input "${input_dir}/Redump" \
  --output "${output_dir}/${path_token}"

echo "Copying FBNeo roms..."
igir copy zip clean test \
  --dat "./dat/FBNeo 1.0.0.3*.zip" \
  --dat-name-regex "/arcade/i" \
  --input  "${input_dir}/FBNeo-1.0.0.3" \
  --output "${output_dir}/fbneo"

echo "Copying MAME roms..."
igir copy zip clean test \
  --dat "$mame_dat" \
  --input  "$mame_input" \
  --output "${output_dir}/mame" \
  --temp-dir ./igir_tmp # Don't let CHD files exhaust tmpfs

# Rename CHD files that lack extensions
find "${output_dir}/mame" -mindepth 2 -type f ! -name "*.*" \
  -exec mv "{}" "{}.chd" \;

echo "ROM preparation complete for $target!"