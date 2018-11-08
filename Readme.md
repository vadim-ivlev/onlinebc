# Онлайн трансляции


JSON API for rg.ru.

Endpoints on 2018.11.02:
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


## develop

After cloning the repo into $GOPATH/src/ start postgresql
	
	docker-compose up -d



restore database from the dump

	docker-compose exec db psql -U root -1 -v -q -d postgres -f /dumps/online1.sql

Develop





## settings

see

    configs/config.yaml


## database


start postgresql (localhost:5432) and adminer http://localhost:8080. 

- System: PostgreSQL,
- Server: db,
- Username: root,
- Password: root,
- Database: onlinebc

start

    docker-compose up -d


restore database

	docker-compose exec db psql -U root -1 -v -q -d postgres -f /dumps/online1.sql



db command line

	docker-compose exec db psql -U root onlinebc

stop

    docker-compose down


## implementation

See [NOTES.md](NOTES.md)