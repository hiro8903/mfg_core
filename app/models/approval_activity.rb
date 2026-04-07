class ApprovalActivity < ApplicationRecord
  # 【ADR 010】 資材要求に対する承認、差戻、修正等の具体的なアクション履歴を記録する。
  
  belongs_to :material_request
  belongs_to :approver, class_name: "User"

  validates :step_name, presence: true
  validates :action, presence: true
end
