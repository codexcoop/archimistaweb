class CreatorsController < ApplicationController
  layout "two_columns"

  def index
    @creators = Creator.page(params['page']).list.order("name")
  end

  def show
    @creator = Creator.find(params[:id])
  end

end

