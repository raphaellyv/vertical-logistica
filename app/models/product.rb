class Product < ApplicationRecord
  self.primary_key = :product_id

  has_many :product_items

  validates :product_id, :value, presence: true
  validates :value, uniqueness: { scope: :product_id }
end
