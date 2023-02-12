## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'
	
.PHONEY: confirm
confirm:
	@echo -n 'Are you sure? [y/N]' && read ans && [ $${ans:-N} = y ]
	
## run/api: run the cmd/api application
.PHONEY: run/api
run/api:
	go run ./cmd/api

## db/psql: connect ot the database using psql
.PHONEY: db/psql
db/psql:
	psql ${GREENLIGHT_DB_DSN}

## db/migrations/new name $1; create a new database migration
.PHONEY: db/migrations/new
db/migrations/new:
	@echo 'Creating migration files for ${name}...'
	migrate create -seq -ext=.sql -dir=./migrations ${name}

## db/migraions/up: apply for up-database migrations
.PHONEY: db/migrations/up
db/migrations/up: confirm
	@echo 'Running up migrations...'
	migrate -path ./migrations/ -database ${GREENLIGHT_DB_DSN} up
