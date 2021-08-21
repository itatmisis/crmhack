from fastapi import FastAPI, Request, File, UploadFile, HTTPException
from loguru import logger
import ujson

from .vosk_api import speech_to_text
from .noise import rate_noise
from ..core.settings import Settings


app = FastAPI(title=Settings().project_name, version=Settings().version, description=Settings().fast_api_description)


# Заглушка на /
@app.get('/')
async def ping():
    return {'ping': 'pong'}


@app.post('/load_wav')
async def load_wav_res(audio_wav: UploadFile = File(...)):
    if audio_wav.content_type != "audio/x-wav":
        raise HTTPException(400, "Wrong content type")

    recognized_text = ujson.loads(speech_to_text(audio_wav.file))
    audio_wav.file.seek(0)
    noise = rate_noise(audio_wav.file)
    logger.info(noise)

    to_return = {"noise": noise, "recognized_text": recognized_text}
    return to_return
