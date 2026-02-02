# Life-Container 🧬
Life-Containerは、Google公式の **Gemini CLI** を搭載した、あなた専用の人生管理エージェント実行環境です。
GitHub CLI (`gh`) との連携が完了したDockerコンテナを提供し、ホスト環境を汚すことなく、AIに情報管理、タスク管理、リポジトリ管理を依頼できます。

## 🌟 特徴

* **公式 Gemini CLI 搭載:** Googleアカウントでログインするだけで大規模な無料枠を利用可能。
* **完全なサンドボックス:** ホストOSから隔離された環境で、AIがコマンド操作を誤っても安全。
* **GitHub Native:** 起動時に指定リポジトリを自動Clone（未存在なら作成）。Issue管理やPR作成が即座に行えます。
* **ホスト連携:** 生成されたファイルはホスト側から権限エラーなしで編集可能です。

## 📂 ディレクトリ構成

```text
Life-Container/
├── docker-compose.yaml     # 構成定義（ボリューム、環境変数）
├── Dockerfile              # 環境定義（Node.js, gh, sudo, tools）
├── entrypoint.sh           # 起動スクリプト（GitHub自動認証、Repo初期化）
├── .env                    # 環境変数（GitHubトークン等）
└── workspace/              # 【永続化領域】ここにあるファイルは消えない
    └── GEMINI.md           # 🧠 AIへの指示書（コンテキスト）
```

## 🔑 事前準備: GitHubトークンの取得

GitHubを操作するために「Classic Token」が必要です。以下の手順で取得してください。

1. GitHubの **[Settings]** > **[Developer settings]** > **[Personal access tokens]** > **[Tokens (classic)]** へ移動。
2. **"Generate new token (classic)"** をクリック。
3. **Note**（名前）に適当な名前を入力（例: `Life-Container`）。
4. **Select scopes**（権限）で以下にチェックを入れる。
    * [x] **repo** (フルチェック: リポジトリの読み書きに必須)
    * [x] **workflow** (Actionsの操作に必要)
    * [x] **read:org** (`admin:org` 内: 組織情報の読み取りに推奨)
    * [ ] **delete_repo** (※安全のためチェックしないこと！)
5. 生成されたトークン（`ghp_...`）をコピーしておく。

## 🚀 セットアップ手順

### 1. 環境変数の設定
プロジェクトルートに `.env` ファイルを作成し、GitHubトークンを記述します。
```code
    # .env
    GH_TOKEN=ghp_xxxxxxxxxxxxxxxxx
    # (Optional) 操作対象のリポジトリ（指定がなければ 'User/Life-Container' が自動設定）
    # GH_REPO=oretti3/Life-Container
```
### 2. コンテキストの定義
`workspace/GEMINI.md` を作成し、AIに与えたい役割（ペルソナ）やルールを記述します。
これがAIの「性格」の一部となります。
```code
    # System Instruction
    あなたは私の専属執事であり、優秀なDevOpsエンジニアです。
    現在のワークスペースにあるリポジトリを管理し、私の指示に従ってIssueの整理やコードの修正を行ってください。
    ...
```
### 3. コンテナの起動
以下のコマンドで環境をビルド・起動します。
```bash
    docker compose up
```
初回起動時、自動的にGitHub認証が行われ、必要なリポジトリが準備されます。


## 🎮 使い方

### 1. コンテナに接続
以下のコマンドでサンドボックス内に入ります。
```bash
    docker compose exec life-agent bash
```
### 2. Geminiへのログイン (初回のみ)
コンテナ内で `gemini` コマンドを直接実行し、インタラクティブモードで認証を行います。
```bash
    gemini
```
起動すると認証方法を問うメニューが表示されます。

1. **"Login with Google"** を選択して Enter を押します。
2. 画面に表示されたURLをブラウザで開き、表示されたコードを入力して認証を完了してください。

※認証情報はDocker Volumeに保存されるため、次回以降この手順は不要です。

### 3. AIエージェントの利用
準備完了です。ディレクトリ内の `GEMINI.md` が自動的に読み込まれた状態で会話できます。
```bash
    gemini
```

