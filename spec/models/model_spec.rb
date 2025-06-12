require 'rails_helper'

RSpec.describe Model, type: :model do
  let(:valid_attributes) do
    {
      email: 'test@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      model = Model.new(valid_attributes)
      expect(model).to be_valid
    end

    it 'is invalid without an email' do
      model = Model.new(valid_attributes.merge(email: nil))
      expect(model).not_to be_valid
    end

    it 'is invalid without a password' do
      model = Model.new(valid_attributes.merge(password: nil))
      expect(model).not_to be_valid
    end
  end

  describe 'CRUD operations' do
    it 'creates a model' do
      expect {
        Model.create!(valid_attributes)
      }.to change(Model, :count).by(1)
    end

    it 'reads a model' do
      model = Model.create!(valid_attributes)
      found = Model.find_by(email: 'test@example.com')
      expect(found).to eq(model)
    end

    it 'updates a model' do
      model = Model.create!(valid_attributes)
      model.update!(email: 'new@example.com')
      expect(model.reload.email).to eq('new@example.com')
    end

    it 'deletes a model' do
      model = Model.create!(valid_attributes)
      expect {
        model.destroy
      }.to change(Model, :count).by(-1)
    end
  end
end
