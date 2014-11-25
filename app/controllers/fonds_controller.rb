class FondsController < ApplicationController

  def index
    @fonds = Fond.page(params['page']).roots.includes(:preferred_event).order("name")
    render :layout => "two_columns"
  end

  def show
    @fond = Fond.find(params[:id])
    @units = @fond.units.list

    if pjax_request?
      render :layout => false
    else
      render :layout => "treeview"
    end
  end

  def tree
    @fond = Fond.find(params[:id])
    @root_fond = @fond.is_root? ? @fond : @fond.root

    @nodes = @root_fond.fast_subtree_to_jstree_hash

    respond_to do |format|
      format.json { render :json => @nodes }
    end
  end

  # def description
  #  @fond = Fond.find(params[:id])
  #  render :layout => false
  # end

end

