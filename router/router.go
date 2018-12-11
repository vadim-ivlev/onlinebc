package router

import (
	"fmt"
	"log"
	"net/http"
	c "onlinebc/controller"
	"onlinebc/middleware"
	"strings"

	"github.com/gorilla/mux"
)

func defineRoutes(router *mux.Router) {
	c.Rs = []c.Route{
		{"/", c.LandingPage, nil, "Стартовая страница"},
		{"/routes", c.GetRoutes, nil, "JSON  маршрутов.  Документация API."},
		{"/broadcasts", c.GetBroadcastList, nil, "Получить список трансляций"},
		{"/broadcast/{id}", c.GetBroadcast, nil, "возвращает трасляцию с ее постами"},
		{"/api/online.php", c.GetBroadcast, []c.Param{{"id", "{id}"}}, "возвращает трасляцию с ее постами. Legacy"},
		{"/api/", c.GetBroadcastList, nil, "Получить список трансляций"},
	}

	for _, r := range c.Rs {
		rout := router.HandleFunc(r.Path, r.Func).Methods("GET", "HEAD")
		for _, q := range r.Params {
			rout.Queries(q.Name, q.Value)
		}
	}
}

func assignRoutes(router *mux.Router) {
	router.Path("/").HandlerFunc(c.LandingPage).Methods("GET", "HEAD")
	router.Path("/routes").HandlerFunc(c.GetRoutes).Methods("GET", "HEAD")
	router.Path("/broadcasts").HandlerFunc(c.GetBroadcastList).Methods("GET", "HEAD")
	router.Path("/broadcast/{id}").HandlerFunc(c.GetBroadcast).Methods("GET", "HEAD")

	// API for external use. Legacy.

	// https://outer.rg.ru/plain/online_translations/api/online.php?id=247
	router.Path("/api/online.php").
		Queries("id", "{id}").
		HandlerFunc(c.GetBroadcast).Methods("GET", "HEAD")

	// https://outer.rg.ru/plain/online_translations/api/?main=0&active=0&num=3
	router.Path("/api/").
		Queries("main", "{main}").
		Queries("active", "{active}").
		Queries("num", "{num}").
		HandlerFunc(c.GetBroadcastList).Methods("GET", "HEAD")
}

// Serve определяет пути, присоединяет функции middleware
// и запускает сервер на заданном порту.
func Serve(port string) {

	router := mux.NewRouter()
	defineRoutes(router)
	// assignRoutes(router)
	c.Routes = listRoutes(router)

	router.Use(middleware.HeadersMiddleware)
	router.Use(middleware.RedisMiddleware)

	log.Fatal(http.ListenAndServe(port, router))
}

// GetRoutes : Перечисляет доступные маршруты. Документация API.
func listRoutes(r *mux.Router) []c.RouteInfo {
	var routeInfos []c.RouteInfo

	err := r.Walk(func(route *mux.Route, router *mux.Router, ancestors []*mux.Route) error {
		var ri c.RouteInfo
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
