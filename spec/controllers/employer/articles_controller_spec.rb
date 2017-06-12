require "rails_helper"

RSpec.describe Employer::ArticlesController, type: :controller do
  let(:admin){FactoryGirl.create :user, role: 1}
  let(:company){FactoryGirl.create :company}
  let!(:article){FactoryGirl.create :article, company_id: company.id}

  before :each do
    allow(controller).to receive(:current_user).and_return admin
    sign_in admin
  end

  describe "GET #index" do
    it "populates an array of article" do
      get :index, params: {company_id: company.id}
      expect(assigns(:article_presenter).articles).to include article
    end

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to be_success
      expect(response).to have_http_status 200
    end
  end

  describe "GET #new" do
    it "renders the :new template" do
      get :new, params: {company_id: company.id}
      expect(response).to render_template :new
    end
  end

  describe "POST #create article" do
    it "create article successfully" do
      article_params = FactoryGirl.attributes_for :article
      post :create, params: {company_id: company, article: article_params}
      expect{response.to change(Article, :count).by 1}
    end

    it "create fail with title nil" do
      article_params = FactoryGirl.attributes_for :article, title: nil
      post :create, params: {company_id: company, article: article_params}
      expect(response).to render_template :new
    end

    it "create fail with descrition nil" do
      article_params = FactoryGirl.attributes_for :article, description: nil
      post :create, params: {company_id: company, article: article_params}
      expect(response).to render_template :new
    end

    it "create fail with content nil" do
      article_params = FactoryGirl.attributes_for :article, content: nil
      post :create, params: {company_id: company, article: article_params}
      expect(response).to render_template :new
    end
  end

  describe "PATCH #update" do
    it "update successfully" do
      article_params = FactoryGirl.attributes_for :article, title: "something"
      patch :update, params: {company_id: company, id: article, article: article_params}
      expect(response).to redirect_to employer_company_articles_path company
    end

    it "update fail with title nil" do
      article_params = FactoryGirl.attributes_for :article, title: nil
      patch :update, params: {company_id: company, id: article, article: article_params}
      expect(response).to render_template :edit
    end

    it "update fail with description nil" do
      article_params = FactoryGirl.attributes_for :article, description: nil
      patch :update, params: {company_id: company, id: article, article: article_params}
      expect(response).to render_template :edit
    end

    it "update fail with content nil" do
      article_params = FactoryGirl.attributes_for :article, content: nil
      patch :update, params: {company_id: company, id: article, article: article_params}
      expect(response).to render_template :edit
    end
  end

  describe "DELETE #destroy" do
    it "delete successfully" do
      delete :destroy, params: {company_id: company, id: article}
      expect{response.to change(Article, :count).by -1}
    end

    it "delete fail" do
      allow_any_instance_of(Article).to receive(:destroy).and_return false
      article = Article.new
      expect(article.destroy).to eq false
    end
  end
end
