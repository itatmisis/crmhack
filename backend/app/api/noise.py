from typing import BinaryIO

from scipy.io import wavfile
import numpy as np


def data_to_analyse(data):
    step = 50
    new_data = [i for i in data if i >= 0]
    newer_data = []
    for i in range(0, len(new_data), step):
        newer_data.append(np.array(new_data[i:i + step]).max())
    return (newer_data)


def perc(data, edge):
    return sum(abs(i) > edge for i in data) / len(data)


def bin_search(a, value):
    mid = max(a) // 2
    low = 0
    high = max(a) - 1

    while perc(a, mid) != value and low <= high:
        if (abs(value - perc(a, mid)) < 0.01):
            return mid
        if value < perc(a, mid):
            low = mid + 1
        else:
            high = mid - 1
        mid = (low + high) // 2
    return mid


def rate_noise(wav_loc: BinaryIO):
    rate, data = wavfile.read(wav_loc)

    new_list = data_to_analyse(data)
    noise = bin_search(new_list, 0.7) / bin_search(new_list, 0.05)
    if noise < 0.1:
        comment = "Идеально"
    elif noise < 0.3:
        comment = "Удовлетворительно"
    elif noise < 0.5:
        comment = "Обстановка зашумлена, необходимо уменьшить уровень шума"
    else:
        comment = "Обстановка очень зашемлена, нуобходимо сильно уменьшить уровень шума"
    return {"noise_level": noise, "comment": comment}
