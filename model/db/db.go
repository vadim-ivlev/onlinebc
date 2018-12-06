package db

import (
	"database/sql"

	//blank import
	_ "github.com/lib/pq"
)

// GetBroadcastJson возвращает json трансляции с идентификатором id.
func GetBroadcastJson(id string) string {
	db, err := sql.Open("postgres", connectStr)
	panicIf(err)
	defer db.Close()
	var json string
	err = db.QueryRow("SELECT get_broadcast($1);", id).Scan(&json)
	printIf(err)
	return json
}
