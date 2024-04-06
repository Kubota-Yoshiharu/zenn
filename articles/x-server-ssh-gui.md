---
title: "Linuxの画面をSSHでWindowsに転送する"
emoji: "📻"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["VcXsrv", "SSH", "PowerShell", "Windows Terminal"]
published: false
publication_name: "headwaters"
---

## 使用するツール

- VcXsrv
- OpenSSH
- PowerShell
- Windows Terminal

## 0. 前提

- Windows に OpenSSH がインストールされている
- 対象の Linux と SSH で接続できる状態になっている

```log
C:\Windows\system32> Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'

Name  : OpenSSH.Client~~~~0.0.1.0
State : Installed
```

インストールされてない場合は <https://learn.microsoft.com/ja-jp/windows-server/administration/openssh/openssh_install_firstuse> の手順でインストールしておく

## 1. VcXsrv をインストール

[VcXsrv のインストール（Windows 上）](https://www.kkaneko.jp/tools/win/vcxsrv.html) の手順を参考にインストールし、起動する

## 2. 環境変数DISPLAYを設定

```powershell
[System.Environment]::SetEnvironmentVariable("DISPLAY", "localhost:0.0", "User")
exit
```

## 3. SSH で接続

```powershell
# 通常の SSH 接続
ssh      yossy@yossy-Ubuntu-desktop.local

# X11 転送を有効にして SSH 接続
ssh -AXY yossy@yossy-Ubuntu-desktop.local
```

| オプション | 説明                          |
| ---------- | ----------------------------- |
| -A         | エージェント転送を有効にする  |
| -X         | X11転送を有効にする           |
| -Y         | 信頼されたX11転送を有効にする |

オプションの詳細は <https://man.openbsd.org/ssh> を参照

Linux の GUI アプリが Windows 側に表示されれば成功

![xeyes](/images/x-server-ssh-gui/xeyes.gif)

## 参考

- <https://portal.isee.nagoya-u.ac.jp/stel-it/doku.php?id=public:win10_openssh>
- [SSH接続経由でLinuxデスクトップアプリケーションを使いたい](https://www.u.tsukuba.ac.jp/ufaq/ssh%E6%8E%A5%E7%B6%9A%E7%B5%8C%E7%94%B1%E3%81%A7linux%E3%83%87%E3%82%B9%E3%82%AF%E3%83%88%E3%83%83%E3%83%97%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%92%E4%BD%BF/)
