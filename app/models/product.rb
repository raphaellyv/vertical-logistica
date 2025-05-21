class Product < ApplicationRecord
  belongs_to :order
  after_save :update_order_total

  validates :product_id, :value, presence: true
  validates :value, comparison: { greater_than: 0 }

  private
    def update_order_total
      order.update_total
    end
end
