---
name: pr-flow
description: PR作成→PR同期→Issue同期を一気通貫で実行するオーケストレーター。`create-pr` → `sync-pr` → `sync-issue` の3エージェントを順次 spawn する。push 後の PostToolUse hook から自動発火される（手動実行も可）。Triggers: "pr-flow", "PR フロー", "push後の自動化", "PRと同期を一括"
---

# pr-flow

3 つの専任エージェントを順次 spawn して PR 周辺の自動化を一気通貫で実行するオーケストレーター。

- **Step 1: `create-pr`** — PR が無ければ新規作成。あれば冪等スキップ
- **Step 2: `sync-pr`** — PR body の `Closes #N` を維持・補完
- **Step 3: `sync-issue`** — 紐付く Issue のチェックリスト更新 + 冪等な changelog コメント投稿

## 前提

- 3 エージェント定義（`.claude/agents/create-pr.md` / `sync-pr.md` / `sync-issue.md`）が存在すること
- y/n 確認は挟まない

## ワークフロー

### Step 1: create-pr を spawn

Agent ツールで `subagent_type: "create-pr"` を spawn する。prompt:

```
現在のブランチに対応する PR を新規作成してください。手順は `.claude/agents/create-pr.md` の Step 1–4 に従ってください。結果は短文サマリのみ返してください。
```

`⚠️` で始まる場合は Step 2/3 をスキップして Step 4 に進む。

### Step 2: sync-pr を spawn

Agent ツールで `subagent_type: "sync-pr"` を spawn する。prompt:

```
現在のブランチに対応する PR body に `Closes #N` が含まれていることを保証してください。手順は `.claude/agents/sync-pr.md` の Step 1–4 に従ってください。結果は短文サマリのみ返してください。
```

`⚠️` で始まる場合は Step 3 をスキップして Step 4 に進む。

### Step 3: sync-issue を spawn

Agent ツールで `subagent_type: "sync-issue"` を spawn する。prompt:

```
現在のブランチに対応する PR に紐付く全 Issue について、本文チェックリストの更新と冪等な changelog コメント投稿を行ってください。手順は `.claude/agents/sync-issue.md` の Step 1–6 に従ってください。結果は短文サマリのみ返してください。
```

### Step 4: 結果統合

各サブエージェントのサマリを並べてユーザーに提示する:

```
{create-pr のサマリ}

{sync-pr のサマリ}

{sync-issue のサマリ}
```

スキップした Step は含めない。装飾や要約の追加はしない。

## 禁止事項

- 本スキル内で `gh` コマンドを直接実行しないこと（必ずエージェント経由）
- 各エージェントのロジックを再実装しないこと
- サマリを書き換えてユーザーに提示しないこと
