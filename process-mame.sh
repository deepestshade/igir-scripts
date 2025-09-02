#!/bin/bash

input_dir="./input"
output_dir="./intermediate" 
current_version="0.280"

# MAME latest
npx --yes igir@latest copy zip clean test \
  --dat "./dat/MAME ${current_version}.zip" \
  --input "${input_dir}/MAME" \
  --output "${output_dir}/MAME-${current_version}" \
  --input-checksum-quick \
  --input-checksum-archives never \
  --merge-roms split

# rename extensionless files to .chd
find "${output_dir}/MAME" -mindepth 2 -type f ! -name "*.*" -exec mv "{}" "{}.chd" \;

# # MAME-2003-Plus
npx --yes igir@latest copy zip clean test \
  --dat "./dat/MAME 0.78.zip" \
  --input "${input_dir}/MAME-2003-Plus" \
  --output "${output_dir}/MAME-2003-Plus" \
  --input-checksum-quick \
  --input-checksum-archives never \
  --merge-roms split

find "${output_dir}/MAME-2003-Plus" -mindepth 2 -type f ! -name "*.*" -exec mv "{}" "{}.chd" \;
