package main

import (
	"database/sql"
	"fmt"
	"onlinebc/services/utils"

	_ "github.com/go-sql-driver/mysql"
)

type Tag struct {
	id    int    `json:"id"`
	title string `json:"name"`
}

func main() {
	// Open up our database connection.
	db, err := sql.Open("mysqlks", "root:root@tcp(127.0.0.1:3305)/works")
	utils.PrintIf(err)
	defer db.Close()

	// Execute the query
	results, err := db.Query("SELECT id_trans, title FROM online_trans_list limit 10")
	utils.PanicIf(err)

	for results.Next() {
		var tag Tag
		// for each row, scan the result into our tag composite object
		err = results.Scan(&tag.id, &tag.title)
		utils.PanicIf(err)
		// and then print out the tag's Name attribute
		// log.Printf(tag.title)
		fmt.Println(tag.id, tag.title)
	}
}
