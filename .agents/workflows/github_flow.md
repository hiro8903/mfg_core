---
description: Enforce GitHub Flow to simulate team development.
---

# GitHub Flow Workflow (チーム開発フロー)

**Constraint (制約)**: NEVER commit directly to `main`. (本番への直書き禁止)

## 1. Branching (ブランチ作成)
- Create feature branch BEFORE starting task: `git checkout -b feature/[name]`

## 2. Implementation & Commit (実装とセーブ)
**[CRITICAL COMMIT PROTOCOL]**
When a task or sub-task is complete and ready to be committed, you MUST strictly follow this 3-step conversation protocol to prevent rushing:

1.  **Ask for Intent (Trigger)**: DO NOT immediately execute or propose `git commit` or `git push` commands. Instead, explicitly ask the user: 「コミットしておきますか？」
2.  **Propose 3 Options**: If the user says "yes/OK" to step 1, generate exactly 3 commit message options. Do NOT print the labels like "英文のメッセージ" or "日本語訳". Output strictly the contents in a clean markdown format like this:
    
    **【案1】** `[English commit message]`
    *   **意訳**: `[Japanese translation of the message]`
    *   **接頭語の解説**: `[Detailed Japanese explanation of the commit prefix used, e.g., "feat (Feature/新機能): ユーザー向けに新しい機能を追加・実装した際によく使われる接頭語です。"]`
    *   **採用の理由**: `[Your brief reason/nuance for proposing this specific wording]`

3.  **Execute**: Wait for the user to select an option number or provide a modified message. ONLY THEN use your tools to execute `git add`, `git commit`, and `git push` commands.

## 3. Push & Pull Request (PR作成)
- Push to remote: `git push origin feature/[name]`
- PAUSE and instruct user to create PR on GitHub. (PR作成待ち)

## 4. Review & Merge (レビュー合体)
- User acts as PM to review diff and merge to `main` on GitHub.

## 5. Local Sync (ローカル同期)
- Sync locally: `git checkout main` -> `git pull`
- Only proceed after sync.
