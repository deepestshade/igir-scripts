#!/bin/bash

input_dir="input/roms/MAME"
output_dir="intermediate/roms-sorted/MAME"

shopt -s globstar nullglob

batches=(
  "**/[0-3]*"   # 0–3
  "**/[4-6]*"   # 4–6
  "**/[7-9]*"   # 7–9
  "**/[A-Ca-c]*" # A–C
  "**/[D-Fd-f]*" # D–F
  "**/[G-Ig-i]*" # G–I
  "**/[J-Lj-l]*" # J–L
  "**/[M-Pm-p]*" # M–P
  "**/[Q-Tq-t]*" # Q–T
  "**/[U-Zu-z]*" # U–Z
)

for glob in "${batches[@]}"; do
  echo "Running batch: $glob"

  npx --yes igir@latest copy zip test \
    --dat "dat/MAME 0.279.zip" \
    --input "${input_dir}/${glob}" \
    --output "${output_dir}" \
    --merge-roms split \
    --temp-dir ".igir_tmp"
done

# rename extensionless files to .chd
find ${output_dir} -mindepth 2 -type f ! -name "*.*" -exec mv "{}" "{}.chd" \;
