# Установка зависимостей
``` bash 
python3 -m venv .venv
source .venv/bin/activate

pip install poetry
poetry isntall
```
# Настройка
``` bash
touch .env
# .env впихнуть настройки:
#    ssl_on: bool = False
#    ssl_keyfile: str = ''
#    ssl_certfile: str = ''

#    api_hostname: str = "localhost"
#    api_port: int = 9999
#    version: str = "0.0.0"
#    project_name: str = "Wirer"
#    fast_api_description: str = ''
```
# Запуск 
``` bash
python3 -m app
```