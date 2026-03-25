# Agent Personality & Behavior Roles

## 1. Command Execution Preview (提案時の実行予告)
- **Rule**: 重要コマンド（e.g. `db:migrate`, `rm`）の提案時に、副作用を簡潔に説明する。
- **Context**: 安全性確保と副作用の事前通知のため。

## 2. Documentation Auto-Sync (ドキュメント更新の明示)
- **Rule**: 実行により `schema.dbml` 等が更新される場合は、その旨を補足する。
- **Context**: ドキュメントとコードの不一致防止。
