class CreateMaterialWorkflowFoundation < ActiveRecord::Migration[8.1]
  def change
    # -----------------------------------------------------------------------------
    # 経理・独自用途コード群
    # -----------------------------------------------------------------------------
    create_table :accounting_usage_codes do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
    add_index :accounting_usage_codes, :code, unique: true

    create_table :internal_usage_codes do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.references :accounting_usage_code, foreign_key: true

      t.timestamps
    end
    add_index :internal_usage_codes, :code, unique: true

    # -----------------------------------------------------------------------------
    # 資材要求 (Material Requests)
    # -----------------------------------------------------------------------------
    create_table :material_requests do |t|
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.references :applicant, null: false, foreign_key: { to_table: :users }
      
      t.references :request_org, foreign_key: { to_table: :org_units }
      t.references :budget_org, foreign_key: { to_table: :org_units }
      t.references :target_org, foreign_key: { to_table: :org_units }
      
      t.integer :transaction_type, default: 1, null: false
      t.references :usage_code, foreign_key: { to_table: :internal_usage_codes }
      
      t.text :purpose
      t.text :reason
      t.text :remarks
      
      t.integer :status, default: 0, null: false
      t.boolean :ringi_needed, default: false, null: false
      
      t.timestamps
    end

    # -----------------------------------------------------------------------------
    # 資材要求明細 (Material Request Lines)
    # -----------------------------------------------------------------------------
    create_table :material_request_lines do |t|
      t.references :material_request, null: false, foreign_key: true
      
      t.references :item, foreign_key: true
      t.string :item_name_free_text
      t.text :item_spec_free_text
      
      t.string :order_unit
      t.decimal :order_quantity, precision: 15, scale: 5
      
      t.decimal :packing_factor, precision: 15, scale: 5
      t.string :base_unit
      t.decimal :total_base_quantity, precision: 15, scale: 5
      
      t.decimal :unit_price, precision: 15, scale: 4
      t.decimal :base_unit_price, precision: 15, scale: 4
      t.decimal :tax_rate, precision: 5, scale: 4, default: 0.10
      
      t.date :required_date
      t.integer :status, default: 0, null: false
      
      t.timestamps
    end
    
    # -----------------------------------------------------------------------------
    # 承認活動履歴 (Approval Activities)
    # -----------------------------------------------------------------------------
    create_table :approval_activities do |t|
      t.references :material_request, null: false, foreign_key: true
      t.references :approver, null: false, foreign_key: { to_table: :users }
      t.string :step_name
      t.string :action
      t.text :comment
      
      t.timestamps
    end
  end
end
