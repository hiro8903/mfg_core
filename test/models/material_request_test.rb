require "test_helper"

class MaterialRequestTest < ActiveSupport::TestCase
  def setup
    # Setup necessary associations for a valid material request
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
    
    @production_dept = OrgUnit.create!(
      org_code: "ORG-PROD",
      name: "Production Dept",
      org_type: 0
    )
  end

  test "valid material request can be saved" do
    request = MaterialRequest.new(
      created_by: @admin_user,
      applicant: @applicant_user,
      request_org: @production_dept,
      transaction_type: :standard_purchase,
      purpose: "Urgent maintenance part replacement",
      status: :draft
    )
    assert request.valid?, "Expected request to be valid: #{request.errors.full_messages}"
    assert request.save
  end

  test "requires a purpose" do
    request = MaterialRequest.new(
      created_by: @admin_user,
      applicant: @applicant_user,
      purpose: nil # missing purpose
    )
    assert_not request.valid?
    assert_includes request.errors[:purpose], "can't be blank"
  end

  test "can represent surrogate data entry (applicant != created_by)" do
    request = MaterialRequest.new(
      created_by: @admin_user,       # Logged-in admin
      applicant: @applicant_user,  # Actual requester
      purpose: "For the shop floor worker"
    )
    assert request.valid?
    assert_not_equal request.created_by, request.applicant
  end
end
