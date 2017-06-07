class CompaniesController < ApplicationController
  load_resource

  def show
    @company_jobs = @company.jobs.includes(:images)
      .page(params[:page]).per Settings.company.per_page
    @company_articles = @company.articles.select(:id, :title, :description,
      :time_show).show(:time_show).page(params[:page]).per Settings.article.page
    if request.xhr?
      render json: {
        content: render_to_string(partial: "company_jobs",
          locals: {company_jobs: @company_jobs, company: @company},
          layout: false),
        company_articles: render_to_string(partial: "articles",
          locals: {articles: @company_articles, company: @company},
           layout: false),
        pagination_company_articles:
          render_to_string(partial: "article_paginate",
          locals: {articles: @company_articles}, layout: false),
        addresses: @company.addresses
      }
    end
  end
end
