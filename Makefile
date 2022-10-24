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
	cat sql/create_raw.sql | docker exec -i prop-e2e-pipeline-postgres-1 psql -U postgres -d prop-e2e
	cat sql/create_staged.sql | docker exec -i prop-e2e-pipeline-postgres-1 psql -U postgres -d prop-e2e

create-views:
	@echo "Creating view tables"
	sleep 2 
	cat sql/create_view_received.sql | docker exec -i prop-e2e-pipeline-postgres-1 psql -U postgres -d prop-e2e
	cat sql/create_view_received_by.sql | docker exec -i prop-e2e-pipeline-postgres-1 psql -U postgres -d prop-e2e

add-data: 
	@echo "Populating existing pskreporter data"
	sudo python3 /home/kepler/prop-e2e-pipeline/psk_load_all.py
	cat /home/kepler/prop-e2e-pipeline/sql/insert_staged_psk.sql | docker exec -i prop-e2e-pipeline-postgres-1 psql -U postgres -d prop-e2e
	python3 /home/kepler/prop-e2e-pipeline/grid_to_latlon.py
	cat /home/kepler/prop-e2e-pipeline/sql/latlon_to_distance.sql | docker exec -i prop-e2e-pipeline-postgres-1 psql -U postgres -d prop-e2e

drop:
	@echo "Dropping tables"
	cat sql/drop_all_tables.sql | docker exec -i prop-e2e-pipeline-postgres-1 psql -U postgres -d prop-e2e