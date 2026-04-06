class CreateDeliveryDestinations < ActiveRecord::Migration[8.1]
  def change
    create_table :delivery_destinations do |t|
      # [意図] この拠点（届け先）がどの取引先に属しているか。
      t.references :business_partner, null: false, foreign_key: true

      # [意図] 納入先を識別するための業務コード（客先拠点コード等）。
      t.string :destination_code, null: false

      # [意図] 正式な拠点名（例：横浜第1工場）。
      t.string :name, null: false

      # [意図] 画面表示・ドロップダウン用の略称（例：「横浜第1」）。
      t.string :short_name, null: false

      # [意図] 一覧のソート、フリガナ用。
      t.string :name_kana

      # [意図] 現場での通称や旧称などを吸収するための検索キーワード。
      t.string :search_keywords

      # [意図] 配送に必要となる物理的な住所・連絡先情報。
      t.string :postal_code    # 郵便番号
      t.string :address        # 住所
      t.string :phone_number   # 電話番号
      t.string :fax_number     # FAX番号
      t.string :email          # メールアドレス（出荷案内等の自動送信先として想定）
      # [意図] 配送ラベルや納品書の宛名（受取人）として印字される担当者・組織情報。
      # 部署のみ、役職のみといった柔軟な印字ロジックを構成できるよう詳細化。
      t.string :contact_person_org    # 部署名、組織名（例：第一工場 購買部）
      t.string :contact_person_title  # 役職名（例：工場長、課長）
      t.string :contact_person_name   # 担当者個人名（例：田中 太郎）
      t.string :honorific_title       # 敬称（例：様、御中、先生）。空ならロジックで自動付与。

      # [意図] 拠点の運用ステータス（一時閉鎖中など）。
      t.boolean :is_active, default: true, null: false

      # [意図] その取引先におけるデフォルトの配送先かどうか。
      t.boolean :is_default, default: false, null: false

      # [意図] 送り状や納品書の備考欄に印字するための、配送業者・顧客向けの指示メッセージ。
      t.string :shipping_instruction

      # [意図] 納入時の特殊指定（昼休み荷受け不可、入り口制限等）など、社内共有用の泥臭い業務メモ欄。
      t.text :internal_memo

      # [意図] ADR 004/006 に基づく論理削除用。
      t.datetime :discarded_at

      t.timestamps
    end

    # [意図] 納入先コードが絶対に重複しないよう、DBレベルでインデックスとユニーク制約を付与
    add_index :delivery_destinations, :destination_code, unique: true
    add_index :delivery_destinations, :discarded_at
  end
end
