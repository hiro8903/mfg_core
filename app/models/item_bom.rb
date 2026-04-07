class ItemBom < ApplicationRecord
  # 【ADR 007】品目構成マスタ（BOM: Bill of Materials）
  # [意図] 製品や部品がどの材料から構成されているか（レシピ・BOM）を管理。
  # 自己参照リレーションにより、items テーブル内で無限階層のツリー構造を表現する。

  belongs_to :parent_item, class_name: "Item"
  belongs_to :child_item, class_name: "Item"

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  # [意図] 親と子が同一品目になることを防ぐ（自分自身を構成要素にはできない）。
  validate :parent_and_child_must_differ

  private

  def parent_and_child_must_differ
    if parent_item_id == child_item_id
      errors.add(:child_item_id, "親品目と子品目は同一にできません")
    end
  end
end
