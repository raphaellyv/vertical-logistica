class Product < ApplicationRecord
  validates :product_id, :value, presence: true
  validates :value, uniqueness: { scope: :product_id }
end
