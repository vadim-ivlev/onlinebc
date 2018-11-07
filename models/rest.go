package models

import (
	"io/ioutil"
	"net/http"
	"strconv"
)

// getBroadcast : Делает запрос на сервер и возвращает JSON трансляции 
func getBroadcast(id int) []byte {
	resp, err := http.Get("https://outer.rg.ru/plain/online_translations/api/online.php?id=" + strconv.Itoa(id))
	check(err)
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	check(err)
	defer resp.Body.Close()
	return body
}
