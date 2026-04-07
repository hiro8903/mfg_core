class MaterialRequestLine < ApplicationRecord
  # 【ADR 010】 資材要求の具体的な品目、数量、希望納期等の明細データを管理する。
  
  belongs_to :material_request
  
  # [意図] マスタ品の場合、アイテムマスタと紐づく。指定がない場合はフリーテキストを使用する。
  belongs_to :item, optional: true

  # [意図] 0:未処理, 10:引当済, 20:発注済, 30:入荷済
  enum :status, {
    unprocessed: 0,
    allocated: 10,
    ordered: 20,
    received: 30
  }

  validates :order_quantity, numericality: { greater_than: 0 }
  validates :required_date, presence: true

  # マスタ品かフリー入力かのどちらかが必須
  validate :item_or_free_text_must_be_present

  private

  def item_or_free_text_must_be_present
    if item_id.blank? && item_name_free_text.blank?
      errors.add(:base, "品目マスタを選択するか、品名（フリー入力）を入力してください")
    end
  end
end
