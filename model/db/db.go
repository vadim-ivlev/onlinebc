package db

import (
	"fmt"
	"database/sql"
	//blank import
	_ "github.com/lib/pq"
	"onlinebc/configs"
)

// func insertBroadcast(id int, jsonText string) int {
// 	db, err := sql.Open("postgres", configs.Conf.PstgrConnStr)
// 	check(err)
// 	defer db.Close()
// 	var newId int
// 	err = db.QueryRow("INSERT INTO broadcasts (id, broadcast) VALUES ( $1 , $2 ) RETURNING id;", id, jsonText).Scan(&newId)
// 	show(err)
// 	return newId
// }

// func clearBrodcasts() {
// 	db, err := sql.Open("postgres", configs.Conf.PstgrConnStr)
// 	check(err)
// 	defer db.Close()
// 	_, err1 := db.Exec("DELETE FROM broadcasts ;")
// 	check(err1)
// }

// func setSequenceValue(n int) {
// 	db, err := sql.Open("postgres", configs.Conf.PstgrConnStr)
// 	check(err)
// 	defer db.Close()
// 	// _, err1 := db.Exec("SELECT setval('broadcasts_id_seq', $1, true);", n )
// 	_, err1 := db.Query("SELECT setval('broadcasts_id_seq', $1, true);", n)
// 	check(err1)
// }


// GetBroadcastJson возвращает json трансляции с идентификатором id.
func GetBroadcastJson(id string) string {
	db, err := sql.Open("postgres", configs.Conf.PstgrConnStr)
	check(err)
	defer db.Close()
	var json string
	err = db.QueryRow("SELECT get_broadcast($1);", id).Scan(&json)
	show(err)
	return json
}


// Вспомогательные функции /////////////////////////////////////////////////////

// check Прерывает программу в случае ошибки
func check(err error) {
	if err != nil {
		panic(err.Error()) // proper error handling instead of panic in your app
	}
}

// show Печатает ошибку
func show(err error) {
	if err != nil {
		fmt.Println(err.Error())
		// log.Println(err.Error())
	}

}

