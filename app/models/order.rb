class Order < ApplicationRecord
  validates :order_id, :total, :date, presence: true
  validates :order_id, uniqueness: true
  validates :total, comparison: { greater_than_or_equal_to: 0}
end
