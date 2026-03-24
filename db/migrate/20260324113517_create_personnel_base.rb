class CreatePersonnelBase < ActiveRecord::Migration[8.0]
  def change
    # 1. ユーザーマスタ (Auth & Identity)
    create_table :users do |t|
      t.string :user_code, null: false, index: { unique: true }
      t.string :name, null: false
      t.string :password_digest, null: false
      t.datetime :discarded_at, index: true

      t.timestamps
    end

    # 2. 拠点マスタ (Facilities)
    create_table :facilities do |t|
      t.string :code, null: false, index: { unique: true }
      t.string :name, null: false
      t.text :address
      t.datetime :discarded_at, index: true

      t.timestamps
    end

    # 3. 組織単位マスタ (OrgUnits: Dept, Section, PJ, Committee)
    create_table :org_units do |t|
      t.references :parent, foreign_key: { to_table: :org_units }
      t.string :code, null: false, index: { unique: true }
      t.string :name, null: false
      t.integer :org_type, default: 0, null: false # 0:Dept, 1:PJ, 2:Committee
      t.datetime :discarded_at, index: true

      t.timestamps
    end

    # 4. 配属・役職履歴 (Assignments)
    create_table :assignments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :facility, null: false, foreign_key: true
      t.references :org_unit, null: false, foreign_key: true
      t.string :job_title
      t.integer :role, default: 0, null: false
      t.boolean :is_primary, default: true, null: false
      t.date :start_date, null: false
      t.date :end_date

      t.timestamps
    end

    # 5. ロケーションマスタ (Locations: Bins, Shelves within a facility)
    create_table :locations do |t|
      t.references :facility, null: false, foreign_key: true
      t.string :code, null: false
      t.string :name, null: false
      t.datetime :discarded_at, index: true

      t.timestamps
    end
    add_index :locations, [ :facility_id, :code ], unique: true

    # 6. 在庫データ (Inventories: Hybrid Logical/Physical)
    create_table :inventories do |t|
      t.integer :item_id # 将来拡張用
      t.references :org_unit, null: false, foreign_key: true # 論理的所有者
      t.references :location, foreign_key: true              # 物理的場所（任意）
      t.decimal :quantity, precision: 15, scale: 5, default: 0, null: false

      t.timestamps
    end

    # 7. 認証セッション (Sessions for Rails 8 Native Auth)
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
  end
end
