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
Since this is a demo project, data is being ingested via dbt's [seeds](https://docs.getdbt.com/docs/build/seeds) functionality. 

Static data - grid-to-lon-lat
Dynamic data - pskreporter, logbook -- weekly 7d downloads, archive, and replace of seed files & dbt seeds full-refresh

## Tables and Views
**analysis_raw.psk**
**analysis_raw.logbook**
**analysis.stg_psk**
**analysis.stg_logbook**
**analysis.received**
**analysis.received_by**
