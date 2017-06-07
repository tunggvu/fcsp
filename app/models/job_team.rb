class JobTeam < ApplicationRecord
  belongs_to :job
  belongs_to :team
end
