require "test_helper"

class ApprovalActivityTest < ActiveSupport::TestCase
  def setup
    @admin_user = User.create!(
      user_code: "U-ADM",
      name: "Admin User",
      password: "password",
      password_confirmation: "password"
    )
    
    @applicant_user = User.create!(
      user_code: "U-MGR",
      name: "Shop Floor Manager",
      password: "password",
      password_confirmation: "password"
    )
    
    @request = MaterialRequest.create!(
      created_by: @applicant_user,
      applicant: @applicant_user,
      transaction_type: :standard_purchase,
      purpose: "Needs approval",
      status: :draft
    )
  end

  test "can submit request for approval" do
    assert @request.draft?

    # Action: Submit
    @request.update!(status: :pending_approval)
    activity = @request.approval_activities.create!(
      approver: @applicant_user,
      step_name: "Submission",
      action: "submitted",
      comment: "Please review"
    )

    assert @request.pending_approval?
    assert_equal 1, @request.approval_activities.count
    assert_equal "submitted", activity.action
  end

  test "manager can approve request" do
    @request.update!(status: :pending_approval)

    # Action: Approve
    @request.update!(status: :approved)
    activity = @request.approval_activities.create!(
      approver: @admin_user,
      step_name: "Manager Approval",
      action: "approved",
      comment: "Looks good"
    )

    assert @request.approved?
    assert_equal "approved", activity.action
  end

  test "manager can return request" do
    @request.update!(status: :pending_approval)

    # Action: Return
    @request.update!(status: :returned)
    activity = @request.approval_activities.create!(
      approver: @admin_user,
      step_name: "Manager Approval",
      action: "returned",
      comment: "Missing cost center"
    )

    assert @request.returned?
    assert_equal "returned", activity.action
  end
end
