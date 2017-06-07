class Employer::JobsController < Employer::BaseController
  load_and_authorize_resource
  before_action :load_hiring_types, only: [:new, :create, :edit]
  before_action :update_status, only: :create

  def index
    if params[:type]
      listarr = params[:array_id]
      listarr = listarr.split(",").map(&:to_i) if listarr.class == String
      sort_by = params[:sort].nil? ? "ASC" : params[:sort]
      @jobs = @company.jobs.includes(:candidates, :images, :bookmarks)
        .filter(listarr, sort_by, params[:type]).page(params[:page])
        .per Settings.employer.jobs.per_page
    else
      @jobs = @company.jobs.includes(:candidates, :images, :bookmarks)
        .page(params[:page]).per Settings.employer.jobs.per_page
    end

    if request.xhr?
      render json: {
        html_job: render_to_string(partial: "job", locals: {jobs: @jobs},
          layout: false),
        pagination_job: render_to_string(partial: "paginate", layout: false)
      }
    else
      respond_to do |format|
        format.html
      end
    end
  end

  def new
    @job = Job.new
    @job.images.build
    @teams = @company.teams.includes(:images).page(Settings.employer.page)
      .per Settings.employer.team.per_page
  end

  def create
    @job = @company.jobs.build job_params
    if @job.save
      flash[:success] = t "employer.jobs.create.created"
      redirect_to @job
    else
      flash[:danger] = t "employer.jobs.create.failed"
      redirect_back fallback_location: :back
    end
  end

  def edit
  end

  def update
    if @job.update_attributes job_params
      if request.xhr?
        @teams = @company.teams.includes(:images).page(Settings.employer.page)
          .per Settings.employer.team.per_page
        render json: {
          html_job: render_to_string(partial: "new_job",
            layout: false),
          status: Job.human_enum_name(:status, @job.status)
        }, status: 200
      else
        redirect_to job_path(@job)
      end
    else
      redirect_back fallback_location: :back
    end
  end

  def destroy
    Job.delete_job params[:array_id]
    @jobs = @company.jobs.includes(:candidates, :images, :bookmarks)
      .page(params[:page]).per Settings.employer.jobs.per_page

    if request.xhr?
      render json: {
        html_job: render_to_string(partial: "job", locals: {jobs: @jobs},
          layout: false),
        pagination_job: render_to_string(partial: "paginate", layout: false)
      }
    else
      respond_to do |format|
        format.html
      end
    end
  end

  private

  def job_params
    params.require(:job).permit Job::ATTRIBUTES
  end

  def load_hiring_types
    @hiring_types = HiringType.select :id, :name
  end

  def update_status
    params[:status] = params[:preview] ? :draft : :open
  end
end
