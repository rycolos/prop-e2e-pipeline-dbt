# prop-e2e-pipeline-dbt

## Objective
This is an expansion of my [prop-e2e-pipeline project](https://github.com/rycolos/prop-e2e-pipeline), with the addition of [dbt](https://getdbt.com/) for transformation.

As an amateur radio operator (KC1QBY, you'll me me mostly on 20m-10m on FT8 and JS8Call), I am frequently experimenting with antennas and new communication modes. I would like to begin quantifying these experiments to analyze how different variables affect my signal propagation. This project serves a dual purpose of assisting in my continued learning about data and analytics engineering. 

## High-level data flow
<img src="https://raw.githubusercontent.com/rycolos/prop-e2e-pipeline-dbt/main/pipeline.png" width="900">

## Modeling
<img src="https://i.imgur.com/zQEi61h.png" width="900">

**Data is sourced from two primary sources:**

1. pskreporter.info -- an automated reception recorder for a variety of amateur radio digital communication modes, filtered for reception reports related to my callsign
2. qrz.com -- the primary location of my logbook for all logged radio contacts


There is an important distinction between these sources. Pskreporter provides information about stations that I have received and that have received me. "Receiving" is different than a true contact, which are accounted for in the qrz dataset -- my logbook. A contact (aka QSO in radio terminology) requires not just reception, but an exchange. This can be a long conversation via voice or keyboard or as simple as a back-and-forth exchange of signal quality and location.

Capturing data from both of these sources is important, as it's far easier to receive/be received by the vagaries of atmospheric conditions than to make a true contact. With psk data, I can see where my signal is going and what I'm receiving, but this doesn't adequately capture the true performance of my station that's required for a back-and-forth exchange. 

A third source is also present -- a static grid-to-geo lookup table. Rather than lon/lat, amateur radio uses [maidenhead grid locators](https://en.wikipedia.org/wiki/Maidenhead_Locator_System) for succinct location descriptions. To make for easier geographic analysis, I've derived a lookup table converting 4-digit grid locators to lon/lat (see scripts/gridsquare_table_gen.py). 

**Data is modeled as follows:**

Raw psk and logbook data is transformed to staged versions of these tables, with type casting, improved column names, the addition of consistent datetime styling, and the addition of surrogate primary keys. These are then inherited by various analysis-ready data mart tables.

Dimensional modeling is employed to denormalize the staged psk and logbook tables. The contact/reception events themselves are stored in their relevant `fact_` tables while station information (callsign, location, additional information) is stored in a `dim_station table`, which unions station information from both psk and logbook sources and adds a lookup column that converts Maidenhead grid square to lon/lat. Dimension tables are then joined in a table that shows only true contacts (from my logbook) with added columns for psk-related details, like signal-to-noise ratio.  

Additionally, analysis-ready tables are present that filter psk data into stations received at my station (`psk_received`) and stations who have received me (`psk_received_by`).

Full table documentation is available in dbt docs.

## Requirements
1. Docker Compose
2. Python3
3. dbt-core, dbt-postgres

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

### Ingest seed data to analysis and analysis_raw schemas
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

Scripts to retreive and process this data are available in the `scripts` directory. 
