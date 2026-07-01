---
name: sync-pr
description: 現在のブランチに対応する PR body に `Closes #N` が存在することを保証する。専任エージェント `sync-pr` を spawn する薄いラッパー。Triggers: "sync-pr", "PR body 同期", "Closes を維持"
---

# sync-pr

専任エージェント `sync-pr` を Agent ツールで spawn する薄いラッパー。

## ワークフロー

### Step 1: エージェント呼び出し

Agent ツールで `subagent_type: "sync-pr"` を spawn する。prompt:

```
現在のブランチに対応する PR body に `Closes #N` が含まれていることを保証してください。手順は `.claude/agents/sync-pr.md` の Step 1–4 に従ってください。結果は短文サマリのみ返してください。
```

### Step 2: 結果の提示

サブエージェントの短文サマリをそのままユーザーに提示する。

## 禁止事項

- 本スキル内で `gh pr edit` を直接実行しないこと
- サマリを書き換えてユーザーに提示しないこと
