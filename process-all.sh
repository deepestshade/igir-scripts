#!/bin/bash

echo "BIOS..."
./process-bios.sh
echo "No-Intro..."
./process-nointro.sh
echo "Redump..."        
./process-redump.sh
echo "FBNeo..."
./process-fbneo.sh
echo "MAME..."
./process-mame.sh
