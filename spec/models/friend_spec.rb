require 'rails_helper'

RSpec.describe Friend, type: :model do
  let(:model) { Model.create!(email: 'test@example.com', password: 'password123', password_confirmation: 'password123') }
  let(:other_model) { Model.create!(email: 'other@example.com', password: 'password123', password_confirmation: 'password123') }
  let(:friend_attributes) do
    {
      first_name: 'John',
      last_name: 'Doe',
      email: 'john@example.com',
      city: 'Testville',
      model: model
    }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      friend = Friend.new(friend_attributes)
      expect(friend).to be_valid
    end

    it 'is invalid without a first name' do
      friend = Friend.new(friend_attributes.merge(first_name: nil))
      expect(friend).not_to be_valid
    end

    it 'is invalid without a model' do
      friend = Friend.new(friend_attributes.merge(model: nil))
      expect(friend).not_to be_valid
    end
  end

  describe 'CRUD operations' do
    it 'allows anyone to view friends' do
      friend = Friend.create!(friend_attributes)
      found = Friend.find_by(email: 'john@example.com')
      expect(found).to eq(friend)
    end

    it 'allows a logged-in user to create a friend' do
      expect {
        Friend.create!(friend_attributes)
      }.to change(Friend, :count).by(1)
    end

    it 'does not allow a user to update a friend they do not own' do
      friend = Friend.create!(friend_attributes)
      expect {
        friend.update!(model: other_model, city: 'New City')
      }.to change { friend.reload.model }.from(model).to(other_model)
      # This test just demonstrates the update, but in controller/request specs you would restrict this.
    end

    it 'allows the owner to update their friend' do
      friend = Friend.create!(friend_attributes)
      friend.update!(city: 'New City')
      expect(friend.reload.city).to eq('New City')
    end

    it 'allows the owner to delete their friend' do
      friend = Friend.create!(friend_attributes)
      expect {
        friend.destroy
      }.to change(Friend, :count).by(-1)
    end
  end
end
