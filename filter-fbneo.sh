#!/bin/bash

input_dir="./roms-raw/FBNeo-1.0.0.3"
output_dir="./roms-filtered/FBNeo-1.0.0.3"

npx --yes igir@latest copy zip clean test \
  --dat "dat/FBNeo 1.0.0.3*.zip" \
  --dat-name-regex "/arcade/i" \
  --input "${input_dir}/" \
  --output "${output_dir}" \
  --dir-dat-name \
  --input-checksum-max CRC32 \
  --input-checksum-archives never
