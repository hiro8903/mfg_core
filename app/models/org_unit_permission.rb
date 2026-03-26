class OrgUnitPermission < ApplicationRecord
  belongs_to :org_unit

  # 【ADR 003】組織に紐付く権限の定義
  enum :permission, {
    system_admin: 0,     # 全機能へのフルアクセス
    manage_users: 1,     # ユーザーマスターの管理
    manage_hr: 2,        # 人事・配属履歴の管理
    view_inventory: 3,   # 在庫の閲覧
    manage_inventory: 4, # 在庫の編集・移動
    approve_orders: 5    # 発注の承認
  }

  validates :permission, presence: true, uniqueness: { scope: :org_unit_id }
end
