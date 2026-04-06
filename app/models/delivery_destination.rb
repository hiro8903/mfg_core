class DeliveryDestination < ApplicationRecord
  include Discard::Model

  belongs_to :business_partner

  # [意図] コードや名前が空欄のまま保存されるのを防ぐ。コードは重複も禁止する。
  validates :destination_code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :short_name, presence: true
end
