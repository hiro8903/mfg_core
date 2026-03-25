# 開発ロードマップ (Project Roadmap)

このドキュメントは、プロジェクト全体の道筋を整理し、現在どこにいるかを見失わないための **Map（地図）** です。
タスクが完了するごとにチェック（`[x]`）を入れて進捗を管理します。

## 📍 フェーズ 1: MVP（人事組織・調達プロセスと在庫管理の基礎）
目標: **組織・権限基盤を確立し、** モノの入り口（発注・入荷）から在庫の決定までを一気通貫で流し、「在庫のズレをなくす」基盤を構築する。

### Step 1: 開発環境の基礎固め
- [x] **プロジェクトの雛形作成 (Project Scaffolding)**: `rails new` による開発の土台（箱）の用意。
    - 💻 `rails new mfg_core`
    - [x] **使用 DB の事前確認**: DBML 連携の準備として DB 種類を確認。
        - 📂 [`config/database.yml`](./config/database.yml): デフォルトの SQLite3 を使用。
- [x] **DBML 連携**: テーブル構成の自動設計図出力ツールの導入（開発進捗を反映させるため）。
    - [x] 自動出力用 Rake タスクの作成。
        - 📂 [`lib/tasks/dbml.rake`](./lib/tasks/dbml.rake)
    - [x] スキーマの自動書き出し。
        - 💻 `bin/rake dbml:export`
        - 📂 [`db/schema.dbml`](./db/schema.dbml)
    - [x] DBML 設計図の Web 公開。
        - 💻 `npx dbdocs build docs/architecture/ideal_schema.dbml --project mfg-core-ideal`
        - 📂 [`docs/architecture/ideal_schema.dbml`](./docs/architecture/ideal_schema.dbml)
        - https://dbdocs.io/hiro8903/mfg-core-ideal

### Step 2: 認証とユーザーマスタ (Rails 8 Native Authentication)
- [x] **ADR 001: 認証方式の選定**
    - 📄 [`001-authentication-choice.md`](./docs/architecture/adr/001-authentication-choice.md)
    - 決定: Rails 8 公式認証をベースに `user_code` 認証でカスタマイズする。
    - 📂 ER 図（初版）: [`docs/architecture/er_diagram.md`](./docs/architecture/er_diagram.md)
    - 📂 ER 図（初版）: [`docs/architecture/ideal_schema.dbml`](./docs/architecture/ideal_schema.dbml)
- [x] **認証基盤構築**: ADR 001 の決定に基づき Rails 8 公式認証機能を実装。
    - [x] **認証用 Gem の有効化**: パスワード暗号化の準備。
        - 📂 [`Gemfile`](./Gemfile): `gem "bcrypt"` を有効化（コメントアウト解除）。
    - [x] 基盤生成の実施。
        - 💻 `bin/rails generate authentication`
        - 📂 [`app/models/user.rb`](./app/models/user.rb) / [`app/models/session.rb`](./app/models/session.rb)
- [x] **CI 環境の正常化**: デフォルト生成された GitHub Actions やテストの不備修正。
    - [x] デフォルトのワークフロー定義の不備修正（バージョン指定ミス等の解消）。
        - 💻 [`.github/workflows/ci.yml`](./.github/workflows/ci.yml) の修正。
    - [x] デフォルト生成されたテストファイル群の修正・整理。
        - [x] 独自設計（`user_code` 認証）と競合するテストを一時的に `skip` して CI 正常化。
            - 📂 対象: [`passwords_controller_test.rb`](./test/controllers/passwords_controller_test.rb) / [`sessions_controller_test.rb`](./test/controllers/sessions_controller_test.rb) / [`user_test.rb`](./test/models/user_test.rb)
- [x] **ユーザーコード認証**: ログイン ID を業務コードにカスタマイズ。
    - [x] 生成されたマイグレーションの `email` 欄を `user_code` に**手動で書き換え**。
        - 編集ファイル: `bin/rails generate authentication` で生成されたマイグレーションファイルを1次改修
    - [x] `User` モデルに `normalizes :user_code` や `has_many :assignments` を手動追記。
    - [x] **初期動作確認 (Console(コンソール): 操作画面)**: 業務コードでのユーザー登録・認証検証。
        - 💻 `bin/rails console` -> `User.create!(user_code: "U001", ...)` -> `user.authenticate("...")`
    - 📂 [`app/models/user.rb`](./app/models/user.rb)
- [x] **組織・在庫基盤の DB 実装**
    - [x] **ADR 002: 人事・組織構造の設計**
        - 📄 [`002-personnel-and-organization-structure.md`](./docs/architecture/adr/002-personnel-and-organization-structure.md)
        - 決定: `assignments`, `org_units`, `facilities`, `locations` の設計。
        - 📂 ER 図（再設計）: [`docs/architecture/er_diagram.md`](./docs/architecture/er_diagram.md)
        - 📂 ER 図（再設計）: [`docs/architecture/ideal_schema.dbml`](./docs/architecture/ideal_schema.dbml)
    - [x] **ADR の設計に従いマイグレーションファイルを手書き**。
        - 📂 [`db/migrate/20260324113517_create_personnel_base.rb`](./db/migrate/20260324113517_create_personnel_base.rb)
        - 対象テーブル: `users`, `facilities`, `org_units`, `assignments`, `locations`, `inventories`, `sessions`
    - [x] リレーション設定（has_many, belongs_to 等）
        - 📂 モデル: [`User`](./app/models/user.rb) / [`Facility`](./app/models/facility.rb) / [`OrgUnit`](./app/models/org_unit.rb) / [`Assignment`](./app/models/assignment.rb) / [`Location`](./app/models/location.rb) / [`Inventory`](./app/models/inventory.rb) / [`Session`](./app/models/session.rb)
    - [x] DB への反映。
        - 💻 `bin/rails db:migrate`
    - [x] 現状の ER 図を出力。
        - 💻 `bin/rake dbml:export`
        - 📂 ER 図（実績）: [`db/schema.dbml`](./db/schema.dbml)
- [x] **ADR 003: 権限管理モデルの刷新**（承認後、`org_unit_permissions` 実装へ着手）。
    - 📄 [`003-permission-management.md`](./docs/architecture/adr/003-permission-management.md)
    - 決定: `users.system_role` を廃止し、`org_unit_permissions` テーブルで動的権限継承へ移行。
    - 📂 ER 図（目標）: [`docs/architecture/er_diagram.md`](./docs/architecture/er_diagram.md)
    - 📂 ER 図（目標）: [`docs/architecture/ideal_schema.dbml`](./docs/architecture/ideal_schema.dbml)
- [x] **組織権限テーブルの追加**: ADR 003 の決定に基づき `org_unit_permissions` を実装。
    - 📂 [`db/migrate/20260325004515_create_org_unit_permissions.rb`](./db/migrate/20260325004515_create_org_unit_permissions.rb)
    - 📂 モデル: [`OrgUnitPermission`](./app/models/org_unit_permission.rb)
    - 💻 `bin/rails db:migrate`
    - [x] 現状の ER 図を出力。
        - 💻 `bin/rake dbml:export`
        - 📂 ER 図（実績）: [`db/schema.dbml`](./db/schema.dbml)
- [x] **テストデータ投入 (Seed: 初期データの種まき)**。
    - 💻 `bin/rails db:seed`
    - 登録モデル: `Facility`, `OrgUnit`, `Location`, `User`, `Assignment`
    - 📂 [`db/seeds.rb`](./db/seeds.rb)
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
