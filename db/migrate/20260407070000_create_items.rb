class CreateItems < ActiveRecord::Migration[8.1]
  def change
    # 1. 品目マスタ (Items: Unified per ADR 007)
    # [意図] 原材料、製品、消耗品、工具等、すべての管理対象品目を一元管理する基本マスタ。
    # 販売品・購入品・消費財を単一テーブルで管理することで、BOMや在庫計算の起点を統一する。
    create_table :items do |t|
      t.string :item_code, null: false       # 品目コード（例: RM-001, TG-002）
      t.string :name, null: false            # 品目名称（正式名称）
      t.string :unit, null: false            # 基本単位（例: 枚, kg, L, m）
      t.integer :item_type, default: 0, null: false # 品目区分（1:受託基材, 4:購入品, 10:消費財 等）
      t.string :manufacturer_name            # メーカー/製造元名称
      t.boolean :is_lot_managed, default: false, null: false # ロット管理フラグ
      t.references :managing_org, foreign_key: { to_table: :org_units } # 主管部門
      t.decimal :min_stock_level, precision: 15, scale: 5, default: 0, null: false # 安全在庫数
      t.text :internal_memo                  # 社内向けの共有・申し送り事項（非公開）
      t.datetime :discarded_at, index: true  # 論理削除

      t.timestamps
    end

    add_index :items, :item_code, unique: true

    # 2. 品目構成マスタ (ItemBOM: 自己参照による部品表)
    # [意図] 製品や部品がどの材料から構成されているか（レシピ・BOM）を管理。
    create_table :item_boms do |t|
      t.references :parent_item, null: false, foreign_key: { to_table: :items } # 親品目（成果物）
      t.references :child_item, null: false, foreign_key: { to_table: :items }  # 子品目（構成要素）
      t.decimal :quantity, precision: 15, scale: 5, null: false                  # 構成数
      t.text :note                           # 補足メモ

      t.timestamps
    end

    # [意図] 同一の親子組み合わせの重複登録を防ぐ
    add_index :item_boms, [ :parent_item_id, :child_item_id ], unique: true

    # 3. inventories テーブルに items への外部キー制約を追加
    # [意図] 既存の item_id カラム（整数型）に対して外部キー制約を付与する。
    add_foreign_key :inventories, :items, column: :item_id
  end
end
