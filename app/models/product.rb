class Product < ApplicationRecord
  belongs_to :order

  validates :product_id, :value, presence: true
  validates :value, comparison: { greater_than: 0 }
end
