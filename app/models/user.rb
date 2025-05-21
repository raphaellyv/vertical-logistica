class User < ApplicationRecord
  has_many :orders
  
  validates :user_id, :name, presence: true
  validates :user_id, uniqueness: true
end
