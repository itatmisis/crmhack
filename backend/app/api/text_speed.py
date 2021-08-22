import numpy as np


def average_speed(data: dict):
    syllables = []
    if "result" not in data:
        return 0
    for word in data["result"]:
        vowels = sum(x in 'aeiouауоыэяюёие' for x in word['word']) + 1
        time = word['end'] - word['start']
        for i in range(vowels):
            syllables.append(time / vowels)
    mean = np.array(syllables).mean()
    class_ = ""
    if mean < 2.3:
        class_ = "Слишком медленно"
    elif mean < 5:
        class_ = "Нормально"
    else:
        class_ = "Слишком быстро"
    return {"mean": mean, "speed_class": class_}
