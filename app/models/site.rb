class Site < ApplicationRecord
  include Discard::Model

  # [意図] サイト（拠点）に紐付く配属履歴とロケーション。
  # 以前は sity と呼んでいたものを site としてリレーションを継続。
  has_many :assignments, dependent: :destroy
  has_many :locations, dependent: :destroy

  # [意図] サイトコードと名称は必須、コードは一意。
  validates :site_code, presence: true, uniqueness: true
  validates :name, presence: true
end
