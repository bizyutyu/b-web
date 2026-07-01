---
name: sync-issue
description: 現在のブランチの PR に紐付く Issue のチェックリスト更新と changelog コメント投稿を行う。専任エージェント `sync-issue` を spawn する薄いラッパー。Triggers: "sync-issue", "Issue 同期", "changelog コメント"
---

# sync-issue

専任エージェント `sync-issue` を Agent ツールで spawn する薄いラッパー。

## ワークフロー

### Step 1: エージェント呼び出し

Agent ツールで `subagent_type: "sync-issue"` を spawn する。prompt:

```
現在のブランチに対応する PR に紐付く全 Issue について、本文チェックリストの更新と冪等な changelog コメント投稿を行ってください。手順は `.claude/agents/sync-issue.md` の Step 1–6 に従ってください。結果は短文サマリのみ返してください。
```

### Step 2: 結果の提示

サブエージェントの短文サマリをそのままユーザーに提示する。

## 禁止事項

- 本スキル内で `gh issue edit` / `gh issue comment` を直接実行しないこと
- サマリを書き換えてユーザーに提示しないこと
