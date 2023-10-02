package db

import (
	"database/sql"
	"github.com/YourDanya/simplebank/util"
	_ "github.com/lib/pq"
	"log"
	"os"
	"testing"
)

const (
	dbDriver = "postgres"
	dbSource = "postgresql://root:pass@172.31.254.53:5432/simple_bank?sslmode=disable"
)

var testQueries *Queries
var testDB *sql.DB

func TestMain(m *testing.M) {
	config, err := util.LoadConfig("../..")

	if err != nil {
		log.Fatal("cannot log config:", err)
	}

	testDB, err = sql.Open(config.DBDriver, config.DBSource)

	if err != nil {
		log.Fatal("cannot connect to the db:", err)
	}

	err = testDB.Ping()

	if err != nil {
		log.Fatal("ping failed:", err)
	}

	log.Println("testDB", testDB)
	log.Println("err", err)

	testQueries = New(testDB)

	os.Exit(m.Run())
}
