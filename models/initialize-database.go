package models

import (
	"strconv"
	"time"
	"net/http"
	"io/ioutil"
	"database/sql"
	"fmt"
	"onlinebc/services/utils"
	// blank import
	_ "github.com/go-sql-driver/mysql"
)

// type Tag struct {
// 	id    int    `json:"id"`
// 	title string `json:"name"`
// }

// ImportData : импортирует данные из существующей системы
func ImportData(maxNumber int) {
	db, err := sql.Open("mysql", "root:root@tcp(127.0.0.1:3305)/works")
	utils.PrintIf(err)
	defer db.Close()

	results, err := db.Query("SELECT id_trans FROM online_trans_list")
	utils.PanicIf(err)

	counter:=1
	for results.Next() {
		if counter >maxNumber {
			break
		}
		var id int
		err = results.Scan(&id)
		utils.PanicIf(err)
		json:=getJson(id)

		counter++

		println(json[0:120])

		time.Sleep(1 * time.Second)
	}
}

func getJson(id int) string {
	// addr := fmt.Sprintf("https://outer.rg.ru/plain/online_translations/api/online.php?id=%v", id)
	resp, err := http.Get("https://outer.rg.ru/plain/online_translations/api/online.php?id=" + strconv.Itoa(id))
	utils.PanicIf(err)
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	utils.PanicIf(err)
	defer resp.Body.Close()
	return string(body)
}


func CreateDatabase()  {
	
}

func RestoreFromDump()  {
	
}
