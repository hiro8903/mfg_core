class Inventory < ApplicationRecord
  # [意図] この在庫は「誰（どの組織）のものか」を必須にするため（ハイブリッド：論理）。
  belongs_to :org_unit

  # [意図] この在庫は「どこにあるか（ロケーション）」を任意にするため（ハイブリッド：物理）。
  # [意味] optional: true にすることで、まだ棚が決まっていない在庫も登録可能にする。
  belongs_to :location, optional: true

  # [意図] この在庫レコードが対象とする品目。品目未定（仮入庫）のケースを考慮し optional。
  belongs_to :item, optional: true

  # [意図] マイナスの在庫にならないよう最低限のバリデーション。
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
