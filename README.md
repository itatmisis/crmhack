## Запуск бекенд сервера
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
## Требования
`python >= 3.7` 