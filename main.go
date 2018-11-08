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
	http://localhost%v/api/online.php?id=247



In terminal

    curl -i localhost%v/broadcast/247

CTRL-C to terminate
`

func main() {
	// Read config params
	configs.Conf.ReadConfigFile("./configs/config.yaml")

	// Process command line parameters
	isImporting := flag.Bool("importdata", false, "Import data from the current app using http requests and mysql connection.")
	flag.Parse()

	if *isImporting {
		models.ImportData(500)
		os.Exit(0)
	}

	// Print a greeting message
	p := configs.Conf.Port
	fmt.Printf(msg, p, p, p, p)

	// and start serving routes
	routers.Serve()
}
