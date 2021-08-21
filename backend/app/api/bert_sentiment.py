import torch
from transformers import AutoModelForSequenceClassification
from transformers import BertTokenizerFast
from transformers_interpret import SequenceClassificationExplainer


tokenizer = BertTokenizerFast.from_pretrained('blanchefort/rubert-base-cased-sentiment')
model = AutoModelForSequenceClassification.from_pretrained('blanchefort/rubert-base-cased-sentiment', return_dict=True)


def get_sentiment(sample_text):
	@torch.no_grad()
	def predict(text):
		inputs = tokenizer(text, max_length=512, padding=True, truncation=True, return_tensors='pt')
		outputs = model(**inputs)
		predicted = torch.nn.functional.softmax(outputs.logits, dim=1)
		return predicted

	results = predict(sample_text).tolist()
	multiclass_explainer = SequenceClassificationExplainer(model=model, tokenizer=tokenizer)
	word_attributions = multiclass_explainer(text=sample_text)
	predicted_class = multiclass_explainer.predicted_class_name
	return {"predicted_class": predicted_class, "conf": results[0], "word_attributions": word_attributions[1:-1]}