package router

import (
	"log"
	"net/http"
	c "onlinebc/controller"
	"onlinebc/middleware"

	"github.com/gorilla/mux"
)

// InitRoutesArray инициализирует массив маршрутов.
func InitRoutesArray() {
	c.Routes = []c.Route{
		{"/", "/", c.LandingPage, nil, "Стартовая страница"},
		{"/routes", "/routes", c.GetRoutes, nil, "JSON  маршрутов.  Документация API."},
		{"/broadcasts", "/broadcasts", c.GetBroadcastList, nil, "Список трансляций"},
		{"/broadcast/{id}", "/broadcast/354", c.GetBroadcast, nil, "Трасляция с постами"},
		{"/api/online.php", "/api/online.php?id=354", c.GetBroadcast, []c.Param{{"id", "{id}"}}, "Трасляция с постами. Legacy"},
		{"/api/", "/api/?main=0&active=0&num=3", c.GetBroadcastList, []c.Param{
			{"main", "{main}"},
			{"active", "{active}"},
			{"num", "{num}"},
		}, "Список трансляций"},
	}
}

// defineRoutes -  Сопоставляет маршруты контроллерам для заданного раутера
func defineRoutes(router *mux.Router) {

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
	InitRoutesArray()
	defineRoutes(router)
	router.Use(middleware.HeadersMiddleware)
	router.Use(middleware.RedisMiddleware)
	log.Fatal(http.ListenAndServe(port, router))
}
