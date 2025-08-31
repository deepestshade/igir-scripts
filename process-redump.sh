#!/bin/bash

input_dir="input/Redump"
output_dir="intermediate/Redump"

npx --yes igir@latest copy test \
  --dat "dat/Redump*.zip" \
  --input "${input_dir}/" \
  --output "${output_dir}" \
  --input-checksum-max CRC32 \
  --input-checksum-archives never \
  --dir-dat-name \
  --no-bios \
  --only-retail \
  --single \
  --prefer-language EN \
  --prefer-region USA,WORLD,EUR,JPN \
  --prefer-revision newer
