class CreateBusinessPartners < ActiveRecord::Migration[8.1]
  def change
    create_table :business_partners do |t|
      # [意図] 取引先を識別するための業務コード。一意（ユニーク）である必要がある。
      t.string :partner_code, null: false

      # [意図] 正式な会社名（帳票・支払等での正式名称）。
      t.string :name, null: false

      # [意図] 画面表示・ドロップダウン用の略称（代表1つ。例：「パナソニック」）。
      t.string :short_name, null: false

      # [意図] 一覧の五十音順ソート、フリガナ用。
      t.string :name_kana

      # [意図] 検索時の表記揺れや複数のニックネームを吸収するためのキーワード群（例：「松下 パナ ナショナル」）。区切り文字は任意。
      t.string :search_keywords

      # [意図] 取引先が持つ「役割」をフラグで管理。重複（例：仕入先かつメーカー）を許容。
      t.boolean :is_customer, default: false, null: false     # 顧客（受注先）
      t.boolean :is_supplier, default: false, null: false     # 仕入先（発注先）
      t.boolean :is_manufacturer, default: false, null: false # メーカー（製造元）

      # [意図] グループ会社や支店などの親子階層（ホールディングス対応）を自己参照で実現するための親ID。
      # to_tableオプションで「紐づく先は同じbusiness_partnersテーブルだよ」とDBに教える。
      t.references :parent, foreign_key: { to_table: :business_partners }

      # [意図] 取引ステータス（与信ストップや取引終了など、新規取引を制御するためのフラグ）。0=取引中, 1=停止, 2=終了 など。
      t.integer :trade_status, default: 0, null: false

      # [意図] 納税・企業識別。法人番号（13桁）、およびインボイス登録番号。
      t.string :corporate_number             # 法人番号 (13桁)
      t.string :invoice_registration_number  # インボイス番号

      # [意図] 下請法適用の判定や与信管理の基礎となる情報。
      t.bigint :capital_amount               # 資本金（円単位）

      # [意図] 事業形態の区分（メーカー、商社、加工店、個人事業主等）。抽出や統計、監査時の分析用。
      t.string :business_type                # 事業形態 (メーカー, 商社, 個人事業主等)

      # [意図] 法人としての代表住所・連絡先（契約や請求のベースとなる情報）。
      t.string :postal_code                  # 郵便番号
      t.string :address                      # 住所
      t.string :phone_number                 # 電話番号
      t.string :fax_number                   # FAX番号
      t.string :website_url                  # 公式URL

      # [意図] 請求書の特殊ルールや担当者の引き継ぎ事項など、社内共有用の泥臭い業務メモ欄。
      t.text :internal_memo

      # [意図] ADR 004/006 に基づく論理削除用の日時保持用。
      t.datetime :discarded_at

      t.timestamps
    end

    # [意図] 取引先コードが絶対に重複しないよう、DBレベルでインデックスとユニーク制約を付与
    add_index :business_partners, :partner_code, unique: true
    add_index :business_partners, :discarded_at
  end
end
