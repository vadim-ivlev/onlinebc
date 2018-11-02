package models

import (
	"io/ioutil"
)

func GetBroadcastJsonText(id string) string  {
		
	jsonText, e := ioutil.ReadFile("./data/text/broadcast-247.json")
	if e != nil {
		panic(e)
	}
	return string(jsonText)
}