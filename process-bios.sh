#!/bin/bash

input_dir="input/roms/BIOS"
output_dir="output/roms-sorted/BIOS"

npx igir@latest copy extract test \
  --dat "https://raw.githubusercontent.com/libretro/libretro-database/master/dat/System.dat" \
  --input "${input_dir}/" \
  --output "${output_dir}"
