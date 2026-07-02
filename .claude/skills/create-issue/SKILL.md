---
name: create-issue
description: タイトルと概要から GitHub Issue を新規作成し、ブランチ作成コマンドを提示する。専任エージェント `create-issue` を spawn する薄いラッパー。Triggers: "Issue作成", "create-issue", "Issueを作って"
---

# create-issue

専任エージェント `create-issue` を Agent ツールで spawn する薄いラッパー。

## ワークフロー

### Step 1: エージェント呼び出し

Agent ツールで `subagent_type: "create-issue"` を spawn する。prompt にはユーザーの入力（タイトル・概要）をそのまま渡す:

```
以下の内容で GitHub Issue を新規作成してください。手順は `.claude/agents/create-issue.md` の Step 1–6 に従ってください。結果は短文サマリのみ返してください。

<ユーザーの入力内容>
```

### Step 2: 結果の提示

サブエージェントの短文サマリをそのままユーザーに提示する。

## 禁止事項

- 本スキル内で `gh issue create` を直接実行しないこと
- サマリを書き換えてユーザーに提示しないこと
