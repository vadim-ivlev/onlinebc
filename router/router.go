package router

import (
	"log"
	"net/http"
	"onlinebc/controller"
	"onlinebc/middleware"
	"github.com/gorilla/mux"
)

func assignRoutes(router *mux.Router) *mux.Router {
	router.Path("/").HandlerFunc(controller.LandingPage).Methods("GET", "HEAD")
	router.Path("/broadcasts").HandlerFunc(controller.GetBroadcastList).Methods("GET", "HEAD")
	router.Path("/broadcast/{id}").HandlerFunc(controller.GetBroadcast).Methods("GET", "HEAD")

	// API for external use. Legacy.

	// https://outer.rg.ru/plain/online_translations/api/online.php?id=247
	router.Path("/api/online.php").
		Queries("id", "{id}").
		HandlerFunc(controller.GetBroadcast).Methods("GET", "HEAD")

	// https://outer.rg.ru/plain/online_translations/api/?main=0&active=0&num=3
	router.Path("/api/").
		Queries("main", "{main}").
		Queries("active", "{active}").
		Queries("num", "{num}").
		HandlerFunc(controller.GetBroadcastList).Methods("GET", "HEAD")

	return router
}

func Serve(port string) {

	router := mux.NewRouter()
	// router.Headers("Content-Type", "application/json; charset=utf-8")
	assignRoutes(router)
	router.Use(middleware.HeadersMiddleware)
	router.Use(middleware.RedisMiddleware)

	log.Fatal(http.ListenAndServe(port, router))

	// headersOk := handlers.AllowedHeaders([]string{"Authorization"})
	// originsOk := handlers.AllowedOrigins([]string{"*"})
	// methodsOk := handlers.AllowedMethods([]string{"GET", "POST", "OPTIONS"})
	// log.Fatal(http.ListenAndServe(":12345", handlers.CORS(originsOk, headersOk, methodsOk)(router)))

}
