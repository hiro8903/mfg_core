# 開発ロードマップ (Project Roadmap)

このドキュメントは、プロジェクト全体の道筋を整理し、現在どこにいるかを見失わないための **Map（地図）** です。
タスクが完了するごとにチェック（`[x]`）を入れて進捗を管理します。

## 📍 フェーズ 1: MVP（調達プロセスと在庫管理の基礎）
目標: モノの入り口（発注・入荷）から在庫の決定までを一気通貫で流し、「在庫のズレをなくす」基盤を構築する。

### Step 1: 開発環境の基礎固め
- [x] `rails new`直後の初期状態と今回の初期設定を **Git** にコミットする。
  - 💻 `rails new mfg_core --database=postgresql`
  - 📂 [`Gemfile`](./Gemfile) / [`config/database.yml`](./config/database.yml)
- [x] テーブル構成を自動でDBML（設計図）として出力・管理するツールの導入。
  - 💻 `bin/rake dbml:export` — 実行ごとに `db/schema.dbml` を最新化
  - 💻 `npx dbdocs build docs/architecture/ideal_schema.dbml --project mfg-core-ideal` — Web 公開
  - 📂 [`lib/tasks/dbml.rake`](./lib/tasks/dbml.rake) — 自動生成スクリプト
  - 📄 [`db/schema.dbml`](./db/schema.dbml) — 実装の最新スキーマ
  - 📄 [`docs/architecture/ideal_schema.dbml`](./docs/architecture/ideal_schema.dbml) — 設計上の理想スキーマ
  - 🌐 [dbdocs.io (mfg-core-ideal)](https://dbdocs.io/hiro8903/mfg-core-ideal) — Web 公開版 ER 図

### Step 2: 認証とユーザーマスタ (Rails 8 Native Authentication)
- [x] Rails 8 公式認証ジェネレーターを用いた基礎認証基盤の構築。
  - 💻 `bin/rails generate authentication`
  - 📂 [`app/models/user.rb`](./app/models/user.rb) / [`app/models/session.rb`](./app/models/session.rb)
  - 📂 `app/controllers/sessions_controller.rb`
- [x] `User` モデルを「ユーザーコード」で認証するようにカスタマイズ。
  - 💻 `bin/rails generate migration AddUserCodeToUsers user_code:string:uniq`
  - 💻 `bin/rails db:migrate`
  - 📂 [`app/models/user.rb`](./app/models/user.rb)
- [x] アーキテクチャ設計の記録（ADR 001, 002, 003）の作成。組織ベースの動的権限継承モデルの決定。
  - 📄 [`docs/architecture/adr/001-authentication-choice.md`](./docs/architecture/adr/001-authentication-choice.md)
  - 📄 [`docs/architecture/adr/002-personnel-and-organization-structure.md`](./docs/architecture/adr/002-personnel-and-organization-structure.md)
  - 📄 [`docs/architecture/adr/003-permission-management.md`](./docs/architecture/adr/003-permission-management.md)
  - 📄 [`docs/architecture/er_diagram.md`](./docs/architecture/er_diagram.md)
- [x] 組織情報 (`OrgUnit`) および 組織権限 (`OrgUnitPermission`) のテーブル実装。
  - 💻 `bin/rails generate model OrgUnit code:string name:string org_type:integer parent:references`
  - 💻 `bin/rails generate migration CreateOrgUnitPermissions org_unit:references permission:integer:index`
  - 💻 `bin/rails db:migrate`
  - 📂 [`db/migrate/20260324113517_create_personnel_base.rb`](./db/migrate/20260324113517_create_personnel_base.rb)
  - 📂 [`db/migrate/20260325004515_create_org_unit_permissions.rb`](./db/migrate/20260325004515_create_org_unit_permissions.rb)
  - 📂 [`app/models/org_unit.rb`](./app/models/org_unit.rb) / [`app/models/org_unit_permission.rb`](./app/models/org_unit_permission.rb)
  - 📂 [`app/models/assignment.rb`](./app/models/assignment.rb)
- [ ] 管理者が「ユーザーマスタ」を管理できる画面の実装。
    - [ ] `index`: ユーザー一覧表示（所属組織・有効な権限のサマリー表示含む）。
    - [ ] `new/create`: 新規ユーザー登録（パスワード初期設定含む）。
    - [ ] `edit/update`: ユーザー基本情報の編集。
    - [ ] `destroy` (Discard): ユーザーの論理削除（退職・無効化処理）。
    - [ ] **配属管理**: ユーザーを組織（OrgUnit）や拠点（Facility）に紐付ける `assignments` の登録・更新機能。
    - [ ] **認可（Pundit）**: `manage_users` 権限を持つユーザーのみが上記操作を行えるようにガード。
- [ ] 一般ユーザー用のログイン・ログアウト機能の実装。

### Step 3: 調達・在庫向け 基礎マスタデータの構築 (Foundation)
- [ ] `品番マスタ`（メーカー名含む） および `商品マスタ` の構築。
- [ ] `相手先名称マスタ`（仕入先）、`発送先マスタ`（納品先）、`ロケーションマスタ` の構築。
- [ ] 管理者がPCから上記のマスタを登録できるUI作成。

### Step 4: 調達プロセス（仕入）の構築 (Procurement Flow)
- [ ] `見積データ` の構築（仕入単価の管理）。
- [ ] `発注データ`・`発注明細データ` の構築（数量・希望納期・納期回答・納品先等）。
- [ ] `入荷データ`・`入荷明細データ` の構築（届いた資材を受け入れる処理）。

### Step 5: トランザクション・在庫管理の構築 (Core Logic)
- [ ] 現在の在庫数を保持する `個別在庫データ` の構築。
- [ ] 在庫の増減履歴を記録する `在庫移動データ` の構築。
- [ ] 「入荷」が行われた際に自動的に「個別在庫」が変動する（または連携して手動増減できる）ロジックの構築と画面作成。

---
*これ以降のタスクはフェーズ1完了後に詳細化します。*

## 📍 フェーズ 2: 生産・工程管理の拡張 (Future Planning)
- [ ] `作業指示データ`・`作業実績データ` の導入。
- [ ] `標準レシピマスタ` と実際の作業との連携による材料消費計算。

## 📍 フェーズ 3: 購買予測・品質の統合 (Ultimate Goal)
- [ ] 受注情報からの必要量算出、不足する資材の調達計画自動化。
- [ ] 過去実績からの高度な予測機能への挑戦。
- [ ] 品質検査と受入フローの完全統合。
