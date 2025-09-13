#!/bin/bash
set -euo pipefail

input_dir="./roms-raw"
output_dir="./roms-filtered"

igir() {
    npx --yes igir@latest "$@"
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

    ln -sfn "MAME-${latest_version}" "${output_dir}/MAME/MAME-latest"

    # Rename extension-less files to .chd safely
    find "${output_dir}/MAME" -mindepth 2 -type f ! -name "*.*" \
        -exec mv "{}" "{}.chd" \;
}

# Parse arguments and call corresponding functions  
if [ "$#" -eq 0 ]; then
    echo "Error: No targets specified"
    echo "Usage: $0 <target1> [target2 ...]"
    echo "Available targets: bios, nointro, redump, fbneo, mame"
    exit 1
fi

for arg in "$@"; do
    func_name="filter_$arg"
    if declare -f "$func_name" > /dev/null; then
        "$func_name"
    else
        echo "No such function: $func_name"
    fi
done
