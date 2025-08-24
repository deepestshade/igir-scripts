#!/bin/bash

input_dir="./roms/MAME"
output_dir="roms-sorted/MAME"

shopt -s globstar nullglob

batches=(
  "**/[0]*" "**/[1]*" "**/[2]*" "**/[3]*" "**/[4]*" "**/[5]*" "**/[6]*" "**/[7]*" "**/[8]*" "**/[9]*"
  "**/[Aa]*" "**/[Bb]*" "**/[Cc]*" "**/[Dd]*" "**/[Ee]*" "**/[Ff]*" "**/[Gg]*" "**/[Hh]*" "**/[Ii]*"
  "**/[Jj]*" "**/[Kk]*" "**/[Ll]*" "**/[Mm]*" "**/[Nn]*" "**/[Oo]*" "**/[Pp]*" "**/[Qq]*" "**/[Rr]*"
  "**/[Ss]*" "**/[Tt]*" "**/[Uu]*" "**/[Vv]*" "**/[Ww]*" "**/[Xx]*" "**/[Yy]*" "**/[Zz]*"
)

for glob in "${batches[@]}"; do
  echo "Running batch: $glob"

  npx igir@latest copy zip test \
    --dat "dat/MAME 0.279.zip" \
    --input "${input_dir}/${glob}" \
    --output "${output_dir}" \
    --dat-description-regex-exclude "/(Asia|Bootleg|China|Japan|Korea|Prototype)/i" \
    --merge-roms split
done

# rename extensionless files to .chd
find ${output_dir} -mindepth 2 -type f ! -name "*.*" -exec mv "{}" "{}.chd" \;
