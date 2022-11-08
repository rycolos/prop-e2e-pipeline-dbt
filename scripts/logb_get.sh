#!/bin/bash

DATADIR="/home/kepler/prop-e2e-pipeline-dbt/source_data"
SCRIPTDIR="/home/kepler/prop-e2e-pipeline-dbt/scripts"
KEY="A02C-3B9A-CCCF-F366"
SDATE=$(date +%Y-%m-%d -d "-7 days")
EDATE=$(date +%Y-%m-%d)

mkdir -p "$DATADIR"

#GET FILE, LAST 7 DAYS
echo "Getting latest data..."
curl "https://logbook.qrz.com/api?key=$KEY&action=fetch&option=BETWEEN:$SDATE+$EDATE,type:adif" \
> "$DATADIR"/$(date +%Y-%m-%d)_logb.adi

#CLEAN WITH SED (replace &lt; and &gt; with < >)
echo "Cleaning data..."
sed -i -e 's/&lt;/</' -e 's/&gt;/>/' "$DATADIR"/$(date +%Y-%m-%d)_logb.adi

#CONVERT TO CSV
python3 "$SCRIPTDIR"/adif_parser_qrz.py "$DATADIR"/$(date +%Y-%m-%d)_logb.adi
mv $SCRIPTDIR/$(date +%Y-%m-%d)_logb.csv $DATADIR
rm "$DATADIR"/$(date +%Y-%m-%d)_logb.adi