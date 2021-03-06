import numpy as np


def average_speed(data: dict):
    syllables = []
    if "result" not in data:
        return {"mean": 0, "speed_class": "Нет данных"}
    for word in data["result"]:
        vowels = sum(x in 'aeiouауоыэяюёие' for x in word['word']) + 1
        time = word['end'] - word['start']
        for i in range(vowels):
            syllables.append(vowels / time)
    mean = np.array(syllables).mean()
    if mean < 8.5:
        class_ = "Слишком медленно"
        comment = "Говорите быстрее"
    elif mean < 11.5:
        class_ = "Нормально"
        comment = "Всё хорошо!"
    else:
        class_ = "Слишком быстро"
        comment = "Говорите медленее"
    return {"mean": mean, "speed_class": class_, "comment": comment}