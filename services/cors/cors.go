package cors

// import (
// 	"net/http"
// 	"notifyapp/configs"
// 	"strings"
// )

// // Check CORS
// func Check(origin string) (string, bool) {
// 	i := strings.Index(origin, configs.AccessHost)
// 	if i >= 0 {
// 		return strings.Trim(origin, "/"), true
// 	}
// 	return "", false
// }

// // Set the headers for CORS
// func Set(w http.ResponseWriter, origin string) {
// 	w.Header().Set("Access-Control-Allow-Origin", "*")
// 	// w.Header().Set("Access-Control-Allow-Credentials", "true")
// 	w.Header().Set("Content-Type", "application/json")
// }
