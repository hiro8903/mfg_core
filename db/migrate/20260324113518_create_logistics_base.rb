class CreateLogisticsBase < ActiveRecord::Migration[8.0]
  def change
    # 1. 拠点マスタ (Sites: Factory, Office, Warehouse etc.)
    # [意図] 物理的な「場所」を示す拠点。郵便番号や電話番号を持ち、帳票印字のソースとなる。
    create_table :sites do |t|
      t.string :code, null: false, index: { unique: true } # 拠点コード
      t.string :name, null: false                          # 拠点名（例：横浜第1工場）

      # [意図] 出荷元・発注元などの帳票印字や、対外連絡に必要となる自社拠点情報。
      t.string :postal_code                                # 郵便番号
      t.string :address                                    # 住所
      t.string :phone_number                               # 電話番号
      t.string :fax_number                                 # FAX番号
      t.text :internal_memo                                # 社内向けの共有・申し送り事項（非公開）

      t.datetime :discarded_at, index: true                # 論理削除
      t.timestamps
    end

    # 2. ロケーションマスタ (Locations: Bins, Shelves within a site)
    # [意図] 工場や倉庫内のミクロな保管場所（棚、床、パレット等）。
    create_table :locations do |t|
      t.references :site, null: false, foreign_key: true      # 所属サイト
      t.string :code, null: false                          # 場所コード
      t.string :name, null: false                          # 場所名（例：A棟2F-棚B-1）
      t.text :internal_memo                                # 社内向けの共有・申し送り事項（非公開）
      t.datetime :discarded_at, index: true                # 論理削除

      t.timestamps
    end
    add_index :locations, [ :site_id, :code ], unique: true
  end
end
