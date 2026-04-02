class BusinessPartner < ApplicationRecord
  include Discard::Model

  has_many :delivery_destinations, dependent: :destroy

  # [意図] ホールディングスや支店の親子階層表現（自己参照）
  belongs_to :parent, class_name: 'BusinessPartner', optional: true
  has_many :children, class_name: 'BusinessPartner', foreign_key: 'parent_id', dependent: :destroy

  # [意図] コードや名前が空欄のまま保存されるのを防ぐ。コードは重複も禁止する。
  validates :partner_code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :short_name, presence: true

  # [意図] 取引ステータスを文字列（activeなど）で直感的に検索・更新できるようにする。
  # active: 取引中（通常）、suspended: 一時停止（与信ストップ等）、closed: 取引終了（事業撤退等）
  enum :trade_status, { active: 0, suspended: 1, closed: 2 }
end
