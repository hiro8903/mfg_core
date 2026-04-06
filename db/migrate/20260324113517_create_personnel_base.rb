class CreatePersonnelBase < ActiveRecord::Migration[8.0]
  def change
    # 1. ユーザーマスタ (Auth & Identity)
    create_table :users do |t|
      t.string :user_code, null: false, index: { unique: true } # 認証ID
      t.string :name, null: false                             # 姓名・名称
      t.string :password_digest, null: false                  # 認証パスワード
      t.integer :user_category, default: 0, null: false         # 0:internal, 10:external, 80:service
      t.integer :employment_type, default: 0, null: false       # 0:regular, 10:contract, 20:dispatched, 30:part_time
      t.bigint :business_partner_id, index: true              # 所属取引先（外部協力者や派遣会社の場合）
      t.text :internal_memo                                   # 社内向けの共有・申し送り事項（非公開）
      t.datetime :discarded_at, index: true                   # 論理削除

      t.timestamps
    end

    # 2. 組織単位マスタ (OrgUnits: Dept, Section, PJ, Committee)
    # [意図] 会社の論理的な組織図。原価責任の所在（コストセンター）でもある。
    create_table :org_units do |t|
      t.references :parent, foreign_key: { to_table: :org_units } # 親部署
      t.string :code, null: false, index: { unique: true } # 組織コード
      t.string :name, null: false                          # 組織名（例：製造部、資材課）
      t.integer :org_type, default: 0, null: false           # 0:Dept(部署), 1:PJ(プロジェクト), 2:Committee(委員会)
      t.text :internal_memo                                # 社内向けの共有・申し送り事項（非公開）
      t.datetime :discarded_at, index: true                # 論理削除

      t.timestamps
    end

    # 3. 配属・役職履歴 (Assignments)
    # [意図] 「誰」が「どこ(Site)」の「どの部署(OrgUnit)」に所属しているかのマッピング。
    create_table :assignments do |t|
      t.references :user, null: false, foreign_key: true     # 対象ユーザー
      t.references :site, null: false, foreign_key: true     # 所属サイト
      t.references :org_unit, null: false, foreign_key: true # 所属部署
      t.string :job_title                                  # 役職名（例：課長、係長）
      t.integer :role, default: 0, null: false               # ロール（権限区分）
      t.boolean :is_primary, default: true, null: false      # 本務・兼務フラグ
      t.text :internal_memo                                # 社内向けの共有・申し送り事項（非公開）
      t.date :start_date, null: false                      # 着任日
      t.date :end_date                                     # 離任日（空なら在任中）

      t.timestamps
    end

    # 4. 認証セッション (Sessions for Rails 8 Native Auth)
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true     # 対象ユーザー
      t.string :ip_address                                 # ログイン元IP
      t.string :user_agent                                 # 端末情報

      t.timestamps
    end
  end
end
