from typing import List

from ..third_party.bert_punctuation import Bert_punctuation

Bert_punctuation = Bert_punctuation()


def berd_predict(to_predict: List[str]):
    sents_punctuation = Bert_punctuation.predict(to_predict)
    return sents_punctuation