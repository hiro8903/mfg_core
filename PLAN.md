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
- [x] **ADR 004: 論理削除の方針とトレーサビリティの確保**
    - 📄 [`004-logical-deletion-policy.md`](./docs/architecture/adr/004-logical-deletion-policy.md)
    - 決定: 物理削除を禁じ、`discarded_at` による論理削除を一貫して採用する。
- [x] **ユーザーマスタ管理画面の実装**: 管理者がユーザー情報を操作できる基盤を構築。
    - [x] `index`: ユーザー一覧表示（所属組織・拠点の表示含む）。
        - 📂 [`app/views/users/index.html.erb`](./app/views/users/index.html.erb)
    - [x] `show`: ユーザー詳細表示（配属履歴と継承パスワード権限の可視化）。
        - 📂 [`app/views/users/show.html.erb`](./app/views/users/show.html.erb)
    - [x] `new/create`: 新規ユーザー登録。
        - 📂 [`app/views/users/new.html.erb`](./app/views/users/new.html.erb)
    - [x] **UI/UX の刷新**: 全画面共通のデザイン基盤（Layout）と通知システム（Flash）の導入。
        - 📂 [`app/views/layouts/application.html.erb`](./app/views/layouts/application.html.erb)
    - [x] **フォームの共通部品化 (Refactoring)**: `new` と `edit` で共通して使う入力欄を切り出し。
        - 📂 [`app/views/users/_form.html.erb`](./app/views/users/_form.html.erb)
    - [x] `edit/update`: ユーザー基本情報の編集。
        - 📂 [`app/views/users/edit.html.erb`](./app/views/users/edit.html.erb)
    - [x] `destroy` (Discard): ユーザーの論理削除（退職・無効化処理）。
        - 📂 [`app/controllers/users_controller.rb`](./app/controllers/users_controller.rb) / [`app/views/users/index.html.erb`](./app/views/users/index.html.erb)
    - [ ] **配属管理の高度化**: 画面から組織（OrgUnit）や拠点（Facility）を動的に紐付ける機能。
    - [ ] **認可（Pundit）**: `manage_users` 権限を持つユーザーのみが上記操作を行えるようにガード。
- [ ] 一般ユーザー用のログイン・ログアウト機能の実装。

### Step 2.5: フロントエンド標準化 (Frontend Standardization)
- [x] **ADR 005: フロントエンド技術選定 (Hotwire + Tailwind CSS)**
    - 📄 [`005-frontend-stack-selection.md`](./docs/architecture/adr/005-frontend-stack-selection.md)
    - 決定: Hotwire + Tailwind を主軸とし、特定の高度な UI のみ React/Vue 導入を検討する。
- [x] **Rails 8 + Tailwind v4 標準化の確立**: Propshaft の `:app` 魔法による自動解決の検証と文書化。
    - 📂 [`rails8-tailwind-v4-standard-setup.md`](./til/[Ruby]_[Fw]_Rails-Frontend-Standard/rails8-tailwind-v4-standard-setup.md)
- [x] **ユーザーマスタ画面のリファクタリング**: ドラフト版（暫定 UI）を ADR 005 および TIL ガイドに従って刷新。
    - [x] 全画面（index, show, new, edit, _form）のインラインスタイルを Tailwind クラスへ完全移行。
    - [x] モバイルファーストなレスポンシブレイアウトの導入。
- [x] **汎用 UI コンポーネント（ボタン、バッジ、カード等）の抽出**: 実装したクラスを `shared/` パーシャルへ共通化し、DRY を徹底する。

### Step 3: 調達・在庫向け 基礎マスタデータの構築 (Foundation)
- [x] **ADR 006: 取引先および納入先の設計方針**
    - 📄 [`006-business-partner-and-delivery-model.md`](./docs/architecture/adr/006-business-partner-and-delivery-model.md)
- [x] **ADR 007: 品目マスタの統合とBOMアーキテクチャ**
    - 📄 [`007-item-master-and-bom-integration.md`](./docs/architecture/adr/007-item-master-and-bom-integration.md)
- [/] **Phase 1: 環境整備（論理削除基盤）**
    - [x] `Gemfile` への `discard` gem の追記
    - [ ] `bundle install` の実行によるインストール
    - [ ] 既存の `User` モデル等を `Discard::Model` 対応にリファクタリング
- [ ] **Phase 2: 取引先・納入先マスタ（BusinessPartner）の実装**
    - [ ] `BusinessPartner` モデル & マイグレーション作成
    - [ ] `DeliveryDestination` モデル & マイグレーション作成
    - [ ] バリデーション・リレーションの設定（ADR 006 準拠）
    - [ ] 取引先の一覧・詳細画面の構築 (Tailwind v4 使用)
- [ ] **Phase 3: 品目・構成マスタ（Item / ItemBOM）の実装**
    - [ ] `Item` モデル & マイグレーション作成
    - [ ] `ItemBOM` モデル（自己参照） & マイグレーション作成
    - [ ] 運用ガイドに基づく区分（item_type）の定義
    - [ ] 品目の一覧画面（区分別タブ・フィルタ付）の構築
- [ ] **Phase 4: データの流し込みと動作確認**
    - [ ] `seeds.rb` の更新と大規模テストデータの投入
    - [ ] 論理削除・復元の UI 動作確認
    - [ ] BOM 再帰検索等の基本メソッドの動作確認

### Step 4: 調達プロセス（仕入）の構築 (Procurement Flow)
- [ ] `仕入見積データ` の構築（仕入単価の管理）。
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
- [ ] `品目構成マスタ (ItemBOM)` と実際の作業との連携による材料消費計算。

## 📍 フェーズ 3: 購買予測・品質の統合 (Ultimate Goal)
- [ ] 受注情報からの必要量算出、不足する資材の調達計画自動化。
- [ ] 過去実績からの高度な予測機能への挑戦。
- [ ] 品質検査と受入フローの完全統合。
