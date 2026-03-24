class SessionsController < ApplicationController
  # [意図] ログイン画面（new）とログイン処理（create）は、未ログインのユーザーでもアクセスできる必要がある。
  # [意味] `allow_unauthenticated_access` は「認証なしでアクセスを許可する」という設定。
  #        ここで指定しないと、ログイン画面自体にアクセスできなくなってしまう（無限ループ）。
  allow_unauthenticated_access only: %i[ new create ]

  # [意図] ブルートフォース攻撃（パスワードを総当たりで試す不正行為）を防ぐため、ログイン試行回数を制限する。
  # [意味] 3分以内に10回ログインを試みた場合、自動でリダイレクトされアラートを表示する。
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  # [意図] ログイン画面を表示するためのアクション。
  # [意味] `new` アクションを定義するだけで、Railsは自動的に `app/views/sessions/new.html.erb` を表示する。
  def new
  end

  # [意図] ユーザーが入力した「ユーザーコード」と「パスワード」を検証し、一致すればログインさせる。
  # [意味] `authenticate_by` はRailsが提供する安全な認証メソッド。
  #        ユーザーコードでDBからユーザーを探し、パスワードが合えば `user` オブジェクトを返す。
  #        合わない場合は `nil`（何もない）を返す。
  def create
    if user = User.authenticate_by(params.permit(:user_code, :password))
      # [意図] 認証成功後、セッション（ログイン状態の記録）を新しく開始する。
      # [意味] `start_new_session_for` はRailsが生成した認証基盤のメソッドで、
      #        Sessionレコードを作成し、ブラウザにクッキーを発行してログイン状態を維持する。
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "ユーザーコードまたはパスワードが正しくありません。"
    end
  end

  # [意図] ログアウト処理を行うアクション。
  # [意味] `terminate_session` はセッション（ログイン状態）を破棄するメソッド。
  #        その後、ログイン画面へリダイレクトする。
  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end
end
