# **prop-e2e-pipeline-dbt**

## Objective
This is an expansion of my [prop-e2e-pipeline project](https://github.com/rycolos/prop-e2e-pipeline), with the addition of [dbt](https://getdbt.com/) for transformation.

As an amateur radio operator, I am frequently experimenting with antennas and new communication modes. I would like to begin quantifying these experiments to analyze how different variables affect my signal propagation. This project serves a dual purpose of assisting in my continued learning about data and analytics engineering. 

## High-level data flow
<img src="https://i.imgur.com/RBmN2Y7.png" width="800">

## Tooling
1. PostgreSQL
2. Docker, Docker Compose
3. Python 3
4. dbt

## Setup
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

## Data Sourcing and Ingestion

## Tables and Views

**analysis_raw.psk**

Raw daily dump from https://pskreporter.info, filtered for my callsign (`KC1QBY`). Mild cleaning using `sed` is performed prior to ingestion to remove any interjected double-quotes from the free-text `receiverAntennaInformation` column.

**analysis_raw.logbook**

**analysis.stg_psk**

Pre-analysis table with data types updated, irrelevant columns removed, columns renamed for clarity, and an auto-incrementing `id` column added. Three derived data colums are added: (1) sender/receiver latitude and (2) sender/receiver longitude are populated via a daily python scripts that convert maidenhead grid locator to lat/lon and (3) station-to-station distance is populated via a daily sql script.

**analysis.stg_logbook**

**analysis.received**

Filtered view on `pskreporter_staged` to only show signals received at my station.

**analysis.received_by**

Filtered view on `pskreporter_staged` to only show signals of mine that have been received by other stations.

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
