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
    return np.array(syllables).mean()
