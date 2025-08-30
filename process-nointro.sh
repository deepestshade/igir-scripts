#!/bin/bash

input_dir="input/roms/No-Intro"
output_dir="intermediate/roms-sorted/No-Intro"
dat_file="dat/proper1g1r-collection.zip"

npx --yes igir@latest copy zip test \
  --dat "${dat_file}" \
  --input "${input_dir}" \
  --output "${output_dir}" \
  --dir-dat-name \
  --no-bios \
  --single \
  --only-retail \
  --filter-region USA,WORLD \
  --prefer-language EN \
  --prefer-region USA,WORLD,EUR \
  --prefer-revision newer \
  --zip-exclude "*.{chd,iso}"
