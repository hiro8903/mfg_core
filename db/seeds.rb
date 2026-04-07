# [意図] ADR 009 および 運用ガイドのユースケース（多重配属、役割の衝突回避）を確認するための標準的なサンプル。
#
# [組織・人員ツリー]
# 東京本社 (S001)
#  ├── 総務部 (D100) ────────── [田中] 課長(20) ※本務
#  │                     └── [高橋] 一般(0)  ※本務
#  ├── 営業一課 (D200) ──────── [佐藤] 一般(0)  ※派遣社員
#  └── DX推進PJ (P900) ──────── [高橋] リーダー(10) ★若手抜擢パターン
#                        ├── [田中] 一般(0)      ★メンバーとして参加
#                        └── [伊藤] ベンダー(310) ※外部協力者

puts "--- Resetting Data ---"
Assignment.destroy_all
Inventory.destroy_all
Location.destroy_all
OrgUnit.destroy_all
Site.destroy_all
Session.destroy_all
User.destroy_all

# 1. 拠点の作成 (Sites)
puts "Creating Sites..."
tokyo_office = Site.create!(
  site_code: "S001",
  name: "東京本社",
  postal_code: "100-0005",
  address: "東京都千代田区丸の内1-9-1",
  phone_number: "03-0000-0000",
  internal_memo: "メインオフィス。全社管理部門が在籍。"
)

# 2. 組織の作成 (OrgUnits)
puts "Creating Organization Units..."
admin_dept = OrgUnit.create!(
  org_code: "D100",
  name: "総務部",
  org_type: 0 # 部署
)

sales_section = OrgUnit.create!(
  org_code: "D200",
  name: "営業一課",
  org_type: 0
)

dx_project = OrgUnit.create!(
  org_code: "P900",
  name: "DX推進PJ",
  org_type: 1 # PJ
)

# 3. ユーザーの作成 (Users)
puts "Creating Users with Identity Taxonomy..."
# A. 田中さん（正社員・ベテラン）
tanaka = User.create!(
  user_code: "EMP001",
  name: "田中 太郎",
  user_category: 0,   # internal
  employment_type: 0, # regular
  password: "password",
  password_confirmation: "password"
)

# B. 高橋さん（正社員・期待の若手）
takahashi = User.create!(
  user_code: "EMP002",
  name: "高橋 桃子",
  user_category: 0,   # internal
  employment_type: 0, # regular
  password: "password",
  password_confirmation: "password"
)

# C. 佐藤さん（派遣社員）
sato = User.create!(
  user_code: "DIS001",
  name: "佐藤 次郎",
  user_category: 0,    # internal
  employment_type: 20, # dispatched
  internal_memo: "派遣元: キャリアエージェント社。",
  password: "password",
  password_confirmation: "password"
)

# D. 伊藤さん（外部開発会社）
ito = User.create!(
  user_code: "EXT001",
  name: "伊藤 誠",
  user_category: 10,  # external
  internal_memo: "ITコンサル担当。",
  password: "password",
  password_confirmation: "password"
)

# 4. 人事配属の作成 (Assignments) - ADR 009 の検証用
puts "Creating Assignments for RBAC Use Cases..."

# --- ケース1: 複数配属による権限合算の確認 ---
# 田中さん：総務部の課長 (Role 20)
Assignment.create!(
  user: tanaka,
  site: tokyo_office,
  org_unit: admin_dept,
  job_title: "総務部 課長",
  role: 20, # manager
  is_primary: true,
  start_date: "2024-01-01"
)

# 田中さん：DX推進PJの一般メンバー (Role 0)
# => 部署では管理者だが、PJ内では一般権限しか持たないことをテストできる。
Assignment.create!(
  user: tanaka,
  site: tokyo_office,
  org_unit: dx_project,
  job_title: "DX推進PJ メンバー",
  role: 0, # member
  is_primary: false,
  start_date: "2024-10-01"
)

# --- ケース2: PJ抜擢リーダーの確認 ---
# 高橋さん：総務部の一般 (Role 0)
Assignment.create!(
  user: takahashi,
  site: tokyo_office,
  org_unit: admin_dept,
  job_title: "総務部 事務職",
  role: 0, # member
  is_primary: true,
  start_date: "2024-04-01"
)

# 高橋さん：DX推進PJのリーダー (Role 10)
# => 部署では平社員だが、PJ内ではリーダー（10番台ブロック）権限を享受できる。
Assignment.create!(
  user: takahashi,
  site: tokyo_office,
  org_unit: dx_project,
  job_title: "DX推進PJ リーダー",
  role: 10, # leader
  is_primary: false,
  start_date: "2024-10-01"
)

# --- ケース3: 派遣・外部の属性隔離の確認 ---
# 佐藤さん（派遣）：営業の標準事務
Assignment.create!(
  user: sato,
  site: tokyo_office,
  org_unit: sales_section,
  job_title: "営業事務補佐",
  role: 0,
  is_primary: true,
  start_date: "2024-04-01"
)

# 伊藤さん（外部）：PJ内でのみ活動
Assignment.create!(
  user: ito,
  site: tokyo_office,
  org_unit: dx_project,
  job_title: "外部技術顧問",
  role: 310, # vendor
  is_primary: true,
  start_date: "2024-10-01"
)

# 5. 品目マスタの作成 (Items) - ADR 007 準拠
puts "Creating Items (Unified Item Master per ADR 007)..."

# --- 完成品 ---
product_pcb = Item.create!(
  item_code: "FP-001",
  name: "制御基板 Assy（型番: CB-200）",
  unit: "枚",
  item_type: :finished_product,
  manufacturer_name: "自社",
  is_lot_managed: true,
  managing_org: admin_dept,
  min_stock_level: 10
)

# --- 原材料 ---
raw_copper = Item.create!(
  item_code: "RM-001",
  name: "銅板 t0.5 (300×400mm)",
  unit: "枚",
  item_type: :raw_material,
  manufacturer_name: "三菱マテリアル",
  is_lot_managed: true,
  managing_org: admin_dept,
  min_stock_level: 100
)

raw_solder = Item.create!(
  item_code: "RM-002",
  name: "鉛フリーはんだ Sn-Ag-Cu",
  unit: "kg",
  item_type: :raw_material,
  manufacturer_name: "千住金属",
  is_lot_managed: true,
  managing_org: admin_dept,
  min_stock_level: 5
)

# --- 購入部品 ---
part_ic = Item.create!(
  item_code: "PP-001",
  name: "マイコン STM32F401 (LQFP-64)",
  unit: "個",
  item_type: :purchased_part,
  manufacturer_name: "STMicroelectronics",
  is_lot_managed: true,
  managing_org: admin_dept,
  min_stock_level: 200
)

part_resistor = Item.create!(
  item_code: "PP-002",
  name: "チップ抵抗 10kΩ 1/10W (0603)",
  unit: "個",
  item_type: :purchased_part,
  manufacturer_name: "村田製作所",
  is_lot_managed: false,
  managing_org: admin_dept,
  min_stock_level: 5000,
  internal_memo: "リール単位（5000個/リール）で発注。バラ発注不可。"
)

# --- 消耗品 ---
consumable_glove = Item.create!(
  item_code: "CS-001",
  name: "静電気防止手袋 Mサイズ",
  unit: "双",
  item_type: :consumable,
  is_lot_managed: false,
  managing_org: admin_dept,
  min_stock_level: 50
)

# --- 工具 ---
tool_soldering = Item.create!(
  item_code: "TL-001",
  name: "温調はんだごて FX-951",
  unit: "台",
  item_type: :tool,
  manufacturer_name: "白光",
  is_lot_managed: false,
  managing_org: admin_dept,
  min_stock_level: 0,
  internal_memo: "壊れたら都度購入。安全在庫の概念なし。"
)

# 6. BOM（部品表）の作成 - 完成品「制御基板 Assy」の構成
puts "Creating Item BOMs (Bill of Materials)..."

ItemBom.create!(parent_item: product_pcb, child_item: raw_copper,    quantity: 1,    note: "基板ベース 1枚/製品")
ItemBom.create!(parent_item: product_pcb, child_item: raw_solder,    quantity: 0.02, note: "はんだ 約20g/製品")
ItemBom.create!(parent_item: product_pcb, child_item: part_ic,       quantity: 1,    note: "メインMCU 1個/製品")
ItemBom.create!(parent_item: product_pcb, child_item: part_resistor, quantity: 24,   note: "各種抵抗 計24個/製品")

# 7. 組織権限の作成 (OrgUnitPermissions) - ADR 009 準拠
puts "Creating OrgUnitPermissions (RBAC per ADR 009)..."

# [意図] 全社（admin_dept を仮の最上位として使用）で、課長(manager)は見積・発注の承認権限を持つ
OrgUnitPermission.create!(org_unit: admin_dept, role: :manager, permission_key: "quotation", permission_level: :approver)
OrgUnitPermission.create!(org_unit: admin_dept, role: :manager, permission_key: "purchase_order", permission_level: :approver)
OrgUnitPermission.create!(org_unit: admin_dept, role: :manager, permission_key: "item", permission_level: :editor)

# [意図] 一般社員(member)は閲覧・編集のみ
OrgUnitPermission.create!(org_unit: admin_dept, role: :member, permission_key: "quotation", permission_level: :editor)
OrgUnitPermission.create!(org_unit: admin_dept, role: :member, permission_key: "purchase_order", permission_level: :reader)
OrgUnitPermission.create!(org_unit: admin_dept, role: :member, permission_key: "item", permission_level: :reader)

# [意図] PJリーダー(leader)は品目の編集権限を持つ
OrgUnitPermission.create!(org_unit: dx_project, role: :leader, permission_key: "item", permission_level: :editor)

puts "--- Seed Success: Full Foundation Masters Loaded ---"
