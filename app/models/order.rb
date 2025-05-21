class Order < ApplicationRecord
  validates :order_id, :total, :date, presence: true
  validates :order_id, uniqueness: true
  validates :total, comparison: { greater_than: 0 }
end
