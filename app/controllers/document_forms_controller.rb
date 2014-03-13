class DocumentFormsController < ApplicationController
  layout "two_columns"

  def index
    @document_forms = DocumentForm.order("name")
  end

  def show
    @document_form = DocumentForm.find(params[:id])
  end

end

