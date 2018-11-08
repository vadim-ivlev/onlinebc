package controllers

import (
	"fmt"
	"github.com/gorilla/mux"
	"net/http"
	"onlinebc/models"
	"onlinebc/services/cache"
)

type Broadcast struct {
}

func LandingPage(w http.ResponseWriter, req *http.Request) {
	// json.NewEncoder(w).Encode("Hello from new Api")
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	const page = `
        <h3>Online broadcasting API for rg.ru</h3>
        <div>
            <a target="_blank" href="broadcast/247">%s%sbroadcast/247</a>
        </div>
    `
	fmt.Fprintf(w, page, req.Host, req.URL.Path)
}

// returns list of broadcasts
func GetBroadcastList(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	main := vars["main"]
	active := vars["active"]
	num := vars["num"]

	fmt.Printf("main=%v active=%v num=%v", main, active, num)

}

// GetBroadcast returns a broadcast and its messages
func GetBroadcast(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id := vars["id"]
	println(id)
	return

	jsonText, err := cache.Get(id)
	if err == nil {
		w.Write([]byte(jsonText))
		return
	}

	jsonText = models.GetBroadcastJsonText(id)
    
	cache.Set("broadcast-json:"+id, jsonText)
	fmt.Fprint(w, jsonText)
}
