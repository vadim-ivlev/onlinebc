# Онлайн трансляции



Golang implementation of JSON API for rg.ru.

Current PHP endpoints (2018.11.02):
- https://outer.rg.ru/plain/online_translations/api/?main=0&active=0&num=3
- https://outer.rg.ru/plain/online_translations/api/online.php?id=247

## usage 
    go run main.go

## check

In browser

	http://localhost:1234/
	http://localhost:1234/broadcast/247

In terminal

	curl -i localhost:1234/broadcast/247

CTRL-C to terminate

## settings

    configs/*.*

configs/config.db.yml - should be placed by sysadmin. 


## implementation

See [NOTES.md](NOTES.md)