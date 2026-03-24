class CreateAuthenticationTables < ActiveRecord::Migration[8.1]
  def change
    # [意図] ユーザー情報を一元管理するためのテーブル。
    #        「仕事上の肩書き(job_title)」と「システム上の権限(system_role)」を明確に分離する設計を採用。
    # [意味] `user_code` をログインIDに、`name` を氏名表示、`system_role` で操作権限を判定する。
    create_table :users do |t|
      t.string :user_code, null: false
      t.string :password_digest, null: false
      t.string :name, null: false
      t.string :job_title                             # 👈 人間界の肩書き（工場長、部長など）
      t.integer :system_role, default: 0, null: false  # 👈 システム界の権限（管理者:1, 一般:0 など）

      t.timestamps
    end
    add_index :users, :user_code, unique: true

    # [意図] セッションベースの認証を管理するテーブル。Rails 8 公式認証の標準構成。
    # [意味] ログインしたブラウザを識別するためのトークンと、端末情報（IP, UA）を記録する。
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
  end
end
