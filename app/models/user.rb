class User < ApplicationRecord
  validates :user_id, :name, presence: true
  validates :user_id, uniqueness: true
end
