package controller

import (
	"encoding/json"
	"fmt"
	"net/http"
	"onlinebc/model/db"
	"onlinebc/model/redis"

	"github.com/gorilla/mux"
	"gopkg.in/yaml.v2"
)

// RouteInfo - информация о пути и методах маршрута. Документация API.
type RouteInfo struct {
	Path string
	Meth string
}

// Routes содержит инфориацию о маршрутах.  Документация API.
var Routes []RouteInfo

// LandingPage : To test API in browser.
func LandingPage(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	page := `
        <h3>Online broadcasting API for rg.ru</h3>
        <div>
            <a target="_blank" href="broadcast/354">%s%sbroadcast/354</a>
		</div>
		<pre>%s</pre>
	`
	// bytes, _:= yaml.Marshal(Routes)
	fmt.Fprintf(w, page, req.Host, req.URL.Path, toYAML(Routes))
}

// GetRoutes : Перечисляет доступные маршруты.  Документация API.
func GetRoutes(w http.ResponseWriter, req *http.Request) {
	fmt.Fprint(w, toJSON(Routes))
}

// GetBroadcastList returns list of broadcasts
func GetBroadcastList(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	main := vars["main"]
	active := vars["active"]
	num := vars["num"]
	fmt.Printf("main=%v active=%v num=%v", main, active, num)
}

// GetBroadcast returns a broadcast and its messages
func GetBroadcast(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	json := db.GetBroadcastJSON(id)
	redis.Set(r.RequestURI, json)
	fmt.Fprint(w, json)
}

func toJSON(o interface{}) string {
	bytes, _ := json.Marshal(o)
	return string(bytes)
}

func toYAML(o interface{}) string {
	bytes, _ := yaml.Marshal(o)
	return string(bytes)
}
