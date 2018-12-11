package router

import (
	"log"
	"net/http"
	c "onlinebc/controller"
	"onlinebc/middleware"

	"github.com/gorilla/mux"
)

func defineRoutes(router *mux.Router) {
	c.Routes = []c.Route{
		{"/", c.LandingPage, nil, "Стартовая страница"},
		{"/routes", c.GetRoutes, nil, "JSON  маршрутов.  Документация API."},
		{"/broadcasts", c.GetBroadcastList, nil, "Получить список трансляций"},
		{"/broadcast/{id}", c.GetBroadcast, nil, "возвращает трасляцию с ее постами"},
		{"/api/online.php", c.GetBroadcast, []c.Param{{"id", "{id}"}}, "возвращает трасляцию с ее постами. Legacy"},
		{"/api/", c.GetBroadcastList, nil, "Получить список трансляций"},
	}

	for _, route := range c.Routes {
		r := router.HandleFunc(route.Path, route.Func).Methods("GET", "HEAD")
		for _, param := range route.Params {
			r.Queries(param.Name, param.Value)
		}
	}
}

// Serve определяет пути, присоединяет функции middleware
// и запускает сервер на заданном порту.
func Serve(port string) {
	router := mux.NewRouter()
	defineRoutes(router)
	router.Use(middleware.HeadersMiddleware)
	router.Use(middleware.RedisMiddleware)
	log.Fatal(http.ListenAndServe(port, router))
}
