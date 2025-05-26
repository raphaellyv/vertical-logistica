class Order < ApplicationRecord
  self.primary_key = :order_id

  belongs_to :user
  has_many :products_items
  has_many :products, through: :product_items

  validates :order_id, :date, presence: true
  validates :order_id, uniqueness: true

  scope :filter_by_start_date, ->(start_date) { where('date >= ?', start_date) }
  scope :filter_by_end_date, ->(end_date) { where('date <= ?', end_date) }
  scope :filter_by_order_id, ->(order_id) { where(order_id: order_id) }

  def calculate_total_value
    products.sum(:value).round(2)
  end
end
