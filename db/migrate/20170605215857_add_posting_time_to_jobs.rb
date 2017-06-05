class AddPostingTimeToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :posting_time, :datetime
  end
end
