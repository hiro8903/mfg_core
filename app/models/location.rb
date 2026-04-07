class Location < ApplicationRecord
  include Discard::Model
  # [意図] この在庫ロケーション（棚など）がどの拠点に属しているか。
  belongs_to :site

  # [意図] このロケーションに現在置かれている在庫を把握するため。
  has_many :inventories, dependent: :nullify

  validates :location_code, presence: true, uniqueness: { scope: :site_id }
  validates :name, presence: true
end
