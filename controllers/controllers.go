package controllers

import (
	"onlinebc/services/cache"
	"onlinebc/models"
	"fmt"
	"net/http"
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
func GetBroadcastList(w http.ResponseWriter, req *http.Request) {

}

// GetBroadcast
// returns a broadcast and its messages
func GetBroadcast(w http.ResponseWriter, req *http.Request) {

	id :="247"

	jsonText, e := cache.Get(id)
	if e == nil {
		w.Write([]byte(jsonText))
		return
	}

	jsonText = models.GetBroadcastJsonText(id)
	cache.Set("broadcast-json:"+id, jsonText)
	fmt.Fprint(w, jsonText)
}
