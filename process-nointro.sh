#!/bin/bash

input_dir="input/roms/No-Intro"
output_dir="output/roms-sorted/No-Intro"
dat_file="dat/No-Intro (Reduced Set).zip"

# Array of batch glob patterns
batches=(
  "**/[0-9A-Fa-f]*"
  "**/[G-Lg-l]*"
  "**/[M-Rm-r]*"
  "**/[S-Zs-z]*"
)

for glob in "${batches[@]}"; do
  echo "Running batch: $glob"

  npx igir@latest copy zip test \
    --dat "$dat_file" \
    --input "${input_dir}/${glob}" \
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
done
