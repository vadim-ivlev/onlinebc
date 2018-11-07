package models

import (
	"fmt"
)

// check Прерывает программу в случае ошибки
func check(err error) {
	if err != nil {
		panic(err.Error()) // proper error handling instead of panic in your app
	}
}

// show Печатает ошибку
func show(err error) {
	if err != nil {
		fmt.Println(err.Error())
		// log.Println(err.Error())
	}

}

// find max value in a sclice
func getMaxValue(arr []int) int {
	m := -1
	for _, v := range arr {
		if v > m {
			m = v
		}
	}
	return m
}
