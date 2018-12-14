package db

import (
	"database/sql"
	//blank import
	_ "github.com/lib/pq"
)

// GetBroadcastJSON возвращает  трансляцию с идентификатором id в JSON формате.
// func GetBroadcastJSON(id string) string {
// 	return GetJSON("SELECT get_broadcast($1);", id)
// }

// GetJSON возвращает JSON результатов запроса заданного sqlText, с параметром id.
func GetJSON(sqlText string, id string) string {
	db, err := sql.Open("postgres", connectStr)
	panicIf(err)
	defer db.Close()
	var json string
	if id == "" {
		err = db.QueryRow(sqlText).Scan(&json)
	} else {
		err = db.QueryRow(sqlText, id).Scan(&json)
	}
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
