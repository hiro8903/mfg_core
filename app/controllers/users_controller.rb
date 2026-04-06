class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy undiscard ]

  def index
    # 退職済み(discarded)を表示するか、現職のみを表示するかを切り替え
    if params[:discarded] == "true"
      @users = User.discarded
    else
      @users = User.kept
    end

    # 共通の並び替えとプリロード処理
    @users = @users.order(:user_code).includes(:sites, assignments: :org_unit)
  end

  def show
    # 詳細画面では、配属(Assignment)経由で得られる組織(OrgUnit)とその権限(OrgUnitPermission)も確認できるようにロード
    @assignments = @user.assignments.includes(org_unit: :org_unit_permissions).order(start_date: :desc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path, notice: "ユーザー [#{@user.user_code}] を登録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "ユーザー [#{@user.user_code}] の情報を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # データを消さずに、退職日時をセットして「無効化 (Discard)」する
    @user.discard!
    redirect_to users_path, notice: "ユーザー [#{@user.user_code}] を退職処理しました。一覧から除外されました。", status: :see_other
  end

  def undiscard
    # 退職状態を解除（nil に戻す）
    @user.undiscard!
    redirect_to users_path, notice: "ユーザー [#{@user.user_code}] の退職処理を取り消しました。現職に復帰しました。"
  end

  private
    # ID をキーにユーザーを特定する
    def set_user
      @user = User.find(params[:id])
    end

    # 許可するパラメーターの定義（Strong Parameters）
    def user_params
      # パスワードが入力されていない場合は、パラメーターから除外する
      p = params.expect(user: [ :name, :user_code, :password, :password_confirmation ])
      p.delete(:password) if p[:password].blank?
      p.delete(:password_confirmation) if p[:password_confirmation].blank?
      p
    end
end
