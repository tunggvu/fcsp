class CreateJobTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :job_teams do |t|
      t.references :job, foreign_key: true
      t.references :team, foreign_key: true

      t.timestamps
    end
  end
end
