---
title: "Azure AI Foundry でRAGの精度を評価する"
emoji: "🐕"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["Azure", "aifoundry"]
published: false
publication_name: "headwaters"
---

## Azure AI Foundry について

Azure AI Foundry は2024年11月19日に「Microsoft Ignite 2024」で発表された。  
Azure AI Studio の名前が変わって、  
Azure AI Foundry になり、AI関連の各種サービスが統合された形。  
Azure AI Foundry を活用することでシステムプロンプトの変更や自動評価などを行うことができる。

## 公式ドキュメント

- <https://learn.microsoft.com/ja-jp/azure/ai-studio/what-is-ai-studio>
- <https://learn.microsoft.com/ja-jp/azure/ai-studio/concepts/retrieval-augmented-generation>

## 必要な作業

- AI Search にインデックスを作成
- AI Foundry のリソース作成
- プレイグラウンドでRAGの動作確認
- AI Searchに登録するドキュメント類の準備
- ドキュメントに対する質問とGroundTruthの準備

## AI Search にインデックスを作成

Azure AI Foundry の中からインデックスを作成することも可能なのだが、  
挙動が不安定で正常に動作しない場合が多々あるため、  
インデックスは事前に作成しておくことを推奨する。

ストレージアカウントを作成し、コンテナの中にドキュメントを格納しておく。  
今回は、AWSが公開しているRAG用サンプルデータを使用した。

- [kintai.pdf](https://ws-assets-prod-iad-r-nrt-2cb4b4649d0e0f94.s3.ap-northeast-1.amazonaws.com/9748a536-3a71-4f0e-a6cd-ece16c0e3487/rag-data/kintai.pdf) (勤怠管理システム入力方法マニュアル)
- [information-system-dept.pdf](https://ws-assets-prod-iad-r-nrt-2cb4b4649d0e0f94.s3.ap-northeast-1.amazonaws.com/9748a536-3a71-4f0e-a6cd-ece16c0e3487/rag-data/information-system-dept.pdf) (情報システム部門の Wiki)

AI Search の 概要 から データのインポートとベクター化 を選択

![alt text](/images/azure-ai-foundry-rag/image-37.png)  
![alt text](/images/azure-ai-foundry-rag/image-38.png)  

インデックスが正常に作成され、検索が行えることを確認

![alt text](/images/azure-ai-foundry-rag/image-39.png)  

### 補足

上記の手順でExcelの表を取り込むことができる  
ファイルを追加する場合、Blobストレージにアップロードして、インデクサーを再実行すれば良い  
![alt text](/images/azure-ai-foundry-rag/image-7.png)  
![alt text](/images/azure-ai-foundry-rag/image-8.png)  
![alt text](/images/azure-ai-foundry-rag/image-9.png)  
![alt text](/images/azure-ai-foundry-rag/image-10.png)  

## AI Foundry のリリース作成など

1. リソースの作成

    ![alt text](/images/azure-ai-foundry-rag/image.png)

    リージョンは`East US 2`にした。  
    `Japan East`等だと新しめの機能やモデルが使えない場合もあるので、  
    `EAST US`, `EAST US2`, `Sweden Central` あたりから選ぶのが無難。

    参考  
    [Azure OpenAI Service モデル - デプロイの種類別モデル](https://learn.microsoft.com/ja-jp/azure/ai-services/openai/concepts/models?tabs=python-secure%2Cglobal-standard%2Cstandard-chat-completions#models-by-deployment-type)

    ![alt text](/images/azure-ai-foundry-rag/image-1.png)

2. Azure AI Foundry を起動

    Azure AI Foundry に改名して日が浅いせいか、  
    Azure AI Studio という記述がところどころ残っている。  
    ![alt text](/images/azure-ai-foundry-rag/image-2.png)

    初回起動時はプロジェクトの作成を求められるので、適当な名前を付ける。  
    ※次回以降、既にプロジェクトを作成済の状態でもダイアログが表示されるが、その場合はキャンセルし、作成済のプロジェクトを選択すること  
    ![alt text](/images/azure-ai-foundry-rag/image-3.png)

3. モデルを展開

    今回は gpt-4o-mini を選択
    ![alt text](/images/azure-ai-foundry-rag/image-4.png)  
    ![alt text](/images/azure-ai-foundry-rag/image-5.png)  
    ![alt text](/images/azure-ai-foundry-rag/image-6.png)  

## RAG プレイグラウンド

作成したインデックスを指定することで、RAGが正常に動作することを確認する

入力

```txt
有給休暇の申請方法を教えて
```

想定の回答

```md
1. 勤怠管理システム ( https://kintai.example.com/) にアクセス
2. メインメニューから休暇申請のセクションを選択し、「有給休暇」のオプションをクリック
3. 新規申請を選び、申請日、休暇取得日、休暇終了日、および休暇の理由を入力
4. 詳細が必要な場合は、コメント欄に追記し、「申請」ボタンをクリック
```

想定の回答と実際の回答がおおよそ一致しており、RAGが正常に動作していることが確認できる。  
![alt text](/images/azure-ai-foundry-rag/image-40.png)

## プロンプトフロー

プロンプトフローを活用することで、RAGに関連する挙動をカスタマイズ、出力の確認、精度評価などがお手軽に行える。

参考サイト  
[Azure AI Studio Prompt flow によるプロンプトのテストと評価ハンズオン③ - RAG](https://qiita.com/nohanaga/items/9cda65aee671b0b2ef74)

参考サイトの手順ではシステムプロンプトの変更が最小限だったため、  
今回、AWSのサンプルを真似たシステムプロンプトに変更している。  
<https://github.com/aws-samples/generative-ai-use-cases-jp/blob/70fe6884778b6ebf9133e3dfd09769b1756467aa/packages/web/src/prompts/claude.ts#L160>

```ts
`あなたはユーザの質問に答えるAIアシスタントです。
以下の手順でユーザの質問に答えてください。手順以外のことは絶対にしないでください。

<回答手順>
* <参考ドキュメント></参考ドキュメント>に回答の参考となるドキュメントを設定しているので、それを全て理解してください。なお、この<参考ドキュメント></参考ドキュメント>は<参考ドキュメントのJSON形式></参考ドキュメントのJSON形式>のフォーマットで設定されています。
* <回答のルール></回答のルール>を理解してください。このルールは絶対に守ってください。ルール以外のことは一切してはいけません。例外は一切ありません。
* チャットでユーザから質問が入力されるので、あなたは<参考ドキュメント></参考ドキュメント>の内容をもとに<回答のルール></回答のルール>に従って回答を行なってください。
</回答手順>

<参考ドキュメントのJSON形式>
{
"SourceId": データソースのID,
"DocumentId": "ドキュメントを一意に特定するIDです。",
"DocumentTitle": "ドキュメントのタイトルです。",
"Content": "ドキュメントの内容です。こちらをもとに回答してください。",
}[]
</参考ドキュメントのJSON形式>

<参考ドキュメント>
[
${params
  .referenceItems!.map((item, idx) => {
    return `${JSON.stringify({
      SourceId: idx,
      DocumentId: item.DocumentId,
      DocumentTitle: item.DocumentTitle,
      Content: item.Content,
    })}`;
  })
  .join(',\n')}
]
</参考ドキュメント>

<回答のルール>
* 雑談や挨拶には応じないでください。「私は雑談はできません。通常のチャット機能をご利用ください。」とだけ出力してください。他の文言は一切出力しないでください。例外はありません。
* 必ず<参考ドキュメント></参考ドキュメント>をもとに回答してください。<参考ドキュメント></参考ドキュメント>から読み取れないことは、絶対に回答しないでください。
* 回答の文末ごとに、参照したドキュメントの SourceId を [^<SourceId>] 形式で文末に追加してください。
* <参考ドキュメント></参考ドキュメント>をもとに回答できない場合は、「回答に必要な情報が見つかりませんでした。」とだけ出力してください。例外はありません。
* 質問に具体性がなく回答できない場合は、質問の仕方をアドバイスしてください。
* 回答文以外の文字列は一切出力しないでください。回答はJSON形式ではなく、テキストで出力してください。見出しやタイトル等も必要ありません。
</回答のルール>
`
```

これをプロンプトフローに入れ込む

![alt text](/images/azure-ai-foundry-rag/image-36.png)

```py
from typing import List
from promptflow import tool
from promptflow_vectordb.core.contracts import SearchResultEntity


@tool
def generate_prompt_context(search_result: List[dict]) -> str:
    def format_doc(doc: dict):
        return f"""
        {{
            "text": "{doc['text']}",
            "metadata": {doc['metadata']},
            "additional_fields": {doc['additional_fields']},
            "score": {doc['score']}
        }}
        """

    retrieved_docs = []
    for item in search_result:
        entity = SearchResultEntity.from_dict(item)
        content = entity.text or ""

        retrieved_docs.append(
            {
                "text": content,
                "metadata": item.get("metadata", {}),
                "additional_fields": item.get("additional_fields", {}),
                "score": item.get("score", 0),
            }
        )
    doc_string = ",\n".join([format_doc(doc) for doc in retrieved_docs])
    return f"[{doc_string}]"
```

![alt text](/images/azure-ai-foundry-rag/image-41.png)

```ts
# system:
あなたはユーザの質問に答えるAIアシスタントです。
以下の手順でユーザの質問に答えてください。手順以外のことは絶対にしないでください。

<回答手順>
* <参考ドキュメント></参考ドキュメント>に回答の参考となるドキュメントを設定しているので、それを全て理解してください。なお、この<参考ドキュメント></参考ドキュメント>は<参考ドキュメントのJSON形式></参考ドキュメントのJSON形式>のフォーマットで設定されています。
* チャットでユーザから質問が入力されるので、あなたは<参考ドキュメント></参考ドキュメント>の内容をもとに<回答のルール></回答のルール>に従って回答を行なってください。
</回答手順>

<参考ドキュメントのJSON形式>
[
    {
        "text": "検索結果の本文テキスト",
        "metadata": "検索結果に関連するメタデータ情報",
        "additional_fields": "追加のフィールド情報。メタデータに含まれないが、検索結果に関連する他の情報が含まれる。",
        "score": "検索結果の関連性スコア"
    }
]
</参考ドキュメントのJSON形式>

<参考ドキュメント>
[
{{source}}
]
</参考ドキュメント>

<回答のルール>
* 雑談や挨拶には応じないでください。「私は雑談はできません。通常のチャット機能をご利用ください。」とだけ出力してください。他の文言は一切出力しないでください。例外はありません。
* 必ず<参考ドキュメント></参考ドキュメント>をもとに回答してください。<参考ドキュメント></参考ドキュメント>から読み取れないことは、絶対に回答しないでください。
* 回答の文末ごとに、参照したドキュメントの SourceId を [^<SourceId>] 形式で文末に追加してください。
* <参考ドキュメント></参考ドキュメント>をもとに回答できない場合は、「回答に必要な情報が見つかりませんでした。」とだけ出力してください。例外はありません。
* 質問に具体性がなく回答できない場合は、質問の仕方をアドバイスしてください。
* 回答文以外の文字列は一切出力しないでください。回答はJSON形式ではなく、テキストで出力してください。見出しやタイトル等も必要ありません。
</回答のルール>

# user:
{{question}}
```

### 自動評価

精度評価用に `context` の出力を追加  
![alt text](/images/azure-ai-foundry-rag/image-45.png)

自動評価を作成  
![alt text](/images/azure-ai-foundry-rag/image-42.png)

CSV形式で作成したデータセットをアップロード

```csv
question,answer,ground_truth,context,chat_history
"社内 wifi に接続する際のSSIDを教えて","","社内 wifi に接続する際の SSID は GenerativeAiUseCasesJP です。","",[]
"有給休暇の申請方法を教えて","","1. 勤怠管理システム (<https://kintai.example.com/>) にアクセス\n2. メインメニューから休暇申請のセクションを選択し、「有給休暇」のオプションをクリック\n3. 新規申請を選び、申請日、休暇取得日、休暇終了日、および休暇の理由を入力\n4. 詳細が必要な場合は、コメント欄に追記し、「申請」ボタンをクリック","",[]
```

![alt text](/images/azure-ai-foundry-rag/image-43.png)  
![alt text](/images/azure-ai-foundry-rag/image-44.png)

#### 自動評価に用いられるメトリック

<https://learn.microsoft.com/ja-jp/azure/ai-studio/concepts/evaluation-metrics-built-in?tabs=warning#generation-quality-metrics>

| 項目         | 原語         | 推奨シナリオ            | 説明                                                                                                   |
| ------------ | ------------ | ----------------------- | ------------------------------------------------------------------------------------------------------ |
| 根拠性       | Groundedness | RAG                     | 生成AIアプリケーションで生成された回答が入力ソースからの情報とどの程度一致しているか                   |
| 関連性       | Relevance    | RAG                     | 生成AIアプリケーションで生成された回答がどの程度適切で、提示された質問に直接関連するか                 |
| コヒーレンス | Coherence    | 会議メモ要約など        | 生成AIアプリケーションが、スムーズに流れ、自然に読み取られ、人間のような言語に似た出力を生成できる程度 |
| 流暢性       | Fluency      | 会議メモ要約など        | 生成AIアプリケーションの予測応答の言語習熟度                                                           |
| 類似性       | Similarity   | GroundTruthが明確な場合 | ソースデータ(GroundTruth)文と生成AIアプリケーションで生成された応答の間の類似性                        |

#### スコア

RAGの評価にはあまり用いられないため省略

<https://learn.microsoft.com/ja-jp/azure/ai-studio/concepts/evaluation-metrics-built-in?tabs=warning#ai-assisted-similarity>

### 手動評価

<https://learn.microsoft.com/ja-jp/azure/ai-studio/how-to/evaluate-prompts-playground>

`入力`に対して、`想定される応答`と`出力`がどれくらい一致しているかを手動で評価する。  
👍`サムズアップ` or 👎`サムズダウン` の二択での評価になってしまうのが不便に思える。  

![alt text](/images/azure-ai-foundry-rag/image-22.png)  
![alt text](/images/azure-ai-foundry-rag/image-25.png)  
![alt text](/images/azure-ai-foundry-rag/image-26.png)  

## 評価に関する公式ドキュメント

- <https://learn.microsoft.com/ja-jp/azure/ai-studio/tutorials/copilot-sdk-evaluate>

## おわりに

Azure AI Foundry はRAGの構築から自動評価・手動評価まで一気通貫で行えるところが便利だと感じました。
また、ここでは紹介しませんでしたが、[Webアプリとしてデプロイする機能](https://learn.microsoft.com/ja-jp/azure/ai-foundry/tutorials/deploy-chat-web-app#deploy-the-web-app)も備わっているため、
特別なカスタマイズが不要なのであれば、RAGのパッケージ製品を購入したり自社開発したりしなくても、Azure AI Foundry で十分なケースもあると思われます。
ぜひ使ってみてください。
