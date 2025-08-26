#!/bin/bash

input_dir="roms/FBNeo"
output_dir="roms-sorted/FBNeo"

npx igir@latest copy zip test \
  --dat "dat/FBNeo*.zip" \
  --input "${input_dir}/" \
  --output "${output_dir}" \
  --dir-dat-name \
  --no-bios \
  --only-retail \
  --single \
  --prefer-language EN \
  --prefer-region USA,WORLD,EUR,JPN \
  --prefer-revision newer
