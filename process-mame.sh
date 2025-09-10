#!/bin/bash

input_dir="./input"
output_dir="./intermediate" 
current_version="0.280"

npx --yes igir@latest copy zip clean test \
  --dat "./dat/MAME/MAME-latest.zip" \
  --input "${input_dir}/MAME/roms" \
  --input "${input_dir}/MAME/chd" \
  --input "${input_dir}/MAME/samples" \
  --output "${output_dir}/MAME-${current_version}" \
  --input-checksum-quick \
  --input-checksum-archives never

# rename extensionless files to .chd
find "${output_dir}/MAME-${current_version}" -mindepth 2 -type f ! -name "*.*" \
  -exec mv "{}" "{}.chd" \;
