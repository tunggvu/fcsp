class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: [:show, :edit]

  def show
    @user_object = Supports::ShowUser.new @user, current_user
    @user.build_info_user if @user.info_user.nil?
    @info_user = @user.info_user
    if @user.is_user? current_user
      @user_jobs = Kaminari.paginate_array(@user_object.job_skill)
        .page(params[:page]).per Settings.user.per_page
    end
    if request.xhr?
      render json: {
        content: render_to_string(partial: "job_accordance",
          locals: {jobs: @user_jobs})
      }
    end
  end

  def new
  end

  private

  def find_user
    @user = User.includes(:info_user).find_by id: params[:id]
    if @user
      if @user.education_status_blocked?
        flash[:danger] = t ".blocked"
        redirect_to root_url
      end
    else
      flash[:danger] = t ".not_found"
      redirect_to root_url
    end
  end
end
