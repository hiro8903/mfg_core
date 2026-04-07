class MaterialRequest < ApplicationRecord
  # 【ADR 010】 現場や管理部門からの資材要求を管理するヘッダデータ。
  # 承認プロセスの起点となり、各明細単位で在庫引当や発注に連携される。

  # [意図] システムにデータを打ち込んだ人
  belongs_to :created_by, class_name: "User"
  # [意図] 実際にその資材を必要としている担当者。問い合わせ先となる
  belongs_to :applicant, class_name: "User"

  belongs_to :request_org, class_name: "OrgUnit", optional: true
  belongs_to :budget_org, class_name: "OrgUnit", optional: true
  belongs_to :target_org, class_name: "OrgUnit", optional: true

  belongs_to :usage_code, class_name: "InternalUsageCode", optional: true

  has_many :material_request_lines, dependent: :destroy
  has_many :approval_activities, dependent: :destroy

  accepts_nested_attributes_for :material_request_lines, allow_destroy: true, reject_if: :all_blank

  # [意図] ADR 010: 取引区分の設定
  enum :transaction_type, {
    standard_purchase: 1, # 購入(通常)
    internal_supply: 2,   # 自社支給(加工外注用)
    customer_supply: 3    # 客先支給(無償)
  }

  # [意図] 現在の進行状態
  enum :status, {
    draft: 0,             # 起案中
    pending_approval: 10, # 承認待ち
    approved: 40,         # 承認済
    returned: 90          # 差戻し
  }

  validates :purpose, presence: true
end
