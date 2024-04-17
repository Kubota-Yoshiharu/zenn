---
title: "Jetson Orin Nano で日本語LLMを動かしてみた"
emoji: "👋"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["nvidia", "jetson", "llm"]
published: false
publication_name: "headwaters"
---

必要なデバイス

- Jetson Orin Nano Developer Kit 8GB
- Ubuntu 20.04 がインストールされているPC
- NVMe SSD

## 0. 前準備

- <https://www.jetson-ai-lab.com/tutorial_text-generation.html>

を読むと

>preferably with NVMe SSD  
とのことなので、[SDK Manager](https://developer.nvidia.com/sdk-manager) を使用して、NVMe SSD に OS をインストールする

JetPack 6.x の最新版は JetPack 6.0 Developer Preview で、まだ不安定なので、  
JetPack 5.1.3 をインストールするものとする
JetPack 5.x をインストールするには Ubuntu 20.04 が必要なので、事前に用意しておくこと

![alt text](/images/jetson-orin-nano-llm/JetPack-Support.png)

※Ubuntu 22.04 だと JetPack 6.x しかサポートされていないので注意

## 1. Jetson OS と Jetson SDK をインストール

- <https://developer.nvidia.com/sdk-manager>
- <https://docs.nvidia.com/sdk-manager/download-run-sdkm/index.html>
- <https://docs.nvidia.com/sdk-manager/install-with-sdkm-jetson/index.html>

1. Jetson Orin Nano に NVMe SSD を取り付ける

    ![](/images/jetson-orin-nano-llm/NVMe-SSD.jpg)

    使用した NVMe SSD  
    <https://www.amazon.co.jp/gp/product/B0B56X29BK/ref=ppx_yo_dt_b_asin_title_o06_s00?ie=UTF8&psc=1>

    もし別の用途に使用していた NVMe SSD を使用する場合は、nvme-cli で初期化しておく  
    後述の手順で OS をインストールする際に上手くいかない場合、nvme-cli で初期化しておくことで解決する場合がある  

    ```sh
    # nvme-cli をインストール
    sudo apt install && sudo apt install -y nvme-cli

    # 初期化対象のデバイスを確認
    sudo fdisk -l

    # 実行例
    nvme format /dev/nvme0
    ```

1. Jetson Orin Nano にジャンパピンを接続

    Force Recovery Mode にするためにジャンパピンを接続  
    ![](/images/jetson-orin-nano-llm/Force-Recovery-Mode.png)  
    <https://developer.nvidia.com/embedded/learn/jetson-orin-nano-devkit-user-guide/howto.html>

    ジャンパピン接続前(赤枠のピンにジャンパピンを接続)  
    ![](/images/jetson-orin-nano-llm/jumper-pin-1.jpg)  

    ジャンパピン接続後  
    ![](/images/jetson-orin-nano-llm/jumper-pin-2.jpg)

    使用したジャンパピン
    <https://www.amazon.co.jp/gp/product/B00076YM1K/ref=ppx_yo_dt_b_asin_title_o01_s01?ie=UTF8&psc=1>

1. Jetson Orin Nano と PC を USB-C ケーブルで接続

1. Jetson Orin Nano に電源ケーブルを挿して、起動

1. Ubuntu 20.04 が Jetson Orin Nano を認識していることを確認

    ```log
    $ lsusb
    Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
    Bus 001 Device 003: ID 25a7:fa61 Compx 2.4G Receiver
    Bus 001 Device 004: ID 8087:0026 Intel Corp.
    Bus 001 Device 002: ID 0955:7523 NVIDIA Corp. APX
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    ```

1. SDK Manager をインストールし、JetPack 5.1.3 をインストール

    ![](/images/jetson-orin-nano-llm/JetPack-install-1.png)  
    ![](/images/jetson-orin-nano-llm/JetPack-install-2.png)  

    以下のようなダイアログが表示されたら、Jetson Orin Nano は既に起動した状態になっているので、  
    Jetson Orin Nano にモニターを接続し、
    初期セットアップを行った後、LANケーブルを接続した状態で、  
    `hostname -I` をターミナルで実行し、IPアドレスを確認して、こちらのダイアログに入力する  

    ※以下はスクショを撮り忘れたため、公式ドキュメントの画像を使用
    ![](https://docs.nvidia.com/sdk-manager/_images/jetson-external-storage.png)  

## 2. Jetson Orin Nano の RAM の最適化

- <https://www.jetson-ai-lab.com/tips_ram-optimization.html>

LLM を実行するには大量の RAM を必要とするため、不要なサービス等を無効化しておく

```sh
# GUI を無効化
sudo systemctl set-default multi-user.target

# その他のサービスを無効化
sudo systemctl disable nvargus-daemon.service

# swap をマウント
sudo systemctl disable nvzramconfig
sudo fallocate -l 16G /ssd/16GB.swap
sudo mkswap /ssd/16GB.swap
sudo swapon /ssd/16GB.swap
sudo vi /etc/fstab
```

/etc/fstab の末尾に次の行を追加

```txt
/ssd/16GB.swap  none  swap  sw 0  0
```

```sh
sudo reboot
```

## 3. text-generation-webui で日本語LLMを動かす

- <https://www.jetson-ai-lab.com/tutorial_text-generation.html>
- [Llama 2をJetson Orin Nanoで起動してみる](https://qiita.com/vfuji/items/4618d78d2cb6964c67a1)

コンテナが用意されているので、以下のコマンドを実行するだけで text-generation-webui が立ち上がる

```sh
git clone https://github.com/dusty-nv/jetson-containers
bash jetson-containers/install.sh
jetson-containers run $(autotag text-generation-webui)
```

<https://www.jetson-ai-lab.com/tutorial_text-generation.html#model-size-tested>
によると、Jetson Orin Nano では 7B model までは動作するとのことだが、  
記載されている手順で `llama-2-7b-chat.Q4_K_M.gguf` をダウンロード後にロードすると、落ちてしまった  
こちらの方も同様の事象が発生した模様  
<https://qiita.com/vfuji/items/4618d78d2cb6964c67a1#webui%E3%81%AE%E5%AE%9F%E8%A1%8C%E3%81%A8%E3%83%A2%E3%83%87%E3%83%AB%E3%81%AE%E8%A8%AD%E5%AE%9A>  
こちらに記載されているコンパクトなモデルは動作した

別のモデルとして、日本語のLLMの
`mmnga/ELYZA-japanese-Llama-2-7b-fast-instruct-gguf`  
`ELYZA-japanese-Llama-2-7b-fast-instruct-q3_K_M.gguf` を動かしてみたが、こちらの性能はかなりイマイチ...

## 以下のToDoを実施したら記事を投稿する

- [ ] Docker を起動する際のオプションを変更することで重いモデルを動かせるか検証
- [ ] 軽くて高性能なモデルが出てきたら、試してみる

## 動作検証したモデルのメモ

```txt
llama-2-7b-chat.Q4_K_M.gguf
llama-2-7b-chat.Q4_K_M.gguf

TheBloke/Llama-2-7b-Chat-GGUF
TheBloke/Tinyllama-2-1b-miniguanaco-GGUF

ELYZA-japanese-Llama-2-7b-fast-instruct-q40
ELYZA-japanese-Llama-2-7b-fast-instruct-gguf

https://huggingface.co/mmnga/ELYZA-japanese-Llama-2-7b-fast-instruct-gguf
mmnga/ELYZA-japanese-Llama-2-7b-fast-instruct-gguf
ELYZA-japanese-Llama-2-7b-fast-instruct-q4_K_M.gguf

ELYZA-japanese-Llama-2-7b-fast-instruct-q3_K_M.gguf

TheBloke/calm2-7B-chat-GGUF
calm2-7b-chat.Q3_K_M.gguf
calm2-7b-chat.Q3_K_S.gguf

TheBloke/japanese-stablelm-instruct-gamma-7B-GGUF
japanese-stablelm-instruct-gamma-7b.Q3_K_S.gguf
japanese-stablelm-instruct-gamma-7b.Q2_K.gguf
```
