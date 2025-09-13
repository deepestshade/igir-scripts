#!/bin/bash
set -euo pipefail

input_dir="./roms-raw"
output_dir="./roms-filtered" 

igir() {
  npx --yes igir@latest \
    "$@" 
}

filter_bios() {
    echo "Filtering BIOS files..."

    igir copy clean test \
      --dat "https://raw.githubusercontent.com/libretro/libretro-database/master/dat/System.dat" \
      --input "${input_dir}/BIOS" \
      --output "${output_dir}/BIOS"
}

filter_nointro() {
    echo "Filtering No-Intro files..."

    igir copy zip clean test \
        --dat "./dat/proper1g1r-collection.zip" \
        --input "${input_dir}/No-Intro" \
        --output "${output_dir}/No-Intro" \
        --dir-dat-name \
        --input-checksum-max CRC32 \
        --input-checksum-archives never \
        --no-bios \
        --single \
        --only-retail \
        --filter-region USA,WORLD \
        --prefer-language EN \
        --prefer-region USA,WORLD,EUR \
        --prefer-revision newer \
        --zip-exclude "*.{chd,iso}"
}

filter_redump() {
    echo "Filtering Redump files..."

    igir copy clean test \
        --dat "./dat/Redump*.zip" \
        --input "${input_dir}/Redump" \
        --output "${output_dir}/Redump" \
        --input-checksum-max CRC32 \
        --input-checksum-archives never \
        --dir-dat-name \
        --no-bios \
        --only-retail \
        --single \
        --prefer-language EN \
        --prefer-region USA,WORLD,EUR,JPN \
        --prefer-revision newer

}

filter_fbneo() {
    echo "Filtering FBNeo files..." 

    igir copy zip clean test \
        --dat "dat/FBNeo 1.0.0.3*.zip" \
        --dat-name-regex "/arcade/i" \
        --input "${input_dir}/FBNeo-1.0.0.3" \
        --output "${output_dir}/FBNeo-1.0.0.3" \
        --dir-dat-name \
        --input-checksum-max CRC32 \
        --input-checksum-archives never
}           

filter_mame() {
    echo "Filtering MAME files..."

    latest_version="0.280"

    for version in "${latest_version}" "0.268" "0.78"; do
    echo "Filtering MAME version ${version}..."

    igir copy zip clean test \
        --dat "./dat/MAME/MAME-${version}.zip" \
        --input "${input_dir}/MAME/roms" \
        --input "${input_dir}/MAME/rollback" \
        --input "${input_dir}/MAME/chd" \
        --input "${input_dir}/MAME/samples" \
        --output "${output_dir}/MAME/MAME-${version}" \
        --input-checksum-quick \
        --input-checksum-archives never
    done

    ln -sf "MAME-${latest_version}" "${output_dir}/MAME/MAME-latest"

    # rename extension-less files to .chd
    find "${output_dir}/MAME" -mindepth 2 -type f ! -name "*.*" \
    -exec mv "{}" "{}.chd" \;

}

# Check for arguments
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 bios nointro redump fbneo mame ..." 
    exit 1
fi

# Loop over arguments and call the function with the same name
for arg in "$@"; do
    func_name="filter_$arg"
    if declare -f "$func_name" > /dev/null; then
        "$func_name"  # Call the function
    else
        echo "No such function: $func_name"
    fi
done
