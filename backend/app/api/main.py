from fastapi import FastAPI, Request, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from loguru import logger

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


@app.post('/load_wav')
async def load_wav_res(file: UploadFile = File(...)):
    logger.info("{} {} {}", 0, file.content_type, file.filename)
    if file.content_type != "audio/x-wav":
        raise HTTPException(400, "Wrong content type")
    # to something
    pass
    return "Ok"
