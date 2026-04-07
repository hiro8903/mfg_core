require "test_helper"

class MaterialRequestLineTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      user_code: "U-LINE",
      name: "Line Tester",
      password: "password",
      password_confirmation: "password"
    )
    
    @request = MaterialRequest.create!(
      created_by: @user,
      applicant: @user,
      purpose: "Line test purpose"
    )
    
    @item = Item.create!(
      item_code: "ITM-001",
      name: "Test Item",
      unit: "pcs",
      min_stock_level: 0
    )
  end

  test "valid with a master item" do
    line = MaterialRequestLine.new(
      material_request: @request,
      item: @item,
      order_quantity: 10,
      required_date: Date.tomorrow
    )
    assert line.valid?
  end

  test "valid with a free text item when master item is missing" do
    line = MaterialRequestLine.new(
      material_request: @request,
      item: nil,
      item_name_free_text: "Custom made tool set",
      order_quantity: 1,
      required_date: Date.tomorrow
    )
    assert line.valid?
  end

  test "invalid if both master item and free text are missing" do
    line = MaterialRequestLine.new(
      material_request: @request,
      item: nil,
      item_name_free_text: nil,
      order_quantity: 5,
      required_date: Date.tomorrow
    )
    assert_not line.valid?
    assert_includes line.errors[:base], "品目マスタを選択するか、品名（フリー入力）を入力してください"
  end

  test "invalid if order quantity is zero or less" do
    line = MaterialRequestLine.new(
      material_request: @request,
      item: @item,
      order_quantity: 0,
      required_date: Date.tomorrow
    )
    assert_not line.valid?
    assert_includes line.errors[:order_quantity], "must be greater than 0"
  end
end
