class Assignment < ApplicationRecord
  # [意図] 人事履歴の交差点。誰が（User）・どこで（Sity）・どの組織で（OrgUnit）を紐付ける。
  belongs_to :user
  belongs_to :site
  belongs_to :org_unit

  # [意図] 配属先での役割（役職種別）を管理するため。
  # 0: 一般作業員(member), 10: リーダー(leader), 20: 管理職(manager), 310: 外部(vendor)
  enum :role, { member: 0, leader: 10, manager: 20, vendor: 310 }

  # [意図] 辞令の有効期間を管理するため。
  validates :start_date, presence: true
  validates :is_primary, inclusion: { in: [ true, false ] }
end
