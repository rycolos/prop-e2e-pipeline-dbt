# prop-e2e-pipeline-dbt

## Objective
This is an expansion of my [prop-e2e-pipeline project](https://github.com/rycolos/prop-e2e-pipeline), with the addition of [dbt](https://getdbt.com/) for transformation.

As an amateur radio operator, I am frequently experimenting with antennas and new communication modes. I would like to begin quantifying these experiments to analyze how different variables affect my signal propagation. This project serves a dual purpose of assisting in my continued learning about data and analytics engineering. 

## High-level data flow
<img src="https://raw.githubusercontent.com/rycolos/prop-e2e-pipeline-dbt/main/pipeline.png" width="900">

## DAG
<img src="https://i.imgur.com/zQEi61h.png" width="900">

## Dependencies
1. Docker, Docker Compose
2. Python3

## Setup
In my setup, data is being stored locally on a headless home server and maintained via SSH on another local machine.

### Install dbt and initialize
```
pip3 install dbt-core dbt-postgres
mkdir /home/kepler/prop-e2e-pipeline-dbt/dbt_prop_e2e && cd /home/kepler/prop-e2e-pipeline-dbt/dbt_prop_e2e && dbt init
```

### Start postgres and create db
```
docker compose up -d
cat /home/kepler/prop-e2e-pipeline-dbt/sql/create_db.sql | docker exec -i prop-e2e-pipeline-dbt-postgres-1 psql -U postgres

#OR, via Makefile

make clean && make start && make create-db
```

### Install `dbt_utils` package
Refers to packages.yml file in dbt root directory
```
dbt deps
```

### Ingest data to analysis and analysis_raw schemas
Three files are present in the dbt `seeds` directory: `gridsquare_lon_lat.csv`, `raw/psk.csv`, and `raw/logbook.csv`.
```
dbt seed --profiles-dir ./profiles
```

### Run dbt and build models
```
dbt run --profiles-dir ./profiles
```

### Run all tests
Includes custom singular test in `/tests` directory: 'callsign-present'
```
dbt test --profiles-dir ./profiles
```

### Generate and serve documentation
```
dbt docs generate
cd /home/kepler/prop-e2e-pipeline-dbt/dbt_prop_e2e/target && python3 -m http.server
```

### Analysis
Data is being accessed via [pgAdmin](https://www.pgadmin.org) on a local network machine.

## Data Sourcing and Ingestion
Since this is a demo project focused around learning dbt, data is being ingested via dbt's [seeds](https://docs.getdbt.com/docs/build/seeds) functionality and served as static data. [Another version of this project](https://github.com/rycolos/prop-e2e-pipeline) is making use of scheduling and ddl statements in postgres to continually update this dataset.

Data is sourced from three locations for this project:
1. pskreporter.info -- an automated reception recorder for a variety of amateur radio digital communication modes
2. qrz.com -- the primary location of my logbook for all logged radio contacts (aka "QSOs" in radio terminology)
3. a static grid-to-geo lookup table -- rather than lon/lat, amateur radio uses [maidenhead grid locators](https://en.wikipedia.org/wiki/Maidenhead_Locator_System) for succinct location descriptions. To make for easier geographic analysis, I've derived a lookup table converting 4-digit grid locators to lon/lat. 
