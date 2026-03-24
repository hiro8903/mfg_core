---
description: how to commit, push, and create pull requests following GitHub Flow. Apply this whenever the user wants to commit, push, merge, or create a PR.
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

    After listing all 3 options, you MUST add a direct engineer's recommendation in this exact format. Be honest and opinionated — do NOT be vague or diplomatic:

    ---
    💬 **エンジニア的には【案X】がベストです。**
    > `[1〜2文で「なぜこれが最も正確か」「他の案のどこが弱いか」を率直に述べる。シニアエンジニアがコードレビューで語りかけるような、歯に衣着せないトーンで書くこと。]`

3.  **Execute**: Wait for the user to select an option number or provide a modified message. ONLY THEN use your tools to execute `git add`, `git commit`, and `git push` commands.

## 3. Push & Pull Request (PR作成)
**[CRITICAL PR PROTOCOL]**
After pushing a branch, you MUST follow this 2-step conversation protocol:

1.  **Ask for Intent**: DO NOT simply instruct the user to go to GitHub. Instead, explicitly ask: 「プルリクエストを作成しますか？」
2.  **Propose Draft**: If the user says "yes/OK", generate a draft PR Title and Description strictly following this Markdown template. **You MUST output the final text within a Markdown code block so the user can copy it easily.**
    - **Note on Style**: The PR **Title** must use an English prefix (e.g., `feat:`, `chore:`, `docs:`) followed by a **Japanese** main subject (e.g., `feat: [新機能の役割]の実装`).

    ```markdown
    [Draft PR Title Example: chore: [新機能]の追加]
    ## 概要 / Summary
    [Summarize the change]

    ## 実装機能 / Key Features
    - [ ] [Feature 1]

    ## 変更内容 / Key Changes
    - [ ] [Change 1]

    ## 設計上の意思決定と目的 / Design Decisions & Objectives
    ### 1. [Decision 1]
    - **理由**: [Rationale]

    ## 補足 / Note
    [Any extra info]
    ```

3.  **Instruction**: After the user approves or modifies the draft, PAUSE and provide the link to create the PR on GitHub.

## 4. Review & Merge (レビュー合体)
- User acts as PM to review diff and merge to `main` on GitHub.

## 5. Local Sync (ローカル同期)
- Sync locally: `git checkout main` -> `git pull`
- Only proceed after sync.
