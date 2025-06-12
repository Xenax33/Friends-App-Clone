require 'rails_helper'

RSpec.describe "Friends", type: :request do
  before(:all) do
    Devise.mappings[:model] = Devise.mappings[:model] || Devise::Mapping.new(:model, {})
  end
  let(:model) { Model.create(email: "test@example.com", password: "password") }
  let!(:friend) { Friend.create(first_name: "John", last_name: "Doe", email: "john@example.com", city: "Testville", model: model) }

  before do
    sign_in model
  end

  describe "GET /friends" do
    it "returns http success" do
      get friends_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Friends")
    end
  end

  describe "GET /friends/:id" do
    it "shows a friend" do
      get friend_path(friend)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(friend.first_name)
    end
  end

  describe "GET /friends/new" do
    it "renders the new friend form" do
      get new_friend_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("New friend")
    end
  end

  describe "POST /friends" do
    it "creates a new friend" do
      expect {
        post friends_path, params: { friend: { first_name: "Jane", last_name: "Smith", email: "jane@example.com", city: "Sampletown", model_id: model.id } }
      }.to change(Friend, :count).by(1)
      expect(response).to redirect_to(friend_path(Friend.last))
    end
  end

  describe "GET /friends/:id/edit" do
    it "renders the edit form" do
      get edit_friend_path(friend)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Editing friend")
    end
  end

  describe "PATCH /friends/:id" do
    it "updates the friend" do
      patch friend_path(friend), params: { friend: { city: "New City" } }
      expect(response).to redirect_to(friend_path(friend))
      friend.reload
      expect(friend.city).to eq("New City")
    end
  end

  describe "DELETE /friends/:id" do
    it "deletes the friend" do
      expect {
        delete friend_path(friend)
      }.to change(Friend, :count).by(-1)
      expect(response).to redirect_to(friends_path)
    end

    it "does not allow a non-owner to delete the friend" do
      owner = Model.create!(email: "owner@example.com", password: "password123", password_confirmation: "password123")
      non_owner = Model.create!(email: "notowner@example.com", password: "password123", password_confirmation: "password123")
      friend = Friend.create!(first_name: "John", last_name: "Doe", email: "john@example.com", city: "Testville", model: owner)

      sign_in non_owner
      expect {
        delete friend_path(friend)
      }.not_to change(Friend, :count)
      expect(response).to redirect_to(friends_path)
      expect(flash[:notice]).to eq("You are not authorized to access this friend.")
    end
  end
end
