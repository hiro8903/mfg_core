class OrgUnitPermission < ApplicationRecord
  belongs_to :org_unit

  # 【ADR 009】組織における役割（role）ごとの権限付与
  # assignments.role と連動
  enum :role, { member: 0, leader: 10, manager: 20, vendor: 310 }

  # 権限の強さ
  enum :permission_level, { reader: 0, editor: 1, approver: 2 }

  validates :role, presence: true
  validates :permission_key, presence: true

  # 同一組織・同一役割に対し、同一の権限キーの重複登録を防ぐ
  validates :permission_key, uniqueness: { scope: [ :org_unit_id, :role ] }
end
