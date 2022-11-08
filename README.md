# prop-e2e-pipeline-dbt

## Objective
This is an expansion of my [prop-e2e-pipeline project](https://github.com/rycolos/prop-e2e-pipeline), with the addition of [dbt](https://getdbt.com/) for transformation.

As an amateur radio operator, I am frequently experimenting with antennas and new communication modes. I would like to begin quantifying these experiments to analyze how different variables affect my signal propagation. This project serves a dual purpose of assisting in my continued learning about data and analytics engineering. 

## High-level data flow
<img src="https://i.imgur.com/RBmN2Y7.png" width="800">

## Tooling
1. PostgreSQL
2. Docker, Docker Compose
3. Python3
4. dbt

## Setup
```
#install docker, docker compose, python3

#install dbt
pip3 install dbt-core
pip3 install dbt-postgres
cd /home/kepler/prop-e2e-pipeline-dbt && dbt init

#start postgres and create database, if necessary (aka make clean && make start && make create-db
docker compose up -d
cat /home/kepler/prop-e2e-pipeline-dbt/sql/create_db.sql | docker exec -i prop-e2e-pipeline-dbt-postgres-1 psql -U postgres

#install packages (dbt_utils); Refers to packages.yml file in dbt root directory
dbt deps

#ingest data to analysis and analysis_raw schemas
dbt seed --profiles-dir ./profiles

#run all tests
dbt test --profiles-dir ./profiles

#run
dbt run --full-refresh --profiles-dir ./profiles

#documentation generate
dbt docs generate

#documentation serve - dbt docs serve isn't working, likely because I'm running on a headless machine
#navigate to /target dir instead and run:
python3 -m http.server

```

## Data Sourcing and Ingestion
Since this is a demo project focused around learning dbt, data is being ingested via dbt's [seeds](https://docs.getdbt.com/docs/build/seeds) functionality and served as static data. [Another version of this project](https://github.com/rycolos/prop-e2e-pipeline) is making use of scheduling and ddl statements in postgres to continually update this dataset.

Data is sourced from three locations for this project:
1. pskreporter.info -- an automated reception recorder for a variety of amateur radio digital communication modes
2. qrz.com -- the primary location of my logbook for all logged radio contacts (aka "QSOs" in radio terminology)
3. a static grid-to-geo lookup table -- rather than lon/lat, amateur radio uses [maidenhead grid locators](https://en.wikipedia.org/wiki/Maidenhead_Locator_System) for succinct location descriptions. To make for easier geographic analysis, I've derived a lookup table converting 4-digit grid locators to lon/lat. 

## Tables and Views
**analysis_raw.psk**

**analysis_raw.logbook**

**analysis.stg_psk**

**analysis.stg_logbook**

**analysis.received**

**analysis.received_by**
