## Пример
https://crmhack.itatmisis.ru:9999/docs - пример работающего бекенда

## Описание продукта

## Стек 
Алгоритмы:
- [Vosk](https://alphacephei.com/vosk/) - speech to text алгоритм
Технологии:
- Python 3.7
- FastAPI, Uvicorn

## Запуск Бекенд сервера
Автоматически:
``` bash
curl https://raw.githubusercontent.com/itatmisis/crmhack/master/auto_install.sh | sh
```
Вручную:
``` bash
git clone https://github.com/itatmisis/crmhack
cd crmhack/backend
python3 -m venv .venv
source .venv/bin/activate
pip install -U pip
pip install poetry
poetry install

# Скачать модель для воска и положить в папку vosk, 
# либо сделать это автоматически:
cd app/vosk
./download.sh
cd -

touch .env # в .env положить настройки,
# список настроек в /app/core/settings.py
bash start.sh
```
## Протестирован на
- OS: Debian GNU/Linux 10 (buster) x86_64
- Python 3.7
- Kernel: 4.19.0-17-amd64 
