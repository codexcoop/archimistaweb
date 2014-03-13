class ProjectsController < ApplicationController
  layout "two_columns"

  def index
    @projects = Project.page(params['page']).order("name")
  end

  def show
    @project = Project.find(params[:id])
  end

end

