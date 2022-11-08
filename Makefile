all: clean start create-db create-base-tables add-data dbt-seed dbt-run
all-no-load: clean start create-db create-base-tables

clean: 
	@echo "Stopping docker and removing container"
	docker compose stop && docker compose rm

start:
	@echo "Starting docker container"
	docker compose up -d

create-db:
	@echo "Creating databse"
	cat /home/kepler/prop-e2e-pipeline-dbt/sql/create_db.sql | docker exec -i prop-e2e-pipeline-dbt-postgres-1 psql -U postgres

create-base-tables:
	@echo "Creating base tables"
	sleep 2 
	cat /home/kepler/prop-e2e-pipeline-dbt/sql/create_raw.sql | docker exec -i prop-e2e-pipeline-dbt-postgres-1 psql -U postgres -d prop-e2e-dbt

add-data: 
	@echo "Populating existing pskreporter data"
	sudo python3 /home/kepler/prop-e2e-pipeline-dbt/scripts/psk_load_all.py
	
	@echo "Populating existing logbook data"
	sudo python3 /home/kepler/prop-e2e-pipeline-dbt/scripts/logb_load_all.py

dbt-seed:
	@echo "Populating dbt seeds"
	dbt seed --project-dir /home/kepler/prop-e2e-pipeline-dbt/dbt_prop_e2e/ --profiles-dir /home/kepler/prop-e2e-pipeline-dbt/dbt_prop_e2e/profiles

dbt-run:
	@echo "Initializing dbt and running models"
	dbt run --project-dir /home/kepler/prop-e2e-pipeline-dbt/dbt_prop_e2e --profiles-dir /home/kepler/prop-e2e-pipeline-dbt/dbt_prop_e2e/profiles

drop:
	@echo "Dropping tables"
	cat /home/kepler/prop-e2e-pipeline-dbt/sql/drop_all_tables.sql | docker exec -i prop-e2e-pipeline-dbt-postgres-1 psql -U postgres -d prop-e2e-dbt