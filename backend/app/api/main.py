import subprocess as sp
from io import BytesIO
from typing import List

from fastapi import FastAPI, Request, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from loguru import logger
import ujson
from pydantic import BaseModel

from .vosk_api import speech_to_text
from .noise import rate_noise
# from .bert_pred import berd_predict
from ..core.settings import Settings


app = FastAPI(title=Settings().project_name, version=Settings().version, description=Settings().fast_api_description)
# FIX_ME: менять в проде allow_origins на локальные!
app.add_middleware(
    CORSMiddleware,
    allow_origins="*",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Заглушка на /
@app.get('/')
async def ping():
    return {'ping': 'pong'}


class PartialResult(BaseModel):
    conf: float
    end: float
    start: float
    word: str


class RecognizedText(BaseModel):
    result: List[PartialResult]
    text: str


class Analysis(BaseModel):
    noise: float
    recognized_text: RecognizedText
    berd_commas: str


# TODO сделать переход в одноканальный звук по дефолту
@app.post('/load_audio', response_model=Analysis)
async def load_audio_res(audio_webm: UploadFile = File(...)):
    """
    На вход подавать только wav.
    Анализирует аудиофайл на:
    - Зашумленность, поле noise, float, от 0 до 1(больше - хуже)
    - Переводит в текст, поле recognized_text, conf - уверенность модели в том, что слово - слово, время в абсолютных
    - Добавляет тексту запятые, berd_commas
    значениях.
    """
    p = sp.Popen(["ffmpeg", "-hide_banner", "-loglevel", "error", "-i", "-", '-f', 'wav', "-"], stdin=audio_webm.file,
                 stdout=sp.PIPE)

    audio_wav = BytesIO(p.stdout.read())

    recognized_text = ujson.loads(speech_to_text(audio_wav))
    audio_wav.seek(0)
    noise = rate_noise(audio_wav)
    # berd_commas = berd_predict([recognized_text['text']])

    to_return = {"noise": noise, "recognized_text": recognized_text, }#'berd_commas': berd_commas}
    logger.info("Request Done")
    return to_return
