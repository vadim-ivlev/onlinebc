package main

import (
	"onlinebc/configs"
	"strconv"
	// "onlinebc/model/db"
	"onlinebc/router"
)

func main() {
	// Read config params
	configs.Conf.ReadConfigFile("./configs/config.yaml")
	readCommandLineParams()
	printGreetings()

	// and start serving routes
	router.Serve(":" + strconv.Itoa(port))
}
