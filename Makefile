
OPENTERM ?= "alacritty -e"

PHONY: list

list:
	@LC_ALL=C $(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | grep -E -v -e '^[^[:alnum:]]' -e '^$@$$' 

graph.png: Makefile
	make -Bnd $(echo $(make list)) | make2graph | dot -Tpng > $@

install: python-install rust-install julia-install

# prog langs

.venv:
	python -m venv .venv

python-install: .venv
	#pip install -r pip.freeze
	./pip-install-deps

rust-install:
	rustup default stable
	rustup update
	rustup component add rust-analyzer

pixi-install: rust-install
	cargo install --locked --git https://github.com/prefix-dev/pixi.git

julia-install:
	julia --project -e 'import Pkg; Pkg.instantiate()'

# ollama

ollama-1-serve:
	pgrep -f '^ollama serve' || { eval $(OPENTERM) ollama serve & sleep 3; }
ollama-2-docs:
	xdg-open https://github.com/ollama/ollama
	xdg-open https://ollama.com/library
ollama-3-llama2:
	ollama run llama2
ollama-4-misc:
	ollama list 
	ollama pull mistral
	ollama show mistral

# piper

models/piper-voices:
	git clone https://huggingface.co/rhasspy/piper-voices $@
	(cd $@ && git lfs install && git lfs pull)

piper-1-en: models/piper-voices
	{ echo '{"text":"hello people of planet earth! we come in peace!"}'; } | piper --model $</en/en_US/amy/medium/en_US-amy-medium.onnx --json-input --output-raw -s 1 --length_scale 1.3 | aplay -r 22050 -f S16_LE -t raw -

piper-2-sr: models/piper-voices
	{ echo '{"text":"zdravo ljudi sa planete zemlje! mi dolazimo u miru!"}'; } | piper --model $</sr/sr_RS/serbski_institut/medium/sr_RS-serbski_institut-medium.onnx --json-input --output-raw -s 1 --length_scale 1.0 | aplay -r 22050 -f S16_LE -t raw -

# whisper

WHISPER_MODEL=tiny.en

models/whisper/ggml-$(WHISPER_MODEL).bin:
	(mkdir -p models/whisper && cd models/whisper && whisper-cpp-download-ggml-model $(WHISPER_MODEL))

whisper-1-talk-with-llm: models/whisper/ggml-$(WHISPER_MODEL).bin #ollama-1-serve
	examples/whisper-1-talk-with-llm $<

# fluxml

models/fluxml/model-zoo:
	git clone https://github.com/FluxML/model-zoo $@

fluxml-1-mnist: models/fluxml/model-zoo
	(cd $</vision/conv_mnist && julia -t4 --project -e 'import Pkg; Pkg.instantiate()' && julia --project conv_mnist.jl)

# pytorch

models/pytorch/examples:
	git clone https://github.com/pytorch/examples $@

pytorch-1-mnist: models/pytorch/examples
	(cd $</mnist && python main.py)

# python-transformers

python-transformers-1-bert: 
	python examples/huggingface-transformers-1.py

# candle

models/candle:
	git clone https://github.com/huggingface/candle $@

candle-1-mnist: models/candle
	(cd $< && cargo run --example mnist-training --features candle-datasets,cuda)

candle-2-stable-diffusion: models/candle
	(cd $< && cargo run --example stable-diffusion --release --features=cuda,cudnn -- --prompt "a cosmonaut on a horse (hd, realistic, high-def)" --sd-version v1-5 --width=512 --height=512)

# spacy

spacy-1-docs-get-started:
	xdg-open https://spacy.io/usage/spacy-101

spacy-2-tokenization:
	python examples/spacy-tokenization.py

# whisper-serbian

whisper-serbian-1-intro:
	xdg-open https://milutinbojic.org.rs/vesti/digitalna-novo/asr-whisper-serbian

data/serbian-speech.wav:
	mkdir -p data
	ffmpeg -y -i https://upload.wikimedia.org/wikipedia/commons/a/a8/Bioinformatika.ogg -ac 1 -ar 16000 $@

whisper-serbian-2-transcribe: data/serbian-speech.wav
	python examples/$@.py $<

whisper-serbian-3-transcribe-faster: data/serbian-speech.wav
	python examples/$@.py $<

