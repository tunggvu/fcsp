require "rails_helper"

RSpec.describe LikesController, type: :controller do
  let!(:user){FactoryGirl.create :user}
  let(:user_post){FactoryGirl.create :user_post}

  before :each do
    sign_in user
  end

  describe "POST #create" do
    it "like post successful" do
      expect do
        post :create, params: {user_post_id: user_post.id}, xhr: true
      end
        .to change(Like, :count).by 1
    end

    it "can not like post when user not login" do
      sign_out user
      expect do
        post :create, params: {user_post_id: user_post.id}, xhr: true
      end
        .to change(Like, :count).by 0
    end
  end

  describe "delete #destroy" do
    it "dislike post successful" do
      expect do
        post :create, params: {user_post_id: user_post.id}, xhr: true
      end
        .to change(Like, :count).by 1
    end

    it "can not dislike post when user not login" do
      sign_out user
      expect do
        post :create, params: {user_post_id: user_post.id}, xhr: true
      end
        .to change(Like, :count).by 0
    end
  end
end
