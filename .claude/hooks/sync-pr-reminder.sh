#!/usr/bin/env bash
# PostToolUse hook: git push を検知して /pr-flow の実行を促す
set -euo pipefail

INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || true)

if printf '%s' "$CMD" | grep -qE '(^|[;&|])[[:space:]]*git[[:space:]]+push([[:space:]]|$|[;&|])'; then
  jq -nc '{
    hookSpecificOutput: {
      hookEventName: "PostToolUse",
      additionalContext: "PR/Issue 同期トリガー: `git push` が実行されました。続けて `/pr-flow` を実行し、PR 作成（必要な場合のみ）→ PR body の `Closes #N` 維持 → 紐付く Issue のチェックリスト更新・changelog コメント投稿、までを一気通貫で行ってください。確認は不要です。"
    }
  }'
fi

exit 0
