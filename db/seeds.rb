# [意図] 重複登録を避けるため、実行時に既存データを一度リセットする。
puts "--- Resetting Data ---"
Assignment.destroy_all
Inventory.destroy_all
Location.destroy_all
OrgUnit.destroy_all
Facility.destroy_all
Session.destroy_all
User.destroy_all

# 1. 拠点の作成 (Facilities)
puts "Creating Facilities..."
tokyo_factory = Facility.create!(
  code: "F001",
  name: "東京第一工場",
  address: "東京都中央区銀座1-1-1"
)

# 2. 組織の作成 (OrgUnits)
puts "Creating Organization Units..."
manufacturing_dept = OrgUnit.create!(
  code: "D100",
  name: "製造本部",
  org_type: 0 # 部署
)

mfg_section_1 = OrgUnit.create!(
  parent: manufacturing_dept,
  code: "D110",
  name: "製造第1課",
  org_type: 0
)

safety_committee = OrgUnit.create!(
  code: "C500",
  name: "全社安全衛生委員会",
  org_type: 2 # 委員会
)

# 3. 在庫ロケーションの作成 (Locations)
puts "Creating Locations..."
Location.create!(
  facility: tokyo_factory,
  code: "LOC-A-01",
  name: "部品倉庫 A-01棚"
)

# 4. ユーザーの作成 (Users)
puts "Creating Users..."
tanaka = User.create!(
  user_code: "M001",
  name: "田中 太郎",
  password: "password",
  password_confirmation: "password"
)

# 5. 人事配属の作成 (Assignments)
puts "Creating Assignments..."
# 田中さんを「東京工場」の「製造1課」に配属（メイン所属）
Assignment.create!(
  user: tanaka,
  facility: tokyo_factory,
  org_unit: mfg_section_1,
  job_title: "課長",
  role: 0,
  is_primary: true,
  start_date: "2024-01-01"
)

# 田中さんを「安全衛生委員会」にも兼務させる
Assignment.create!(
  user: tanaka,
  facility: tokyo_factory,
  org_unit: safety_committee,
  job_title: "委員長",
  role: 0,
  is_primary: false,
  start_date: "2024-03-01"
)

puts "--- Seed Success: Tanaka (M001) is ready! ---"
