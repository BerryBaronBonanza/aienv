import sys
from pprint import pprint as pp
from transformers import pipeline
pipe = pipeline("automatic-speech-recognition", model="Sagicc/whisper-large-v3-sr-cmb", device=0)
pp(pipe(sys.argv[1]))
