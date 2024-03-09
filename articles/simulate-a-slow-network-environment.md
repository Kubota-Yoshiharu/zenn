---
title: "ネットワークが劣悪な環境を再現する方法"
emoji: "🤖"
type: "tech"
topics: ["Android","Network", "Test"]
published: true
publication_name: "headwaters"
---

## 目的

アプリケーションが通信に失敗した際のテストを行いたい
例. 「通信に失敗した場合に再取得ボタンが表示されること」など

![alt text](/images/simulate-a-slow-network-environment/network-error-example.png)

### 方法1. Chrome DevTools を使う

<https://developer.chrome.com/docs/devtools/network/reference?hl=ja#throttling>

任意の設定を追加して使用することができる

![alt text](/images/simulate-a-slow-network-environment/slot.png)
![alt text](/images/simulate-a-slow-network-environment/DevTools.png)

メリット

- PCとモバイルデバイスの両方で使用可能
- 新規にアプリケーションをインストールする必要が無い

デメリット

- パケロス率などを設定できない
- Android, iOS のネイティブアプリでは使用できない

### 方法2. Network Link Conditioner を使用する

Network Link Conditioner は Apple が提供しているネットワークユーティリティツール

使用手順等は以下のサイトが分かりやすい

- [【Tips】Macで帯域制限をかけて通信速度を下げるテストがしたい](https://kingmo.jp/kumonos/reduce-bandwidth-speed-limiting-mac/)
- [Androidの通信速度を制限してアプリのテストを行う](https://www.gesource.jp/weblog/?p=8813)

iOSであれば開発者ツールで使用可能らしいが、
自分の場合はメイン開発機がWindows、テスト対象端末がAndroidだったため、
以下のような構成でテストを行った

![alt text](/images/simulate-a-slow-network-environment/network.drawio.png)

同一のWi-Fiに接続すれば、メイン開発機のネットワーク速度を損ねずにデバッグ等を行うことができて便利

![alt text](/images/simulate-a-slow-network-environment/remote.png)

### 方法3. 物理的に頑張る

以下のような方法で物理的にネットワーク環境を悪化させる

- Wi-Fiルータにアルミホイルを巻く
  ![alt text](/images/simulate-a-slow-network-environment/Wi-Fi_Router.jpg)

- モバイルWi-Fiルータを金属製の缶の中に入れて、アルミホイルで巻く
  ![alt text](/images/simulate-a-slow-network-environment/mobile_Wi-Fi-kan.jpg)

- ノートPCとAndroid端末を風呂場やトイレに持ち込んでテストする
  ![alt text](/images/simulate-a-slow-network-environment/bath.jpg)

メリット

- 特別なソフトや知識が無くてもできる

デメリット

- 「アルミホイルが無くなってるんだけど！？！？？？」と家族に怒られる
- 良い塩梅にネットワークを悪くするのが難しい
- 俺は一体何をやってるんだろう...という気持ちになる
