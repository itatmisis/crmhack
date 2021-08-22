from typing import List, Optional

from pydantic import BaseModel


class Word(BaseModel):
    conf: float
    end: float
    start: float
    word: str


class RecognizedText(BaseModel):
    result: Optional[List[Word]]
    text: Optional[str]


class Sentiment(BaseModel):
    predicted_class: Optional[str]
    conf: Optional[List[float]]
    word_attributions: Optional[List[List]]


class TextSpeed(BaseModel):
    speed_class: str
    comment: str
    mean: float


class Politness(BaseModel):
    positive: float
    friendly: float
    clear: float
    formal: float
    average: float


class Noise(BaseModel):
    noise_level: float
    comment: str


class Analysis(BaseModel):
    noise: Optional[Noise]
    politness: Optional[Politness]
    text_speed: Optional[TextSpeed]
    recognized_text: Optional[RecognizedText]
    berd_commas: Optional[str]
    sentiments: Optional[Sentiment]
