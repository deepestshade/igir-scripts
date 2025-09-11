#!/bin/bash

input_dir="./roms-raw"
output_dir="./roms-filtered" 
latest_version="0.280"

for version in "${latest_version}" "0.268" "0.78"; do
  echo "Filtering MAME version ${version}..."
  
  npx --yes igir@latest copy zip clean test \
    --dat "./dat/MAME/MAME-${version}.zip" \
    --input "${input_dir}/MAME/roms" \
    --input "${input_dir}/MAME/rollback" \
    --input "${input_dir}/MAME/chd" \
    --input "${input_dir}/MAME/samples" \
    --output "${output_dir}/MAME/MAME-${version}" \
    --input-checksum-quick \
    --input-checksum-archives never
done

ln -sf "MAME-${latest_version}" "./roms-filtered/MAME/MAME-latest"

# rename extensionless files to .chd
find "${output_dir}/MAME" -mindepth 2 -type f ! -name "*.*" \
  -exec mv "{}" "{}.chd" \;
