require "rails_helper"

RSpec.describe UserPostsController, type: :controller do
  let!(:user){FactoryGirl.create :user}
  let!(:user_post){FactoryGirl.create :user_post, postable: user}
  before do
    sign_in user
  end

  describe "GET #new" do
    context "logged in user" do
      it "render new template" do
        get :new
        expect(response).to render_template :new
      end
    end

    context "not logged in user" do
      before{sign_out user}

      it "render divise login" do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create" do
    context "not logged in user" do
      before{sign_out user}

      it "can not create" do
        expect do
          post :create, params: {post: FactoryGirl.attributes_for(:user_post)}
        end
          .to change(Post, :count).by 0
      end
    end

    context "create valid post" do
      it "save success" do
        expect do
          post :create, params: {post: FactoryGirl.attributes_for(:user_post)}
        end
          .to change(Post, :count).by 1
      end
    end

    context "create invalid post" do
      it "save fail" do
        expect do
          post :create,
            params: {post: FactoryGirl.attributes_for(:user_post, content: nil)}
        end
          .to change(Education::Post, :count).by 0
        expect(response).to render_template :new
      end
    end
  end

  describe "GET #show" do
    it do
      expect(response).to have_http_status :success
    end
  end

  describe "PATCH #update" do
    context "update valid params" do
      it "save success" do
        patch :update, params: {id: user_post,
          post: FactoryGirl.attributes_for(:user_post)}
        expect(controller).to set_flash[:success]
          .to(I18n.t "user_posts.update.success")
      end
    end

    context "update invalid post" do
      it "save fail" do
        patch :update, params: {id: user_post,
          post: FactoryGirl.attributes_for(:user_post, content: nil)}
        expect(controller).to set_flash[:danger]
          .to(I18n.t "user_posts.update.fail")
      end
    end
  end

  describe "DELETE #destroy" do
    it "deleted post successfully" do
      delete :destroy, params: {id: user_post}
      expect(controller).to set_flash[:success]
        .to(I18n.t "user_posts.destroy.success")
    end
  end
end
