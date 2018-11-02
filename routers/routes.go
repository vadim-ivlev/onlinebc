package routers

import (
	"log"
	"net/http"
	"onlinebc/configs"
	"onlinebc/controllers"

	"github.com/gorilla/mux"
)

func assignRoutes(router *mux.Router) *mux.Router {
	router.HandleFunc("/"              , controllers.LandingPage     ).Methods("GET")
	router.HandleFunc("/broadcasts"    , controllers.GetBroadcastList).Methods("GET")
	router.HandleFunc("/broadcast/{id}", controllers.GetBroadcast    ).Methods("GET")
	return router
}


func Serve() {

	router := mux.NewRouter()
	router.Headers("Content-Type", "application/json; charset=utf-8")
	assignRoutes(router)
	log.Fatal(http.ListenAndServe(configs.Port, router))

	// headersOk := handlers.AllowedHeaders([]string{"Authorization"})
	// originsOk := handlers.AllowedOrigins([]string{"*"})
	// methodsOk := handlers.AllowedMethods([]string{"GET", "POST", "OPTIONS"})
	// log.Fatal(http.ListenAndServe(":12345", handlers.CORS(originsOk, headersOk, methodsOk)(router)))

}
