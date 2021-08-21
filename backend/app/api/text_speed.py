import json
import numpy as np
from typing import BinaryIO


def average_speed(data: dict):
    syllables = []
    for word in data["result"]:
        vowels = sum(x in 'aeiouауоыэяюёие' for x in word['word']) + 1
        time = word['end'] - word['start']
        for i in range(vowels):
            syllables.append(time / vowels)
    return np.array(syllables).mean()


# print(average_speed("speed/peter.json"))