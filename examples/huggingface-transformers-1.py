from pprint import pprint as pp

from transformers import pipeline
unmasker = pipeline('fill-mask', model='bert-base-uncased')
pp(unmasker("Hello I'm a [MASK] model."))
