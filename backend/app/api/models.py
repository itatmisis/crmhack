from typing import List

from pydantic import BaseModel


class Word(BaseModel):
    conf: float
    end: float
    start: float
    word: str


class RecognizedText(BaseModel):
    result: List[Word]
    text: str


# class WordSentiment(BaseModel):
#     word: str
#     conf: float


class Sentiment(BaseModel):
    predicted_class: str
    conf: List[float]
    word_attributions: List[List]


class Analysis(BaseModel):
    noise: float
    recognized_text: RecognizedText
    berd_commas: str
    sentiments: Sentiment
