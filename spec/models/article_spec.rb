require "rails_helper"
include ApplicationHelper

RSpec.describe Article, type: :model do
  article_params = FactoryGirl.attributes_for :article
  subject{described_class.new article_params}
  let!(:image) do
    Rack::Test::UploadedFile
      .new(Rails.root.join("spec", "support", "education", "image", "test.jpg"))
  end

  describe "Article Validation" do
    context "association" do
      it{expect have_many(:image)}
      it{expect belong_to(:company)}
      it{expect have_many(:user)}
    end

    context "column_specifications" do
      it{expect have_db_column(:title).of_type(:string)}
      it{expect have_db_column(:content).of_type(:text)}
      it{expect have_db_column(:description).of_type(:string)}
      it{expect have_db_column(:time_show).of_type(:datetime)}
      it{expect have_db_column(:company_id).of_type(:integer)}
      it{expect have_db_column(:user_id).of_type(:integer)}
    end
  end

  describe "validate attributes" do
    it{expect validate_presence_of(:title)}
    it{expect validate_presence_of(:content)}
    it{expect validate_presence_of(:description)}
  end

  describe "validate time_show" do
    it "valid time_show" do
      subject.time_show = Time.zone.now
      expect(subject).to be_valid
    end

    it "invalid time_show" do
      subject.time_show = Time.zone.now + 40.days
      expect(subject).not_to be_valid
    end
  end

  describe "scope" do
    it "show articles in the correct order and time" do
      expect(Article.time_filter(:time_show).to_sql).to eq Article
        .where("time_show <= ?", format_time(Time.zone.now, :format_datetime))
        .order("time_show DESC").to_sql
    end

    it "search and sort correct type" do
      params = ["search", "type", "sort_by"]
      expect(Article.search_form(params).to_sql).to eq Article
        .where("LOWER(title) LIKE '%search%' OR LOWER(description) LIKE '%search%'")
        .order("type sort_by").to_sql
    end
  end
end
