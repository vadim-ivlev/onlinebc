package main

import (
	"flag"
	"fmt"
	"os"
)

var port = 1234
var serve = true


const greetingMessage = `
Running server.

In browser

	http://localhost:%v/
	
	http://localhost:%v/broadcast/354
	http://localhost:%v/api/online.php?id=354



In terminal

    curl -i localhost:%v/broadcast/247

CTRL-C to terminate
`


func printGreetings() {
	// Print greeting
	fmt.Printf(greetingMessage, port, port, port, port)
}



func readCommandLineParams() {
	flag.IntVar(&port, "port", 7777, "Номер порта")
	flag.BoolVar(&serve, "serve", true, "Запустить приложение")

	
	if *flag.Bool("initdb", false, "Инициализировать базу данных c пустыми таблицами.") {
		fmt.Println("инициализация БД...")
		os.Exit(0)
	}	

	if *flag.Bool("filldb", false, "Заполнить таблицы БД тестовыми данными.") {
		fmt.Println("Заполнение БД тестовыми данными...")
		os.Exit(0)
	}	

	if *flag.Bool("create-db-functions", false, "Породить функции БД из файла migrations/create-functions.sql") {
		fmt.Println("Порождение функций БД...")
		os.Exit(0)
	}	
	
	fmt.Println("Параметры запуска приложения")
	flag.Usage()
	flag.Parse()
}	
