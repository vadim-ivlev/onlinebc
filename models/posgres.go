package models

import (
	"database/sql"
	//blank import
	_ "github.com/lib/pq"
	"onlinebc/configs"
)

func insertBroadcast(id int, jsonText string) int {
	db, err := sql.Open("postgres", configs.Conf.PstgrConnStr)
	check(err)
	defer db.Close()
	var newId int
	err = db.QueryRow("INSERT INTO broadcasts (id, broadcast) VALUES ( $1 , $2 ) RETURNING id;", id, jsonText).Scan(&newId)
	show(err)
	return newId
}

func clearBrodcasts() {
	db, err := sql.Open("postgres", configs.Conf.PstgrConnStr)
	check(err)
	defer db.Close()
	_, err1 := db.Exec("DELETE FROM broadcasts ;")
	check(err1)
}

func setSequenceValue(n int) {
	db, err := sql.Open("postgres", configs.Conf.PstgrConnStr)
	check(err)
	defer db.Close()
	// _, err1 := db.Exec("SELECT setval('broadcasts_id_seq', $1, true);", n )
	_, err1 := db.Query("SELECT setval('broadcasts_id_seq', $1, true);", n)
	check(err1)
}


func GetBroadcastJson(id string) string {
	db, err := sql.Open("postgres", configs.Conf.PstgrConnStr)
	check(err)
	defer db.Close()
	var json string
	err = db.QueryRow("SELECT broadcast FROM broadcasts WHERE id=$1 LIMIT 1;", id).Scan(&json)
	show(err)
	return json
}

