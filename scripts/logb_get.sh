#!/bin/bash

DATADIR="/home/kepler/prop-e2e-pipeline-dbt/postgres_data/source_data"
DOCKERDATADIR="/var/lib/postgresql/data/source_data"
SQLDIR="/home/kepler/prop-e2e-pipeline-dbt/sql"
SCRIPTDIR="/home/kepler/prop-e2e-pipeline-dbt/scripts"
DB="prop-e2e"
USER="postgres"
KEY="A02C-3B9A-CCCF-F366"
SDATE=$(date +%Y-%m-%d -d "-7 days")
EDATE=$(date +%Y-%m-%d)
TABLENAME="raw.logbook"

mkdir -p "$DATADIR"

#GET FILE, LAST 7 DAYS
echo "Getting latest data..."
curl "https://logbook.qrz.com/api?key=$KEY&action=fetch&option=BETWEEN:$SDATE+$EDATE,type:adif" \
> "$DATADIR"/$(date +%Y-%m-%d)_logb.adi

#CLEAN WITH SED (replace &lt; and &gt; with < >)
echo "Cleaning data..."
sed -i -e 's/&lt;/</' -e 's/&gt;/>/' "$DATADIR"/$(date +%Y-%m-%d)_logb.adi

#CONVERT TO CSV
python3 "$SCRIPTDIR"/adif_parser/adif_parser_qrz.py "$DATADIR"/$(date +%Y-%m-%d)_logb.adi
mv $SCRIPTDIR/adif_parser/$(date +%Y-%m-%d)_logb.csv $DATADIR

# #APPEND TO RAW DB
echo "Appending to logbook_raw table..."
docker exec -i prop-e2e-pipeline-postgres-1 psql -d $DB -U $USER --command="CREATE TEMP TABLE tmp_log_table ON COMMIT DROP AS SELECT \
app_qrzlog_logid, call, country, frequency, gridsquare, mode, \
my_country, my_gridsquare, qrzcom_qso_upload_date, qso_date, \
rst_rcvd, rst_sent, station_callsign, time_off, tx_pwr \
FROM $TABLENAME; \
COPY tmp_log_table \
FROM '$DOCKERDATADIR/$(date +%Y-%m-%d)_logb.csv' \
WITH (FORMAT CSV, HEADER, DELIMITER ','); \

INSERT INTO $TABLENAME ( \
app_qrzlog_logid, call, country, frequency, gridsquare, mode, \
my_country, my_gridsquare, qrzcom_qso_upload_date, qso_date, rst_rcvd, \
rst_sent, station_callsign, time_off, tx_pwr ) \

SELECT app_qrzlog_logid, call, country, frequency, gridsquare, mode, \
my_country, my_gridsquare, qrzcom_qso_upload_date, qso_date, rst_rcvd, \
rst_sent, station_callsign, time_off, tx_pwr \
FROM tmp_log_table \
ON CONFLICT DO NOTHING;"