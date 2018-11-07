package main

/*

Online broadcasting.
-------------

Golang implementation of JSON API for rg.ru.

Current PHP endpoints (2018.11.02):
- https://outer.rg.ru/plain/online_translations/api/?main=0&active=0&num=3
- https://outer.rg.ru/plain/online_translations/api/online.php?id=247

*/

import (
	"flag"
	"fmt"
	"onlinebc/configs"
	"onlinebc/models"
	"onlinebc/routers"
	"os"
)

const msg = `
Running server.

In browser

	http://localhost%v/
	http://localhost%v/broadcast/247

In terminal

	curl -i localhost%v/broadcast/247

CTRL-C to terminate
`

// Print a greeting message
// and start serving routes
func main() {

	isImporting := flag.Bool("import-data", false, "import data from the current app")
	flag.Parse()

	if *isImporting {
		println("importing data")
		models.ImportData(500)
		os.Exit(0)
	}

	fmt.Printf(msg, configs.Port, configs.Port, configs.Port)
	routers.Serve()
}
