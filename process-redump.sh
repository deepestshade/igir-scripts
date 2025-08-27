#!/bin/bash

input_dir="input/roms/Redump"
output_dir="output/roms-sorted/Redump"

npx igir@latest copy test \
  --dat "dat/Redump*.zip" \
  --input "${input_dir}/" \
  --output "${output_dir}" \
  --dir-dat-name \
  --no-bios \
  --only-retail \
  --single \
  --prefer-language EN \
  --prefer-region USA,WORLD,EUR,JPN \
  --prefer-revision newer
