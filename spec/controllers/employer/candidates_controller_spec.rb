require "rails_helper"

RSpec.describe Employer::CandidatesController, type: :controller do
  let(:admin){FactoryGirl.create :user, role: 1}
  let(:company){FactoryGirl.create :company}
  let(:job){FactoryGirl.create :job, company_id: company.id}
  let(:group){FactoryGirl.create :group, name: "HR", company_id: company.id}
  let(:group_user){FactoryGirl.create :group_user, user_id: user.id,
    group_id: group.id}
  let(:permission){FactoryGirl.create :permission, entry: "Company",
    optional: {create: true, read: true, update: true, destroy: true},
    group_id: group.id}
  let!(:candidate){FactoryGirl.create :candidate, user_id: 1, job_id: job.id}

  before :each do
    allow(controller).to receive(:current_user).and_return admin
    sign_in admin
    request.env["HTTP_REFERER"] = "sample_path"
  end

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index, params: {company_id: company.id}
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "get candidates of a job successfully" do
      get :index, params: {company_id: company.id, select: job.id}, xhr: true
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "get all candidates of company successfully when params select is empty" do
      get :index, params: {company_id: company.id, select: ""}, xhr: true
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "render template successfully when using xhr request" do
      get :index, params: {company_id: company.id, select: job.id}, xhr: true
      expect(response).to render_template("employer/candidates/_candidate")
      expect(response).to render_template("employer/candidates/_paginate")
    end

    it "request xhr successfully, get follow type of candidates" do
      get :index, params: {company_id: company.id, select: job.id,
        type: "process", sort: "ASC", array_id: [1, 2, 3], page: 1}, xhr: true
      expect(response).to render_template("employer/candidates/_candidate")
      expect(response).to render_template("employer/candidates/_paginate")
    end
  end

  describe "PUT #update" do
    it "request xhr, update candidates" do
      patch :update, params: {company_id: company.id, type: "apply", id: 10}, xhr: true
      expect(response).to render_template("employer/candidates/_change_process")
    end

    it "request xhr successfully, get follow type of candidates" do
      get :index, params: {company_id: company.id, select: job.id,
        type: "apply", sort: "ASC", array_id: [1, 2, 3], page: 1}, xhr: true
      expect(response).to render_template("employer/candidates/_candidate")
      expect(response).to render_template("employer/candidates/_paginate")
    end
  end

  describe "PUT #update" do
    it "update successfully with json" do
      put :update, params: {company_id: company.id, select: job.id,
        type: "apply", id: candidate}, xhr: true
      candidate.reload
      expect(response).to have_http_status 200
    end
  end

  describe "DELETE #destroy" do
    context "delete candidate successfully" do
      arr_id_success = [1, 2]
      before{delete :destroy,
        params: {company_id: company, array_id: arr_id_success, page: 1}}
      it "expect are" do
        expect{response.to change(Candidate, :count).by - 1}
      end
    end

    context "delete candidate with xhr true successfully" do
      arr_id_success = [1, 2]
      before{delete :destroy, xhr: true,
        params: {company_id: company, array_id: arr_id_success, page: 1}}
      it "expect are" do
        expect{response.to change(Candidate, :count).by - 1}
        expect(response).to have_http_status 200       
      end
    end

    context "delete candidate with xhr false successfully" do
      arr_id_success = [1, 2]
      before{delete :destroy, xhr: false,
        params: {company_id: company, array_id: arr_id_success, page: 1}}
      it "expect are" do
        expect{response.to change(Candidate, :count).by - 1}
      end
    end

    it "can't delete because not candidate is checked with xhr true" do
      arr_id_fail = []
      allow_any_instance_of(Candidate).to receive(:destroy).and_return(false)
      expect do
        delete :destroy, xhr: true,
          params: {company_id: company, array_id: arr_id_fail},
        format: :json
        expect(response.body).to eq({flash:
          I18n.t("employer.candidates.destroy.warning")}.to_json)
      end.not_to change(Candidate, :count)
    end

    it "can't delete because not candidate is checked with xhr false" do
      arr_id_fail = []
      allow_any_instance_of(Candidate).to receive(:destroy).and_return(false)
      expect do
        delete :destroy, xhr: false,
          params: {company_id: company, array_id: arr_id_fail}
        expect(response).to have_http_status 204
      end.not_to change(Candidate, :count)
    end
  end
end
