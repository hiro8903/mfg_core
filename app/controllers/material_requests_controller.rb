class MaterialRequestsController < ApplicationController
  before_action :set_material_request, only: %i[ show edit update destroy ]

  def index
    @material_requests = MaterialRequest.order(created_at: :desc).all
  end

  def show
  end

  def new
    @material_request = MaterialRequest.new
    @material_request.material_request_lines.build
  end

  def edit
  end

  def create
    @material_request = MaterialRequest.new(material_request_params)
    # 暫定的にログインユーザーを作成者・起案者とする
    @material_request.created_by ||= Current.user
    @material_request.applicant ||= Current.user

    respond_to do |format|
      if @material_request.save
        format.html { redirect_to @material_request, notice: "資材要求を保存しました。" }
        format.json { render :show, status: :created, location: @material_request }
      else
        @material_request.material_request_lines.build if @material_request.material_request_lines.empty?
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @material_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @material_request.update(material_request_params)
        format.html { redirect_to @material_request, notice: "資材要求を更新しました。" }
        format.json { render :show, status: :ok, location: @material_request }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @material_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @material_request.destroy!
    respond_to do |format|
      format.html { redirect_to material_requests_path, status: :see_other, notice: "資材要求を削除しました。" }
      format.json { head :no_content }
    end
  end

  private

  def set_material_request
    @material_request = MaterialRequest.find(params[:id])
  end

  def submit
    @material_request = MaterialRequest.find(params[:id])
    
    if @material_request.material_request_lines.empty?
      redirect_to @material_request, alert: "要求明細が登録されていないため、申請できません。"
      return
    end

    @material_request.transaction do
      @material_request.update!(status: :pending_approval)
      # 承認履歴の作成
      @material_request.approval_activities.create!(
        approver: Current.user, # 本来は承認ルート定義から取得
        step_name: "第1次承認",
        action: "submit",
        comment: "申請されました"
      )
    end

    redirect_to @material_request, notice: "資材要求を申請しました。"
  rescue => e
    redirect_to @material_request, alert: "申請に失敗しました: #{e.message}"
  end

  def approve
    @material_request = MaterialRequest.find(params[:id])
    
    @material_request.transaction do
      @material_request.update!(status: :approved)
      @material_request.approval_activities.create!(
        approver: Current.user,
        step_name: "最終承認",
        action: "approve",
        comment: "承認されました"
      )
    end

    redirect_to @material_request, notice: "資材要求を承認しました。"
  rescue => e
    redirect_to @material_request, alert: "承認に失敗しました: #{e.message}"
  end

  def reject
    @material_request = MaterialRequest.find(params[:id])
    
    @material_request.transaction do
      @material_request.update!(status: :returned)
      @material_request.approval_activities.create!(
        approver: Current.user,
        step_name: "承認却下",
        action: "reject",
        comment: "内容に不備があるため差し戻します"
      )
    end

    redirect_to @material_request, notice: "資材要求を差し戻しました。"
  rescue => e
    redirect_to @material_request, alert: "差し戻しに失敗しました: #{e.message}"
  end

  def material_request_params
    params.require(:material_request).permit(
      :applicant_id, :request_org_id, :budget_org_id, :target_org_id,
      :transaction_type, :usage_code_id, :purpose, :reason, :remarks, :status,
      material_request_lines_attributes: [
        :id, :item_id, :item_name_free_text, :item_spec_free_text,
        :order_unit, :order_quantity, :packing_factor, :base_unit,
        :total_base_quantity, :unit_price, :base_unit_price, :tax_rate,
        :required_date, :status, :_destroy
      ]
    )
  end
end
