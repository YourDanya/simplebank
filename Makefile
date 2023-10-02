postgres:
	docker run --name postgres15 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=pass -d postgres:15

createdb:
	docker exec -it postgres15 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres15 dropdb simple_bank

dbUrl := postgresql://root:pass@172.31.254.53:5432/simple_bank?sslmode=disable

dbUrlCi := postgresql://root:pass@localhost:5432/simple_bank?sslmode=disable

migrateup:
	migrate -path db/migration -database "${dbUrl}" -verbose up 1

migratedown:
	migrate -path db/migration -database "${dbUrl}" -verbose down 1

migrateupci:
	migrate -path db/migration -database "${dbUrlCi}" -verbose up 1

makeFileDir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

sqlc:
	docker run --rm -v $(makeFileDir):/src -w /src sqlc/sqlc generate

test:
	go test -v -cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test