class CustodiansController < ApplicationController
  layout "two_columns"

  def index
    @custodians = Custodian.page(params['page']).list.order("name")
  end

  def show
    @custodian = Custodian.find(params[:id])
  end

end

