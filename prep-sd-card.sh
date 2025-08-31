#!/bin/bash

input_dir="intermediate/roms-sorted"
output_dir="output/EmulationStation"

igir() {
  npx --yes igir@latest \
    "$@" \
    --input-checksum-max CRC32 \
    --input-checksum-archives never
}

mkdir -p "${output_dir}"

echo "Copying BIOS files..."
igir copy extract test \
  --dat "https://raw.githubusercontent.com/libretro/libretro-database/master/dat/System.dat" \
  --input  "${input_dir}/BIOS" \
  --output "${output_dir}/bios"

echo "Copying No-Intro roms..."
igir copy zip test \
  --dat "dat/proper1g1r-collection.zip" \
  --input  "${input_dir}/No-Intro" \
  --output "${output_dir}/{es}"

echo "Copying Redump roms..."
igir copy test \
  --dat "dat/Redump*.zip" \
  --input "${input_dir}/Redump" \
  --output "${output_dir}/{es}" \
  --disable-cache

echo "Copying FBNeo roms..."
igir copy zip test \
  --dat "dat/FBNeo*.zip" \
  --input  "${input_dir}/FBNeo" \
  --output "${output_dir}/fbneo"

echo "Copying MAME roms..."
igir copy zip test \
  --dat "dat/MAME 0.279.zip" \
  --input  "${input_dir}/MAME" \
  --output "${output_dir}/mame" \
  --temp-dir ".igir_tmp"

# Rename CHD files that lack extensions
find "${output_dir}/mame" -mindepth 2 -type f ! -name "*.*" \
  -exec mv "{}" "{}.chd" \;

