#!/bin/bash

DATADIR="/home/kepler/prop-e2e-pipeline/postgres_data/source_data"
DOCKERDATADIR="/var/lib/postgresql/data/source_data"
SQLDIR="/home/kepler/prop-e2e-pipeline/sql"
DB="prop-e2e"
USER="postgres"
FILE=$1

#PASS CSV FILE IN AS ARG
if [ $# -eq 0 ]; then
    echo "Please provide filename of .csv stored in $DATADIR"
    exit 1
fi

mkdir -p "$DATADIR"

#APPEND TO RAW DB
echo "Appending to logbook_raw table..."
docker exec -i prop-e2e-pipeline-postgres-1 psql -d $DB -U $USER --command="CREATE TEMP TABLE tmp_log_table ON COMMIT DROP AS SELECT \
app_qrzlog_logid, call, country, frequency, gridsquare, mode, \
my_country, my_gridsquare, qrzcom_qso_upload_date, qso_date, \
rst_rcvd, rst_sent, station_callsign, time_off, tx_pwr \
FROM logbook_raw; \
COPY tmp_log_table \
FROM '$DOCKERDATADIR/$FILE' \
WITH (FORMAT CSV, HEADER, DELIMITER ','); \

INSERT INTO logbook_raw ( \
app_qrzlog_logid, call, country, frequency, gridsquare, mode, \
my_country, my_gridsquare, qrzcom_qso_upload_date, qso_date, rst_rcvd, \
rst_sent, station_callsign, time_off, tx_pwr ) \

SELECT app_qrzlog_logid, call, country, frequency, gridsquare, mode, \
my_country, my_gridsquare, qrzcom_qso_upload_date, qso_date, rst_rcvd, \
rst_sent, station_callsign, time_off, tx_pwr \
FROM tmp_log_table \
ON CONFLICT DO NOTHING;"

#UPDATE logbook_staged
echo "Updating logbook_staged table..."
sleep 2
cat $SQLDIR/update_staged_logb.sql | docker exec -i prop-e2e-pipeline-postgres-1 psql -d $DB -U $USER 
