---
title: "WSL で local-deep-research を動かす"
emoji: "🌊"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: []
published: false
---

## Local Deep Research について

<https://github.com/LearningCircuit/local-deep-research>

Local Deep Research は

> A powerful AI-powered research assistant that performs deep, iterative analysis using multiple LLMs and web searches.

である。(GitHub の説明をそのまま引用)

日本語に訳すと

> 複数の LLM と Web 検索を使用して詳細な反復分析を実行する 強力な AI 搭載リサーチアシスタント.

といったところ。

要するに、

| AIプラットフォーム | リサーチ機能の名称 |
| ------------------ | ------------------ |
| ChatGPT            | Deep Research      |
| Gemini             | Deep Research      |
| Perplexity         | Deep Research      |
| Grok               | Deep Search        |
| Claude             | Compass (開発中)   |

に相当する機能をローカルのPC上で動かせるツールである
(Grok と Claude は名称が異なるが、簡便のためこの機能は Deep Research と呼ぶものとする)

Deep Research は非常に便利なのだが、以下のような理由で満足に使用できない場合がある

- `ChatGPT`, `Gemini` は月額20ドル程度支払わないと使えない
  - 支払ったとしても回数制限がある
- `Perplexity`, `Grok` は無料でも使えるが、回数制限がある
- セキュリティ上の懸念などにより、社内ルールで ChatGPT などが禁止されている

そういった場合、ローカルで Deep Research を使えると嬉しい

## WSL の Docker で動かす

基本的には
<https://github.com/LearningCircuit/local-deep-research/blob/main/docs/docker-usage-readme.md>
の手順で進めるのだが、WSL の Docker で動かす場合にハマったところがあった。

## Local Deep Research を起動させる

手順の中では

```sh
# Quick Start
docker run --network=host \
  -e LDR_LLM__PROVIDER="ollama" \
  -e LDR_LLM__MODEL="mistral" \
  local-deep-research
```

と記載されているのだが、
`--network=host` オプションは WSL2 経由の Docker Desktop の Linux コンテナではサポートされていないため、
以下のようなコマンドに変える必要がある。

```sh
docker run \
  -p 5000:5000 \
  -e LDR_LLM__PROVIDER="ollama" \
  -e LDR_LLM__MODEL="mistral" \
  local-deep-research
```

## Ollama を起動させる

Local Deep Research を起動しても、自動的に Ollama が使えるようになるわけではないので、
別途で Ollama を起動させておく必要がある。

```sh
sudo vi /etc/wsl.conf
```

これをしておかないと、以下のようなエラーが発生する

```log
yossy:~ $ curl -fsSL https://ollama.com/install.sh | sh
>>> Cleaning up old version at /usr/local/lib/ollama
>>> Installing ollama to /usr/local
>>> Downloading Linux amd64 bundle
######################################################################## 100.0%
>>> Creating ollama user...
>>> Adding ollama user to render group...
>>> Adding ollama user to video group...
>>> Adding current user to ollama group...
>>> Creating ollama systemd service...
WARNING: systemd is not running
WARNING: see https://learn.microsoft.com/en-us/windows/wsl/systemd#how-to-enable-systemd to enable it
>>> The Ollama API is now available at 127.0.0.1:11434.
>>> Install complete. Run "ollama" from the command line.
>>> The Ollama API is now available at 127.0.0.1:11434.
>>> Install complete. Run "ollama" from the command line.
```

```sh
# Ollama をインストール
curl -fsSL https://ollama.com/install.sh | sh
```

以下のようになるはず

```log
yossy:~ $ curl -fsSL https://ollama.com/install.sh | sh
>>> Installing ollama to /usr/local
>>> Downloading Linux amd64 bundle
######################################################################## 100.0%
>>> Adding ollama user to render group...
>>> Adding ollama user to video group...
>>> Adding current user to ollama group...
>>> Creating ollama systemd service...
>>> Enabling and starting ollama service...
Created symlink /etc/systemd/system/default.target.wants/ollama.service → /etc/systemd/system/ollama.service.
>>> The Ollama API is now available at 127.0.0.1:11434.
>>> Install complete. Run "ollama" from the command line.
```

```sh
# Start ollama
ollama serve

# ollama pull deepseek-r1:1.5b
# ollama run deepseek-r1:1.5b

ollama run hf.co/mmnga/cyberagent-DeepSeek-R1-Distill-Qwen-14B-Japanese-gguf

ollama list
ollama show
ollama pull
ollama ps
ollama 
```

```log
Usage:
  ollama [flags]
  ollama [command]

Available Commands:
  serve       Start ollama
  create      Create a model from a Modelfile
  show        Show information for a model
  run         Run a model
  stop        Stop a running model
  pull        Pull a model from a registry
  push        Push a model to a registry
  list        List models
  ps          List running models
  cp          Copy a model
  rm          Remove a model
  help        Help about any command

Flags:
  -h, --help      help for ollama
  -v, --version   Show version information

Use "ollama [command] --help" for more information about a command.
```

```sh
# Stop any running Ollama instance first
sudo systemctl stop ollama
sudo systemctl start ollama

# Start Ollama with external access enabled
OLLAMA_HOST=0.0.0.0 ollama serve
OLLAMA_HOST=0.0.0.0:11434 ollama serve

ollama list
ollama run hf.co/mmnga/cyberagent-DeepSeek-R1-Distill-Qwen-14B-Japanese-gguf


export OLLAMA_DATA_DIR=/path/to/your/ollama/data  # systemctlで使われているパスに合わせる
OLLAMA_HOST=0.0.0.0 OLLAMA_DATA_DIR=/home/yossy/.ollama ollama serve
OLLAMA_HOST=0.0.0.0 OLLAMA_DATA_DIR=/home/yossy/.ollama/models ollama serve

cat /etc/default/ollama

docker run \
  -p 5000:5000 \
  -e LDR_LLM__PROVIDER="ollama" \
  -e LDR_LLM__MODEL="hf.co/mmnga/cyberagent-DeepSeek-R1-Distill-Qwen-14B-Japanese-gguf:latest" \
  local-deep-research


docker run --rm                curlimages/curl curl -v http://your-ollama-ip:11434/api/tags
docker run --rm                curlimages/curl curl -v http://localhost:11434/api/tags
docker run --rm                curlimages/curl curl -v http://127.0.0.1:11434/api/tags
docker run --rm -p 11434:11434 curlimages/curl curl -v http://127.0.0.1:11434/api/tags
docker run --rm --network host curlimages/curl curl -v http://127.0.0.1:11434/api/tags
docker run --rm                curlimages/curl curl -v http://host.docker.internal:11434/api/tags

docker run --rm                curlimages/curl curl -v http://localhost:11434/api/tags

curl -X POST http://localhost:11434/api/tag

curl -X POST http://localhost:11434/api/generate -d '{
  "model": "hf.co/mmnga/cyberagent-DeepSeek-R1-Distill-Qwen-14B-Japanese-gguf:latest",
  "prompt": "こんにちは、Ollama！日本語で返答してください。"
}'

curl -v http://localhost:11434/api/tags


curl -X POST http://localhost:11434/api/generate -d '{
  "model": "hf.co/mmnga/cyberagent-DeepSeek-R1-Distill-Qwen-14B-Japanese-gguf:latest",
  "prompt": "こんにちは、Ollama！日本語で返答してください。"
}'

curl -X POST http://localhost:11434/api/generate -d '{
  "model": "gemma2:2b",
  "prompt": "こんにちは、Ollama！日本語で返答してください。"
}'

curl -X POST http://localhost:11434/api/chat -d '{
  "model": "gemma2:2b",
  "messages": [{"role": "user", "content": "こんにちは、Ollama！日本語で返答してください。"}],
  "stream": false
}'

ollama run  hf.co/mmnga/cyberagent-DeepSeek-R1-Distill-Qwen-14B-Japanese-gguf
ollama run  gemma2:2b
ollama pull lightblue/DeepSeek-R1-Distill-Qwen-7B-Japanese
ollama pull gemma3:4b
ollama run  gemma3:4b

https://ai.google.dev/gemma/docs/integrations/ollama?hl=ja

http://localhost:11434/api/tags
http://localhost:11434/docs

```

WSL で `OLLAMA_HOST=0.0.0.0 ollama serve` を実行すると、以下のようになります。

```log
$ OLLAMA_HOST=0.0.0.0 ollama serve
2025/03/28 15:48:35 routes.go:1230: INFO server config env="map[CUDA_VISIBLE_DEVICES: GPU_DEVICE_ORDINAL: HIP_VISIBLE_DEVICES: HSA_OVERRIDE_GFX_VERSION: HTTPS_PROXY: HTTP_PROXY: NO_PROXY: OLLAMA_CONTEXT_LENGTH:2048 OLLAMA_DEBUG:false OLLAMA_FLASH_ATTENTION:false OLLAMA_GPU_OVERHEAD:0 OLLAMA_HOST:http://0.0.0.0:11434 OLLAMA_INTEL_GPU:false OLLAMA_KEEP_ALIVE:5m0s OLLAMA_KV_CACHE_TYPE: OLLAMA_LLM_LIBRARY: OLLAMA_LOAD_TIMEOUT:5m0s OLLAMA_MAX_LOADED_MODELS:0 OLLAMA_MAX_QUEUE:512 OLLAMA_MODELS:/home/yossy/.ollama/models OLLAMA_MULTIUSER_CACHE:false OLLAMA_NEW_ENGINE:false OLLAMA_NOHISTORY:false OLLAMA_NOPRUNE:false OLLAMA_NUM_PARALLEL:0 OLLAMA_ORIGINS:[http://localhost https://localhost http://localhost:* https://localhost:* http://127.0.0.1 https://127.0.0.1 http://127.0.0.1:* https://127.0.0.1:* http://0.0.0.0 https://0.0.0.0 http://0.0.0.0:* https://0.0.0.0:* app://* file://* tauri://* vscode-webview://* vscode-file://*] OLLAMA_SCHED_SPREAD:false ROCR_VISIBLE_DEVICES: http_proxy: https_proxy: no_proxy:]"
time=2025-03-28T15:48:35.890+09:00 level=INFO source=images.go:432 msg="total blobs: 0"
time=2025-03-28T15:48:35.890+09:00 level=INFO source=images.go:439 msg="total unused blobs removed: 0"
time=2025-03-28T15:48:35.891+09:00 level=INFO source=routes.go:1297 msg="Listening on [::]:11434 (version 0.6.2)"
time=2025-03-28T15:48:35.891+09:00 level=INFO source=gpu.go:217 msg="looking for compatible GPUs"
time=2025-03-28T15:48:41.043+09:00 level=INFO source=gpu.go:377 msg="no compatible GPUs were discovered"
time=2025-03-28T15:48:41.043+09:00 level=INFO source=types.go:130 msg="inference compute" id=0 library=cpu variant="" compute="" driver=0.0 name="" total="11.7 GiB" available="10.6 GiB"
```

WSL の別タブを開き、以下を実行すると、エラーになってしまいます。
原因と対応策を教えてください。

```log
$ docker run --rm curlimages/curl curl -v http://127.0.0.1:11434/api/tags
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0*   Trying 127.0.0.1:11434...
* connect to 127.0.0.1 port 11434 from 127.0.0.1 port 44226 failed: Connection refused
* Failed to connect to 127.0.0.1 port 11434 after 2 ms: Could not connect to server
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
* closing connection #0
curl: (7) Failed to connect to 127.0.0.1 port 11434 after 2 ms: Could not connect to server
```

`curl -v http://localhost:11434/api/tags` を直接実行すると、

```log
$ curl -v http://localhost:11434/api/tags
*   Trying 127.0.0.1:11434...
* Connected to localhost (127.0.0.1) port 11434 (#0)
> GET /api/tags HTTP/1.1
> Host: localhost:11434
> User-Agent: curl/7.81.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json; charset=utf-8
< Date: Fri, 28 Mar 2025 07:10:42 GMT
< Content-Length: 465
<
* Connection #0 to host localhost left intact
{"models":[{"name":"hf.co/mmnga/cyberagent-DeepSeek-R1-Distill-Qwen-14B-Japanese-gguf:latest","model":"hf.co/mmnga/cyberagent-DeepSeek-R1-Distill-Qwen-14B-Japanese-gguf:latest","modified_at":"2025-03-27T22:18:57.425923846+09:00","size":8988111151,"digest":"12c8e38e42da98f1db1b7e52d84834c17215eead23a628db8b8992a74221c253","details":{"parent_model":"","format":"gguf","family":"qwen2","families":["qwen2"],"parameter_size":"14.8B","quantization_level":"unknown"}}]}
```

という実行結果になるのですが、
`docker run --rm curlimages/curl curl -v http://localhost:11434/api/tags` で実行すると

```log
$ docker run --rm curlimages/curl curl -v http://localhost:11434/api/tags
* Host localhost:11434 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0*   Trying [::1]:11434...
* connect to ::1 port 11434 from ::1 port 60996 failed: Connection refused
*   Trying 127.0.0.1:11434...
* connect to 127.0.0.1 port 11434 from 127.0.0.1 port 32932 failed: Connection refused
* Failed to connect to localhost port 11434 after 1 ms: Could not connect to server
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
* closing connection #0
curl: (7) Failed to connect to localhost port 11434 after 1 ms: Could not connect to server
```

でエラーになります。
原因と対応策を教えてください。

docker run --rm curlimages/curl curl -v <http://localhost:11434/api/tags>

```sh
docker run --rm curlimages/curl curl -v http://host.docker.internal:11434/api/tags

```sh
docker run \
  -p 5000:5000 \
  -e OLLAMA_BASE_URL="http://host.docker.internal:11434" \
  -e LDR_LLM__PROVIDER="ollama" \
  -e LDR_LLM__MODEL="hf.co/mmnga/cyberagent-DeepSeek-R1-Distill-Qwen-14B-Japanese-gguf:latest" \
  local-deep-research

ollama run gemma2:2b

docker run \
  -p 5000:5000 \
  -e OLLAMA_BASE_URL="http://host.docker.internal:11434" \
  -e LDR_LLM__PROVIDER="ollama" \
  -e LDR_LLM__MODEL="gemma2:2b" \
  local-deep-research

docker run --rm curlimages/curl curl -v http://host.docker.internal:11434/api/tags

docker run -p 5000:5000 \
  -e OLLAMA_BASE_URL="http://host.docker.internal:11434/api" \
  -e LDR_LLM__PROVIDER="ollama" \
  -e LDR_LLM__MODEL="gemma2:2b" \
  local-deep-research

docker build --no-cache -t local-deep-research .


curl http://localhost:11434/api/tags
curl -v http://host.docker.internal:11434/api/tags

python -c 'import os;os.environ.get("OLLAMA_BASE_URL");'
python -c '"aa";'


```

```py
import os

print(os.environ.get("OLLAMA_BASE_URL"))
```

1. `curl http://localhost:11434/api/tags` は正常に動作しました。

2. `-e OLLAMA_BASE_URL="http://host.docker.internal:11434"` は合っています。
   なぜなら、Dockerから実行する場合には
   `docker run --rm curlimages/curl curl -v http://host.docker.internal:11434/api/tags` のように、`localhost` を `host.docker.internal` に変更する必要があるからです。

3. 11434ポートは他のプロセスでは使用していません。

## GPU

```sh
docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
ollama run gemma2:2b
docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main


docker exec -it 6fe751dea295 bash
ollama pull gemma2:2b
sudo apt install nvtop
nvtop
```

<https://docs.openwebui.com/>

`docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama` で Ollama を立ち上げたのですが、
推論実行時に GPU が使われていないようでした。
原因と対応策を教えてください。

<https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/sample-workload.html>

```sh
sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi
```

を実行すると、NVIDAのドライバに関する情報が適切に出力されました。

```sh
cd ~/.config/local_deep_research
python -m local_deep_research.web.app
```
