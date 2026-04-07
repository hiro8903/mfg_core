class AccountingUsageCode < ApplicationRecord
  # [意図] 経理部が管理する公式な予算科目・用途番号。現場用の独自用途番号と紐付く。
  has_many :internal_usage_codes, dependent: :nullify

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end
