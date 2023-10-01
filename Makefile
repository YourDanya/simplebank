postgres:
	docker run --name postgres15 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=pass -d postgres:15

createdb:
	docker exec -it postgres15 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres15 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:pass@172.31.254.53:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://root:pass@172.31.254.53:5432/simple_bank?sslmode=disable" -verbose down 1

makeFileDir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
sqlc:
	docker run --rm -v $(makeFileDir):/src -w /src sqlc/sqlc generate

test:
	go test -v -cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test