module Supports
  class ShowUser
    attr_reader :job_active, :job_skill, :portfolios, :awards,
      :shared_job_ids, :list_friends

    def initialize user, current_user
      @user = user
      @current_user = current_user
    end

    def job_active
      Job.active.includes :company, :images, :skills, :job_skills
    end

    def job_skill
      ArrayJob.get_job job_active, @user
    end

    def portfolios
      @user.user_portfolios.includes(:images).order created_at: :DESC
    end

    def awards
      @user.awards.order created_at: :DESC
    end

    def shared_job_ids
      @current_user.friends.pluck(:id) << @current_user.id
    end

    def shared_jobs
      ShareJob.shared_jobs(shared_job_ids).includes :job, user: :avatar
    end

    def list_friends
      @user.friends.includes :avatar
    end
  end
end
