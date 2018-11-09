package controllers

import (
	"fmt"
	"net/http"
	"onlinebc/models"
	"onlinebc/services/cache"

	"github.com/gorilla/mux"
)

// LandingPage : To test API in browser.
func LandingPage(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	page := `
        <h3>Online broadcasting API for rg.ru</h3>
        <div>
            <a target="_blank" href="broadcast/247">%s%sbroadcast/247</a>
        </div>
    `
	fmt.Fprintf(w, page, req.Host, req.URL.Path)
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
	json := models.GetBroadcastJson(id)
	cache.Set(r.RequestURI, json)
	fmt.Fprint(w, json)
}
