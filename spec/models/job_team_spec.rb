require "rails_helper"

RSpec.describe JobTeam, type: :model do
  describe "Job team validation" do
    context "association" do
      it{expect belong_to(:job)}
      it{expect belong_to(:team)}
    end

    context "column_specifications" do
      it{expect have_db_column(:job_id).of_type(:integer)}
      it{expect have_db_column(:team_id).of_type(:integer)}
    end
  end
end
