from typing import List

from pydantic import BaseModel


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