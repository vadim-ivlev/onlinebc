package routers

import (
    "log"
    "net/http"
    "onlinebc/configs"
    "onlinebc/controllers"

    "github.com/gorilla/mux"
)

func assignRoutes(router *mux.Router) *mux.Router {
    router.Path("/")              .HandlerFunc(controllers.LandingPage)     .Methods("GET")
    router.Path("/broadcasts")    .HandlerFunc(controllers.GetBroadcastList).Methods("GET")
    router.Path("/broadcast/{id}").HandlerFunc(controllers.GetBroadcast)    .Methods("GET")

    // API for external use. Legacy. 
    
    // https://outer.rg.ru/plain/online_translations/api/online.php?id=247
    router.Path("/api/online.php").
        Queries("id", "{id}").
        HandlerFunc(controllers.GetBroadcast).Methods("GET")

    // https://outer.rg.ru/plain/online_translations/api/?main=0&active=0&num=3
    router.Path("/api/").
        Queries("main",     "{main}").
        Queries("active",   "{active}").
        Queries("num",       "{num}").
        HandlerFunc(controllers.GetBroadcastList).Methods("GET")

    return router
}

func Serve() {

    router := mux.NewRouter()
    router.Headers("Content-Type", "application/json; charset=utf-8")
    assignRoutes(router)
    log.Fatal(http.ListenAndServe(configs.Conf.Port, router))

    // headersOk := handlers.AllowedHeaders([]string{"Authorization"})
    // originsOk := handlers.AllowedOrigins([]string{"*"})
    // methodsOk := handlers.AllowedMethods([]string{"GET", "POST", "OPTIONS"})
    // log.Fatal(http.ListenAndServe(":12345", handlers.CORS(originsOk, headersOk, methodsOk)(router)))

}
