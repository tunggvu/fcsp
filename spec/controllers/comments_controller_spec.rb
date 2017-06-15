require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  let!(:user){FactoryGirl.create :user}
  let!(:user2){FactoryGirl.create :user}
  let(:user_post){FactoryGirl.create :user_post}
  let!(:comment) do
    FactoryGirl.create :comment_user_post, user_id: user.id,
      post_id: user_post.id, content: "ABC"
  end
  let!(:comment2) do
    FactoryGirl.create :comment_user_post, user_id: user2.id,
    post_id: user_post.id, content: "ABC"
  end

  before :each do
    sign_in user
  end

  describe "POST #create" do
    it "expect comment successful save" do
      expect do
        post :create, params: {user_post_id: user_post.id,
          comment: {content: "abc", user_id: user.id}}, xhr: true
      end
        .to change(Comment, :count).by(1)
      expect(assigns[:comment]).to be_an_instance_of Comment
    end
  end

  describe "DELETE #destroy" do
    it "delete a comment successfully" do
      expect do
        delete :destroy, params: {id: comment.id,
          user_post_id: user_post.id}, xhr: true
      end
        .to change(Comment, :count).by(-1)
    end
  end

  describe "GET #edit" do
    it do
      get :edit, params: {id: comment.id, user_post_id: user_post.id}, xhr: true
      expect(response).to render_template :edit
    end
  end

  describe "PUT #update" do
    it "action comment update state success" do
      put :update, params: {id: comment.id, user_post_id: user_post.id,
        comment: {content: "CAD", user_id: user.id}}, xhr: true
      expect((Comment.find comment.id).content).to eq "CAD"
    end
  end
end
