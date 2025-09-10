#!/bin/bash

echo "Filtering BIOS..."
./filter-bios.sh
echo "Filtering No-Intro..."
./filter-nointro.sh
echo "Filtering Redump..."
./filter-redump.sh
echo "Filtering FBNeo..."
./filter-fbneo.sh
echo "Filtering MAME..."
./filter-mame.sh
