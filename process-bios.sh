#!/bin/bash

input_dir="./input/BIOS"
output_dir="./intermediate/BIOS"

npx --yes igir@latest copy clean test \
  --dat "https://raw.githubusercontent.com/libretro/libretro-database/master/dat/System.dat" \
  --input "${input_dir}/" \
  --output "${output_dir}" 
