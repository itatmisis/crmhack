from fastapi import FastAPI, Request

from ..core.settings import Settings

app = FastAPI(title=Settings().project_name, version=Settings().version, description=Settings().fast_api_description)


# Заглушка на /
@app.get('/')
def ping():
    return {'ping': 'pong'}