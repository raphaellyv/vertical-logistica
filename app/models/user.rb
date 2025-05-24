class User < ApplicationRecord
  self.primary_key = :user_id

  has_many :orders
  
  validates :user_id, :name, presence: true
  validates :user_id, uniqueness: true
end
