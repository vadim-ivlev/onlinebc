package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"onlinebc/model/db"
	"onlinebc/model/redis"
	"onlinebc/router"
	"os"
	"strconv"
)

func main() {
	// считать конфиги
	db.ReadConfig("./configs/db.yaml")
	redis.ReadConfig("./configs/redis.yaml")

	// считать параметры командной строки
	serve, port := readCommandLineParams()

	// если есть параметр -serve, запустить сервер
	if serve {
		printGreetings(port)
		router.Serve(":" + strconv.Itoa(port))
	}
}

// TODO: finish params.
func readCommandLineParams() (bool, int) {
	port := 1234
	serve := true

	flag.IntVar(&port, "port", 7777, "Номер порта")
	flag.BoolVar(&serve, "serve", false, "Запустить приложение")

	initdb := flag.Bool("initdb", false, "Инициализировать базу данных c пустыми таблицами.")
	filldb := flag.Bool("filldb", false, "Заполнить таблицы БД тестовыми данными.")
	createDbFunctions := flag.Bool("create-db-functions", false, "Породить функции БД из файла migrations/create-functions.sql")
	printParams := flag.Bool("print-params", false, "Показать параметры приложения.")

	flag.Parse()

	if *initdb {
		fmt.Println("инициализация БД...")
		os.Exit(0)
	}
	if *filldb {
		fmt.Println("Заполнение БД тестовыми данными...")
		os.Exit(0)
	}
	if *createDbFunctions {
		fmt.Println("Порождение функций БД...")
		os.Exit(0)
	}
	if *printParams {
		db.PrintConfig()
		redis.PrintConfig()
		os.Exit(0)
	}

	fmt.Println("Параметры запуска приложения")
	flag.Usage()

	return serve, port
}

func printGreetings(port int) {
	greeting, _ := ioutil.ReadFile("./docs/greetings.txt")
	fmt.Printf(string(greeting), port, port, port, port)
}
