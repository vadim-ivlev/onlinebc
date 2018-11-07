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

## database


start postgresql
	
	docker-compose up -d



restore database

	docker-compose exec db psql -U root -1 -v -q -d postgres -f /dumps/online1.sql



db command line

	docker-compose exec db psql -U root onlinebc


## implementation

See [NOTES.md](NOTES.md)