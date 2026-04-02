class Facility < ApplicationRecord
  include Discard::Model
  # [意図] この拠点に配属されている人の履歴を引くため。
  has_many :assignments, dependent: :destroy
  has_many :users, through: :assignments

  # [意図] この拠点の中にどのような在庫置き場（棚・倉庫等）があるか管理するため。
  has_many :locations, dependent: :destroy

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end
