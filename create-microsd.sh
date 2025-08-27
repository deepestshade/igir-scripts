#!/bin/bash

input_dir="input/roms-sorted"
output_dir="output/microsd"

igir() {
  npx --yes igir@latest "$@"
}

echo "Copying BIOS files..."
igir copy extract test \
  --input-checksum-quick \
  --dat "https://raw.githubusercontent.com/libretro/libretro-database/master/dat/System.dat" \
  --input  "${input_dir}/BIOS" \
  --output "${output_dir}/bios"

echo "Copying No-Intro files..."
igir copy zip test \
  --input-checksum-quick \
  --dat "dat/No-Intro (Reduced Set).zip" \
  --input  "${input_dir}/No-Intro" \
  --output "${output_dir}/{es}"

echo "Copying Redump files..."
igir copy test \
  --input-checksum-quick \
  --dat "dat/Redump*.zip" \
  --input  "${input_dir}/Redump" \
  --output "${output_dir}/{es}"

echo "Copying MAME files..."
igir copy zip test \
  --input-checksum-quick \
  --dat "dat/MAME 0.279.zip" \
  --input  "${input_dir}/MAME" \
  --output "${output_dir}/mame"

# Rename CHD files that lack extensions
find "${output_dir}/mame" -mindepth 2 -type f ! -name "*.*" \
  -exec mv "{}" "{}.chd" \;

echo "Copying FBNeo files..."
igir copy zip test \
  --input-checksum-quick \
  --dat "dat/FBNeo*.zip" \
  --input  "${input_dir}/FBNeo" \
  --output "${output_dir}/fbneo"

