
positive_vocab = ['здравствуйте', 'свидания', 'хорошего', 'приятно', 'хорошо', 'вы', 'вас']
positive_vocab_koef = 5
negative_vocab = ['извините', 'простите', 'прощения', 'жаль']
negative_vocab_koef = 1.2
clear_vocab = ['типа', 'бы', 'итак', 'короче', 'таки', 'вот', 'честно', 'говоря', 'общем', 'самое', 'принципе']
clear_vocab_koef = 7
formal_vocab = ['ты', 'тобой', 'приветствую', 'знаешь', 'помнишь', 'будешь']
formal_vocab_koef = 15


# здравствуйте до свидания - позитивная
# извините простите сожалею обидеть (вина) - негативная (+ позитивная)
# паузы, слова-паразиты - чистота речи
# ты, вы - формальность речи
def average_politeness(data: dict):
    words = data["result"]
    word_count = len(words)

    result = {'positive': sum(x['word'] in positive_vocab for x in words) * positive_vocab_koef / word_count,
              'friendly': (sum(x['word'] in positive_vocab for x in words) - negative_vocab_koef * (sum(
                  x['word'] in negative_vocab for x in words))) * (positive_vocab_koef + 0.2) / word_count,
              'clear': 1 - 0.1 * (clear_vocab_koef / word_count) * sum(x['word'] in clear_vocab for x in words),
              'formal': 1 - 0.1 * (formal_vocab_koef / word_count) * sum(x['word'] in formal_vocab for x in words),
              'average': 0}

    for key in result.keys():
        if result[key] > 1:
            result[key] = 1
        if result[key] < 0:
            result[key] = 0
    result['average'] = (result['positive'] + result['friendly'] + result['clear'] + result['formal']) / 4
    return result
