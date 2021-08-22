## Пример
- https://crmhack.itatmisis.ru - пример работающего фронтенда
- https://crmhack.itatmisis.ru:9999/docs - пример работающего бекенда

## Описание продукта

Представленное разработка реализует рекомендательную систему для оптимизации стратегий взаимодействия с клиентом. На вход алгоритма подаются аудиоданные диалога сотрудника call-центра и клиента, впоследствии запись преобразуется в текст посредством Speech-to-Text модели Vosk. Полученный текст дополняется знаками препинания и подается на вход семантическим и звуковым метрикам. Полученные таким образом данные о качестве диалога сотрудника дополняют эмбеддинги предложений, полученные с помощью doc2vec, относящиеся к эмпирическому графу реализации стратегий взаимодействия с клиентом. 

Мы собрали свой собственный пробный датасет, реализующий тестовую стратегию продажи и построили на её основе взвешенный эмпирический граф (веса на ребрах = частоты использования ребра^{-1]). Эти данные позволяют вычислить оптимальную эмпирическую стратегию продаж, которая может отличаться от эталонной (изначальная стратегия). Вместе с этим продукт реализует предсказание потенциальных связей между элементами графа, предоставляя, таким образом, возможность протестировать прочие стратегии продвижения продуктов не затронутые в эталонной и эмпирических стратегиях.  

Для обработки данных и вычисления метрик используется нейронная сеть ruBERT, предсказание связей в эмпирическом графе осуществляется посредством обученной авторами графовой сверточной сети (GCN).     

## Стек 
Алгоритмы:
- [Vosk](https://alphacephei.com/vosk/) - speech to text алгоритм
- [ruBERT](http://docs.deeppavlov.ai/en/master/features/models/bert.html) - нейронная сеть-трасформер, дообученная на предсказание эмоциональной окраски текста.
- [punctBERT]() - нейронная сеть-трансформер, дообученная на восстановление пропущенных знаков препинания (постобработка речи из speech-to-text).
- [Doc2Vec](https://radimrehurek.com/gensim/models/doc2vec.html) - self-supervised нейронная сеть, обученная на предсказание контекста текстового массива (построение эмбеддингов ответов сотрудников в графе стратегий продаж). 
- [GCN](https://github.com/tkipf/gcn) - графовая нейронная сеть, дообученная на предсказание дополнительных связей в эмпирическом графе стратегий продаж. 
Технологии:
- Python 3.7
- FastAPI, Uvicorn
- Flutter 2.2
- StellarGraph, PyTorch, Gensim.

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
