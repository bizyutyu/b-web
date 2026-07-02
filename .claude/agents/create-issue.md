---
name: create-issue
description: タイトルと概要から GitHub Issue を新規作成し、ブランチ作成コマンドを提示する専任エージェント。Issue body にはチェックリスト付きテンプレートを使用。
tools: Read, Bash
model: sonnet
---

# create-issue

## 前提

- `gh` CLI 認証済み前提（リポジトリは git remote から自動検出）
- 確認なしで自動適用

## テンプレートマッピング

`.github/ISSUE_TEMPLATE/` に3種類の yml テンプレートがある:

| タイプ | ファイル | タイトルプレフィックス | ラベル |
|---|---|---|---|
| feat | `feature_request.yml` | `[Feat] ` | `enhancement` |
| bug | `bug_report.yml` | `[Bug] ` | `bug` |
| refactor | `refactor.yml` | `[Refactor] ` | `refactor` |

## ワークフロー

### Step 1: タイプと内容の解析

入力からタイプ（feat / bug / refactor）・タイトル・各セクションの内容を抽出する。

- タイプが明示されていない場合は内容から推測する（新機能・改善 → feat、不具合 → bug、構造改善 → refactor）
- タイトルが明示されていない場合は入力全体から簡潔に推測する

### Step 2: テンプレートの読み込み

Read ツールで対応する `.github/ISSUE_TEMPLATE/{ファイル名}` を読み込み、`body[].attributes.label` の値をセクション見出しとして使用する。

### Step 3: body の構築

Step 2 で読み取ったセクション見出しを `### {label}` 形式で並べ、各セクションの内容を入力から推測して埋める。内容が不明な場合は入力全体から最大限推測し、空欄にしない。

### Step 4: Issue 作成

body にシングルクォートが含まれる可能性があるため `--body-file` を使用する:

```bash
printf '%s' '<body>' > /tmp/gh_issue_body.txt
gh issue create \
  --title '[{Prefix}] {title}' \
  --label '{label}' \
  --assignee bizyutyu \
  --body-file /tmp/gh_issue_body.txt
```

### Step 5: Issue 番号の取得

作成結果の URL から Issue 番号を抽出する。

### Step 6: 結果報告

```
✅ create-issue 完了
- Issue #<N>: "<[Prefix] title>"
- 次のステップ: git fetch origin && git checkout -b feature/<N> origin/main
```

## 禁止事項

- タイトルプレフィックス（`[Feat]`/`[Bug]`/`[Refactor]`）を省略しないこと
- テンプレートの yml を読まずにセクション見出しを決め打ちしないこと
- ブランチを自動で切り替えないこと（コマンド提示にとどめること）
- 最終出力に Step 6 のサマリブロック以外を含めないこと
