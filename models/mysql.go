package models

import (
	"database/sql"
	// blank import
	_ "github.com/go-sql-driver/mysql"

	//blank import
	_ "github.com/lib/pq"

)

// MySqlQuery : исполняет запрос, возвращает записи.
func queryMySql(query string) *sql.Rows {
	db, err := sql.Open("mysql", "root:root@tcp(127.0.0.1:3305)/works")
	show(err)
	defer db.Close()

	rows, err := db.Query(query)
	check(err)

	return rows
}

// getBroadcastsIds : возвращает ids онлайн трансляций
func getBroadcastsIds() []int {
	rows := queryMySql("SELECT id_trans FROM online_trans_list")
	defer rows.Close()

	// ids := make( []int, 5)
	ids := []int{}
	for rows.Next() {
		var id int
		err := rows.Scan(&id)
		check(err)
		ids = append(ids, id)
	}
	return ids
}

