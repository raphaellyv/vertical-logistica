class Order < ApplicationRecord
  belongs_to :user
  has_many :products

  validates :order_id, :total, :date, presence: true
  validates :order_id, uniqueness: true
  validates :total, comparison: { greater_than_or_equal_to: 0 }

  def update_total
    self.total = products.sum(:value)
  end
end
