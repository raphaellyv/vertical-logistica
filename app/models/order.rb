class Order < ApplicationRecord
  belongs_to :user
  has_many :products

  validates :order_id, :date, presence: true
  validates :order_id, uniqueness: true

  def calculate_total_value
    products.sum(:value)
  end

  def self.filter_by_start_date_string(start_date_string)
    self.where('date >= ?', start_date_string.to_date)
  end

  def self.filter_by_end_date_string(end_date_string)
    self.where('date <= ?', end_date_string.to_date)
  end

  def self.filter_by_order_id(order_id)
    self.where('order_id like ?', order_id + '%')
  end
end
