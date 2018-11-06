package utils

import (
	"fmt"
)

func PanicIf(err error) {
	if err != nil {
		panic(err.Error()) // proper error handling instead of panic in your app
	}
}

func PrintIf(err error) {
	if err != nil {
		fmt.Println(err.Error())
		// log.Println(err.Error())
	}

}
