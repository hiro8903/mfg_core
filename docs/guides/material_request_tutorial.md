# 実装チュートリアル：資材要求機能 (Material Request Implementation)

本ドキュメントは、Mfg Coreプロジェクトにおける「資材要求」モジュールの実装手順を、Railsチュートリアルのようなステップバイステップ形式で解説します。

## Step 1: モデルとマイグレーションの生成

まず、資材要求の基本となる3つのモデルを生成します。

```bash
# ヘッダ（本体）
bin/rails generate model MaterialRequest \
  created_by:references applicant:references \
  request_org:references budget_org:references target_org:references \
  transaction_type:integer usage_code:references \
  purpose:text reason:text remarks:text \
  status:integer ringi_needed:boolean

# 明細
bin/rails generate model MaterialRequestLine \
  material_request:references item:references \
  item_name_free_text:string item_spec_free_text:text \
  order_unit:string order_quantity:decimal \
  packing_factor:decimal base_unit:string total_base_quantity:decimal \
  unit_price:decimal base_unit_price:decimal tax_rate:decimal \
  required_date:date status:integer

# 承認履歴
bin/rails generate model ApprovalActivity \
  material_request:references approver:references \
  step_name:string action:string comment:text
```

### マイグレーションの調整
`db/migrate/..._create_material_workflow_foundation.rb` を開き、以下のポイントを修正・追記します。
- `User` や `OrgUnit` への外部キー制約を `foreign_key: { to_table: :users }` の形式で明示。
- デフォルト値（`status: 0`, `transaction_type: 1` 等）の設定。
- 小数点以下の精度（`precision: 15, scale: 5` 等）の設定。

## Step 2: モデル間のリレーションとバリデーション

### `MaterialRequest.rb`
ネストされた属性の受け入れを設定します。
```ruby
class MaterialRequest < ApplicationRecord
  belongs_to :created_by, class_name: "User"
  belongs_to :applicant, class_name: "User"
  has_many :material_request_lines, dependent: :destroy
  
  accepts_nested_attributes_for :material_request_lines, allow_destroy: true, reject_if: :all_blank
  
  enum :status, { draft: 0, pending_approval: 10, approved: 40, returned: 90 }
  enum :transaction_type, { standard_purchase: 1, internal_supply: 2, customer_supply: 3 }
end
```

## Step 3: コントローラーとルーティング

### `config/routes.rb`
承認アクション用のカスタムルートを追加します。
```ruby
resources :material_requests do
  member do
    patch :submit
    patch :approve
    patch :reject
  end
end
```

### `MaterialRequestsController.rb`
`Current.user` を活用して、作成者や承認者を自動設定します。
```ruby
def submit
  @material_request.transaction do
    @material_request.update!(status: :pending_approval)
    @material_request.approval_activities.create!(
      approver: Current.user,
      step_name: "第1次承認", action: "submit", comment: "申請"
    )
  end
  redirect_to @material_request, notice: "申請しました。"
end
```

## Step 4: 日本語化とUIデザイン

### `config/locales/ja.yml`
モデル名や Enum の値を日本語で定義します（前述のトラブルシューティング参照）。

### ビューの実装
Tailwind CSS を活用し、`app/views/material_requests/` 配下の各ファイルを構築します。
- `_form.html.erb`: `fields_for` を用いた明細行の入力。
- `show.html.erb`: 承認ボタンとタイムライン表示。

## Step 5: テストデータの投入

`db/seeds.rb` にテスト用の品目や組織などを追加し、動作確認を行います。
```bash
bin/rails db:seed
```

以上で、資材要求の起案から承認までの基本サイクルが動作するようになります。
