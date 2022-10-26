all: clean start create-base-tables create-views add-data
all-no-load: clean start create-base-tables create-views

clean: 
	@echo "Stopping docker and removing container"
	docker compose stop && docker compose rm

start:
	@echo "Starting docker container"
	docker compose up -d

create-base-tables:
	@echo "Creating base tables"
	sleep 2 
	cat sql/create_raw.sql | docker exec -i prop-e2e-pipeline-postgres-1 psql -U postgres -d prop-e2e-dbt

add-data: 
	@echo "Populating existing pskreporter data"
	sudo python3 /home/kepler/prop-e2e-pipeline-dbt/scripts/psk_load_all.py
	
	@echo "Populating existing logbook data"
	sudo python3 /home/kepler/prop-e2e-pipeline/scripts/logb_load_all.py

drop:
	@echo "Dropping tables"
	cat sql/drop_all_tables.sql | docker exec -i prop-e2e-pipeline-postgres-1 psql -U postgres -d prop-e2e