#!/bin/bash

CALLSIGN="KC1QBY"
DATADIR="/home/kepler/prop-e2e-pipeline/postgres_data/source_data"
DOCKERDATADIR="/var/lib/postgresql/data/source_data"
DB="prop-e2e"
USER="postgres"

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

#APPEND TO RAW DB
echo "Appending to DB..."
docker exec -i prop-e2e-pipeline-postgres-1 psql -d $DB -U $USER --command="CREATE TEMP TABLE tmp_table ON COMMIT DROP AS SELECT sNR, mode, mhz, rxTime, senderdxcc, flowstartseconds, senderCallsign, senderLocator, receiverCallsign, receiverLocator, receiverAntennaInformation, senderDXCCADIF, submode FROM pskreporter_raw; \
COPY tmp_table \
FROM '$DOCKERDATADIR/$(date +%Y-%m-%d)_psk.csv' \
WITH (FORMAT CSV, HEADER, DELIMITER ','); \
INSERT INTO pskreporter_raw (sNR, mode, mhz, rxTime, senderdxcc, flowstartseconds, senderCallsign, senderLocator, receiverCallsign, receiverLocator, receiverAntennaInformation, senderDXCCADIF, submode) \
SELECT sNR, mode, mhz, rxTime, senderdxcc, flowstartseconds, senderCallsign, senderLocator, receiverCallsign, receiverLocator, receiverAntennaInformation, senderDXCCADIF, submode FROM tmp_table \
ON CONFLICT DO NOTHING;"

