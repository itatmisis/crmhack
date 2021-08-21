#!/usr/bin/env python3
import sys
import os
from pathlib import Path
from typing import Union

from vosk import Model, KaldiRecognizer, SetLogLevel
import wave

SetLogLevel(-1)

VOSK = Path(os.path.realpath(__file__)).parent.parent / "vosk"


def speech_to_text(file: Union[str, Path]):
    if isinstance(file, Path):
        file = str(file)
    wf = wave.open(file, "rb")
    if wf.getnchannels() != 1 or wf.getsampwidth() != 2 or wf.getcomptype() != "NONE":
        print("Audio file must be WAV format mono PCM.")
        sys.exit(1)

    model = Model(str(VOSK))
    rec = KaldiRecognizer(model, wf.getframerate())
    rec.SetWords(True)

    while True:
        data = wf.readframes(4000)
        if len(data) == 0:
            break
        rec.AcceptWaveform(data)

    finish = str(rec.FinalResult())
    return finish