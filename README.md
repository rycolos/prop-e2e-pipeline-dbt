# **prop-e2e-pipeline-dbt**

```
#install python requirements
dbt-core, dbt-postgres, pyyaml, psycopg2, pandas

#install packages (dbt_utils)
dbt deps

# seed maidenhead grid to lat/lon lookup table in analysis schema
dbt seed --profiles-dir ./profiles

#documentation generate
dbt docs generate

#documentation serve - dbt docs serve isn't working, likely because I'm running on a headless machine
#navigate to /target dir instead and run:
python3 -m http.server

#run all tests
dbt test --profiles-dir ./profiles

#run
dbt run --full-refresh --profiles-dir ./profiles

```

## Objective
This is an expansion of my [prop-e2e-pipeline project](https://github.com/rycolos/prop-e2e-pipeline), with the addition of [dbt](https://getdbt.com/) for transformation.

As an amateur radio operator, I am frequently experimenting with antennas and new communication modes. I would like to begin quantifying these experiments to analyze how different variables affect my signal propagation. This project serves a dual purpose of assisting in my continued learning about data and analytics engineering. 

## High-level data flow
<img src="https://i.imgur.com/RBmN2Y7.png" width="800">

## Tooling
1. PostgreSQL
2. Docker, Docker Compose
3. Python 3
4. Grafana, Prometheus

## Setup
### Run `make all`
Runs all key tasks to build postgres container, create tabes and views, ingest initial dataset, and perform transformation.
1. `clean` - Stops docker compose (if running) and removes containers
2. `start` - Starts docker compose and brings up containers
3. `create-base-tables` - Creates initial `pskreporter_raw` and `pskreporter_staged` tables
4. `create-views` - Create analytics-ready views on `pskreporter_staged`
5. `add-data` - Loads existing data from `postgres_data/psk_data` folder into `pskreporter_raw`, transforms and inserts into `pskreporter_staged`, performs a function to convert grid square > lat/lon and inserts into `pskreporter_staged`, and performs a function to calculate station-to-station distance and inserts into `pskreporter_staged`
6. `drop` - Delete all tables 

Run `make all-no-load` to run all tasks except `add-data`

## Maintenance
### Automated pskreporter data ingest and transformation
Add tasks for the following to the root crontab:
1. Pull 7d data dump daily from pskreporter, perform basic cleaning, and append to `pskreporter_raw`
2. Perform a daily INSERT of `pskreporter_raw` into `pskreporter_staged`
3. Run a daily function to convert maidenhead grid square (`sender_locator` and `receiver_locator`) to lat/lon on `pskreporter_staged`
4. Run a daily function to calculate station-to-station distance on `pskreporter_staged`
```
0 4 * * *  printf "$(date)\n********************\n" >> /home/kepler/prop-e2e-pipeline/cronlog.log 2>&1
0 4 * * * sh /home/kepler/prop-e2e-pipeline/scripts/psk_get_docker.sh >> /home/kepler/prop-e2e-pipeline/cronlog.log 2>&1
30 4 * * * cat /home/kepler/prop-e2e-pipeline/sql/insert_staged_psk.sql | docker exec -i prop-e2e-pipeline-postgres-1 psql -U postgres -d prop-e2e >> /home/kepler/prop-e2e-pipeline/cronlog.log 2>&1
0 5 * * * python3 /home/kepler/prop-e2e-pipeline/scripts/grid_to_latlon.py >> /home/kepler/prop-e2e-pipeline/cronlog.log 2>&1
30 5 * * * cat /home/kepler/prop-e2e-pipeline/sql/latlon_to_distance.sql | docker exec -i prop-e2e-pipeline-postgres-1 psql -U postgres -d prop-e2e >> /home/kepler/prop-e2e-pipeline/cronlog.log 2>&1
```

### Manual logbook data ingest and transformation
Logbook data is not available to be automatically retrieved and ingested. It requires a recurring manual process. On some cadence, the following tasks are required:
1. Export logbook in ADIF format from qrz.com
2. Convert ADIF fil to CSV with `adif_parser_qrz.py`
3. Append logbook csv to `logbook_raw` table and copy records to `logbook_staged` table with `logb_get_docker.sh`

## Tables

**pskreporter_raw**

Raw daily dump from https://pskreporter.info, filtered for my callsign (`KC1QBY`). Mild cleaning using `sed` is performed prior to ingestion to remove any interjected double-quotes from the free-text `receiverAntennaInformation` column.

**pskreporter_staged**

Pre-analysis table with data types updated, irrelevant columns removed, columns renamed for clarity, and an auto-incrementing `id` column added. Three derived data colums are added: (1) sender/receiver latitude and (2) sender/receiver longitude are populated via a daily python scripts that convert maidenhead grid locator to lat/lon and (3) station-to-station distance is populated via a daily sql script.

**received**

Filtered view on `pskreporter_staged` to only show signals received at my station.

**received_by**

Filtered view on `pskreporter_staged` to only show signals of mine that have been received by other stations.

**logbook_raw**

**logbook_staged**

## Example Analysis Queries

**Median signal-to-noise ratio**
```
SELECT PERCENTILE_CONT(.5) WITHIN GROUP(ORDER BY snr) FROM received
SELECT PERCENTILE_CONT(.5) WITHIN GROUP(ORDER BY snr) FROM received_by
```

**Mapping of received_by stations**
```
SELECT receiver_lat as lat, receiver_lon as lon FROM received_by
```
Visualized with plotly and pandas:
<img src="https://i.imgur.com/z8cbSwe.png">
