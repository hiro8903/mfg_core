---
description: Enforce GitHub Flow to simulate team development.
---
# GitHub Flow Workflow (チーム開発フロー)

**Constraint (制約)**: NEVER commit directly to `main`. (本番への直書き禁止)

## 1. Branching (ブランチ作成)
- Create feature branch BEFORE starting task: `git checkout -b feature/[name]`

## 2. Implementation & Commit (実装とセーブ)
- Atomic commits within the branch.

## 3. Push & Pull Request (PR作成)
- Push to remote: `git push origin feature/[name]`
- PAUSE and instruct user to create PR on GitHub. (PR作成待ち)

## 4. Review & Merge (レビュー合体)
- User acts as PM to review diff and merge to `main` on GitHub.

## 5. Local Sync (ローカル同期)
- Sync locally: `git checkout main` -> `git pull`
- Only proceed after sync.
