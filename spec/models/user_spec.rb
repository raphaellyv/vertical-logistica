require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'requires user_id' do
        user = User.new(user_id: '')

        user.valid?

        expect(user.errors.include?(:user_id)).to be true
      end

      it 'requires name' do
        user = User.new(name: '')

        user.valid?

        expect(user.errors.include?(:name)).to be true
      end
    end

    context 'uniqueness' do
      it 'requires user_id to be unique' do
        User.create(user_id: 1, name: 'Lara Andrade')
        user = User.new(user_id: 1)

        user.valid?

        expect(user.errors.include?(:user_id)).to be true
      end
    end
  end

  describe '.primary_key' do
    it 'returns user_id as the primary_key' do
      expect(User.primary_key).to eq 'user_id'
    end
  end
end
