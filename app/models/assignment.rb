class Assignment < ApplicationRecord
  # [意図] 人事履歴の交差点。誰が（User）・どこで（Facility）・どの組織で（OrgUnit）を紐付ける。
  belongs_to :user
  belongs_to :facility
  belongs_to :org_unit

  # [意図] 配属先での役割（役職種別）を管理するため。
  # 0: 一般作業員（デフォルト）, 1: 管理職・班長等
  enum :role, { worker: 0, manager: 1 }

  # [意図] 辞令の有効期間を管理するため。
  validates :start_date, presence: true
  validates :is_primary, inclusion: { in: [ true, false ] }
end
