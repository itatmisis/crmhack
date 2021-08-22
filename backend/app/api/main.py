import subprocess as sp
from io import BytesIO

from fastapi import FastAPI, Request, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from loguru import logger
import ujson
from pydantic import BaseModel

from .vosk_api import speech_to_text
from .noise import rate_noise
from .bert_pred import berd_predict
from .bert_sentiment import get_sentiment
from .text_speed import average_speed
from .network_evolution_inf import generate_gif
from .models import Analysis

from ..core.settings import Settings


app = FastAPI(title=Settings().project_name, version=Settings().version, description=Settings().fast_api_description)

# FIXME: менять в проде allow_origins на локальные!
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Заглушка на /
@app.get('/')
async def ping():
    return {'ping': 'pong'}


# TODO сделать переход в одноканальный звук по дефолту
@app.post('/load_audio', response_model=Analysis)
async def load_audio_res(request: Request, audio: UploadFile = File(...)):
    logger.info("Request from: {}", request.client.host)
    """
    На вход подавать только wav.
    Анализирует аудиофайл на:
    - Зашумленность, поле noise, float, от 0 до 1(больше - хуже)
    - Переводит в текст, поле recognized_text, conf - уверенность модели в том, что слово - слово, время в абсолютных
    - Добавляет тексту запятые, berd_commas
    значениях.
    """
    p = sp.Popen(["ffmpeg", "-ac", "1", "-hide_banner", "-loglevel", "error", "-i", "-", '-f', 'wav', "-"], stdin=audio.file,
                 stdout=sp.PIPE)

    audio_wav = BytesIO(p.stdout.read())

    recognized_text = ujson.loads(speech_to_text(audio_wav))
    audio_wav.seek(0)

    text_speed = average_speed(recognized_text)


    noise = rate_noise(audio_wav)
    berd_commas = berd_predict([recognized_text['text']])[0]
    sentiments = get_sentiment(berd_commas)

    to_return = {"noise": noise, "text_speed": text_speed, "recognized_text": recognized_text, 'berd_commas': berd_commas,
                 "sentiments": sentiments}
    logger.info("Request done from: {}", request.client.host)
    return to_return


@app.get('/graph_generate_gif')
async def graph_generate_gif_res(request: Request):
    filename = generate_gif()
    return FileResponse(filename)
