#!/bin/bash

input_dir="input/FBNeo"
output_dir="intermediate/FBNeo"

npx --yes igir@latest copy zip test \
  --dat "dat/FBNeo*.zip" \
  --input "${input_dir}/" \
  --output "${output_dir}" \
  --dir-dat-name \
  --input-checksum-max CRC32 \
  --input-checksum-archives never \
  --no-bios \
  --only-retail \
  --single \
  --prefer-language EN \
  --prefer-region USA,WORLD,EUR,JPN \
  --prefer-revision newer
