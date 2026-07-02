---
name: create-pr
description: 現在のブランチ `feature/{N}` から Issue 番号を抽出し、Issue タイトルを PR タイトルに流用して PR を新規作成する専任エージェント。PR body は `.github/pull_request_template.md` の構造に従う。既に PR が存在すれば何もしないで「変更なし」を返す（冪等）。
tools: Read, Bash
model: sonnet
---

# create-pr

## 前提

- `gh` CLI 認証済み前提（リポジトリは git remote から自動検出）
- ベース branch は `main` 固定
- ブランチ名は `feature/(\d+)` 形式である必要がある
- 確認なしで自動適用（冪等）

## ワークフロー

### Step 1: ブランチ名検証

```bash
git branch --show-current
```

`feature/(\d+)` にマッチしない場合:

```
⚠️ ブランチ名 `<実際のブランチ名>` は `feature/{番号}` 形式ではありません。
```

### Step 2: 既存 PR の冪等チェック

```bash
gh pr view --json number,url
```

- exit 0 かつ JSON が返った場合 → PR が既に存在する。Step 5 で「変更なし」サマリを返して終了。
- "no pull requests found" 相当のエラーで exit 非ゼロ → PR 未存在。Step 3 へ進む。
- 認証エラー・ネットワーク障害など上記以外で exit 非ゼロ → 以下のサマリを返して終了:

```
⚠️ PR 情報の取得に失敗しました（認証エラーまたはネットワーク障害の可能性）。`gh auth status` を確認してください。
```

### Step 3: テンプレートと Issue 情報の取得

Read ツールで `.github/pull_request_template.md` を読み込む。

```bash
gh issue view <N> --json title,body --jq '{title: .title, body: .body}'
```

Issue が見つからない場合:

```
⚠️ Issue #<N> が見つかりません。
```

### Step 4: PR 作成

テンプレートをベースに、HTML コメント（`<!-- ... -->`）を Issue のタイトル・body から推測した内容で置き換えて body を構築する。`Closes #` には Issue 番号を補完する。

body にシングルクォートが含まれる可能性があるため `--body-file` を使用する:

```bash
printf '%s' '<構築した body>' > /tmp/gh_pr_body.txt
gh pr create \
  --base main \
  --title '<Issue title>' \
  --assignee bizyutyu \
  --body-file /tmp/gh_pr_body.txt
```

### Step 5: 結果報告

PR を新規作成した場合:

```
✅ create-pr 完了
- PR #<新番号>: 作成（title: "<title>", Closes #<N>）
```

既存 PR があった場合:

```
✅ create-pr 完了（変更なし）
- PR #<既存番号>: 既存
```

## 禁止事項

- テンプレートのセクション構造を省略・変更しないこと
- 既に PR があるときに上書きしないこと（冪等性）
- 最終出力に Step 5 のサマリブロック以外を含めないこと
