package models

import (
	"io/ioutil"
)

func ReadTextFile(id string) string {
	jsonText, err := ioutil.ReadFile("./data/text/broadcast-247.json")
	check(err)
	return string(jsonText)
}
