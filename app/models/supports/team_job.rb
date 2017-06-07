module Supports
  class TeamJob
    attr_reader :company, :params

    def initialize company, params
      @company = company
      @params = params
    end

    def paginate
      if params[:type]
        listarr = params[:array_id]
        listarr = listarr.split(",").map(&:to_i) if listarr.class == String
        sort_by = params[:sort].nil? ? "ASC" : params[:sort]
        @teams = @company.teams.includes(:images)
          .filter(listarr, sort_by, params[:type])
          .page(params[:page]).per Settings.employer.team.per_page
      else
        @teams = @company.teams.includes(:images).page(params[:page])
          .per Settings.employer.team.per_page
      end
      @teams
    end
  end
end
