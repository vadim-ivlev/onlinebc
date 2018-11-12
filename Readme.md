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

    docker-compose exec db psql -U root -1 -d onlinebc -f /dumps/onlinebc-dump.sql


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


START

    docker-compose up -d



STOP

    docker-compose down



RESTORE database from SQL dump

	docker-compose exec db psql -U root -1 -d onlinebc -f /dumps/onlinebc-dump.sql


DUMP to SQL file 
  
    docker-compose exec db pg_dump --file "/dumps/onlinebc-dump.sql" --host "localhost" --port "5432" --username "root"  --verbose --format=p --create --clean --if-exists --dbname "onlinebc"


SHOW CREATE TABLE

    docker-compose exec db pg_dump -U root -d onlinebc -t online_trans_list --schema-only



COMMAND LINE

	docker-compose exec db psql -U root onlinebc



## implementation

See [NOTES.md](NOTES.md)
