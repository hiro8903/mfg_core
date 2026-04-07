class InternalUsageCode < ApplicationRecord
  # [意図] 現場で使いやすい名称で定義された用途（例：営繕用、清掃用）。
  belongs_to :accounting_usage_code, optional: true

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end
