class Item < ApplicationRecord
  include Discard::Model

  # 【ADR 007】品目マスタの統合とBOMアーキテクチャ
  # [意図] すべての品目（原材料、製品、消耗品、工具等）を単一テーブルで管理する。

  # [意図] この品目を主管する部門を紐付け。補充要求の起案責任を負う組織。
  belongs_to :managing_org, class_name: "OrgUnit", optional: true

  # [意図] この品目が親となるBOM構成（この品目から何が作れるか）。
  has_many :child_boms, class_name: "ItemBom", foreign_key: :parent_item_id, dependent: :destroy

  # [意図] この品目が子として使われるBOM構成（この品目はどの製品に使われるか）。
  has_many :parent_boms, class_name: "ItemBom", foreign_key: :child_item_id, dependent: :destroy

  # [意図] この品目に紐づく在庫レコード群。
  has_many :inventories, dependent: :nullify

  # [意図] 品目区分を enum で管理。ADR 007 に基づく統合分類。
  enum :item_type, {
    raw_material: 0,         # 原材料
    subcontracted_base: 1,   # 受託基材（客先支給品）
    purchased_part: 4,       # 購入部品
    tool: 7,                 # 工具・治具
    consumable: 10,          # 消費財
    finished_product: 20     # 完成品
  }

  validates :item_code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :unit, presence: true
  validates :min_stock_level, numericality: { greater_than_or_equal_to: 0 }
end
