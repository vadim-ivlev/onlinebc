Онлайн трансляции (onlinebc)
=============================

Рабочая среда для фронтэнд разработчиков. 
-----------------------------------------


- Тестовая страница API: <http://localhost:7700/> `GET`.
- Конечная точка GraphQL <http://localhost:7700/graphql> `POST`.




Требования к ПО
----------
- Docker, Docker-compose.



Запуск 
------

    docker-compose up -d


Просмотр логов работающего приложения.

    docker-compose logs -f runner 


Контроль запуска и доступности API 
------------------------

<http://localhost:7700>. 


Останов программы
-----------

     docker-compose down


Загрузка изображений
---------------------

Осуществляется путем вызова функции create_medium(...). 
В приведенном ниже примере, на сервер отправляются два файла _small.gif и _small.png. Байты изображений закодированы в виде строк base64 и передаются как значения параметра base64.



	mutation {

		new0: create_medium( 
			post_id: 24098, 
			source: "RT", 
			filename: "_small.gif",
			base64: "R0lGODdhBgAHAIABAAAAAP///ywAAAAABgAHAAACCoxvALfRn2JqyBQAOw=="
		) 
		{   
			id 
			post_id  
			source 
			thumb  
			uri  
		}
		
		new1: create_medium( 
			post_id: 24098, 
			source: "RT", 
			filename: "_small.png",
			base64: "iVBORw0KGgoAAAANSUhEUgAAAAYAAAAHCAIAAACk8qu6AAAALklEQVQI122NQQoAMAzCmv7/z9nBMhidFyWIotarjgHAsLTUG7qWPoj0MzR5Px5x5hf78pZ5DQAAAABJRU5ErkJggg=="
		) 
		{   
			id 
			post_id  
			source 
			thumb  
			uri  
		}
		
	}

Ответ сервера:

    {
        "data": {
            "new0": {
            "id": 6002,
            "post_id": 24098,
            "source": "RT",
            "thumb": "/uploads/2019/03/05/_small_thumb.gif",
            "uri": "/uploads/2019/03/05/_small.gif"
            },
            "new1": {
            "id": 6003,
            "post_id": 24098,
            "source": "RT",
            "thumb": "/uploads/2019/03/05/_small_thumb.png",
            "uri": "/uploads/2019/03/05/_small.png"
            }
        }
    }

Поля `uri` и `thumb` показывают путь по которому изображения сохранены на сервере.

Пример того, как в браузере средствами javascript выбрать несколько 
зображений, преобразовать их в base64, сформировать запрос и отправить 
на сервер можно найти в файле `./templates/index.js`.



Дополнительная информация
--------------------------
<https://git.rgwork.ru/web/onlinebc_admin>




