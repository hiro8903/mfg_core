class Location < ApplicationRecord
  # [意図] この在庫ロケーション（棚など）がどの拠点に属しているか。
  belongs_to :facility

  # [意図] このロケーションに現在置かれている在庫を把握するため。
  has_many :inventories, dependent: :nullify

  validates :code, presence: true, uniqueness: { scope: :facility_id }
  validates :name, presence: true
end
