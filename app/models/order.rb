class Order < ApplicationRecord
  belongs_to :user
  has_many :products

  validates :order_id, :date, presence: true
  validates :order_id, uniqueness: true

  def calculate_total_value
    products.sum(:value)
  end
end
