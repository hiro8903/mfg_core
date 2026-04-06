class CreateInventoryFoundation < ActiveRecord::Migration[8.0]
  def change
    # 1. 在庫データ (Inventories: Hybrid Logical/Physical)
    # [意図] 現実のモノの量を管理。どの組織(Dept)が管理責任を持ち、物理的にどこ(Location)に在るか。
    create_table :inventories do |t|
      t.integer :item_id                                   # 品目ID（将来拡張用）
      t.references :org_unit, null: false, foreign_key: true # 管理部署（論理所有者）
      t.references :location, foreign_key: true              # 保管場所（物理的場所。移動中は空のケースもあり）
      t.decimal :quantity, precision: 15, scale: 5, default: 0, null: false # 在庫数

      t.timestamps
    end
  end
end
