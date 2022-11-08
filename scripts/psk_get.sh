#!/bin/bash

CALLSIGN="KC1QBY"
DATADIR="/home/kepler/prop-e2e-pipeline-dbt/source_data"

mkdir -p "$DATADIR"

#GET FILE
echo "Getting latest data..."
wget "https://pskreporter.info/cgi-bin/pskdata.pl?callsign=$CALLSIGN" -O "$DATADIR"/temp.zip
unzip -d "$DATADIR" "$DATADIR"/temp.zip
echo "Renaming file to $(date +%Y-%m-%d)_psk.csv..."
mv "$DATADIR"/psk_data.csv "$DATADIR"/$(date +%Y-%m-%d)_psk.csv
rm "$DATADIR"/temp.zip

#CLEAN WITH SED (remove extra double quotes from antennainfo field)
echo "Cleaning data..."
sed -i  's/\([^,]\)"\([^,]\)/\1\2/g' "$DATADIR"/$(date +%Y-%m-%d)_psk.csv


