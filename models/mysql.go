package models

import (
	"database/sql"
	// blank import
	_ "github.com/go-sql-driver/mysql"
	//blank import
	_ "github.com/lib/pq"
	"onlinebc/configs"
)

//  queryMySQL: исполняет запрос, возвращает записи.
func queryMySQL(query string) *sql.Rows {
	db, err := sql.Open("mysql", configs.Conf.MysqlConnStr)
	show(err)
	defer db.Close()

	rows, err := db.Query(query)
	check(err)
	return rows
}

// getBroadcastsIds : возвращает ids онлайн трансляций
func getBroadcastsIds() []int {
	rows := queryMySQL("SELECT id_trans FROM online_trans_list")
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
