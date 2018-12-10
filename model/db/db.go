package db

import (
	"database/sql"
	//blank import
	_ "github.com/lib/pq"
)

// GetBroadcastJSON возвращает  трансляцию с идентификатором id в JSON формате.
func GetBroadcastJSON(id string) string {
	db, err := sql.Open("postgres", connectStr)
	panicIf(err)
	defer db.Close()
	var json string
	err = db.QueryRow("SELECT get_broadcast($1);", id).Scan(&json)
	printIf(err)
	return json
}

// ExequteSQL executes a query defined in sqlText parameter.
func ExequteSQL(sqlText string) error {
	db, err := sql.Open("postgres", connectStr)
	panicIf(err)
	defer db.Close()
	_, err1 := db.Exec(sqlText)
	printIf(err1)
	return err1
}
