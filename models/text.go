package models

import (
	"io/ioutil"
)

func GetBroadcastJsonText(id string) string {

	jsonText, err := ioutil.ReadFile("./data/text/broadcast-247.json")
	if err != nil {
		panic(err)
	}
	return string(jsonText)
}
