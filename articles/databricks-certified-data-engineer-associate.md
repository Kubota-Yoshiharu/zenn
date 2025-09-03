---
title: "Databricks Certified Data Engineer Associate に合格しました(2025年5月)"
emoji: "💯"
type: "idea" # tech: 技術記事 / idea: アイデア
topics: ["Databricks", "データ分析"]
published: true
publication_name: "headwaters"
---

## Databricks Certified Data Engineer Associate について

- データエンジニア
  - **Databricks Certified Data Engineer Associate** ←今回受験した試験
  - Databricks Certified Data Engineer Professional
- データアナリスト
  - Databricks Certified Data Analyst Associate
- ML エンジニア
  - Databricks Certified Machine Learning Associate
  - Databricks Certified Machine Learning Professional
- 生成AIエンジニア
  - Databricks Certified Generative AI Engineer Associate
- その他
  - Databricks Certified Associate Developer for Apache Spark
  - ~~Databricks Certified Hadoop Migration Architect~~ 2024年8月1日に終了

と、役割毎に認定資格が分かれているが、

- Databricks の基礎を身につけられる
- トレーニングやサンプル問題などが多い
- 日本語で受験できる

等の理由で、いずれの役割であっても最初に `Databricks Certified Data Engineer Associate` を受験することが一般的らしい

公式リンク : <https://www.databricks.com/jp/learn/certification/data-engineer-associate>

参考 : [Databricksの認定資格 全部とってみたので体系的にまとめる](https://qiita.com/nttd-saitouyun/items/e7d1ca77e23b8e635518)

## 学習方法

自分は以下の順番で学習したが、人によって順番は変わると思う

### 1. 無料トライアルで環境を構築し、色々触る

[Databricks の公式サイト](https://www.databricks.com/jp) から無料トライアルを開始できる

![](/images/databricks-certified-data-engineer-associate/trial.png)

### 2. Databricks の公式ドキュメントを読む

ドキュメントは AWS, GCP, SAP, Azure で分かれているが、
Databricks Certified Data Engineer Associate の試験範囲ではプラットフォームは影響しないので、どれでもいい

<https://docs.databricks.com/aws/ja/introduction/>
<https://learn.microsoft.com/ja-jp/azure/databricks/introduction/>

### 2. Databricks の Learning Library からコースを受講

- 以下のようにフィルターすると、無料かつ日本語対応のコースだけを絞り込める
  - <https://www.databricks.com/training/catalog?costs=free&levels=associate%2Conboarding%2Cintroductory&languages=JA>
    ![](/images/databricks-certified-data-engineer-associate/learning-library-filter.png)  
- コース内のビデオ音声は英語だが、日本語字幕が表示可能で、資料も日本語になっているため、分かりやすい  
    ![](/images/databricks-certified-data-engineer-associate/Fundamentals.png)
  
### 3. [Databricks の公式 YouTube](https://www.youtube.com/@%E3%83%87%E3%83%BC%E3%82%BF%E3%83%96%E3%83%AA%E3%83%83%E3%82%AF%E3%82%B9%E3%82%B8%E3%83%A3%E3%83%91%E3%83%B3%E6%A0%AA%E5%BC%8F%E4%BC%9A%E7%A4%BE/videos) を視聴

- Learning Library が充実しているため、YouTube を閲覧する必要性は低いが、ログイン不要で閲覧できるので手軽ではある

### 4. インストラクター指導のトレーニングを受講(2日間で計16時間)

- 会社経由で申し込んだため無料で受講できたが、価格を見てみたら $1500 でおったまげた。自費で受ける人も居るんだろうか？
  ![](/images/databricks-certified-data-engineer-associate/training-zoom-1.png)
- 自分は業務都合により計16時間のうちの4時間程度しか受講できなかったが、講師による説明を Zoom で聞きながら、提供されているラボ環境にてノートブックを動かせるため、とても勉強になった
    ![](/images/databricks-certified-data-engineer-associate/training-zoom-2.png)
    ![](/images/databricks-certified-data-engineer-associate/labo1.png)
    演習問題も用意されており、自分の手で実際にクエリを書いて実行することで、記憶に定着しやすく感じた
    ![](/images/databricks-certified-data-engineer-associate/labo2.png)

### 5. データエンジニアアソシエイト試験ガイド を読む

- <https://www.databricks.com/jp/learn/certification/data-engineer-associate> にリンク先が記載されている
  - 試験の出題範囲やサンプル問題(5題)などが記載されている
    - <https://www.databricks.com/sites/default/files/2024-03/databricks-certified-data-engineer-associate-exam-guide.docx_ja.pdf>
        ![](/images/databricks-certified-data-engineer-associate/guides.png)

### 6. 練習問題を解く

- 過去には公式の練習問題が用意されていたのだが、残念ながら現在は実施されておらず、リンクも無効になってしまっている
    ![](/images/databricks-certified-data-engineer-associate/practice-exam-faq.png)
  - なので、Web上に残っていた過去の練習問題と解説を読む
    - [Databricks認定データエンジニアアソシエイト公式練習問題を翻訳&解説してみた](https://qiita.com/kohei-arai/items/5b54a89cbaec801f1972)
    - [Databricks認定データエンジニアアソシエイト公式練習問題 翻訳&解説 質問31以降](https://zenn.dev/m_ando_abc/articles/dc9a6d4ee91d06)
- Udemy で [Databricks Certified Data Engineer Associate Practice Exams](https://www.udemy.com/course/databricks-certified-data-engineer-associate-practice-tests) を購入
  - 自分は試験当日に慌てて模擬試験を解き始めたため、模擬試験が全5個あるうちの3個しか解けなかったのだが、余裕を持って全て解いて周回した方がより確実
  - 英語版を購入し、Google翻訳を使った
    - Google翻訳を使うとこんな感じ
      ![](/images/databricks-certified-data-engineer-associate/udemy.png)
  - 今は Udemy に別の日本語問題集も出ているので、こっちの方がいいかも
    - <https://www.udemy.com/course/databricks-data-engineer-associate-h>

## 自宅で受験する際の注意点

- 会社のPCを使わない方が良いかも
  - 自分は会社のノートPCを使用して自宅受験したところ「SKYSEA Client View を閉じろ」という旨の警告が出たため、タスクマネージャで関連リソースを Kill したが、この対応は本来はあまり良く無いと思われる

## Databricks Certified Data Engineer Associate を受験した感想

- Databricks を業務で触ってはいたが、Databricks に関する知識を網羅的に再確認するきっかけになり、とても良かったと感じた
- ~~次は Data Engineer Professional も受験したい~~
  - **2025/07/15 に Databricks Certified Data Engineer Professional に合格しました！ Associate の時と同じ勉強法でいけました！**
