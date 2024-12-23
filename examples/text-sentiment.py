import time

from transformers import pipeline

classifier = pipeline(task="zero-shot-classification", model="facebook/bart-large-mnli", device=-1)
print(classifier)

for text in [
        "i'm very happy",
        "i'm very sad",
        "what is this place",
        ]:
    r = classifier(text, ["positive", "negative", "neutral", "question"], multi_label=True)
    d = dict(zip(r["labels"], r["scores"]))
    maxk, maxv = None, 0
    for (k, v) in d.items():
        if v > maxv:
            maxv = v
            maxk = k
    print(r["sequence"], "->", (maxk, maxv), d)


