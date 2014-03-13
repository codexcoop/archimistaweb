class InstitutionsController < ApplicationController
  layout "two_columns"

  def index
    @institutions = Institution.order("name")
  end

  def show
    @institution = Institution.find(params[:id])
  end

end

