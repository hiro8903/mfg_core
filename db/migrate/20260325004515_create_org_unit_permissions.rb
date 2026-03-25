class CreateOrgUnitPermissions < ActiveRecord::Migration[8.1]
  def change
    create_table :org_unit_permissions do |t|
      t.references :org_unit, null: false, foreign_key: true
      t.integer :permission, null: false

      t.timestamps
    end
    add_index :org_unit_permissions, :permission
  end
end
