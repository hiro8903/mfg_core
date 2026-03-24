class User < ApplicationRecord
  # [意図] パスワードを平文ではなく、暗号化（ハッシュ化）して保存するための設定。
  # [意味] `has_secure_password` を使うと、`password` と `password_confirmation` という
  #        属性が自動で使えるようになり、DBには安全な `password_digest`（暗号文）だけが保存される。
  has_secure_password

  # [意図] ユーザーが削除された時に、そのユーザーのセッション（ログイン情報）も一緒に消すため。
  # [意味] `has_many :sessions` は「1人のユーザーは複数のセッションを持てる」という関係を定義する。
  #        `dependent: :destroy` は「親（User）が消えたら子（Sessions）も自動で消す」という設定。
  has_many :sessions, dependent: :destroy

  # [意図] ユーザーが入力したユーザーコードを、前後の空白を除去して正規化（統一）するため。
  #        「abc 」と「abc」を同じものとして扱いたい。
  # [意味] `normalizes` は保存時に自動で値を変換してくれるメソッド。
  #        `strip` で前後の空白を除去し、入力ミスによる不一致を防ぐ。
  normalizes :user_code, with: -> (c) { c.strip }
end
