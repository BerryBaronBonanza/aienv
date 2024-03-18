import sys
from faster_whisper import WhisperModel
model = WhisperModel("Sagicc/faster-whisper-large-v3-sr", device='cpu')
segments, info = model.transcribe(sys.argv[1])
for segment in segments:
    print("[%.2fs -> %.2fs] %s" % (segment.start, segment.end, segment.text))

