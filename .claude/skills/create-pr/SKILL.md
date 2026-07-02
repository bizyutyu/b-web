---
name: create-pr
description: 現在のブランチに対応する PR を新規作成する。専任エージェント `create-pr` を spawn する薄いラッパー。PR が既に存在すれば何もしない（冪等）。Triggers: "PR作成", "create-pr", "PRを作って"
---

# create-pr

専任エージェント `create-pr` を Agent ツールで spawn する薄いラッパー。

## ワークフロー

### Step 1: エージェント呼び出し

Agent ツールで `subagent_type: "create-pr"` を spawn する。prompt:

```
現在のブランチに対応する PR を新規作成してください。手順は `.claude/agents/create-pr.md` の Step 1–5 に従ってください。結果は短文サマリのみ返してください。
```

### Step 2: 結果の提示

サブエージェントの短文サマリをそのままユーザーに提示する。

## 禁止事項

- 本スキル内で `gh pr create` を直接実行しないこと
- サマリを書き換えてユーザーに提示しないこと
