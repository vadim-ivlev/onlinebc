package models

import (
	"fmt"
	"time"
	// blank import
	_ "github.com/go-sql-driver/mysql"
)


// ImportData : импортирует данные из существующей системы
func ImportData(recNumber int) {
	clearBrodcasts()
	ids   := getBroadcastsIds()
	maxId := getMaxValue(ids)
	setSequenceValue(maxId)

	fmt.Printf("Общее число записей = %v    Max Id = %v\n\n", len(ids), maxId)

	for i, id := range ids {
		if i >= recNumber {
			break
		}

		broadcast := getBroadcast(id)
		fmt.Printf("id=%v %s\n", id, broadcast[0:100])

		newid := insertBroadcast(id, string(broadcast))
		fmt.Printf("New id = %v\n\n", newid)

		time.Sleep(500 * time.Millisecond)
	}

}

func CreateDatabase() {

}

func RestoreFromDump() {

}
