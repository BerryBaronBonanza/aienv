#!/usr/bin/env bash

export CTX="$1"

case "$M" in
    1) m=codellama:13b-instruct-q8_0;;
    2) m=deepseek-coder:6.7b-instruct;;
    3) m=stable-code:latest;;
    4) m=starcoder2:latest;;
    5) m=wizardcoder:latest;;
    6) m=mistral:latest;;
    7) m=deepseek-coder:33b;;
    8) m=gemma:latest;;
    9) m=nous-hermes2:latest;;
    10) m=zephyr:latest;;
    *) m="codellama:13b-instruct-q8_0";;
esac

[ "$2" = "" ] && q="$(cat)" || q="$2"
echo "$q"

jqq () {
    jq -n --arg m "$m" --arg q "$q$CTX" '{
  "model": $m,
  "prompt": $q,
  "stream": false
}' | tee t
}

if [ "$TMUX" = "" ]; then
    curl -s http://localhost:11434/api/generate -d "$(jqq)" | jq -r .response
else
    echo "$q$CTX" > /tmp/llm.in
    tmux split-window -v sh -c "`which ollama` run \"$m\" < /tmp/llm.in | tee /tmp/llm.out; tmux wait -S llm"
    tmux wait llm
    dos2unix -q /tmp/llm.out
    cat /tmp/llm.out
fi

