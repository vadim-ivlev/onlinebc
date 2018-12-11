package controller

import (
	"encoding/json"
	"fmt"
	"html/template"
	"net/http"
	"onlinebc/model/db"
	"onlinebc/model/redis"

	"github.com/gorilla/mux"
	yaml "gopkg.in/yaml.v2"
)

// Param - параметр запроса ?name=value&...
type Param struct {
	Name  string
	Value string
}

// Route - маршрут.
type Route struct {
	Path        string
	Func        func(w http.ResponseWriter, r *http.Request) `json:"-" yaml:"-"`
	Params      []Param                                      `json:",omitempty" yaml:",omitempty"`
	Description string
}

// Routes содержит инфориацию о маршрутах.  Документация API.
var Routes []Route

// LandingPage : To test API in browser.
func LandingPage(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	tmpl, err := template.ParseFiles("templates/landing-page.html")
	if err == nil {
		tmpl.Execute(w, Routes)
	} else {
		fmt.Fprintf(w, "ERR=%v", err)
	}
}

// GetRoutes : Перечисляет доступные маршруты.  Документация API.
func GetRoutes(w http.ResponseWriter, req *http.Request) {
	fmt.Fprint(w, toJSON(Routes))
}

// GetBroadcastList Получить список трансляций
func GetBroadcastList(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	main := vars["main"]
	active := vars["active"]
	num := vars["num"]
	fmt.Printf("main=%v active=%v num=%v", main, active, num)
}

// GetBroadcast возвращает трасляцию с ее постами
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
