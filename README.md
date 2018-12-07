# Онлайн трансляции / onlinebc

**цель** - воспроизвести REST JSON API RG.RU

Endpoints on 2018.11.02:
- https://outer.rg.ru/plain/online_translations/api/?main=0&active=0&num=3
- https://outer.rg.ru/plain/online_translations/api/online.php?id=354 



## Установка

Клонировать проект в  `~/go/src` и перейти в `onlinebc/`

    git clone git@git.rgwork.ru:web/onlinebc.git ~/go/src
    cd ~/go/src/onlinebc

## Запуск БД 
Запустить БД
    
    docker-compose up -d    

Восстановить тестовую БД из дампа

    docker-compose exec db psql -U root -1 -d onlinebc -f /dumps/onlinebc-dump.sql


Postgre доступен на localhost:5432.

Аdminer - в браузере http://localhost:8080. 

Параметры доступа:
- System: PostgreSQL,
- Server: db,
- Username: root,
- Password: root,
- Database: onlinebc





## Запуск приложения

Если установлен go

    go run main.go

Если go не установлен, то под Linux

    ./onlinebc

Программа выдаст список возможных параметров запуска. Для запуска web приложения запустите с ключом `-serve`
    
    go run main.go -serve


--------------------

## Полезные команды


Запуск докера

    docker-compose up -d



Останов докера

    docker-compose down

Восстановление БД из дампа. Находится в `migrations/`.

    docker-compose exec db psql -U root -1 -d onlinebc -f /dumps/onlinebc-dump.sql



Дамп БД в файл в `migrations/`.
  
    docker-compose exec db pg_dump --file /dumps/onlinebc-dump.sql --host "localhost" --port "5432" --username "root"  --verbose --format=p --create --clean --if-exists --dbname "onlinebc"

Дамп схемы БД

    docker-compose exec db pg_dump --file /dumps/onlinebc-schema.sql --host "localhost" --port "5432" --username "root" --schema-only  --verbose --format=p --create --clean --if-exists --dbname "onlinebc"


Дамп только данных таблиц.

    docker-compose exec db pg_dump --file /dumps/onlinebc-data.sql --host "localhost" --port "5432" --username "root"  --verbose --format=p --dbname "onlinebc" --column-inserts --data-only --table=broadcast --table=post --table=media

Можно добавить  -$(date +"-%Y-%m-%d--%H-%M-%S") к имени файла для приклеивания штампа даты-времени.


Показ структуры таблицы TABLE_NAME

    docker-compose exec db pg_dump -U root -d onlinebc -t TABLE_NAME --schema-only



Командная строка Postgres

	docker-compose exec db psql -U root onlinebc


-------------------------------

TODO: add golang container to docker-compose, remote debug, GetBroadcastList, show routes 