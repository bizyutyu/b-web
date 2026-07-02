# Elm Land に関する注意

このリポジトリは Elm Land を使用している。コードを書く前に `elm-land` の公式ドキュメントを参照し、バージョン固有の仕様に従うこと。

# プロジェクト概要

## 関連リポジトリ

| リポジトリ | 用途 |
|---|---|
| `bizyutyu/b-web` | フロントエンド（このリポジトリ） |

## ブランチ戦略（GitHub Flow）

```
main  ←  feature/{issue番号}
```

- `main` が常にデプロイ可能な状態
- 作業は必ず `feature/{issue番号}` ブランチで行う
- ブランチは必ずリモートの main から切る: `git fetch origin && git checkout -b feature/{番号} origin/main`
- PR は必ず `main` へ向ける
- PR body に `Closes #{issue番号}` を含める

## カスタムスキル

| スキル | 用途 |
|---|---|
| `/create-issue` | Issue を新規作成し、ブランチ作成コマンドを提示 |
| `/create-pr` | 現在のブランチの PR を新規作成（冪等） |
| `/sync-pr` | PR body の `Closes #N` を維持・補完 |
| `/sync-issue` | 紐付く Issue のチェックリスト更新 + changelog コメント投稿 |
| `/pr-flow` | 上記3スキルを順次実行するオーケストレーター（push 後に自動発火） |
