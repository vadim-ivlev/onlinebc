package router

import (
	"fmt"
	"log"
	"net/http"
	"onlinebc/controller"
	"onlinebc/middleware"
	"strings"

	"github.com/gorilla/mux"
)

func assignRoutes(router *mux.Router) *mux.Router {
	router.Path("/").HandlerFunc(controller.LandingPage).Methods("GET", "HEAD")
	router.Path("/routes").HandlerFunc(controller.GetRoutes).Methods("GET", "HEAD")
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

// Serve определяет пути, присоединяет функции middleware
// и запускает сервер на заданном порту.
func Serve(port string) {

	router := mux.NewRouter()
	// router.Headers("Content-Type", "application/json; charset=utf-8")
	assignRoutes(router)
	controller.Routes = listRoutes(router)

	router.Use(middleware.HeadersMiddleware)
	router.Use(middleware.RedisMiddleware)

	log.Fatal(http.ListenAndServe(port, router))

	// Альтернативный способ добавить CORS заголовки
	// headersOk := handlers.AllowedHeaders([]string{"Authorization"})
	// originsOk := handlers.AllowedOrigins([]string{"*"})
	// methodsOk := handlers.AllowedMethods([]string{"GET", "POST", "OPTIONS"})
	// log.Fatal(http.ListenAndServe(":12345", handlers.CORS(originsOk, headersOk, methodsOk)(router)))

}

// // RouteInfo - информация о пути и методах маршрута. Документация API.
// type RouteInfo struct {
// 	Path string
// 	Meth string
// }

// // Routes содержит инфориацию о маршрутах.  Документация API.
// var Routes []RouteInfo

// GetRoutes : Перечисляет доступные маршруты. Документация API.
func listRoutes(r *mux.Router) []controller.RouteInfo {
	var routeInfos []controller.RouteInfo

	err := r.Walk(func(route *mux.Route, router *mux.Router, ancestors []*mux.Route) error {
		var ri controller.RouteInfo
		s := ""

		pathTemplate, err := route.GetPathTemplate()
		if err == nil {
			s += pathTemplate
		}
		queriesTemplates, err := route.GetQueriesTemplates()
		if err == nil {
			s += "?" + strings.Join(queriesTemplates, "&")
		}
		ri.Path = s

		methods, err := route.GetMethods()
		if err == nil {
			ri.Meth = strings.Join(methods, ",")
		}
		routeInfos = append(routeInfos, ri)
		return nil
	})

	if err != nil {
		fmt.Println(err)
	}
	return routeInfos
}
