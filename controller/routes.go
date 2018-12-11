package controller

// // Param - параметр запроса ?name=value&...
// type Param struct {
// 	Name  string
// 	Value string
// }

// // Route - маршрут.
// type Route struct {
// 	Path        string                                       // Строка маршрута
// 	Func        func(w http.ResponseWriter, r *http.Request) // контроллер
// 	Params      []Param                                      // возможные параметры
// 	Description string                                       // описание. Для документации
// }

// var Rs = []Route{
// 	{"/", LandingPage, nil, "Стартовая страница"},
// 	{"/routes", GetRoutes, nil, "JSON  маршрутов.  Документация API."},
// 	{"/broadcasts", GetBroadcastList, nil, "Получить список трансляций"},
// 	{"/broadcast/{id}", GetBroadcast, nil, "возвращает трасляцию с ее постами"},
// 	{"/api/online.php", GetBroadcast, []Param{{"id", "{id}"}}, "возвращает трасляцию с ее постами. Legacy"},
// 	{"/api/", GetBroadcastList, nil, "Получить список трансляций"},
// }
