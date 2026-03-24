class Assignment < ApplicationRecord
  # [意図] 人事履歴の交差点。誰が（User）・どこで（Facility）・どの組織で（OrgUnit）を紐付ける。
  belongs_to :user
  belongs_to :facility
  belongs_to :org_unit

  # [意図] 辞令の有効期間を管理するため。
  validates :start_date, presence: true
  validates :is_primary, inclusion: { in: [ true, false ] }
end
