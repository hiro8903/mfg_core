class CreateOrgUnitPermissions < ActiveRecord::Migration[8.1]
  def change
    # [意図] 従業員が各組織単位 (OrgUnit) でどのような職能権限を持つかを詳細に定義する。
    # 例：製造部での「承認権限」、資材課での「発注権限」などを管理。
    create_table :org_unit_permissions do |t|
      t.references :org_unit, null: false, foreign_key: true # 対象組織（Dept, Section etc.）
      
      # [意図] その組織における「役割」に対して権限を付与する。 assignments.role と連動。
      t.integer :role, default: 0, null: false             # 役割（0:Member, 1:Leader, 2:Manager 等）

      # [意図] 権限を識別するキー。将来的に `user.can?(:quotation, role: :manager)` のようなチェックに使用。
      t.string :permission_key, null: false                # 権限種別キー（例：quotation, item, purchase_order）

      # [意図] 権限の強さ。0:Reader(閲覧), 1:Editor(編集), 2:Approver(承認) 等の階層化に使用。
      t.integer :permission_level, default: 0, null: false  # 権限レベル
      t.text :internal_memo                                # 社内向けの共有・申し送り事項（非公開）

      t.timestamps
    end

    # [意図] 組織・役割・権限キーの組み合わせでユニーク性を担保、高速検索できるようにする。
    add_index :org_unit_permissions, [ :org_unit_id, :role, :permission_key ], unique: true, name: 'idx_org_unit_role_perm_unique'
  end
end
