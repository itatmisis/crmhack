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


class Analysis(BaseModel):
    noise: Optional[float]
    recognized_text: Optional[RecognizedText]
    berd_commas: Optional[str]
    sentiments: Optional[Sentiment]