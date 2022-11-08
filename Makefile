all: clean start create-db dbt-seed dbt-run
remove: drop clean

clean: 
	@echo "Stopping docker and removing container"
	docker compose stop && docker compose rm

start:
	@echo "Starting docker container"
	docker compose up -d

create-db:
	@echo "Creating database"
	cat /home/kepler/prop-e2e-pipeline-dbt/sql/create_db.sql | docker exec -i prop-e2e-pipeline-dbt-postgres-1 psql -U postgres

dbt-seed:
	@echo "Populating dbt seeds"
	dbt seed --project-dir /home/kepler/prop-e2e-pipeline-dbt/dbt_prop_e2e/ --profiles-dir /home/kepler/prop-e2e-pipeline-dbt/dbt_prop_e2e/profiles

dbt-run:
	@echo "Initializing dbt and running models"
	dbt run --project-dir /home/kepler/prop-e2e-pipeline-dbt/dbt_prop_e2e --profiles-dir /home/kepler/prop-e2e-pipeline-dbt/dbt_prop_e2e/profiles

drop:
	@echo "Dropping all tables"
	cat /home/kepler/prop-e2e-pipeline-dbt/sql/drop_all_tables.sql | docker exec -i prop-e2e-pipeline-dbt-postgres-1 psql -U postgres -d prop-e2e-dbt