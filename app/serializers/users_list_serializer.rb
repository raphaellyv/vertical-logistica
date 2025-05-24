class UsersListSerializer
  def self.create_serialized_hash_array(users)
    users.order(:user_id)
         .map{ |user| UserOrdersSerializer.create_serialized_hash(user) }
  end
end