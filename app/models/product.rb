class Product < ApplicationRecord
  validates :product_id, :value, presence: true
  validates :product_id, uniqueness: true
  validates :value, comparison: { greater_than: 0 }
end
