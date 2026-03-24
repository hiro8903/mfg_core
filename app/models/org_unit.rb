class OrgUnit < ApplicationRecord
  # [意図] 部・課・班といった階層構造を1つのテーブルで管理するため。
  # [意味] `parent` は親組織, `children` はその配下にある子組織を返す。
  belongs_to :parent, class_name: "OrgUnit", optional: true
  has_many :children, class_name: "OrgUnit", foreign_key: "parent_id", dependent: :destroy

  # [意図] この組織（部署・プロジェクト）に所属している人を引くため。
  has_many :assignments, dependent: :destroy
  has_many :users, through: :assignments

  # [意図] この組織が所有している在庫データを引くため。
  has_many :inventories, dependent: :destroy

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end
